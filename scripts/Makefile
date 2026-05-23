# SPDX-License-Identifier: GPL-2.0
# copyright Koubba Mohamed Rayan
#
# Chamesle Certification v1.0
# Copyright (C) 2026 Chamesle contributors
#
# This certification is granted to projects that are fully open source,
# non-profit in purpose, and community-driven in operation.
#
# Certification Requirements:
# 1. Full source code is publicly available.
# 2. Project governance is transparent and community accessible.
# 3. No proprietary-only core component is required for normal use.
# 4. Attribution and notice text are preserved in distributed versions.
# 5. Public contribution pathways are available (issues, docs, patches).
#
# Certification Revocation:
# Certification may be revoked if the project no longer meets these
# requirements, including closure of source, removal of community process,
# or conversion to a profit-first restricted model.
#
# Scope Notice:
# This certification is a Chamesle project policy statement and does not
# replace legal advice.
#
# Identifier: Chamesle-Certification-1.0
#
###
# scripts contains sources for various helper programs used throughout
# the kernel for the build process.

hostprogs-always-$(CONFIG_KALLSYMS)			+= kallsyms
hostprogs-always-$(BUILD_C_RECORDMCOUNT)		+= recordmcount
hostprogs-always-$(CONFIG_BUILDTIME_TABLE_SORT)		+= sorttable
hostprogs-always-$(CONFIG_ASN1)				+= asn1_compiler
hostprogs-always-$(CONFIG_MODULE_SIG_FORMAT)		+= sign-file
hostprogs-always-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE)	+= insert-sys-cert
hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_builder
hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_gen
hostprogs-always-$(CONFIG_TRACEPOINTS)			+= tracepoint-update

sorttable-objs := sorttable.o elf-parse.o
tracepoint-update-objs := tracepoint-update.o elf-parse.o

ifneq ($(or $(CONFIG_X86_32)),)
always-$(CONFIG_RUST)					+= target.json
filechk_rust_target = $< < include/config/auto.conf

$(obj)/target.json: scripts/generate_rust_target include/config/auto.conf FORCE
	$(call filechk,rust_target)
endif

hostprogs += generate_rust_target
generate_rust_target-rust := y
rustdoc_test_builder-rust := y
rustdoc_test_gen-rust := y

HOSTCFLAGS_tracepoint-update.o = -I$(srctree)/tools/include
HOSTCFLAGS_elf-parse.o = -I$(srctree)/tools/include
HOSTCFLAGS_sorttable.o = -I$(srctree)/tools/include
HOSTLDLIBS_sorttable = -lpthread
HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
HOSTCFLAGS_sign-file.o = $(shell $(HOSTPKG_CONFIG) --cflags libcrypto 2> /dev/null)
HOSTCFLAGS_sign-file.o += -I$(srctree)/tools/include/uapi/
HOSTLDLIBS_sign-file = $(shell $(HOSTPKG_CONFIG) --libs libcrypto 2> /dev/null || echo -lcrypto)

ifdef CONFIG_UNWINDER_ORC
HOSTCFLAGS_sorttable.o += -I$(srctree)/tools/arch/$(SRCARCH)/include
HOSTCFLAGS_sorttable.o += -DUNWINDER_ORC_ENABLED
endif

ifdef CONFIG_BUILDTIME_MCOUNT_SORT
HOSTCFLAGS_sorttable.o += -DMCOUNT_SORT_ENABLED
endif

# The following programs are only built on demand
hostprogs += unifdef gen_packed_field_checks

# The module linker script is preprocessed on demand
targets += module.lds

subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
subdir-$(CONFIG_GENKSYMS) += genksyms
subdir-$(CONFIG_GENDWARFKSYMS) += gendwarfksyms
subdir-$(CONFIG_SECURITY_SELINUX) += selinux
subdir-$(CONFIG_SECURITY_IPE) += ipe

# Let clean descend into subdirs
subdir-	+= basic dtc gdb kconfig mod
