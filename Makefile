.DEFAULT_GOAL := all

# Set some variables
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
WORKCHAIN_ASSETS_DIR:=$(ROOT_DIR)/Docker/assets
WORKCHAIN_ROOT_SC_SRC_DIR:=$(shell realpath $(ROOT_DIR)/../../workchain_root_sc)

# Build and run static Docker environment.
all:
	$(MAKE) build
	$(MAKE) run

# Build deployment Docker environment.
build:
	$(MAKE) prep
	docker-compose build

# Build, no cache
build-nc:
	$(MAKE) prep
	docker-compose build --no-cache

# Run deployment Docker environment.
run:
	docker-compose down --remove-orphans
	docker-compose up

# Bring deployment Docker environment down
down:
	docker-compose down --remove-orphans

# Output some useful info
info:
	@echo "ROOT_DIR                      : $(ROOT_DIR)"
	@echo "WORKCHAIN_ASSETS_DIR          : $(WORKCHAIN_ASSETS_DIR)"
	@echo "WORKCHAIN_ROOT_SC_SRC_DIR     : $(WORKCHAIN_ROOT_SC_SRC_DIR)"

# Delete the Docker/assets/mainchain dir
clean-local-assets:
	@rm -rf $(WORKCHAIN_ASSETS_DIR)/workchain_root_sc

copy-local-assets:
	@rsync -azh --exclude '.git*' --exclude 'build' --exclude '.idea' --exclude 'node_modules' $(WORKCHAIN_ROOT_SC_SRC_DIR) $(WORKCHAIN_ASSETS_DIR)/

prep:
	$(MAKE) clean-local-assets
	$(MAKE) copy-local-assets