; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -mtriple=riscv32 -mattr=+v,+zfh,+zvfh,+experimental-zvfbfmin -verify-machineinstrs < %s | FileCheck -check-prefixes=CHECK,RV32 %s
; RUN: llc -mtriple=riscv64 -mattr=+v,+zfh,+zvfh,+experimental-zvfbfmin -verify-machineinstrs < %s | FileCheck -check-prefixes=CHECK,RV64 %s

define <5 x i8> @load_v5i8(ptr %p) {
; CHECK-LABEL: load_v5i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 5, e8, mf2, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    ret
  %x = load <5 x i8>, ptr %p
  ret <5 x i8> %x
}

define <5 x i8> @load_v5i8_align1(ptr %p) {
; CHECK-LABEL: load_v5i8_align1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 5, e8, mf2, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    ret
  %x = load <5 x i8>, ptr %p, align 1
  ret <5 x i8> %x
}

define <6 x i8> @load_v6i8(ptr %p) {
; CHECK-LABEL: load_v6i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 6, e8, mf2, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    ret
  %x = load <6 x i8>, ptr %p
  ret <6 x i8> %x
}

define <12 x i8> @load_v12i8(ptr %p) {
; CHECK-LABEL: load_v12i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 12, e8, m1, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    ret
  %x = load <12 x i8>, ptr %p
  ret <12 x i8> %x
}

define <6 x i16> @load_v6i16(ptr %p) {
; CHECK-LABEL: load_v6i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 6, e16, m1, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    ret
  %x = load <6 x i16>, ptr %p
  ret <6 x i16> %x
}

define <6 x half> @load_v6f16(ptr %p) {
; CHECK-LABEL: load_v6f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 6, e16, m1, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    ret
  %x = load <6 x half>, ptr %p
  ret <6 x half> %x
}

define <6 x float> @load_v6f32(ptr %p) {
; CHECK-LABEL: load_v6f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 6, e32, m2, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    ret
  %x = load <6 x float>, ptr %p
  ret <6 x float> %x
}

define <6 x double> @load_v6f64(ptr %p) {
; CHECK-LABEL: load_v6f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 6, e64, m4, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    ret
  %x = load <6 x double>, ptr %p
  ret <6 x double> %x
}

define <6 x i1> @load_v6i1(ptr %p) {
; RV32-LABEL: load_v6i1:
; RV32:       # %bb.0:
; RV32-NEXT:    lbu a0, 0(a0)
; RV32-NEXT:    srli a1, a0, 5
; RV32-NEXT:    slli a2, a0, 27
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    slli a3, a0, 28
; RV32-NEXT:    srli a3, a3, 31
; RV32-NEXT:    slli a4, a0, 29
; RV32-NEXT:    srli a4, a4, 31
; RV32-NEXT:    slli a5, a0, 30
; RV32-NEXT:    srli a5, a5, 31
; RV32-NEXT:    andi a0, a0, 1
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; RV32-NEXT:    vmv.v.x v8, a0
; RV32-NEXT:    vslide1down.vx v8, v8, a5
; RV32-NEXT:    vslide1down.vx v8, v8, a4
; RV32-NEXT:    vslide1down.vx v8, v8, a3
; RV32-NEXT:    vslide1down.vx v8, v8, a2
; RV32-NEXT:    vslide1down.vx v8, v8, a1
; RV32-NEXT:    vslidedown.vi v8, v8, 2
; RV32-NEXT:    vand.vi v8, v8, 1
; RV32-NEXT:    vmsne.vi v0, v8, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: load_v6i1:
; RV64:       # %bb.0:
; RV64-NEXT:    lbu a0, 0(a0)
; RV64-NEXT:    srli a1, a0, 5
; RV64-NEXT:    slli a2, a0, 59
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    slli a3, a0, 60
; RV64-NEXT:    srli a3, a3, 63
; RV64-NEXT:    slli a4, a0, 61
; RV64-NEXT:    srli a4, a4, 63
; RV64-NEXT:    slli a5, a0, 62
; RV64-NEXT:    srli a5, a5, 63
; RV64-NEXT:    andi a0, a0, 1
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; RV64-NEXT:    vmv.v.x v8, a0
; RV64-NEXT:    vslide1down.vx v8, v8, a5
; RV64-NEXT:    vslide1down.vx v8, v8, a4
; RV64-NEXT:    vslide1down.vx v8, v8, a3
; RV64-NEXT:    vslide1down.vx v8, v8, a2
; RV64-NEXT:    vslide1down.vx v8, v8, a1
; RV64-NEXT:    vslidedown.vi v8, v8, 2
; RV64-NEXT:    vand.vi v8, v8, 1
; RV64-NEXT:    vmsne.vi v0, v8, 0
; RV64-NEXT:    ret
  %x = load <6 x i1>, ptr %p
  ret <6 x i1> %x
}


define <4 x i32> @exact_vlen_i32_m1(ptr %p) vscale_range(2,2) {
; CHECK-LABEL: exact_vlen_i32_m1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl1re32.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <4 x i32>, ptr %p
  ret <4 x i32> %v
}

define <16 x i8> @exact_vlen_i8_m1(ptr %p) vscale_range(2,2) {
; CHECK-LABEL: exact_vlen_i8_m1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl1r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <16 x i8>, ptr %p
  ret <16 x i8> %v
}

define <32 x i8> @exact_vlen_i8_m2(ptr %p) vscale_range(2,2) {
; CHECK-LABEL: exact_vlen_i8_m2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <32 x i8>, ptr %p
  ret <32 x i8> %v
}

define <128 x i8> @exact_vlen_i8_m8(ptr %p) vscale_range(2,2) {
; CHECK-LABEL: exact_vlen_i8_m8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <128 x i8>, ptr %p
  ret <128 x i8> %v
}

define <16 x i64> @exact_vlen_i64_m8(ptr %p) vscale_range(2,2) {
; CHECK-LABEL: exact_vlen_i64_m8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8re64.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <16 x i64>, ptr %p
  ret <16 x i64> %v
}

define <8 x bfloat> @load_v8bf16(ptr %p) {
; CHECK-LABEL: load_v8bf16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    ret
  %x = load <8 x bfloat>, ptr %p
  ret <8 x bfloat> %x
}