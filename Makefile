.PHONY: usage vbox clean-vbox clean
.DEFAULT_GOAL: usage

VERSION_MAJOR ?= 1
VERSION_MINOR ?= 0
BUILD_NUMBER  ?= 1
PATCH_NUMBER  ?= -beta1
VERSION_STRING = $(VERSION_MAJOR).$(VERSION_MINOR).$(BUILD_NUMBER)$(PATCH_NUMBER)

MATSYA_SOURCE_PATH =
MATSYA_KEY_PAIR_PATH =

define VM_DESCRIPTION
Bhringa Image version $(VERSION_STRING)

Matsya base image: $(MATSYA_SOURCE_PATH)
endef
export VM_DESCRIPTION

usage:
	@echo "Usage: make vbox|clean-vbox|clean"

output-bhringa-vbox/Bhringa-$(VERSION_STRING).ova: bhringa-vbox.pkr.hcl
	packer build \
		-var "source-path=$(MATSYA_SOURCE_PATH)" \
		-var "root-certificate=$(MATSYA_KEY_PAIR_PATH)" \
		-var "vm-version=$(VERSION_STRING)" -var "vm-description=$$VM_DESCRIPTION" $<

vbox: output-bhringa-vbox/Bhringa-$(VERSION_STRING).ova

clean-vbox:
	rm -rf output-bhringa-vbox

clean: clean-vbox
