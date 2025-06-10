# Docker ckan image  ![Docker Pulls](https://img.shields.io/docker/pulls/keitaro/ckan.svg)

## Overview

This repository contains the necessary files for building a base docker image for CKAN. The build can target either [Alpine Linux](https://alpinelinux.org/) or [Debian Linux](https//debian.org) and only includes required extensions to start a CKAN instance. This is based-off Keitaro's [docker-ckan](https://github.com/keitaroinc/docker-ckan).

Additionally, the repository now contains necessary files for building Docker images for `Datapusher` and `Solr` and a sample Docker Compose setup with all services required to run a CKAN instance running on Docker. 

> **NOTE**  
> The `master` branch tracks and absorbs changes from the upstream Keitaro repository which then goes into the `develop` branch. The `develop` contains our modifications to the original work done by Keitaro mostly to include support for building a Debian Linux based CKAN image. The Debian build is modelled after the original Alpine build, to ensure the same build and runtime mechanisms apply across the targetted distros.
>
> Modifications should be done with care in order not to deviate too much from the source and thereby hamper the "pulling and merging" of improvements from the upstream repository.

## Build

To create a new image, use the `build.sh` bash script. Here is a usage description gotten from `./build.sh --help`:

```sh
Build Alpine or Debian based CKAN image

Usage:
  ./build.sh [options]

Options:
  --datapusher            build image for datapusher
  --solr                  build image for solr
  --deb         | -d      build Debain image.
  --dry-run               performs a dry-run to show configs.
  --help        | -h      show this message.
  --namespace             docker hub account name.
  --no-cache              build image without using cache.
  --tag         | -t      the image tag.
```

The script is configured to build an `Alpine` image by default (except when `--deb` flag is provided). The built image is named in the form `<namespace>/ckan` for CKAN and `<namespace>/ckan-<service>` for Solr and Datapuhser. The built image is tagged with the version set in `.env` for the service or "latest" if there is none. 

The resulting full image name becomes `<namespace>/ckan(-service):<tag>-alpine` for Alpine or just `<namespace>/ckan(-service):<tag>` for a Debian image. For instance: `ehealthafrica/ckan:2.7.8-alpine` and `ehealthafrica/ckan-solr:9-alpine`.

## List

Check if the image shows up in the list of images:

```sh
 docker images
```

## Run

To start and test newly created image run:

```sh
 docker run --rm --name <image-name> <namespace>/ckan:<image-tag>
```

Check if CKAN was succesfuly started on <http://localhost:5000>. The ckan site url is configured in `ENV CKAN_SITE_URL`.

## Upload to DockerHub

> *It's recommended to upload built images to DockerHub*

To upload the image to DockerHub run:

```sh
docker push [options] <docker-hub>/ckan:<image-tag>
```

## Upgrade

To upgrade the Docker files to use a new CKAN version, in the Dockerfiles you should change:

> ENV GIT_BRANCH={ckan_release}

and also update the `CKAN_VERSION` entry in the `.env` file.

Check [CKAN repository](https://github.com/ckan/ckan/releases) for the latest releases. 
If there are new libraries used by the new version requirements, those needs to be included too.

## Extensions

Default extensions used in the Dockerfile  are kept in:

> ENV CKAN__PLUGINS="envvars image_view text_view recline_view datastore datapusher"

## Add new scripts

You can add scripts to CKAN custom images and copy them to the *docker-entrypoint.d* directory. Any *.sh or *.py file in that directory will be executed after the main initialization script (prerun.py) is executed.

