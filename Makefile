VERSION := $(shell git describe --tags --exact-match 2>/dev/null || echo latest)
DOCKERHUB_NAMESPACE ?= ehealthafrica
IMAGE := ${DOCKERHUB_NAMESPACE}/ckan:${VERSION}-alpine

build:
	docker build -t ${IMAGE} rootfs

build-no-cache:
	docker build --no-cache -t ${IMAGE} rootfs

lint-python:
	python -m black --skip-string-normalization -l 98 .

push: build
	docker push ${IMAGE}
