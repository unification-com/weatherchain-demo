.DEFAULT_GOAL := all

# Build and run static Docker environment.
all:
	$(MAKE) build
	$(MAKE) run

# Build deployment Docker environment.
build:
	docker-compose build

# Build, no cache
build-nc:
	docker-compose build --no-cache

# Run deployment Docker environment.
run:
	docker-compose down --remove-orphans
	docker-compose up

# Bring deployment Docker environment down
down:
	docker-compose down --remove-orphans

