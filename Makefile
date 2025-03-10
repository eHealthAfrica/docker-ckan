build:
	@./build.sh --deb

build/dry-run:
	@./build.sh --deb --dry-run

build/no-cache:
	@./build.sh --deb --no-cache

build/datapusher:
	@./build.sh --datapusher

build/datapusher/no-cache:
	@./build.sh --datapusher --no-cache

