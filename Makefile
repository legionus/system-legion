export GLOBAL_HSH_APT_CONFIG=$(CURDIR)/apt/conf
export GLOBAL_VERBOSE=1
export CLEANUP_OUTDIR=

.PHONY: clean apt petitboot kernels system kickstart test all

all: petitboot kernels system

clean:
	make -C apt clean
	make -C petitboot clean
	make -C kernels clean
	make -C system clean
	make -C kickstart clean

apt:
	make -C apt clean all

petitboot: apt
	make -C petitboot clean all

kernels: apt
	make -C kernels clean all

system: apt
	make -C system clean all

kickstart: apt
	make -C kickstart clean all

test: kickstart/out/kickstart/vmlinuz kickstart/out/kickstart/initrd.img
	./test
