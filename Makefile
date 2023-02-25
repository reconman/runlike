CUR_VER := $(shell poetry run ./current_version.py)
SHELL := bash
IMAGE_NAME := assaflavie/runlike

.PHONY: build
build:
	docker buildx build -t $(IMAGE_NAME) -t $(IMAGE_NAME):$(CUR_VER) --build-arg VERSION=$(CUR_VER) .

.PHONY: rebuild
rebuild:
	docker buildx build -t $(IMAGE_NAME) -t $(IMAGE_NAME):$(CUR_VER) --build-arg VERSION=$(CUR_VER) --no-cache=true .

.PHONY: push
push:
    # build and push must happen at the same time to push multiple platforms
	# https://github.com/docker/buildx/issues/1152
	docker buildx build -t $(IMAGE_NAME) -t $(IMAGE_NAME):$(CUR_VER) --build-arg VERSION=$(CUR_VER) --no-cache=true --push .

.PHONY: test
test:
	poetry run pytest -v

.PHONY: pypi
pypi:
	poetry build
	poetry publish -u __token__ -p $(POETRY_PYPI_TOKEN_PYPI)
