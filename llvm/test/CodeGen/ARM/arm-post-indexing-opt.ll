; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -o - < %s | FileCheck %s

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8-unknown-linux-gnueabihf"

define <4 x float> @test(ptr %A) {
; CHECK-LABEL: test:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.32 {d16, d17}, [r0]!
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]!
; CHECK-NEXT:    vadd.f32 q8, q8, q9
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]
; CHECK-NEXT:    vadd.f32 q0, q8, q9
; CHECK-NEXT:    bx lr
  %X = load <4 x float>, ptr %A, align 4
  %Y.ptr.elt = getelementptr inbounds float, ptr %A, i32 4
  %Y = load <4 x float>, ptr %Y.ptr.elt, align 4
  %Z.ptr.elt = getelementptr inbounds float, ptr %A, i32 8
  %Z = load <4 x float>, ptr %Z.ptr.elt, align 4
  %tmp.sum = fadd <4 x float> %X, %Y
  %sum = fadd <4 x float> %tmp.sum, %Z
  ret <4 x float> %sum
}

define <4 x float> @test_stride(ptr %A) {
; CHECK-LABEL: test_stride:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    mov r1, #24
; CHECK-NEXT:    vld1.32 {d16, d17}, [r0], r1
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0], r1
; CHECK-NEXT:    vadd.f32 q8, q8, q9
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]
; CHECK-NEXT:    vadd.f32 q0, q8, q9
; CHECK-NEXT:    bx lr
  %X = load <4 x float>, ptr %A, align 4
  %Y.ptr.elt = getelementptr inbounds float, ptr %A, i32 6
  %Y = load <4 x float>, ptr %Y.ptr.elt, align 4
  %Z.ptr.elt = getelementptr inbounds float, ptr %A, i32 12
  %Z = load <4 x float>, ptr %Z.ptr.elt, align 4
  %tmp.sum = fadd <4 x float> %X, %Y
  %sum = fadd <4 x float> %tmp.sum, %Z
  ret <4 x float> %sum
}

define <4 x float> @test_stride_mixed(ptr %A) {
; CHECK-LABEL: test_stride_mixed:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    mov r1, #24
; CHECK-NEXT:    vld1.32 {d16, d17}, [r0], r1
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]!
; CHECK-NEXT:    vadd.f32 q8, q8, q9
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]
; CHECK-NEXT:    vadd.f32 q0, q8, q9
; CHECK-NEXT:    bx lr
  %X = load <4 x float>, ptr %A, align 4
  %Y.ptr.elt = getelementptr inbounds float, ptr %A, i32 6
  %Y = load <4 x float>, ptr %Y.ptr.elt, align 4
  %Z.ptr.elt = getelementptr inbounds float, ptr %A, i32 10
  %Z = load <4 x float>, ptr %Z.ptr.elt, align 4
  %tmp.sum = fadd <4 x float> %X, %Y
  %sum = fadd <4 x float> %tmp.sum, %Z
  ret <4 x float> %sum
}

; Refrain from using multiple stride registers
define <4 x float> @test_stride_noop(ptr %A) {
; CHECK-LABEL: test_stride_noop:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    mov r1, #24
; CHECK-NEXT:    vld1.32 {d16, d17}, [r0], r1
; CHECK-NEXT:    mov r1, #32
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0], r1
; CHECK-NEXT:    vadd.f32 q8, q8, q9
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]
; CHECK-NEXT:    vadd.f32 q0, q8, q9
; CHECK-NEXT:    bx lr
  %X = load <4 x float>, ptr %A, align 4
  %Y.ptr.elt = getelementptr inbounds float, ptr %A, i32 6
  %Y = load <4 x float>, ptr %Y.ptr.elt, align 4
  %Z.ptr.elt = getelementptr inbounds float, ptr %A, i32 14
  %Z = load <4 x float>, ptr %Z.ptr.elt, align 4
  %tmp.sum = fadd <4 x float> %X, %Y
  %sum = fadd <4 x float> %tmp.sum, %Z
  ret <4 x float> %sum
}

define <4 x float> @test_positive_initial_offset(ptr %A) {
; CHECK-LABEL: test_positive_initial_offset:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    add r0, r0, #32
; CHECK-NEXT:    vld1.32 {d16, d17}, [r0]!
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]!
; CHECK-NEXT:    vadd.f32 q8, q8, q9
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]
; CHECK-NEXT:    vadd.f32 q0, q8, q9
; CHECK-NEXT:    bx lr
  %X.ptr.elt = getelementptr inbounds float, ptr %A, i32 8
  %X = load <4 x float>, ptr %X.ptr.elt, align 4
  %Y.ptr.elt = getelementptr inbounds float, ptr %A, i32 12
  %Y = load <4 x float>, ptr %Y.ptr.elt, align 4
  %Z.ptr.elt = getelementptr inbounds float, ptr %A, i32 16
  %Z = load <4 x float>, ptr %Z.ptr.elt, align 4
  %tmp.sum = fadd <4 x float> %X, %Y
  %sum = fadd <4 x float> %tmp.sum, %Z
  ret <4 x float> %sum
}

define <4 x float> @test_negative_initial_offset(ptr %A) {
; CHECK-LABEL: test_negative_initial_offset:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    sub r0, r0, #64
; CHECK-NEXT:    vld1.32 {d16, d17}, [r0]!
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]!
; CHECK-NEXT:    vadd.f32 q8, q8, q9
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]
; CHECK-NEXT:    vadd.f32 q0, q8, q9
; CHECK-NEXT:    bx lr
  %X.ptr.elt = getelementptr inbounds float, ptr %A, i32 -16
  %X = load <4 x float>, ptr %X.ptr.elt, align 4
  %Y.ptr.elt = getelementptr inbounds float, ptr %A, i32 -12
  %Y = load <4 x float>, ptr %Y.ptr.elt, align 4
  %Z.ptr.elt = getelementptr inbounds float, ptr %A, i32 -8
  %Z = load <4 x float>, ptr %Z.ptr.elt, align 4
  %tmp.sum = fadd <4 x float> %X, %Y
  %sum = fadd <4 x float> %tmp.sum, %Z
  ret <4 x float> %sum
}

@global_float_array = external global [128 x float], align 4
define <4 x float> @test_global() {
; CHECK-LABEL: test_global:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, :lower16:global_float_array
; CHECK-NEXT:    movt r0, :upper16:global_float_array
; CHECK-NEXT:    add r0, r0, #32
; CHECK-NEXT:    vld1.32 {d16, d17}, [r0]!
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]!
; CHECK-NEXT:    vadd.f32 q8, q8, q9
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]
; CHECK-NEXT:    vadd.f32 q0, q8, q9
; CHECK-NEXT:    bx lr
  %X = load <4 x float>, ptr getelementptr inbounds ([128 x float], ptr @global_float_array, i32 0, i32 8), align 4
  %Y = load <4 x float>, ptr getelementptr inbounds ([128 x float], ptr @global_float_array, i32 0, i32 12), align 4
  %Z = load <4 x float>, ptr getelementptr inbounds ([128 x float], ptr @global_float_array, i32 0, i32 16), align 4
  %tmp.sum = fadd <4 x float> %X, %Y
  %sum = fadd <4 x float> %tmp.sum, %Z
  ret <4 x float> %sum
}

define <4 x float> @test_stack() {
; Use huge alignment to test that ADD would not be converted to OR
; CHECK-LABEL: test_stack:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r10, r11, lr}
; CHECK-NEXT:    push {r4, r10, r11, lr}
; CHECK-NEXT:    .setfp r11, sp, #8
; CHECK-NEXT:    add r11, sp, #8
; CHECK-NEXT:    .pad #240
; CHECK-NEXT:    sub sp, sp, #240
; CHECK-NEXT:    bfc sp, #0, #7
; CHECK-NEXT:    mov r4, sp
; CHECK-NEXT:    mov r0, r4
; CHECK-NEXT:    bl external_function
; CHECK-NEXT:    vld1.32 {d16, d17}, [r4:128]!
; CHECK-NEXT:    vld1.32 {d18, d19}, [r4:128]!
; CHECK-NEXT:    vadd.f32 q8, q8, q9
; CHECK-NEXT:    vld1.64 {d18, d19}, [r4:128]
; CHECK-NEXT:    vadd.f32 q0, q8, q9
; CHECK-NEXT:    sub sp, r11, #8
; CHECK-NEXT:    pop {r4, r10, r11, pc}
  %array = alloca [32 x float], align 128
  call void @external_function(ptr %array)
  %X = load <4 x float>, ptr %array, align 4
  %Y.ptr.elt = getelementptr inbounds [32 x float], ptr %array, i32 0, i32 4
  %Y = load <4 x float>, ptr %Y.ptr.elt, align 4
  %Z.ptr.elt = getelementptr inbounds [32 x float], ptr %array, i32 0, i32 8
  %Z = load <4 x float>, ptr %Z.ptr.elt, align 4
  %tmp.sum = fadd <4 x float> %X, %Y
  %sum = fadd <4 x float> %tmp.sum, %Z
  ret <4 x float> %sum
}

define <2 x double> @test_double(ptr %A) {
; CHECK-LABEL: test_double:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    add r0, r0, #64
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]!
; CHECK-NEXT:    vld1.64 {d18, d19}, [r0]!
; CHECK-NEXT:    vadd.f64 d20, d17, d19
; CHECK-NEXT:    vadd.f64 d16, d16, d18
; CHECK-NEXT:    vld1.64 {d22, d23}, [r0]
; CHECK-NEXT:    vadd.f64 d1, d20, d23
; CHECK-NEXT:    vadd.f64 d0, d16, d22
; CHECK-NEXT:    bx lr
  %X.ptr.elt = getelementptr inbounds double, ptr %A, i32 8
  %X = load <2 x double>, ptr %X.ptr.elt, align 8
  %Y.ptr.elt = getelementptr inbounds double, ptr %A, i32 10
  %Y = load <2 x double>, ptr %Y.ptr.elt, align 8
  %Z.ptr.elt = getelementptr inbounds double, ptr %A, i32 12
  %Z = load <2 x double>, ptr %Z.ptr.elt, align 8
  %tmp.sum = fadd <2 x double> %X, %Y
  %sum = fadd <2 x double> %tmp.sum, %Z
  ret <2 x double> %sum
}

define void @test_various_instructions(ptr %A) {
; CHECK-LABEL: test_various_instructions:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.32 {d16, d17}, [r0]!
; CHECK-NEXT:    vld1.32 {d18, d19}, [r0]!
; CHECK-NEXT:    vadd.f32 q8, q8, q9
; CHECK-NEXT:    vst1.32 {d16, d17}, [r0]
; CHECK-NEXT:    bx lr
  %X = call <4 x float> @llvm.arm.neon.vld1.v4f32.p0(ptr %A, i32 1)
  %Y.ptr.elt = getelementptr inbounds float, ptr %A, i32 4
  %Y = load <4 x float>, ptr %Y.ptr.elt, align 4
  %Z.ptr.elt = getelementptr inbounds float, ptr %A, i32 8
  %Z = fadd <4 x float> %X, %Y
  tail call void @llvm.arm.neon.vst1.p0.v4f32(ptr nonnull %Z.ptr.elt, <4 x float> %Z, i32 4)
  ret void
}

define void @test_lsr_geps(ptr %a, ptr %b, i32 %n) {
; CHECK-LABEL: test_lsr_geps:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB10_1: @ %for.body.preheader
; CHECK-NEXT:    mov r12, #0
; CHECK-NEXT:  .LBB10_2: @ %for.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add r3, r0, r12
; CHECK-NEXT:    subs r2, r2, #1
; CHECK-NEXT:    vld1.32 {d16, d17}, [r3]!
; CHECK-NEXT:    vld1.32 {d18, d19}, [r3]!
; CHECK-NEXT:    vld1.32 {d20, d21}, [r3]!
; CHECK-NEXT:    vld1.32 {d22, d23}, [r3]
; CHECK-NEXT:    add r3, r1, r12
; CHECK-NEXT:    add r12, r12, #64
; CHECK-NEXT:    vst1.32 {d16, d17}, [r3]!
; CHECK-NEXT:    vst1.32 {d18, d19}, [r3]!
; CHECK-NEXT:    vst1.32 {d20, d21}, [r3]!
; CHECK-NEXT:    vst1.32 {d22, d23}, [r3]
; CHECK-NEXT:    bne .LBB10_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    bx lr
entry:
  %cmp61 = icmp sgt i32 %n, 0
  br i1 %cmp61, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  br label %for.body

for.cond.cleanup:
  ret void

for.body:
  %lsr.iv1 = phi i32 [ 0, %for.body.preheader ], [ %lsr.iv.next2, %for.body ]
  %lsr.iv = phi i32 [ %n, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %uglygep19 = getelementptr i8, ptr %a, i32 %lsr.iv1
  %0 = load <4 x float>, ptr %uglygep19, align 4
  %uglygep16 = getelementptr i8, ptr %a, i32 %lsr.iv1
  %scevgep18 = getelementptr <4 x float>, ptr %uglygep16, i32 1
  %1 = load <4 x float>, ptr %scevgep18, align 4
  %uglygep13 = getelementptr i8, ptr %a, i32 %lsr.iv1
  %scevgep15 = getelementptr <4 x float>, ptr %uglygep13, i32 2
  %2 = load <4 x float>, ptr %scevgep15, align 4
  %uglygep10 = getelementptr i8, ptr %a, i32 %lsr.iv1
  %scevgep12 = getelementptr <4 x float>, ptr %uglygep10, i32 3
  %3 = load <4 x float>, ptr %scevgep12, align 4
  %uglygep8 = getelementptr i8, ptr %b, i32 %lsr.iv1
  tail call void @llvm.arm.neon.vst1.p0.v4f32(ptr %uglygep8, <4 x float> %0, i32 4)
  %uglygep6 = getelementptr i8, ptr %b, i32 %lsr.iv1
  %scevgep7 = getelementptr i8, ptr %uglygep6, i32 16
  tail call void @llvm.arm.neon.vst1.p0.v4f32(ptr nonnull %scevgep7, <4 x float> %1, i32 4)
  %uglygep4 = getelementptr i8, ptr %b, i32 %lsr.iv1
  %scevgep5 = getelementptr i8, ptr %uglygep4, i32 32
  tail call void @llvm.arm.neon.vst1.p0.v4f32(ptr nonnull %scevgep5, <4 x float> %2, i32 4)
  %uglygep = getelementptr i8, ptr %b, i32 %lsr.iv1
  %scevgep = getelementptr i8, ptr %uglygep, i32 48
  tail call void @llvm.arm.neon.vst1.p0.v4f32(ptr nonnull %scevgep, <4 x float> %3, i32 4)
  %lsr.iv.next = add i32 %lsr.iv, -1
  %lsr.iv.next2 = add nuw i32 %lsr.iv1, 64
  %exitcond.not = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

declare void @external_function(ptr)
declare <4 x float> @llvm.arm.neon.vld1.v4f32.p0(ptr, i32) nounwind readonly
declare void @llvm.arm.neon.vst1.p0.v4f32(ptr, <4 x float>, i32) nounwind argmemonly