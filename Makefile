target=''

build:
	docker build -t grpc-php .

run:
	@docker run --rm -v $(shell pwd)/protos:/var/local/protos -v $(shell pwd)/gen:/var/local/gen grpc-php $(target)

.PHONY: build run
