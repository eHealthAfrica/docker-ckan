#!/usr/bin/env bash
set -Eeuo pipefail


deb=no
dry_run=no
build_ckan=yes
nocache=no
target_image=
target_image_fullname=
namespace=${DOCKERHUB_NAMESPACE:-ehealthafrica}
version=$(git describe --tags --exact-match 2>/dev/null || echo ${CKAN_VERSION}-dev)

function show_help {
  echo """
  Build Alpine or Debian based CKAN image

  Usage:
    ./build.sh [options]

  Options:
    --datapusher        build image for datapusher (default: build ckan image)
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
  local build_ckan=$2
  local namespace=$3
  local tag=$4

  target_image=ckan
  target_image_fullname="${namespace}/${target_image}:${tag}"

  if [[ ${build_ckan} = "no" ]]; then
    target_image=datapusher
    tag=$(git describe --tags --exact-match 2>/dev/null || echo ${DATAPUSHER_VERSION:-latest})
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

  if [[ ${nocache} = "yes" ]]; then
    docker build -f images/${image}/${filename} -t ${image_fullname} images/${image}
  else
    docker build --no-cache -f images/${image}/${filename} -t ${image_fullname} images/${image}
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --datapusher )
      build_ckan=no
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
      version=$1
      shift
    ;;
  esac
done

# build image name which is stored in global var: result
_build_image_name ${deb} ${build_ckan} ${namespace} ${version}

if [[ $dry_run = "yes" ]]; then
  echo "deb=${deb} build-ckan=${build_ckan} namespace=${namespace} tag=${version}"
  echo ${target_image_fullname}
else
  build ${deb} ${target_image} ${target_image_fullname} ${nocache}
fi
