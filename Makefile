.DEFAULT_GOAL := help

# Set some variables
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
WORKCHAIN_ASSETS_DIR:=$(ROOT_DIR)/Docker/assets

help:
	@echo "1. make init"
	@echo "2. make build"
	@echo "3. make run"

# INIT DEV ENVIRONMENT
init-dev:
	$(MAKE) init-prepare
	# Copy user configured weatherchain.dev.env to assets, so builders can modify
	@cp $(ROOT_DIR)/weatherchain.dev.env $(WORKCHAIN_ASSETS_DIR)/.env
	$(MAKE) init-run

# INIT TEST ENVIRONMENT
init:
	$(MAKE) init-prepare
	# Copy user configured weatherchain.dev.env to assets, so builders can modify
	@cp $(ROOT_DIR)/weatherchain.test.env $(WORKCHAIN_ASSETS_DIR)/.env
	$(MAKE) init-run

# Build deployment Docker environment.
build:
	test -s $(ROOT_DIR)/.env || { echo "\nBUILD ERROR!\n\n.env does not exist.\n\nRun:\n\n  make init\n\nfirst. Exiting...\n"; exit 1; }
	docker-compose build
	@echo "\nDone. Now run:\n\n  make run\n"


# Build, no cache
build-nc:
	docker-compose build --no-cache

# Run deployment Docker environment.
run:
	test -s $(ROOT_DIR)/.env || { echo "\nBUILD ERROR!\n\n.env does not exist.\n\nRun:\n\n  make init\n  make build\n\nfirst. Exiting...\n"; exit 1; }
	docker-compose down --remove-orphans
	docker-compose up

run-log:
	docker-compose down --remove-orphans
	docker-compose up 2>&1 | tee log.txt

# Bring deployment Docker environment down
down:
	docker-compose down --remove-orphans
	$(MAKE) clean

init-prepare:
	$(MAKE) info
	$(MAKE) clean

init-run:
	@cd $(ROOT_DIR)/Docker && docker build -f init_environment/Dockerfile -t init_weatherchain_environment .
	@docker run -v $(ROOT_DIR)/Docker/assets:/root/assets --ip 192.168.43.124 --network mainchain_chainnet init_weatherchain_environment
	# Copy generated .env to root dir so compose can access values
	@cp $(WORKCHAIN_ASSETS_DIR)/.env $(ROOT_DIR)/.env

# Output some useful info
info:
	@echo "ROOT_DIR                      : $(ROOT_DIR)"
	@echo "WORKCHAIN_ASSETS_DIR          : $(WORKCHAIN_ASSETS_DIR)"

clean:
	@rm -f $(ROOT_DIR)/.env
	@rm -f $(WORKCHAIN_ASSETS_DIR)/.env
	@rm -f $(WORKCHAIN_ASSETS_DIR)/bootnode.key
	@rm -f $(WORKCHAIN_ASSETS_DIR)/weatherchain_genesis.json
	@rm -rf $(WORKCHAIN_ASSETS_DIR)/workchain_root_sc/build