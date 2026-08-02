.PHONY: help install dev build preview deploy clean

help:
	@echo "install   install dependencies"
	@echo "dev       start the local development server"
	@echo "build     build the static site into dist/"
	@echo "preview   serve the built site locally"
	@echo "deploy    build and publish to the server"

install:
	npm install

dev:
	npm run dev

build:
	npm run build

preview:
	npm run preview

deploy: build
	bash scripts/deploy.sh

clean:
	rm -rf dist .astro node_modules
