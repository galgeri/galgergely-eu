.PHONY: help \

.DEFAULT_GOAL := help

NODE_IMAGE := node:22

# Set dir of Makefile to a variable to use later
MAKEPATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PWD := $(dir $(MAKEPATH))

USER_ID=$(shell id -u)
GROUP_ID=$(shell id -g)

help: ## * Show help (Default task)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

npm-install: ## Run npm install
	docker run -it -v $(PWD):/application -w /application --user $(USER_ID):$(GROUP_ID) $(NODE_IMAGE) npm install

npm-build-css: ## Run npm run build:css to build and minify CSS
	docker run -it -v $(PWD):/application -w /application --user $(USER_ID):$(GROUP_ID) $(NODE_IMAGE) npm run build:css

npm-watch-css: ## Run npm run watch:css to watch and build CSS
	docker run -it -v $(PWD):/application -w /application --user $(USER_ID):$(GROUP_ID) $(NODE_IMAGE) npm run watch:css

npm-shell: ## Run npm shell
	docker run -it -v $(PWD):/application -w /application --user $(USER_ID):$(GROUP_ID) $(NODE_IMAGE) bash

npm-shell-root: ## Run npm shell as root
	docker run -it -v $(PWD):/application -w /application -u 0 $(NODE_IMAGE) bash

cleanup: ## Cleanup project
	rm -rf node_modules

serve: ## Run PHP server
	docker run --rm -it -v $(PWD):/application -p 127.0.0.1:8080:8080 -w /application php:8.4-fpm-alpine php -S 0.0.0.0:8080
