.DEFAULT_GOAL := help

# Set some variables
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
WORKCHAIN_ASSETS_DIR:=$(ROOT_DIR)/Docker/assets

ifndef BUILD
    BUILD:=aws_testnet
endif

ifndef DOCKER_CACHE
    DOCKER_CACHE=TRUE
endif

ifndef RUN_LOG
    RUN_LOG=FALSE
endif

help:
	@echo "1. make init"
	@echo "2. make build"
	@echo "3. make run"

# Initialise environment. By default, the environment is initialised
# to run on the AWS testnet. Environment can be changed with:
# BUILD=dev make init
init:
	$(MAKE) init-prepare
	# Copy user configured weatherchain.$(BUILD).env to assets, so builders can modify
	@cp $(ROOT_DIR)/weatherchain.$(BUILD).env $(WORKCHAIN_ASSETS_DIR)/.env
	@cp $(ROOT_DIR)/docker-compose.$(BUILD).yml $(ROOT_DIR)/docker-compose.override.yml
	@cd $(ROOT_DIR)/Docker && docker build -f init_environment/Dockerfile -t init_weatherchain_environment .
ifeq ($(BUILD),aws_testnet)
	@echo "Initialising environment for AWS Testnet"
	@docker run -v $(ROOT_DIR)/Docker/assets:/root/assets init_weatherchain_environment
else
	@echo "Initialising environment something else: $(BUILD)"
	@docker run -v $(ROOT_DIR)/Docker/assets:/root/assets --ip 192.168.43.124 --network mainchain_chainnet init_weatherchain_environment
endif
	@cp $(WORKCHAIN_ASSETS_DIR)/.env $(ROOT_DIR)/.env

# Build deployment Docker environment, based on the initialised variables.
# Must run make init first
build:
	@test -s $(ROOT_DIR)/.env || { echo "\nBUILD ERROR!\n\n.env does not exist.\n\nRun:\n\n  make init\n\nfirst. Exiting...\n"; exit 1; }
ifeq ($(DOCKER_CACHE),TRUE)
	docker-compose -f docker-compose.yml -f docker-compose.override.yml build
else
	docker-compose -f docker-compose.yml -f docker-compose.override.yml build --no-cache
endif
	@echo "TRUE" >> $(ROOT_DIR)/.is_built
	@echo "\nDone. Now run:\n\n  make run\n"

# Run deployment Docker environment.
run:
	@test -s $(ROOT_DIR)/.env || { echo "\nBUILD ERROR!\n\n.env does not exist.\n\nRun:\n\n  make init\n  make build\n\nfirst. Exiting...\n"; exit 1; }
	@test -s $(ROOT_DIR)/.is_built || { echo "\nBUILD ERROR!\n\nDocker not built yet.\n\nRun:\n\n  make build\n\nfirst. Exiting...\n"; exit 1; }
	docker-compose down --remove-orphans
ifeq ($(RUN_LOG),TRUE)
	docker-compose -f docker-compose.yml -f docker-compose.override.yml up 2>&1 | tee log.txt
else
	docker-compose -f docker-compose.yml -f docker-compose.override.yml up
endif

# Bring deployment Docker environment down
down:
	docker-compose down --remove-orphans
	$(MAKE) clean

init-prepare:
	$(MAKE) info
	$(MAKE) clean

# Output some useful info
info:
	@echo "ROOT_DIR                      : $(ROOT_DIR)"
	@echo "WORKCHAIN_ASSETS_DIR          : $(WORKCHAIN_ASSETS_DIR)"
	@echo "BUILD                         : $(BUILD)"

clean:
	@rm -f $(ROOT_DIR)/.env
	@rm -f $(WORKCHAIN_ASSETS_DIR)/.env
	@rm -f $(WORKCHAIN_ASSETS_DIR)/bootnode.key
	@rm -f $(WORKCHAIN_ASSETS_DIR)/weatherchain_genesis.json
	@rm -f $(ROOT_DIR)/docker-compose.override.yml
	@rm -f $(ROOT_DIR)/.is_built

config:
	test -s $(ROOT_DIR)/.env || { echo "\nBUILD ERROR!\n\n.env does not exist.\n\nRun:\n\n  make init\n\nfirst. Exiting...\n"; exit 1; }
	docker-compose -f docker-compose.yml -f docker-compose.override.yml config
