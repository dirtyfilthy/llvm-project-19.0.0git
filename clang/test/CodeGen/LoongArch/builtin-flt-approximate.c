// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --version 4
// RUN: %clang_cc1 -triple loongarch32 -target-feature +f -target-feature +frecipe -O2 -emit-llvm %s -o - | FileCheck %s
// RUN: %clang_cc1 -triple loongarch64 -target-feature +f -target-feature +frecipe -O2 -emit-llvm %s -o - | FileCheck %s

#include <larchintrin.h>

// CHECK-LABEL: @frecipe_s
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = tail call float @llvm.loongarch.frecipe.s(float [[A:%.*]])
// CHECK-NEXT:    ret float [[TMP0]]
//
float frecipe_s (float _1)
{
  return __builtin_loongarch_frecipe_s (_1);
}

// CHECK-LABEL: @frsqrte_s
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = tail call float @llvm.loongarch.frsqrte.s(float [[A:%.*]])
// CHECK-NEXT:    ret float [[TMP0]]
//
float frsqrte_s (float _1)
{
  return __builtin_loongarch_frsqrte_s (_1);
}

// CHECK-LABEL: @frecipe_s_alia
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = tail call float @llvm.loongarch.frecipe.s(float [[A:%.*]])
// CHECK-NEXT:    ret float [[TMP0]]
//
float frecipe_s_alia (float _1)
{
  return __frecipe_s (_1);
}

// CHECK-LABEL: @frsqrte_s_alia
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = tail call float @llvm.loongarch.frsqrte.s(float [[A:%.*]])
// CHECK-NEXT:    ret float [[TMP0]]
//
float frsqrte_s_alia (float _1)
{
  return __frsqrte_s (_1);
}