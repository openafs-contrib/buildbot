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
	@echo "  lint        run lint checks"
	@echo "  test        run unit and molecule tests"
	@echo "  build       build openafs collection"
	@echo "  install     install openafs collection"
	@echo "  clean       remove generated files"
	@echo "  distclean   remove generated files and virtualenv"

.venv/bin/activate:
	test -d .venv || $(PYTHON) -m venv .venv
	.venv/bin/pip install -U pip
	.venv/bin/pip install wheel
	.venv/bin/pip install molecule[ansible] molecule-vagrant molecule-virtup \
                          python-vagrant ansible-lint flake8 pyflakes pytest \
                          sphinx sphinx-rtd-theme ansible-doc-extractor
	touch .venv/bin/activate

init venv: .venv/bin/activate

builds/$(NAMESPACE)-$(NAME)-$(VERSION).tar.gz:
	mkdir -p builds
	ansible-galaxy collection build --output-path builds .

build: builds/$(NAMESPACE)-$(NAME)-$(VERSION).tar.gz

install: build
	ansible-galaxy collection install $(UPDATE) builds/$(NAMESPACE)-$(NAME)-$(VERSION).tar.gz

clean:
	rm -rf builds
	$(MAKE) -C tests clean

distclean: clean
	rm -rf .venv
