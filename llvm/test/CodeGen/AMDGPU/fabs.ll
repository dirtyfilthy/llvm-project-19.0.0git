; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -march=amdgcn -enable-misched=0 < %s | FileCheck -check-prefixes=GCN,SI %s
; RUN: llc -march=amdgcn -mcpu=tonga -enable-misched=0 < %s | FileCheck -check-prefixes=GCN,VI %s


; DAGCombiner will transform:
; (fabsf (f32 bitcast (i32 a))) => (f32 bitcast (and (i32 a), 0x7FFFFFFF))
; unless isFabsFree returns true
define amdgpu_kernel void @s_fabsf_fn_free(ptr addrspace(1) %out, i32 %in) {
; SI-LABEL: s_fabsf_fn_free:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x9
; SI-NEXT:    s_load_dword s4, s[2:3], 0xb
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_bitset0_b32 s4, 31
; SI-NEXT:    v_mov_b32_e32 v0, s4
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: s_fabsf_fn_free:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x24
; VI-NEXT:    s_load_dword s2, s[2:3], 0x2c
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    s_bitset0_b32 s2, 31
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_mov_b32_e32 v2, s2
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
  %bc= bitcast i32 %in to float
  %fabs = call float @fabsf(float %bc)
  store float %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @s_fabsf_free(ptr addrspace(1) %out, i32 %in) {
; SI-LABEL: s_fabsf_free:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dword s0, s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_bitset0_b32 s0, 31
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: s_fabsf_free:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; VI-NEXT:    s_load_dword s0, s[0:1], 0x2c
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s2
; VI-NEXT:    s_bitset0_b32 s0, 31
; VI-NEXT:    v_mov_b32_e32 v1, s3
; VI-NEXT:    v_mov_b32_e32 v2, s0
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
  %bc= bitcast i32 %in to float
  %fabs = call float @llvm.fabs.f32(float %bc)
  store float %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @s_fabsf_f32(ptr addrspace(1) %out, float %in) {
; SI-LABEL: s_fabsf_f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dword s0, s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_bitset0_b32 s0, 31
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: s_fabsf_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; VI-NEXT:    s_load_dword s0, s[0:1], 0x2c
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s2
; VI-NEXT:    s_bitset0_b32 s0, 31
; VI-NEXT:    v_mov_b32_e32 v1, s3
; VI-NEXT:    v_mov_b32_e32 v2, s0
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
  %fabs = call float @llvm.fabs.f32(float %in)
  store float %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fabs_v2f32(ptr addrspace(1) %out, <2 x float> %in) {
; SI-LABEL: fabs_v2f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_and_b32 s0, s3, 0x7fffffff
; SI-NEXT:    s_and_b32 s1, s2, 0x7fffffff
; SI-NEXT:    v_mov_b32_e32 v0, s1
; SI-NEXT:    v_mov_b32_e32 v1, s0
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fabs_v2f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_bitset0_b32 s3, 31
; VI-NEXT:    s_bitset0_b32 s2, 31
; VI-NEXT:    v_mov_b32_e32 v3, s1
; VI-NEXT:    v_mov_b32_e32 v0, s2
; VI-NEXT:    v_mov_b32_e32 v1, s3
; VI-NEXT:    v_mov_b32_e32 v2, s0
; VI-NEXT:    flat_store_dwordx2 v[2:3], v[0:1]
; VI-NEXT:    s_endpgm
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %in)
  store <2 x float> %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fabsf_v4f32(ptr addrspace(1) %out, <4 x float> %in) {
; SI-LABEL: fabsf_v4f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_bitset0_b32 s3, 31
; SI-NEXT:    s_bitset0_b32 s2, 31
; SI-NEXT:    s_bitset0_b32 s1, 31
; SI-NEXT:    s_bitset0_b32 s0, 31
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    v_mov_b32_e32 v1, s1
; SI-NEXT:    v_mov_b32_e32 v2, s2
; SI-NEXT:    v_mov_b32_e32 v3, s3
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fabsf_v4f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x34
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v4, s4
; VI-NEXT:    s_bitset0_b32 s3, 31
; VI-NEXT:    s_bitset0_b32 s2, 31
; VI-NEXT:    s_bitset0_b32 s1, 31
; VI-NEXT:    s_bitset0_b32 s0, 31
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_mov_b32_e32 v2, s2
; VI-NEXT:    v_mov_b32_e32 v3, s3
; VI-NEXT:    v_mov_b32_e32 v5, s5
; VI-NEXT:    flat_store_dwordx4 v[4:5], v[0:3]
; VI-NEXT:    s_endpgm
  %fabs = call <4 x float> @llvm.fabs.v4f32(<4 x float> %in)
  store <4 x float> %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fabsf_fn_fold(ptr addrspace(1) %out, float %in0, float %in1) {
; SI-LABEL: fabsf_fn_fold:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    v_mov_b32_e32 v0, s3
; SI-NEXT:    v_mul_f32_e64 v0, |s2|, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fabsf_fn_fold:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[0:3], s[2:3], 0x24
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s3
; VI-NEXT:    v_mul_f32_e64 v2, |s2|, v0
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
  %fabs = call float @fabsf(float %in0)
  %fmul = fmul float %fabs, %in1
  store float %fmul, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fabs_fold(ptr addrspace(1) %out, float %in0, float %in1) {
; SI-LABEL: fabs_fold:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    v_mov_b32_e32 v0, s3
; SI-NEXT:    v_mul_f32_e64 v0, |s2|, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fabs_fold:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s3
; VI-NEXT:    v_mul_f32_e64 v2, |s2|, v0
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
  %fabs = call float @llvm.fabs.f32(float %in0)
  %fmul = fmul float %fabs, %in1
  store float %fmul, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @bitpreserve_fabsf_f32(ptr addrspace(1) %out, float %in) {
; SI-LABEL: bitpreserve_fabsf_f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dword s0, s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_add_f32_e64 v0, |s0|, 1.0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: bitpreserve_fabsf_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; VI-NEXT:    s_load_dword s0, s[0:1], 0x2c
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s2
; VI-NEXT:    v_add_f32_e64 v2, |s0|, 1.0
; VI-NEXT:    v_mov_b32_e32 v1, s3
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
  %in.bc = bitcast float %in to i32
  %int.abs = and i32 %in.bc, 2147483647
  %bc = bitcast i32 %int.abs to float
  %fadd = fadd float %bc, 1.0
  store float %fadd, ptr addrspace(1) %out
  ret void
}

declare float @fabsf(float) readnone
declare float @llvm.fabs.f32(float) readnone
declare <2 x float> @llvm.fabs.v2f32(<2 x float>) readnone
declare <4 x float> @llvm.fabs.v4f32(<4 x float>) readnone
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; GCN: {{.*}}