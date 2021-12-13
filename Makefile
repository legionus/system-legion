export GLOBAL_HSH_APT_CONFIG=$(CURDIR)/apt/conf
export GLOBAL_VERBOSE=1
export CLEANUP_OUTDIR=

.PHONY: clean apt petitboot system all

all: petitboot system

clean:
	make -C apt clean
	make -C petitboot clean
	make -C system clean

apt:
	make -C apt clean all

petitboot: apt
	make -C petitboot clean all

system: apt
	make -C system clean all
