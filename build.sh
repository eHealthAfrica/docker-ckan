#!/usr/bin/env bash
set -Eeuo pipefail


deb=no
dry_run=no
nocache=no
target_image=ckan
target_image_fullname=
namespace=${DOCKERHUB_NAMESPACE:-ehealthafrica}
tag=$(git describe --tags --exact-match 2>/dev/null || echo ${CKAN_VERSION})

function show_help {
  echo """
  Build Alpine or Debian based CKAN image

  Usage:
    ./build.sh [options]

  Options:
    --datapusher        build image for datapusher
    --solr              build image for solr
    --deb         | -d  build Debain image.
    --dry-run           performs a dry-run to show configs.
    --help        | -h  show this message.
    --namespace         docker hub account name.
    --no-cache          build image without using cache.
    --tag         | -t  the image tag.
  """
}

function _build_image_name {
  local deb=$1
  local target_name=$2
  local namespace=$3

  tag=$4
  target_image_fullname="${namespace}/${target_image}:${tag}"

  if [[ ${target_name} = "datapusher" ]]; then
    tag=$(git describe --tags --exact-match 2>/dev/null || echo ${DATAPUSHER_VERSION:-latest})
    target_image_fullname="${namespace}/ckan-${target_image}:${tag}"
  fi

  if [[ ${target_name} = "solr" ]]; then
    tag=$(git describe --tags --exact-match 2>/dev/null || echo ${SOLR_VERSION:-latest})
    target_image_fullname="${namespace}/ckan-${target_image}:${tag}"
  fi

  if [[ ${deb} = "no" ]]; then
    target_image_fullname="${target_image_fullname}-alpine"
  fi
}

function build {
  local deb=$1
  local image=$2
  local image_fullname=$3
  local nocache=$4
  local filename=Dockerfile

  if [[ ${deb} = "yes" ]]; then
    filename=Dockerfile.deb
  fi

  echo ">> Building CKAN Image '${image_fullname}' (using ${filename}) ..."
  echo ""

  local image_dir=images/${image}
  if [[ ${target_image} = "solr" ]]; then
    image_dir=compose/${image}
  fi

  if [[ ${nocache} = "yes" ]]; then
    docker build -f ${image_dir}/${filename} -t ${image_fullname} ${image_dir}
  else
    docker build --no-cache -f ${image_dir}/${filename} -t ${image_fullname} ${image_dir}
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --datapusher )
      target_image="datapusher"
      shift
    ;;

    --solr )
      target_image="solr"
      shift
    ;;

    -d | --deb )
      deb=yes
      shift
    ;;

    --dry-run )
      dry_run=yes
      shift
    ;;

    --namespace )
      shift
      namespace=$1
      shift
    ;;

    --no-cache )
      nocache=yes
      shift
    ;;

    -h | --help )
      show_help
      exit 0
    ;;

    -t | --tag )
      shift
      tag=$1
      shift
    ;;
  esac
done

# build image name which is stored in global var: result
_build_image_name ${deb} ${target_image} ${namespace} ${tag}

if [[ $dry_run = "yes" ]]; then
  echo "deb=${deb} target-image=${target_image} namespace=${namespace} tag=${tag}"
  echo ${target_image_fullname}
else
  build ${deb} ${target_image} ${target_image_fullname} ${nocache}
fi
