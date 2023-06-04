export GLOBAL_HSH_APT_CONFIG=$(CURDIR)/apt/conf
export GLOBAL_VERBOSE=1
export CLEANUP_OUTDIR=

.PHONY: clean apt kernels system all

all: kernels system

clean:
	make -C apt clean
	make -C kernels clean
	make -C system clean
	make -C kickstart clean

apt:
	make -C apt clean all

kernels: apt
	make -C kernels clean all

system: apt
	make -C system clean all
	@if [ ! -e /sysimage/stateless/local-latest.star ]; then \
	  $(CURDIR)/init-local-star && \
	  printf '%s\n' \
	   "Remember to modify local-latest.star and add the necessary settings."; \
	fi

sync:
	@rsync --remove-source-files -vrlp -- $(HOME)/sysimage/stateless/ /sysimage/stateless/
