SRC?="${PWD}"
RUNTIME_USER=alpine
IMAGETAG=latest
REPOSITORY=sp4ghet/latex-jp
IMAGENAME=$(REPOSITORY):$(IMAGETAG)

all: run

build:
	docker build -t $(IMAGENAME) . --build-arg RUNTIME_USER=$(RUNTIME_USER)

# If the first argument is "run"...
ifeq (run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

run:
	docker run --rm -it -v $(SRC):/home/$(RUNTIME_USER)/src $(IMAGENAME) $(RUN_ARGS)

show-latest-image:
	@echo $(IMAGENAME)

show-images:
	@docker images --format "{{.Repository}} {{.Tag}}" | awk '$$1 == "$(REPOSITORY)" {print $$1 ":" $$2}'

help:
	@cat Makefile

.PHONY: all build run show-latest-image show-images help
