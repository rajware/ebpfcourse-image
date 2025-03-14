.PHONY: usage

VERSION_MAJOR ?= 1
VERSION_MINOR ?= 0
BUILD_NUMBER  ?= 1
PATCH_NUMBER  ?= -beta1
VERSION_STRING = $(VERSION_MAJOR).$(VERSION_MINOR).$(BUILD_NUMBER)$(PATCH_NUMBER)

MATSYA_SOURCE_PATH =
MATSYA_SOURCE_CHECKSUM =

define VM_DESCRIPTION
Bhringa Image version $(VERSION_STRING)

Matsya base image: $(MATSYA_SOURCE_PATH)
endef
export VM_DESCRIPTION

usage:
	@echo "Usage has not yet started."

output-bhringa-vbox/Bhringa.ova: bhringa-vbox.pkr.hcl
	packer build \
		-var "source-path=$(MATSYA_SOURCE_PATH)" -var "source-checksum=$(MATSYA_SOURCE_CHECKSUM)" \
		-var "vm-version=$(VERSION_STRING)" -var "vm-description=$$VM_DESCRIPTION" $<

vbox: output-bhringa-vbox/Bhringa.ova
