service := svelte-service
name := frontend-service
expose := 8080
env := dev

.PHONY: build

all: build run

build:

ifeq ($(env), dev)
build: build-dev
else
build: build-prod
endif

run:

ifeq ($(env), dev)
run: run-dev
else
run: run-prod
endif

build-dev:
	npm ci;

run-dev:
	npm run dev;

build-prod: docker-rm-images
	docker build --no-cache -t ${service}:latest .;

run-prod: docker-rm-container docker-rm-images
	docker run --init \
		-p ${expose}:8080 \
		--name ${name} \
		${service};

docker-rm-images:
	docker image prune -f; exit 0;

docker-rm-container:
	docker rm $$(docker stop $$(docker ps -a -q --filter="name=${name}" --format="{{.ID}}")); exit 0;
