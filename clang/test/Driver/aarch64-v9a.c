// RUN: %clang --target=aarch64 -march=armv9a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A %s
// RUN: %clang --target=aarch64 -march=armv9-a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A %s
// RUN: %clang --target=aarch64 -mlittle-endian -march=armv9a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A %s
// RUN: %clang --target=aarch64 -mlittle-endian -march=armv9-a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A %s
// RUN: %clang --target=aarch64_be -mlittle-endian -march=armv9a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A %s
// RUN: %clang --target=aarch64_be -mlittle-endian -march=armv9-a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A %s
// GENERICV9A: "-cc1"{{.*}} "-triple" "aarch64{{.*}}" "-target-cpu" "generic" "-target-feature" "+v9a"{{.*}} "-target-feature" "+sve" "-target-feature" "+sve2"

// RUN: %clang --target=aarch64_be -march=armv9a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A-BE %s
// RUN: %clang --target=aarch64_be -march=armv9-a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A-BE %s
// RUN: %clang --target=aarch64 -mbig-endian -march=armv9a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A-BE %s
// RUN: %clang --target=aarch64 -mbig-endian -march=armv9-a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A-BE %s
// RUN: %clang --target=aarch64_be -mbig-endian -march=armv9a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A-BE %s
// RUN: %clang --target=aarch64_be -mbig-endian -march=armv9-a -### -c %s 2>&1 | FileCheck -check-prefix=GENERICV9A-BE %s
// GENERICV9A-BE: "-cc1"{{.*}} "-triple" "aarch64_be{{.*}}" "-target-cpu" "generic" "-target-feature" "+v9a"{{.*}} "-target-feature" "+sve" "-target-feature" "+sve2"

// ===== Architecture extensions =====

// RUN: %if aarch64-registered-target %{ %clang -target aarch64 -march=armv9-a --print-enabled-extensions | FileCheck -check-prefix=ARCH-EXTENSION --implicit-check-not FEAT_ %s %}
// ARCH-EXTENSION: FEAT_AMUv1
// ARCH-EXTENSION: FEAT_AdvSIMD
// ARCH-EXTENSION: FEAT_BTI
// ARCH-EXTENSION: FEAT_CCIDX
// ARCH-EXTENSION: FEAT_CRC32
// ARCH-EXTENSION: FEAT_CSV2_2
// ARCH-EXTENSION: FEAT_DIT
// ARCH-EXTENSION: FEAT_DPB
// ARCH-EXTENSION: FEAT_DPB2
// ARCH-EXTENSION: FEAT_DotProd
// ARCH-EXTENSION: FEAT_ETE
// ARCH-EXTENSION: FEAT_FCMA
// ARCH-EXTENSION: FEAT_FP
// ARCH-EXTENSION: FEAT_FP16
// ARCH-EXTENSION: FEAT_FRINTTS
// ARCH-EXTENSION: FEAT_FlagM
// ARCH-EXTENSION: FEAT_FlagM2
// ARCH-EXTENSION: FEAT_JSCVT
// ARCH-EXTENSION: FEAT_LOR
// ARCH-EXTENSION: FEAT_LRCPC
// ARCH-EXTENSION: FEAT_LRCPC2
// ARCH-EXTENSION: FEAT_LSE
// ARCH-EXTENSION: FEAT_LSE2
// ARCH-EXTENSION: FEAT_MEC
// ARCH-EXTENSION: FEAT_MPAM
// ARCH-EXTENSION: FEAT_NV, FEAT_NV2
// ARCH-EXTENSION: FEAT_PAN
// ARCH-EXTENSION: FEAT_PAN2
// ARCH-EXTENSION: FEAT_PAuth
// ARCH-EXTENSION: FEAT_RAS, FEAT_RASv1p1
// ARCH-EXTENSION: FEAT_RDM
// ARCH-EXTENSION: FEAT_RME
// ARCH-EXTENSION: FEAT_SB
// ARCH-EXTENSION: FEAT_SEL2
// ARCH-EXTENSION: FEAT_SPECRES
// ARCH-EXTENSION: FEAT_SSBS, FEAT_SSBS2
// ARCH-EXTENSION: FEAT_SVE
// ARCH-EXTENSION: FEAT_SVE2
// ARCH-EXTENSION: FEAT_TLBIOS, FEAT_TLBIRANGE
// ARCH-EXTENSION: FEAT_TRBE
// ARCH-EXTENSION: FEAT_TRF
// ARCH-EXTENSION: FEAT_UAO
// ARCH-EXTENSION: FEAT_VHE