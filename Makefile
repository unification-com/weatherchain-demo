.DEFAULT_GOAL := all

# Set some variables
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
WORKCHAIN_ASSETS_DIR:=$(ROOT_DIR)/Docker/assets

# Build and run static Docker environment.
all:
	$(MAKE) build
	$(MAKE) run

# Build deployment Docker environment.
build:
	$(MAKE) info
	$(MAKE) init
	docker-compose build

# Build, no cache
build-nc:
	$(MAKE) prep
	docker-compose build --no-cache

# Run deployment Docker environment.
run:
	docker-compose down --remove-orphans
	docker-compose up

run-log:
	docker-compose down --remove-orphans
	docker-compose up 2>&1 | tee log.txt

# Bring deployment Docker environment down
down:
	docker-compose down --remove-orphans
	$(MAKE) clean-local-assets

# Output some useful info
info:
	@echo "ROOT_DIR                      : $(ROOT_DIR)"
	@echo "WORKCHAIN_ASSETS_DIR          : $(WORKCHAIN_ASSETS_DIR)"

init:
    # Copy user configured weatherchain.example.env to assets, so builders can modify
	@cp $(ROOT_DIR)/weatherchain.example.env $(ROOT_DIR)/Docker/assets/.env
	@cd $(ROOT_DIR)/Docker && docker build -f init_environment/Dockerfile -t init_weatherchain_environment .
	@docker run -v $(ROOT_DIR)/Docker/assets:/root/assets --ip 192.168.43.124 --network mainchain_chainnet init_weatherchain_environment
	# Copy generated .env to root dir so compose can access values
	@cp $(ROOT_DIR)/Docker/assets/.env $(ROOT_DIR)/.env