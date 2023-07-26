MKI_GEN_SELF_UNPACK = $(CURDIR)/mki-gen-self-unpack
MKI_IMAGE_INITROOT_PREDB = $(WORKDIR)/init-image-predb

MKI_IMAGE_PREDB_DIR ?= $(CURDIR)/image-predb-files

gen-image-predb: $(SUBDIRS)
	@echo "mkimage: Processing '$@' ..."
	@$(MKI_GEN_SELF_UNPACK) "$(MKI_IMAGE_PREDB_DIR)" "$(MKI_IMAGE_INITROOT_PREDB)"

prepare-image-workdir: gen-image-predb

clean-image-predb: prepare-image-workdir
	@echo "mkimage: Processing '$@' ..."
	@rm -f -- $(MKI_IMAGE_INITROOT_PREDB)
