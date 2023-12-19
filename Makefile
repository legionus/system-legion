MAKESHELL = /bin/bash
CURNAME = $(notdir $(CURDIR))
LOGDIR = $(HOME)/sysimage

.PHONY: clean kernels system all sync

all: kernels system

clean:
	make -C kernels clean
	make -C system clean

LOGFILE = $(LOGDIR)/$(CURNAME)-$@.log
kernels:
	@echo "Processing '$@' and logs in the $(LOGFILE) ..."
	@set -o errexit -o pipefail; \
	  make -C kernels all 2>&1 | tee "$(LOGFILE)"

LOGFILE = $(LOGDIR)/$(CURNAME)-$@.log
system:
	@echo "Processing '$@' and logs in the $(LOGFILE) ..."
	@set -o errexit -o pipefail; \
	  make -C system all 2>&1 | tee "$(LOGFILE)"
	@if [ ! -e /sysimage/stateless/local-latest.star ]; then \
	  $(CURDIR)/init-local-star && \
	  printf '%s\n' \
	   "Remember to modify local-latest.star and add the necessary settings."; \
	fi

sync:
	@rsync --remove-source-files -vrlp -- $(HOME)/sysimage/stateless/ /sysimage/stateless/
	@for d in $(HOME)/sysimage/stateless/kernel-*; do \
	  [ ! -e "$$d" ] || rmdir -- "$$d"; \
	done

.PHONY: update-latest-system

update-latest-system:
	@find /sysimage/stateless/ -mindepth 1 -maxdepth 1 -type f -name 'system-*.star' -printf '%f\n' | \
	  sort -rV | \
	  sed -r -e 's/system-([^-]+)-(.*)\.star/\1\t&/' | \
	  sort -u -k1,1 | \
	while read -r vendor star; do \
	  ln -vnsf -- "$$star" "/sysimage/stateless/system-$$vendor.star"; \
	done

.PHONY: update-latest-local

update-latest-local:
	@find /sysimage/stateless/ -mindepth 1 -maxdepth 1 -type f -name 'local-*.star' -printf '%f\n' | \
	  sort -rV | \
	  sed -r -e 's/local-([^-]+)-(.*)\.star/\1\t&/' | \
	  sort -u -k1,1 | \
	while read -r vendor star; do \
	  ln -vnsf -- "$$star" "/sysimage/stateless/local-$$vendor.star"; \
	done

.PHONY: update-latest-kernel

update-latest-kernel:
	@find /sysimage/stateless/ -mindepth 1 -maxdepth 1 -type d -name 'kernel-*' -printf '%f\n' | \
	  sort -rV | \
	  head -1 | \
	while read -r klatest; do \
	  ln -vnsf -- "$$klatest" "/sysimage/stateless/kernel-latest"; \
	done

.PHONY: update-latest

update-latest: update-latest-system update-latest-kernel update-latest-local
	@:
