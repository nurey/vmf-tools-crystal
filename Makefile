build:
	@crystal build src/vmf-tools.cr --no-debug

build-release:
	@crystal build src/vmf-tools.cr --no-debug --release
