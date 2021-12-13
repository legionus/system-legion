CHROOT_IMAGE_PATCHES ?= $(CURDIR)/mki-image-patches
MKI_IMAGE_PATCHDIR ?= $(CURDIR)/image-patches.d

run-image-patches: prepare-image-workdir $(SUBDIRS)
	@echo "mkimage: Processing '$@' ..."
	@$(CHROOT_IMAGE_PATCHES)
