# Copyright (c) 2021 Sine Nomine Associates

.PHONY: help init build install clean distclean

NAMESPACE := $(strip $(subst namespace:,,$(shell grep namespace: galaxy.yml)))
NAME := $(strip $(subst name:,,$(shell grep name: galaxy.yml)))
VERSION := $(strip $(subst version:,,$(shell grep version: galaxy.yml)))
PYTHON := /usr/bin/python3
UPDATE := --force

help:
	@echo "usage: make <target>"
	@echo "targets:"
	@echo "  venv        install virtualenv"
	@echo "  build       build openafs collection"
	@echo "  install     install openafs collection"
	@echo "  clean       remove generated files"
	@echo "  distclean   remove generated files and virtualenv"

.venv/bin/activate:
	test -d .venv || $(PYTHON) -m venv .venv
	.venv/bin/pip install -U pip
	.venv/bin/pip install -r requirements.txt
	touch .venv/bin/activate

init venv: .venv/bin/activate

builds/$(NAMESPACE)-$(NAME)-$(VERSION).tar.gz:
	mkdir -p builds
	.venv/bin/ansible-galaxy collection build --output-path builds .

build: builds/$(NAMESPACE)-$(NAME)-$(VERSION).tar.gz

install: build
	.venv/bin/ansible-galaxy collection install $(UPDATE) builds/$(NAMESPACE)-$(NAME)-$(VERSION).tar.gz

clean:
	rm -rf builds

distclean: clean
	rm -rf .venv
