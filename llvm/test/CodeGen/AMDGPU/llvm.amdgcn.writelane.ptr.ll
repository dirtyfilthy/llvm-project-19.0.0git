; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 4
; RUN: llc -mtriple=amdgcn--amdhsa -mcpu=gfx802 -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX802-SDAG %s
; RUN: llc -mtriple=amdgcn--amdhsa -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX1010-SDAG %s
; RUN: llc -mtriple=amdgcn--amdhsa -mcpu=gfx1100 -verify-machineinstrs -amdgpu-enable-vopd=0 < %s | FileCheck -check-prefixes=GFX1100-SDAG %s

define void @test_writelane_p0(ptr addrspace(1) %out, ptr %src, i32 %src1) {
; GFX802-SDAG-LABEL: test_writelane_p0:
; GFX802-SDAG:       ; %bb.0:
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX802-SDAG-NEXT:    flat_load_dwordx2 v[5:6], v[0:1]
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 m0, v4
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s4, v3
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s5, v2
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_nop 0
; GFX802-SDAG-NEXT:    v_writelane_b32 v6, s4, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v5, s5, m0
; GFX802-SDAG-NEXT:    flat_store_dwordx2 v[0:1], v[5:6]
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1010-SDAG-LABEL: test_writelane_p0:
; GFX1010-SDAG:       ; %bb.0:
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-SDAG-NEXT:    global_load_dwordx2 v[5:6], v[0:1], off
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s4, v3
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s5, v4
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s6, v2
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-SDAG-NEXT:    v_writelane_b32 v6, s4, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v5, s6, s5
; GFX1010-SDAG-NEXT:    global_store_dwordx2 v[0:1], v[5:6], off
; GFX1010-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1100-SDAG-LABEL: test_writelane_p0:
; GFX1100-SDAG:       ; %bb.0:
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1100-SDAG-NEXT:    global_load_b64 v[5:6], v[0:1], off
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s0, v3
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s1, v4
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s2, v2
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v6, s0, s1
; GFX1100-SDAG-NEXT:    v_writelane_b32 v5, s2, s1
; GFX1100-SDAG-NEXT:    global_store_b64 v[0:1], v[5:6], off
; GFX1100-SDAG-NEXT:    s_setpc_b64 s[30:31]
  %oldval = load ptr, ptr addrspace(1) %out
  %writelane = call ptr @llvm.amdgcn.writelane.p0(ptr %src, i32 %src1, ptr %oldval)
  store ptr %writelane, ptr addrspace(1) %out, align 4
  ret void
}

define void @test_writelane_v3p0(ptr addrspace(1) %out, <3 x ptr> %src, i32 %src1) {
; GFX802-SDAG-LABEL: test_writelane_v3p0:
; GFX802-SDAG:       ; %bb.0:
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX802-SDAG-NEXT:    v_add_u32_e32 v13, vcc, 16, v0
; GFX802-SDAG-NEXT:    flat_load_dwordx4 v[9:12], v[0:1]
; GFX802-SDAG-NEXT:    v_addc_u32_e32 v14, vcc, 0, v1, vcc
; GFX802-SDAG-NEXT:    flat_load_dwordx2 v[15:16], v[13:14]
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 m0, v8
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s6, v5
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s7, v4
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s8, v3
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s9, v2
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s4, v7
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s5, v6
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(1)
; GFX802-SDAG-NEXT:    v_writelane_b32 v12, s6, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v11, s7, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v10, s8, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v9, s9, m0
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    v_writelane_b32 v16, s4, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v15, s5, m0
; GFX802-SDAG-NEXT:    flat_store_dwordx4 v[0:1], v[9:12]
; GFX802-SDAG-NEXT:    flat_store_dwordx2 v[13:14], v[15:16]
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1010-SDAG-LABEL: test_writelane_v3p0:
; GFX1010-SDAG:       ; %bb.0:
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-SDAG-NEXT:    s_clause 0x1
; GFX1010-SDAG-NEXT:    global_load_dwordx2 v[13:14], v[0:1], off offset:16
; GFX1010-SDAG-NEXT:    global_load_dwordx4 v[9:12], v[0:1], off
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s5, v8
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s7, v5
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s8, v4
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s9, v3
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s10, v2
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s4, v7
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s6, v6
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(1)
; GFX1010-SDAG-NEXT:    v_writelane_b32 v14, s4, s5
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-SDAG-NEXT:    v_writelane_b32 v12, s7, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v11, s8, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v10, s9, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v9, s10, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v13, s6, s5
; GFX1010-SDAG-NEXT:    global_store_dwordx4 v[0:1], v[9:12], off
; GFX1010-SDAG-NEXT:    global_store_dwordx2 v[0:1], v[13:14], off offset:16
; GFX1010-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1100-SDAG-LABEL: test_writelane_v3p0:
; GFX1100-SDAG:       ; %bb.0:
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1100-SDAG-NEXT:    s_clause 0x1
; GFX1100-SDAG-NEXT:    global_load_b64 v[13:14], v[0:1], off offset:16
; GFX1100-SDAG-NEXT:    global_load_b128 v[9:12], v[0:1], off
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s1, v8
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s3, v5
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s4, v4
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s5, v3
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s6, v2
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s0, v7
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s2, v6
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(1)
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_2)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v14, s0, s1
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v12, s3, s1
; GFX1100-SDAG-NEXT:    v_writelane_b32 v11, s4, s1
; GFX1100-SDAG-NEXT:    v_writelane_b32 v10, s5, s1
; GFX1100-SDAG-NEXT:    v_writelane_b32 v9, s6, s1
; GFX1100-SDAG-NEXT:    v_writelane_b32 v13, s2, s1
; GFX1100-SDAG-NEXT:    s_clause 0x1
; GFX1100-SDAG-NEXT:    global_store_b128 v[0:1], v[9:12], off
; GFX1100-SDAG-NEXT:    global_store_b64 v[0:1], v[13:14], off offset:16
; GFX1100-SDAG-NEXT:    s_setpc_b64 s[30:31]
  %oldval = load <3 x ptr>, ptr addrspace(1) %out
  %writelane = call <3 x ptr> @llvm.amdgcn.writelane.v3p0(<3 x ptr> %src, i32 %src1, <3 x ptr> %oldval)
  store <3 x ptr> %writelane, ptr addrspace(1) %out, align 4
  ret void
}

define void @test_writelane_p3(ptr addrspace(1) %out, ptr addrspace(3) %src, i32 %src1) {
; GFX802-SDAG-LABEL: test_writelane_p3:
; GFX802-SDAG:       ; %bb.0:
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX802-SDAG-NEXT:    flat_load_dword v4, v[0:1]
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 m0, v3
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s4, v2
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_nop 1
; GFX802-SDAG-NEXT:    v_writelane_b32 v4, s4, m0
; GFX802-SDAG-NEXT:    flat_store_dword v[0:1], v4
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1010-SDAG-LABEL: test_writelane_p3:
; GFX1010-SDAG:       ; %bb.0:
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-SDAG-NEXT:    global_load_dword v4, v[0:1], off
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s4, v2
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s5, v3
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-SDAG-NEXT:    v_writelane_b32 v4, s4, s5
; GFX1010-SDAG-NEXT:    global_store_dword v[0:1], v4, off
; GFX1010-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1100-SDAG-LABEL: test_writelane_p3:
; GFX1100-SDAG:       ; %bb.0:
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1100-SDAG-NEXT:    global_load_b32 v4, v[0:1], off
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s0, v2
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s1, v3
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v4, s0, s1
; GFX1100-SDAG-NEXT:    global_store_b32 v[0:1], v4, off
; GFX1100-SDAG-NEXT:    s_setpc_b64 s[30:31]
  %oldval = load ptr addrspace(3), ptr addrspace(1) %out
  %writelane = call ptr addrspace(3) @llvm.amdgcn.writelane.p3(ptr addrspace(3) %src, i32 %src1, ptr addrspace(3) %oldval)
  store ptr addrspace(3) %writelane, ptr addrspace(1) %out, align 4
  ret void
}

define void @test_writelane_v3p3(ptr addrspace(1) %out, <3 x ptr addrspace(3)> %src, i32 %src1) {
; GFX802-SDAG-LABEL: test_writelane_v3p3:
; GFX802-SDAG:       ; %bb.0:
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX802-SDAG-NEXT:    flat_load_dwordx3 v[6:8], v[0:1]
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 m0, v5
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s4, v4
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s5, v3
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s6, v2
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    v_writelane_b32 v8, s4, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v7, s5, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v6, s6, m0
; GFX802-SDAG-NEXT:    flat_store_dwordx3 v[0:1], v[6:8]
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1010-SDAG-LABEL: test_writelane_v3p3:
; GFX1010-SDAG:       ; %bb.0:
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-SDAG-NEXT:    global_load_dwordx3 v[6:8], v[0:1], off
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s4, v4
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s5, v5
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s6, v3
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s7, v2
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-SDAG-NEXT:    v_writelane_b32 v8, s4, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v7, s6, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v6, s7, s5
; GFX1010-SDAG-NEXT:    global_store_dwordx3 v[0:1], v[6:8], off
; GFX1010-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1100-SDAG-LABEL: test_writelane_v3p3:
; GFX1100-SDAG:       ; %bb.0:
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1100-SDAG-NEXT:    global_load_b96 v[6:8], v[0:1], off
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s0, v4
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s1, v5
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s2, v3
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s3, v2
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v8, s0, s1
; GFX1100-SDAG-NEXT:    v_writelane_b32 v7, s2, s1
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_3)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v6, s3, s1
; GFX1100-SDAG-NEXT:    global_store_b96 v[0:1], v[6:8], off
; GFX1100-SDAG-NEXT:    s_setpc_b64 s[30:31]
  %oldval = load <3 x ptr addrspace(3)>, ptr addrspace(1) %out
  %writelane = call <3 x ptr addrspace(3)> @llvm.amdgcn.writelane.v3p3(<3 x ptr addrspace(3)> %src, i32 %src1, <3 x ptr addrspace(3)> %oldval)
  store <3 x ptr addrspace(3)> %writelane, ptr addrspace(1) %out, align 4
  ret void
}

define void @test_writelane_p5(ptr addrspace(1) %out, ptr addrspace(5) %src, i32 %src1) {
; GFX802-SDAG-LABEL: test_writelane_p5:
; GFX802-SDAG:       ; %bb.0:
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX802-SDAG-NEXT:    flat_load_dword v4, v[0:1]
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 m0, v3
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s4, v2
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_nop 1
; GFX802-SDAG-NEXT:    v_writelane_b32 v4, s4, m0
; GFX802-SDAG-NEXT:    flat_store_dword v[0:1], v4
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1010-SDAG-LABEL: test_writelane_p5:
; GFX1010-SDAG:       ; %bb.0:
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-SDAG-NEXT:    global_load_dword v4, v[0:1], off
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s4, v2
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s5, v3
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-SDAG-NEXT:    v_writelane_b32 v4, s4, s5
; GFX1010-SDAG-NEXT:    global_store_dword v[0:1], v4, off
; GFX1010-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1100-SDAG-LABEL: test_writelane_p5:
; GFX1100-SDAG:       ; %bb.0:
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1100-SDAG-NEXT:    global_load_b32 v4, v[0:1], off
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s0, v2
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s1, v3
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v4, s0, s1
; GFX1100-SDAG-NEXT:    global_store_b32 v[0:1], v4, off
; GFX1100-SDAG-NEXT:    s_setpc_b64 s[30:31]
  %oldval = load ptr addrspace(5), ptr addrspace(1) %out
  %writelane = call ptr addrspace(5) @llvm.amdgcn.writelane.p5(ptr addrspace(5) %src, i32 %src1, ptr addrspace(5) %oldval)
  store ptr addrspace(5) %writelane, ptr addrspace(1) %out, align 4
  ret void
}

define void @test_writelane_v3p5(ptr addrspace(1) %out, <3 x ptr addrspace(5)> %src, i32 %src1) {
; GFX802-SDAG-LABEL: test_writelane_v3p5:
; GFX802-SDAG:       ; %bb.0:
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX802-SDAG-NEXT:    flat_load_dwordx3 v[6:8], v[0:1]
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 m0, v5
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s4, v4
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s5, v3
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s6, v2
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    v_writelane_b32 v8, s4, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v7, s5, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v6, s6, m0
; GFX802-SDAG-NEXT:    flat_store_dwordx3 v[0:1], v[6:8]
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1010-SDAG-LABEL: test_writelane_v3p5:
; GFX1010-SDAG:       ; %bb.0:
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-SDAG-NEXT:    global_load_dwordx3 v[6:8], v[0:1], off
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s4, v4
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s5, v5
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s6, v3
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s7, v2
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-SDAG-NEXT:    v_writelane_b32 v8, s4, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v7, s6, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v6, s7, s5
; GFX1010-SDAG-NEXT:    global_store_dwordx3 v[0:1], v[6:8], off
; GFX1010-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1100-SDAG-LABEL: test_writelane_v3p5:
; GFX1100-SDAG:       ; %bb.0:
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1100-SDAG-NEXT:    global_load_b96 v[6:8], v[0:1], off
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s0, v4
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s1, v5
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s2, v3
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s3, v2
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v8, s0, s1
; GFX1100-SDAG-NEXT:    v_writelane_b32 v7, s2, s1
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_3)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v6, s3, s1
; GFX1100-SDAG-NEXT:    global_store_b96 v[0:1], v[6:8], off
; GFX1100-SDAG-NEXT:    s_setpc_b64 s[30:31]
  %oldval = load <3 x ptr addrspace(5)>, ptr addrspace(1) %out
  %writelane = call <3 x ptr addrspace(5)> @llvm.amdgcn.writelane.v3p5(<3 x ptr addrspace(5)> %src, i32 %src1, <3 x ptr addrspace(5)> %oldval)
  store <3 x ptr addrspace(5)> %writelane, ptr addrspace(1) %out, align 4
  ret void
}

define void @test_writelane_p6(ptr addrspace(1) %out, ptr addrspace(6) %src, i32 %src1) {
; GFX802-SDAG-LABEL: test_writelane_p6:
; GFX802-SDAG:       ; %bb.0:
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX802-SDAG-NEXT:    flat_load_dword v4, v[0:1]
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 m0, v3
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s4, v2
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_nop 1
; GFX802-SDAG-NEXT:    v_writelane_b32 v4, s4, m0
; GFX802-SDAG-NEXT:    flat_store_dword v[0:1], v4
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1010-SDAG-LABEL: test_writelane_p6:
; GFX1010-SDAG:       ; %bb.0:
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-SDAG-NEXT:    global_load_dword v4, v[0:1], off
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s4, v2
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s5, v3
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-SDAG-NEXT:    v_writelane_b32 v4, s4, s5
; GFX1010-SDAG-NEXT:    global_store_dword v[0:1], v4, off
; GFX1010-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1100-SDAG-LABEL: test_writelane_p6:
; GFX1100-SDAG:       ; %bb.0:
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1100-SDAG-NEXT:    global_load_b32 v4, v[0:1], off
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s0, v2
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s1, v3
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v4, s0, s1
; GFX1100-SDAG-NEXT:    global_store_b32 v[0:1], v4, off
; GFX1100-SDAG-NEXT:    s_setpc_b64 s[30:31]
  %oldval = load ptr addrspace(6), ptr addrspace(1) %out
  %writelane = call ptr addrspace(6) @llvm.amdgcn.writelane.p6(ptr addrspace(6) %src, i32 %src1, ptr addrspace(6) %oldval)
  store ptr addrspace(6) %writelane, ptr addrspace(1) %out, align 4
  ret void
}

define void @test_writelane_v3p6(ptr addrspace(1) %out, <3 x ptr addrspace(6)> %src, i32 %src1) {
; GFX802-SDAG-LABEL: test_writelane_v3p6:
; GFX802-SDAG:       ; %bb.0:
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX802-SDAG-NEXT:    flat_load_dwordx3 v[6:8], v[0:1]
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 m0, v5
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s4, v4
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s5, v3
; GFX802-SDAG-NEXT:    v_readfirstlane_b32 s6, v2
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    v_writelane_b32 v8, s4, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v7, s5, m0
; GFX802-SDAG-NEXT:    v_writelane_b32 v6, s6, m0
; GFX802-SDAG-NEXT:    flat_store_dwordx3 v[0:1], v[6:8]
; GFX802-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX802-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1010-SDAG-LABEL: test_writelane_v3p6:
; GFX1010-SDAG:       ; %bb.0:
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-SDAG-NEXT:    global_load_dwordx3 v[6:8], v[0:1], off
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s4, v4
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s5, v5
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s6, v3
; GFX1010-SDAG-NEXT:    v_readfirstlane_b32 s7, v2
; GFX1010-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-SDAG-NEXT:    v_writelane_b32 v8, s4, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v7, s6, s5
; GFX1010-SDAG-NEXT:    v_writelane_b32 v6, s7, s5
; GFX1010-SDAG-NEXT:    global_store_dwordx3 v[0:1], v[6:8], off
; GFX1010-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1100-SDAG-LABEL: test_writelane_v3p6:
; GFX1100-SDAG:       ; %bb.0:
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1100-SDAG-NEXT:    global_load_b96 v[6:8], v[0:1], off
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s0, v4
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s1, v5
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s2, v3
; GFX1100-SDAG-NEXT:    v_readfirstlane_b32 s3, v2
; GFX1100-SDAG-NEXT:    s_waitcnt vmcnt(0)
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v8, s0, s1
; GFX1100-SDAG-NEXT:    v_writelane_b32 v7, s2, s1
; GFX1100-SDAG-NEXT:    s_delay_alu instid0(VALU_DEP_3)
; GFX1100-SDAG-NEXT:    v_writelane_b32 v6, s3, s1
; GFX1100-SDAG-NEXT:    global_store_b96 v[0:1], v[6:8], off
; GFX1100-SDAG-NEXT:    s_setpc_b64 s[30:31]
  %oldval = load <3 x ptr addrspace(6)>, ptr addrspace(1) %out
  %writelane = call <3 x ptr addrspace(6)> @llvm.amdgcn.writelane.v3p6(<3 x ptr addrspace(6)> %src, i32 %src1, <3 x ptr addrspace(6)> %oldval)
  store <3 x ptr addrspace(6)> %writelane, ptr addrspace(1) %out, align 4
  ret void
}