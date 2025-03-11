build:
	@./build.sh --deb

build/dry-run:
	@./build.sh --deb --dry-run

build/no-cache:
	@./build.sh --deb --no-cache


# ---------------------------------------------------
# datapusher
# ---------------------------------------------------

build/datapusher:
	@./build.sh --datapusher

build/datapusher/no-cache:
	@./build.sh --datapusher --no-cache


# ---------------------------------------------------
# solr
# ---------------------------------------------------

build/solr:
	@./build.sh --solr

build/solr/no-cache:
	@./build.sh --solr --no-cache


# ---------------------------------------------------
# docker commands
# ---------------------------------------------------

docker/build:
	docker compose -f ./compose/docker-compose.yml build

docker/down:
	docker compose -f ./compose/docker-compose.yml down

docker/up:
	docker compose -f ./compose/docker-compose.yml up redis solr db -d
	docker compose -f ./compose/docker-compose.yml up datapusher ckan

docker/prune:
	docker compose -f ./compose/docker-compose.yml down
	docker volume rm compose_ckan_data
	docker volume rm compose_solr_data
	docker volume rm compose_pg_data

lint-python:
	python -m black --skip-string-normalization -l 98 .

