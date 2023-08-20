MAKESHELL = /bin/bash
CURNAME = $(notdir $(CURDIR))
LOGDIR = $(HOME)/sysimage

export GLOBAL_HSH_APT_CONFIG=$(CURDIR)/apt/conf
export GLOBAL_VERBOSE=1
export CLEANUP_OUTDIR=

.PHONY: clean apt kernels system all

all: kernels system

clean:
	make -C apt clean
	make -C kernels clean
	make -C system clean

LOGFILE = $(LOGDIR)/$(CURNAME)-$@.log
apt:
	@echo "Processing '$@' and logs in the $(LOGFILE) ..."
	@set -o errexit -o pipefail; \
	  make -C apt clean all 2>&1 | tee "$(LOGFILE)"

LOGFILE = $(LOGDIR)/$(CURNAME)-$@.log
kernels: apt
	@echo "Processing '$@' and logs in the $(LOGFILE) ..."
	@set -o errexit -o pipefail; \
	  make -C kernels clean all 2>&1 | tee "$(LOGFILE)"

LOGFILE = $(LOGDIR)/$(CURNAME)-$@.log
system: apt
	@echo "Processing '$@' and logs in the $(LOGFILE) ..."
	@set -o errexit -o pipefail; \
	  make -C system clean all 2>&1 | tee "$(LOGFILE)"
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
