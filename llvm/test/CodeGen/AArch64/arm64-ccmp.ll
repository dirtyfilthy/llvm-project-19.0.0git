; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -debugify-and-strip-all-safe -mcpu=cyclone -verify-machineinstrs -aarch64-enable-ccmp -aarch64-stress-ccmp | FileCheck %s --check-prefixes=CHECK,SDISEL
; RUN: llc < %s -debugify-and-strip-all-safe -mcpu=cyclone -verify-machineinstrs -aarch64-enable-ccmp -aarch64-stress-ccmp -global-isel -global-isel-abort=2 | FileCheck %s --check-prefixes=CHECK,GISEL
target triple = "arm64-apple-ios"

define i32 @single_same(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: single_same:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #5
; CHECK-NEXT:    ccmp w1, #17, #4, ne
; CHECK-NEXT:    b.ne LBB0_2
; CHECK-NEXT:  ; %bb.1: ; %if.then
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; CHECK-NEXT:    bl _foo
; CHECK-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; CHECK-NEXT:  LBB0_2: ; %if.end
; CHECK-NEXT:    mov w0, #7 ; =0x7
; CHECK-NEXT:    ret
entry:
  %cmp = icmp eq i32 %a, 5
  %cmp1 = icmp eq i32 %b, 17
  %or.cond = or i1 %cmp, %cmp1
  br i1 %or.cond, label %if.then, label %if.end

if.then:
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:
  ret i32 7
}

; Different condition codes for the two compares.
define i32 @single_different(i32 %a, i32 %b) nounwind ssp {
; SDISEL-LABEL: single_different:
; SDISEL:       ; %bb.0: ; %entry
; SDISEL-NEXT:    cmp w0, #6
; SDISEL-NEXT:    ccmp w1, #17, #0, ge
; SDISEL-NEXT:    b.eq LBB1_2
; SDISEL-NEXT:  ; %bb.1: ; %if.then
; SDISEL-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; SDISEL-NEXT:    bl _foo
; SDISEL-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; SDISEL-NEXT:  LBB1_2: ; %if.end
; SDISEL-NEXT:    mov w0, #7 ; =0x7
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: single_different:
; GISEL:       ; %bb.0: ; %entry
; GISEL-NEXT:    cmp w0, #5
; GISEL-NEXT:    ccmp w1, #17, #0, gt
; GISEL-NEXT:    b.eq LBB1_2
; GISEL-NEXT:  ; %bb.1: ; %if.then
; GISEL-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; GISEL-NEXT:    bl _foo
; GISEL-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; GISEL-NEXT:  LBB1_2: ; %if.end
; GISEL-NEXT:    mov w0, #7 ; =0x7
; GISEL-NEXT:    ret
entry:
  %cmp = icmp sle i32 %a, 5
  %cmp1 = icmp ne i32 %b, 17
  %or.cond = or i1 %cmp, %cmp1
  br i1 %or.cond, label %if.then, label %if.end

if.then:
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:
  ret i32 7
}

; Second block clobbers the flags, can't convert (easily).
define i32 @single_flagclobber(i32 %a, i32 %b) nounwind ssp {
; SDISEL-LABEL: single_flagclobber:
; SDISEL:       ; %bb.0: ; %entry
; SDISEL-NEXT:    cmp w0, #5
; SDISEL-NEXT:    b.eq LBB2_2
; SDISEL-NEXT:  ; %bb.1: ; %lor.lhs.false
; SDISEL-NEXT:    lsl w8, w1, #1
; SDISEL-NEXT:    cmp w1, #7
; SDISEL-NEXT:    csinc w8, w8, w1, lt
; SDISEL-NEXT:    cmp w8, #16
; SDISEL-NEXT:    b.gt LBB2_3
; SDISEL-NEXT:  LBB2_2: ; %if.then
; SDISEL-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; SDISEL-NEXT:    bl _foo
; SDISEL-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; SDISEL-NEXT:  LBB2_3: ; %if.end
; SDISEL-NEXT:    mov w0, #7 ; =0x7
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: single_flagclobber:
; GISEL:       ; %bb.0: ; %entry
; GISEL-NEXT:    cmp w0, #5
; GISEL-NEXT:    b.eq LBB2_2
; GISEL-NEXT:  ; %bb.1: ; %lor.lhs.false
; GISEL-NEXT:    lsl w8, w1, #1
; GISEL-NEXT:    cmp w1, #7
; GISEL-NEXT:    csinc w8, w8, w1, lt
; GISEL-NEXT:    cmp w8, #17
; GISEL-NEXT:    b.ge LBB2_3
; GISEL-NEXT:  LBB2_2: ; %if.then
; GISEL-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; GISEL-NEXT:    bl _foo
; GISEL-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; GISEL-NEXT:  LBB2_3: ; %if.end
; GISEL-NEXT:    mov w0, #7 ; =0x7
; GISEL-NEXT:    ret
entry:
  %cmp = icmp eq i32 %a, 5
  br i1 %cmp, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %cmp1 = icmp slt i32 %b, 7
  %mul = shl nsw i32 %b, 1
  %add = add nsw i32 %b, 1
  %cond = select i1 %cmp1, i32 %mul, i32 %add
  %cmp2 = icmp slt i32 %cond, 17
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %lor.lhs.false, %entry
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:                                           ; preds = %if.then, %lor.lhs.false
  ret i32 7
}

; Second block clobbers the flags and ends with a tbz terminator.
define i32 @single_flagclobber_tbz(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: single_flagclobber_tbz:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #5
; CHECK-NEXT:    b.eq LBB3_2
; CHECK-NEXT:  ; %bb.1: ; %lor.lhs.false
; CHECK-NEXT:    lsl w8, w1, #1
; CHECK-NEXT:    cmp w1, #7
; CHECK-NEXT:    csinc w8, w8, w1, lt
; CHECK-NEXT:    tbz w8, #3, LBB3_3
; CHECK-NEXT:  LBB3_2: ; %if.then
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; CHECK-NEXT:    bl _foo
; CHECK-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; CHECK-NEXT:  LBB3_3: ; %if.end
; CHECK-NEXT:    mov w0, #7 ; =0x7
; CHECK-NEXT:    ret
entry:
  %cmp = icmp eq i32 %a, 5
  br i1 %cmp, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %cmp1 = icmp slt i32 %b, 7
  %mul = shl nsw i32 %b, 1
  %add = add nsw i32 %b, 1
  %cond = select i1 %cmp1, i32 %mul, i32 %add
  %and = and i32 %cond, 8
  %cmp2 = icmp ne i32 %and, 0
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %lor.lhs.false, %entry
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:                                           ; preds = %if.then, %lor.lhs.false
  ret i32 7
}

; Speculatively execute division by zero.
; The sdiv/udiv instructions do not trap when the divisor is zero, so they are
; safe to speculate.
define i32 @speculate_division(i32 %a, i32 %b) nounwind ssp {
; SDISEL-LABEL: speculate_division:
; SDISEL:       ; %bb.0: ; %entry
; SDISEL-NEXT:    cmp w0, #1
; SDISEL-NEXT:    sdiv w8, w1, w0
; SDISEL-NEXT:    ccmp w8, #16, #0, ge
; SDISEL-NEXT:    b.le LBB4_2
; SDISEL-NEXT:  ; %bb.1: ; %if.end
; SDISEL-NEXT:    mov w0, #7 ; =0x7
; SDISEL-NEXT:    ret
; SDISEL-NEXT:  LBB4_2: ; %if.then
; SDISEL-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; SDISEL-NEXT:    bl _foo
; SDISEL-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; SDISEL-NEXT:    mov w0, #7 ; =0x7
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: speculate_division:
; GISEL:       ; %bb.0: ; %entry
; GISEL-NEXT:    cmp w0, #0
; GISEL-NEXT:    sdiv w8, w1, w0
; GISEL-NEXT:    ccmp w8, #17, #0, gt
; GISEL-NEXT:    b.lt LBB4_2
; GISEL-NEXT:  ; %bb.1: ; %if.end
; GISEL-NEXT:    mov w0, #7 ; =0x7
; GISEL-NEXT:    ret
; GISEL-NEXT:  LBB4_2: ; %if.then
; GISEL-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; GISEL-NEXT:    bl _foo
; GISEL-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; GISEL-NEXT:    mov w0, #7 ; =0x7
; GISEL-NEXT:    ret
entry:
  %cmp = icmp sgt i32 %a, 0
  br i1 %cmp, label %land.lhs.true, label %if.end

land.lhs.true:
  %div = sdiv i32 %b, %a
  %cmp1 = icmp slt i32 %div, 17
  br i1 %cmp1, label %if.then, label %if.end

if.then:
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:
  ret i32 7
}

; Floating point compare.
define i32 @single_fcmp(i32 %a, float %b) nounwind ssp {
; SDISEL-LABEL: single_fcmp:
; SDISEL:       ; %bb.0: ; %entry
; SDISEL-NEXT:    cmp w0, #1
; SDISEL-NEXT:    scvtf s1, w0
; SDISEL-NEXT:    fdiv s0, s0, s1
; SDISEL-NEXT:    fmov s1, #17.00000000
; SDISEL-NEXT:    fccmp s0, s1, #8, ge
; SDISEL-NEXT:    b.ge LBB5_2
; SDISEL-NEXT:  ; %bb.1: ; %if.end
; SDISEL-NEXT:    mov w0, #7 ; =0x7
; SDISEL-NEXT:    ret
; SDISEL-NEXT:  LBB5_2: ; %if.then
; SDISEL-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; SDISEL-NEXT:    bl _foo
; SDISEL-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; SDISEL-NEXT:    mov w0, #7 ; =0x7
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: single_fcmp:
; GISEL:       ; %bb.0: ; %entry
; GISEL-NEXT:    cmp w0, #0
; GISEL-NEXT:    scvtf s1, w0
; GISEL-NEXT:    fdiv s0, s0, s1
; GISEL-NEXT:    fmov s1, #17.00000000
; GISEL-NEXT:    fccmp s0, s1, #8, gt
; GISEL-NEXT:    b.ge LBB5_2
; GISEL-NEXT:  ; %bb.1: ; %if.end
; GISEL-NEXT:    mov w0, #7 ; =0x7
; GISEL-NEXT:    ret
; GISEL-NEXT:  LBB5_2: ; %if.then
; GISEL-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; GISEL-NEXT:    bl _foo
; GISEL-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; GISEL-NEXT:    mov w0, #7 ; =0x7
; GISEL-NEXT:    ret
entry:
  %cmp = icmp sgt i32 %a, 0
  br i1 %cmp, label %land.lhs.true, label %if.end

land.lhs.true:
  %conv = sitofp i32 %a to float
  %div = fdiv float %b, %conv
  %cmp1 = fcmp oge float %div, 1.700000e+01
  br i1 %cmp1, label %if.then, label %if.end

if.then:
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:
  ret i32 7
}

; Chain multiple compares.
define void @multi_different(i32 %a, i32 %b, i32 %c) nounwind ssp {
; CHECK-LABEL: multi_different:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    sdiv w8, w1, w0
; CHECK-NEXT:    ccmp w8, #5, #0, gt
; CHECK-NEXT:    ccmp w8, w2, #4, eq
; CHECK-NEXT:    b.gt LBB6_2
; CHECK-NEXT:  ; %bb.1: ; %if.end
; CHECK-NEXT:    ret
; CHECK-NEXT:  LBB6_2: ; %if.then
; CHECK-NEXT:    b _foo
entry:
  %cmp = icmp sgt i32 %a, %b
  br i1 %cmp, label %land.lhs.true, label %if.end

land.lhs.true:
  %div = sdiv i32 %b, %a
  %cmp1 = icmp eq i32 %div, 5
  %cmp4 = icmp sgt i32 %div, %c
  %or.cond = and i1 %cmp1, %cmp4
  br i1 %or.cond, label %if.then, label %if.end

if.then:
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:
  ret void
}

; Convert a cbz in the head block.
define i32 @cbz_head(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: cbz_head:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    ccmp w1, #17, #0, ne
; CHECK-NEXT:    b.eq LBB7_2
; CHECK-NEXT:  ; %bb.1: ; %if.then
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; CHECK-NEXT:    bl _foo
; CHECK-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; CHECK-NEXT:  LBB7_2: ; %if.end
; CHECK-NEXT:    mov w0, #7 ; =0x7
; CHECK-NEXT:    ret
entry:
  %cmp = icmp eq i32 %a, 0
  %cmp1 = icmp ne i32 %b, 17
  %or.cond = or i1 %cmp, %cmp1
  br i1 %or.cond, label %if.then, label %if.end

if.then:
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:
  ret i32 7
}

; Check that the immediate operand is in range. The ccmp instruction encodes a
; smaller range of immediates than subs/adds.
; The ccmp immediates must be in the range 0-31.
define i32 @immediate_range(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: immediate_range:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #5
; CHECK-NEXT:    b.eq LBB8_3
; CHECK-NEXT:  ; %bb.1: ; %entry
; CHECK-NEXT:    cmp w1, #32
; CHECK-NEXT:    b.eq LBB8_3
; CHECK-NEXT:  ; %bb.2: ; %if.end
; CHECK-NEXT:    mov w0, #7 ; =0x7
; CHECK-NEXT:    ret
; CHECK-NEXT:  LBB8_3: ; %if.then
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; CHECK-NEXT:    bl _foo
; CHECK-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; CHECK-NEXT:    mov w0, #7 ; =0x7
; CHECK-NEXT:    ret
entry:
  %cmp = icmp eq i32 %a, 5
  %cmp1 = icmp eq i32 %b, 32
  %or.cond = or i1 %cmp, %cmp1
  br i1 %or.cond, label %if.then, label %if.end

if.then:
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:
  ret i32 7
}

; Convert a cbz in the second block.
define i32 @cbz_second(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: cbz_second:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    ccmp w1, #0, #0, ne
; CHECK-NEXT:    b.eq LBB9_2
; CHECK-NEXT:  ; %bb.1: ; %if.then
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; CHECK-NEXT:    bl _foo
; CHECK-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; CHECK-NEXT:  LBB9_2: ; %if.end
; CHECK-NEXT:    mov w0, #7 ; =0x7
; CHECK-NEXT:    ret
entry:
  %cmp = icmp eq i32 %a, 0
  %cmp1 = icmp ne i32 %b, 0
  %or.cond = or i1 %cmp, %cmp1
  br i1 %or.cond, label %if.then, label %if.end

if.then:
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:
  ret i32 7
}

; Convert a cbnz in the second block.
define i32 @cbnz_second(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: cbnz_second:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    ccmp w1, #0, #4, ne
; CHECK-NEXT:    b.ne LBB10_2
; CHECK-NEXT:  ; %bb.1: ; %if.then
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! ; 16-byte Folded Spill
; CHECK-NEXT:    bl _foo
; CHECK-NEXT:    ldp x29, x30, [sp], #16 ; 16-byte Folded Reload
; CHECK-NEXT:  LBB10_2: ; %if.end
; CHECK-NEXT:    mov w0, #7 ; =0x7
; CHECK-NEXT:    ret
entry:
  %cmp = icmp eq i32 %a, 0
  %cmp1 = icmp eq i32 %b, 0
  %or.cond = or i1 %cmp, %cmp1
  br i1 %or.cond, label %if.then, label %if.end

if.then:
  %call = tail call i32 @foo() nounwind
  br label %if.end

if.end:
  ret i32 7
}
declare i32 @foo()

%str1 = type { %str2 }
%str2 = type { [24 x i8], ptr, i32, ptr, i32, [4 x i8], ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i8, ptr, ptr, ptr }

; Test case distilled from 126.gcc.
; The phi in sw.bb.i.i gets multiple operands for the %entry predecessor.
define void @build_modify_expr() nounwind ssp {
; CHECK-LABEL: build_modify_expr:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    ret
entry:
  switch i32 undef, label %sw.bb.i.i [
    i32 69, label %if.end85
    i32 70, label %if.end85
    i32 71, label %if.end85
    i32 72, label %if.end85
    i32 73, label %if.end85
    i32 105, label %if.end85
    i32 106, label %if.end85
  ]

if.end85:
  ret void

sw.bb.i.i:
  %ref.tr.i.i = phi ptr [ %0, %sw.bb.i.i ], [ undef, %entry ]
  %operands.i.i = getelementptr inbounds %str1, ptr %ref.tr.i.i, i64 0, i32 0, i32 2
  %0 = load ptr, ptr %operands.i.i, align 8
  %code1.i.i.phi.trans.insert = getelementptr inbounds %str1, ptr %0, i64 0, i32 0, i32 0, i64 16
  br label %sw.bb.i.i
}

define i64 @select_and(i32 %w0, i32 %w1, i64 %x2, i64 %x3) {
; SDISEL-LABEL: select_and:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmp w1, #5
; SDISEL-NEXT:    ccmp w0, w1, #0, ne
; SDISEL-NEXT:    csel x0, x2, x3, lt
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: select_and:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    mov w8, #5 ; =0x5
; GISEL-NEXT:    cmp w8, w1
; GISEL-NEXT:    ccmp w0, w1, #0, ne
; GISEL-NEXT:    csel x0, x2, x3, lt
; GISEL-NEXT:    ret
  %1 = icmp slt i32 %w0, %w1
  %2 = icmp ne i32 5, %w1
  %3 = and i1 %1, %2
  %sel = select i1 %3, i64 %x2, i64 %x3
  ret i64 %sel
}

define i64 @select_or(i32 %w0, i32 %w1, i64 %x2, i64 %x3) {
; SDISEL-LABEL: select_or:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmp w1, #5
; SDISEL-NEXT:    ccmp w0, w1, #8, eq
; SDISEL-NEXT:    csel x0, x2, x3, lt
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: select_or:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    mov w8, #5 ; =0x5
; GISEL-NEXT:    cmp w8, w1
; GISEL-NEXT:    ccmp w0, w1, #8, eq
; GISEL-NEXT:    csel x0, x2, x3, lt
; GISEL-NEXT:    ret
  %1 = icmp slt i32 %w0, %w1
  %2 = icmp ne i32 5, %w1
  %3 = or i1 %1, %2
  %sel = select i1 %3, i64 %x2, i64 %x3
  ret i64 %sel
}

define float @select_or_float(i32 %w0, i32 %w1, float %x2, float %x3) {
; SDISEL-LABEL: select_or_float:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmp w1, #5
; SDISEL-NEXT:    ccmp w0, w1, #8, eq
; SDISEL-NEXT:    fcsel s0, s0, s1, lt
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: select_or_float:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    mov w8, #5 ; =0x5
; GISEL-NEXT:    cmp w8, w1
; GISEL-NEXT:    ccmp w0, w1, #8, eq
; GISEL-NEXT:    fcsel s0, s0, s1, lt
; GISEL-NEXT:    ret
  %1 = icmp slt i32 %w0, %w1
  %2 = icmp ne i32 5, %w1
  %3 = or i1 %1, %2
  %sel = select i1 %3, float %x2,float %x3
  ret float %sel
}

define i64 @gccbug(i64 %x0, i64 %x1) {
; SDISEL-LABEL: gccbug:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmp x0, #2
; SDISEL-NEXT:    ccmp x0, #4, #4, ne
; SDISEL-NEXT:    ccmp x1, #0, #0, eq
; SDISEL-NEXT:    mov w8, #1 ; =0x1
; SDISEL-NEXT:    cinc x0, x8, eq
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: gccbug:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    cmp x1, #0
; GISEL-NEXT:    cset w8, eq
; GISEL-NEXT:    cmp x0, #2
; GISEL-NEXT:    cset w9, eq
; GISEL-NEXT:    cmp x0, #4
; GISEL-NEXT:    cset w10, eq
; GISEL-NEXT:    orr w9, w10, w9
; GISEL-NEXT:    and w8, w9, w8
; GISEL-NEXT:    and x8, x8, #0x1
; GISEL-NEXT:    add x0, x8, #1
; GISEL-NEXT:    ret
  %cmp0 = icmp eq i64 %x1, 0
  %cmp1 = icmp eq i64 %x0, 2
  %cmp2 = icmp eq i64 %x0, 4

  %or = or i1 %cmp2, %cmp1
  %and = and i1 %or, %cmp0

  %sel = select i1 %and, i64 2, i64 1
  ret i64 %sel
}

define i32 @select_ororand(i32 %w0, i32 %w1, i32 %w2, i32 %w3) {
; CHECK-LABEL: select_ororand:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    cmp w3, #4
; CHECK-NEXT:    ccmp w2, #2, #0, gt
; CHECK-NEXT:    ccmp w1, #13, #2, ge
; CHECK-NEXT:    ccmp w0, #0, #4, ls
; CHECK-NEXT:    csel w0, w3, wzr, eq
; CHECK-NEXT:    ret
  %c0 = icmp eq i32 %w0, 0
  %c1 = icmp ugt i32 %w1, 13
  %c2 = icmp slt i32 %w2, 2
  %c4 = icmp sgt i32 %w3, 4
  %or = or i1 %c0, %c1
  %and = and i1 %c2, %c4
  %or1 = or i1 %or, %and
  %sel = select i1 %or1, i32 %w3, i32 0
  ret i32 %sel
}

define i32 @select_andor(i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: select_andor:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    cmp w1, w2
; CHECK-NEXT:    ccmp w0, #0, #4, lt
; CHECK-NEXT:    ccmp w0, w1, #0, eq
; CHECK-NEXT:    csel w0, w0, w1, eq
; CHECK-NEXT:    ret
  %c0 = icmp eq i32 %v1, %v2
  %c1 = icmp sge i32 %v2, %v3
  %c2 = icmp eq i32 %v1, 0
  %or = or i1 %c2, %c1
  %and = and i1 %or, %c0
  %sel = select i1 %and, i32 %v1, i32 %v2
  ret i32 %sel
}

define i32 @select_andor32(i32 %v1, i32 %v2, i32 %v3) {
; SDISEL-LABEL: select_andor32:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmp w1, w2
; SDISEL-NEXT:    mov w8, #32 ; =0x20
; SDISEL-NEXT:    ccmp w0, w8, #4, lt
; SDISEL-NEXT:    ccmp w0, w1, #0, eq
; SDISEL-NEXT:    csel w0, w0, w1, eq
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: select_andor32:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    mov w8, #32 ; =0x20
; GISEL-NEXT:    cmp w1, w2
; GISEL-NEXT:    ccmp w0, w8, #4, lt
; GISEL-NEXT:    ccmp w0, w1, #0, eq
; GISEL-NEXT:    csel w0, w0, w1, eq
; GISEL-NEXT:    ret
  %c0 = icmp eq i32 %v1, %v2
  %c1 = icmp sge i32 %v2, %v3
  %c2 = icmp eq i32 %v1, 32
  %or = or i1 %c2, %c1
  %and = and i1 %or, %c0
  %sel = select i1 %and, i32 %v1, i32 %v2
  ret i32 %sel
}

define i64 @select_noccmp1(i64 %v1, i64 %v2, i64 %v3, i64 %r) {
; SDISEL-LABEL: select_noccmp1:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmp x0, #0
; SDISEL-NEXT:    ccmp x0, #13, #4, lt
; SDISEL-NEXT:    cset w8, gt
; SDISEL-NEXT:    cmp x2, #2
; SDISEL-NEXT:    ccmp x2, #4, #4, lt
; SDISEL-NEXT:    csinc w8, w8, wzr, le
; SDISEL-NEXT:    cmp w8, #0
; SDISEL-NEXT:    csel x0, xzr, x3, ne
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: select_noccmp1:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    mov x0, x3
; GISEL-NEXT:    ret
  %c0 = icmp slt i64 %v1, 0
  %c1 = icmp sgt i64 %v1, 13
  %c2 = icmp slt i64 %v3, 2
  %c4 = icmp sgt i64 %v3, 4
  %and0 = and i1 %c0, %c1
  %and1 = and i1 %c2, %c4
  %or = or i1 %and0, %and1
  %sel = select i1 %or, i64 0, i64 %r
  ret i64 %sel
}

@g = global i32 0

define i64 @select_noccmp2(i64 %v1, i64 %v2, i64 %v3, i64 %r) {
; SDISEL-LABEL: select_noccmp2:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmp x0, #0
; SDISEL-NEXT:    ccmp x0, #13, #0, ge
; SDISEL-NEXT:    cset w8, gt
; SDISEL-NEXT:    cmp w8, #0
; SDISEL-NEXT:    csel x0, xzr, x3, ne
; SDISEL-NEXT:    sbfx w8, w8, #0, #1
; SDISEL-NEXT:    adrp x9, _g@PAGE
; SDISEL-NEXT:    str w8, [x9, _g@PAGEOFF]
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: select_noccmp2:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    cmp x0, #14
; GISEL-NEXT:    cset w8, hs
; GISEL-NEXT:    tst w8, #0x1
; GISEL-NEXT:    csel x0, xzr, x3, ne
; GISEL-NEXT:    sbfx w8, w8, #0, #1
; GISEL-NEXT:    adrp x9, _g@PAGE
; GISEL-NEXT:    str w8, [x9, _g@PAGEOFF]
; GISEL-NEXT:    ret
  %c0 = icmp slt i64 %v1, 0
  %c1 = icmp sgt i64 %v1, 13
  %or = or i1 %c0, %c1
  %sel = select i1 %or, i64 0, i64 %r
  %ext = sext i1 %or to i32
  store volatile i32 %ext, ptr @g
  ret i64 %sel
}

; The following is not possible to implement with a single cmp;ccmp;csel
; sequence.
define i32 @select_noccmp3(i32 %v0, i32 %v1, i32 %v2) {
; SDISEL-LABEL: select_noccmp3:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmp w0, #0
; SDISEL-NEXT:    ccmp w0, #13, #0, ge
; SDISEL-NEXT:    cset w8, gt
; SDISEL-NEXT:    cmp w0, #22
; SDISEL-NEXT:    mov w9, #44 ; =0x2c
; SDISEL-NEXT:    ccmp w0, w9, #0, ge
; SDISEL-NEXT:    csel w8, wzr, w8, le
; SDISEL-NEXT:    cmp w0, #99
; SDISEL-NEXT:    mov w9, #77 ; =0x4d
; SDISEL-NEXT:    ccmp w0, w9, #4, ne
; SDISEL-NEXT:    cset w9, eq
; SDISEL-NEXT:    tst w8, w9
; SDISEL-NEXT:    csel w0, w1, w2, ne
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: select_noccmp3:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    mov w8, #99 ; =0x63
; GISEL-NEXT:    sub w9, w0, #45
; GISEL-NEXT:    cmp w0, #77
; GISEL-NEXT:    ccmp w0, w8, #4, ne
; GISEL-NEXT:    ccmn w9, #23, #2, eq
; GISEL-NEXT:    ccmp w0, #14, #0, lo
; GISEL-NEXT:    csel w0, w1, w2, hs
; GISEL-NEXT:    ret
  %c0 = icmp slt i32 %v0, 0
  %c1 = icmp sgt i32 %v0, 13
  %c2 = icmp slt i32 %v0, 22
  %c3 = icmp sgt i32 %v0, 44
  %c4 = icmp eq i32 %v0, 99
  %c5 = icmp eq i32 %v0, 77
  %or0 = or i1 %c0, %c1
  %or1 = or i1 %c2, %c3
  %and0 = and i1 %or0, %or1
  %or2 = or i1 %c4, %c5
  %and1 = and i1 %and0, %or2
  %sel = select i1 %and1, i32 %v1, i32 %v2
  ret i32 %sel
}

; Test the IR CCs that expand to two cond codes.

define i32 @select_and_olt_one(double %v0, double %v1, double %v2, double %v3, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_and_olt_one:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d2, d3, #4, mi
; CHECK-NEXT:    fccmp d2, d3, #1, ne
; CHECK-NEXT:    csel w0, w0, w1, vc
; CHECK-NEXT:    ret
  %c0 = fcmp olt double %v0, %v1
  %c1 = fcmp one double %v2, %v3
  %cr = and i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @select_and_one_olt(double %v0, double %v1, double %v2, double %v3, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_and_one_olt:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d0, d1, #1, ne
; CHECK-NEXT:    fccmp d2, d3, #0, vc
; CHECK-NEXT:    csel w0, w0, w1, mi
; CHECK-NEXT:    ret
  %c0 = fcmp one double %v0, %v1
  %c1 = fcmp olt double %v2, %v3
  %cr = and i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @select_and_olt_ueq(double %v0, double %v1, double %v2, double %v3, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_and_olt_ueq:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d2, d3, #0, mi
; CHECK-NEXT:    fccmp d2, d3, #8, le
; CHECK-NEXT:    csel w0, w0, w1, pl
; CHECK-NEXT:    ret
  %c0 = fcmp olt double %v0, %v1
  %c1 = fcmp ueq double %v2, %v3
  %cr = and i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @select_and_ueq_olt(double %v0, double %v1, double %v2, double %v3, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_and_ueq_olt:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d0, d1, #8, le
; CHECK-NEXT:    fccmp d2, d3, #0, pl
; CHECK-NEXT:    csel w0, w0, w1, mi
; CHECK-NEXT:    ret
  %c0 = fcmp ueq double %v0, %v1
  %c1 = fcmp olt double %v2, %v3
  %cr = and i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @select_or_olt_one(double %v0, double %v1, double %v2, double %v3, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_or_olt_one:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d2, d3, #0, pl
; CHECK-NEXT:    fccmp d2, d3, #8, le
; CHECK-NEXT:    csel w0, w0, w1, mi
; CHECK-NEXT:    ret
  %c0 = fcmp olt double %v0, %v1
  %c1 = fcmp one double %v2, %v3
  %cr = or i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @select_or_one_olt(double %v0, double %v1, double %v2, double %v3, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_or_one_olt:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d0, d1, #8, le
; CHECK-NEXT:    fccmp d2, d3, #8, pl
; CHECK-NEXT:    csel w0, w0, w1, mi
; CHECK-NEXT:    ret
  %c0 = fcmp one double %v0, %v1
  %c1 = fcmp olt double %v2, %v3
  %cr = or i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @select_or_olt_ueq(double %v0, double %v1, double %v2, double %v3, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_or_olt_ueq:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d2, d3, #4, pl
; CHECK-NEXT:    fccmp d2, d3, #1, ne
; CHECK-NEXT:    csel w0, w0, w1, vs
; CHECK-NEXT:    ret
  %c0 = fcmp olt double %v0, %v1
  %c1 = fcmp ueq double %v2, %v3
  %cr = or i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @select_or_ueq_olt(double %v0, double %v1, double %v2, double %v3, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_or_ueq_olt:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d0, d1, #1, ne
; CHECK-NEXT:    fccmp d2, d3, #8, vc
; CHECK-NEXT:    csel w0, w0, w1, mi
; CHECK-NEXT:    ret
  %c0 = fcmp ueq double %v0, %v1
  %c1 = fcmp olt double %v2, %v3
  %cr = or i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @select_or_olt_ogt_ueq(double %v0, double %v1, double %v2, double %v3, double %v4, double %v5, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_or_olt_ogt_ueq:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d2, d3, #0, pl
; CHECK-NEXT:    fccmp d4, d5, #4, le
; CHECK-NEXT:    fccmp d4, d5, #1, ne
; CHECK-NEXT:    csel w0, w0, w1, vs
; CHECK-NEXT:    ret
  %c0 = fcmp olt double %v0, %v1
  %c1 = fcmp ogt double %v2, %v3
  %c2 = fcmp ueq double %v4, %v5
  %c3 = or i1 %c1, %c0
  %cr = or i1 %c2, %c3
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @select_or_olt_ueq_ogt(double %v0, double %v1, double %v2, double %v3, double %v4, double %v5, i32 %a, i32 %b) #0 {
; CHECK-LABEL: select_or_olt_ueq_ogt:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    fccmp d2, d3, #4, pl
; CHECK-NEXT:    fccmp d2, d3, #1, ne
; CHECK-NEXT:    fccmp d4, d5, #0, vc
; CHECK-NEXT:    csel w0, w0, w1, gt
; CHECK-NEXT:    ret
  %c0 = fcmp olt double %v0, %v1
  %c1 = fcmp ueq double %v2, %v3
  %c2 = fcmp ogt double %v4, %v5
  %c3 = or i1 %c1, %c0
  %cr = or i1 %c2, %c3
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

; Verify that we correctly promote f16.

define i32 @half_select_and_olt_oge(half %v0, half %v1, half %v2, half %v3, i32 %a, i32 %b) #0 {
; SDISEL-LABEL: half_select_and_olt_oge:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    fcvt s1, h1
; SDISEL-NEXT:    fcvt s0, h0
; SDISEL-NEXT:    fcmp s0, s1
; SDISEL-NEXT:    fcvt s0, h3
; SDISEL-NEXT:    fcvt s1, h2
; SDISEL-NEXT:    fccmp s1, s0, #8, mi
; SDISEL-NEXT:    csel w0, w0, w1, ge
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: half_select_and_olt_oge:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    fcvt s0, h0
; GISEL-NEXT:    fcvt s1, h1
; GISEL-NEXT:    fcvt s2, h2
; GISEL-NEXT:    fcvt s3, h3
; GISEL-NEXT:    fcmp s0, s1
; GISEL-NEXT:    fccmp s2, s3, #8, mi
; GISEL-NEXT:    csel w0, w0, w1, ge
; GISEL-NEXT:    ret
  %c0 = fcmp olt half %v0, %v1
  %c1 = fcmp oge half %v2, %v3
  %cr = and i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

define i32 @half_select_and_olt_one(half %v0, half %v1, half %v2, half %v3, i32 %a, i32 %b) #0 {
; SDISEL-LABEL: half_select_and_olt_one:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    fcvt s1, h1
; SDISEL-NEXT:    fcvt s0, h0
; SDISEL-NEXT:    fcmp s0, s1
; SDISEL-NEXT:    fcvt s0, h3
; SDISEL-NEXT:    fcvt s1, h2
; SDISEL-NEXT:    fccmp s1, s0, #4, mi
; SDISEL-NEXT:    fccmp s1, s0, #1, ne
; SDISEL-NEXT:    csel w0, w0, w1, vc
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: half_select_and_olt_one:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    fcvt s0, h0
; GISEL-NEXT:    fcvt s1, h1
; GISEL-NEXT:    fcvt s2, h2
; GISEL-NEXT:    fcvt s3, h3
; GISEL-NEXT:    fcmp s0, s1
; GISEL-NEXT:    fccmp s2, s3, #4, mi
; GISEL-NEXT:    fccmp s2, s3, #1, ne
; GISEL-NEXT:    csel w0, w0, w1, vc
; GISEL-NEXT:    ret
  %c0 = fcmp olt half %v0, %v1
  %c1 = fcmp one half %v2, %v3
  %cr = and i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

; Also verify that we don't try to generate f128 FCCMPs, using RT calls instead.

define i32 @f128_select_and_olt_oge(fp128 %v0, fp128 %v1, fp128 %v2, fp128 %v3, i32 %a, i32 %b) #0 {
; CHECK-LABEL: f128_select_and_olt_oge:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub sp, sp, #80
; CHECK-NEXT:    stp x22, x21, [sp, #32] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x20, x19, [sp, #48] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x29, x30, [sp, #64] ; 16-byte Folded Spill
; CHECK-NEXT:    mov x19, x1
; CHECK-NEXT:    mov x20, x0
; CHECK-NEXT:    stp q2, q3, [sp] ; 32-byte Folded Spill
; CHECK-NEXT:    bl ___lttf2
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cset w21, lt
; CHECK-NEXT:    ldp q0, q1, [sp] ; 32-byte Folded Reload
; CHECK-NEXT:    bl ___getf2
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cset w8, ge
; CHECK-NEXT:    tst w8, w21
; CHECK-NEXT:    csel w0, w20, w19, ne
; CHECK-NEXT:    ldp x29, x30, [sp, #64] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x20, x19, [sp, #48] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x22, x21, [sp, #32] ; 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #80
; CHECK-NEXT:    ret
  %c0 = fcmp olt fp128 %v0, %v1
  %c1 = fcmp oge fp128 %v2, %v3
  %cr = and i1 %c1, %c0
  %sel = select i1 %cr, i32 %a, i32 %b
  ret i32 %sel
}

; This testcase resembles the core problem of http://llvm.org/PR39550
; (an OR operation is 2 levels deep but needs to be implemented first)
define i32 @deep_or(i32 %a0, i32 %a1, i32 %a2, i32 %a3, i32 %x, i32 %y) {
; CHECK-LABEL: deep_or:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    cmp w2, #20
; CHECK-NEXT:    ccmp w2, #15, #4, ne
; CHECK-NEXT:    ccmp w1, #0, #4, eq
; CHECK-NEXT:    ccmp w0, #0, #4, ne
; CHECK-NEXT:    csel w0, w4, w5, ne
; CHECK-NEXT:    ret
  %c0 = icmp ne i32 %a0, 0
  %c1 = icmp ne i32 %a1, 0
  %c2 = icmp eq i32 %a2, 15
  %c3 = icmp eq i32 %a2, 20

  %or = or i1 %c2, %c3
  %and0 = and i1 %or, %c1
  %and1 = and i1 %and0, %c0
  %sel = select i1 %and1, i32 %x, i32 %y
  ret i32 %sel
}

; Variation of deep_or, we still need to implement the OR first though.
define i32 @deep_or1(i32 %a0, i32 %a1, i32 %a2, i32 %a3, i32 %x, i32 %y) {
; CHECK-LABEL: deep_or1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    cmp w2, #20
; CHECK-NEXT:    ccmp w2, #15, #4, ne
; CHECK-NEXT:    ccmp w0, #0, #4, eq
; CHECK-NEXT:    ccmp w1, #0, #4, ne
; CHECK-NEXT:    csel w0, w4, w5, ne
; CHECK-NEXT:    ret
  %c0 = icmp ne i32 %a0, 0
  %c1 = icmp ne i32 %a1, 0
  %c2 = icmp eq i32 %a2, 15
  %c3 = icmp eq i32 %a2, 20

  %or = or i1 %c2, %c3
  %and0 = and i1 %c0, %or
  %and1 = and i1 %and0, %c1
  %sel = select i1 %and1, i32 %x, i32 %y
  ret i32 %sel
}

; Variation of deep_or, we still need to implement the OR first though.
define i32 @deep_or2(i32 %a0, i32 %a1, i32 %a2, i32 %a3, i32 %x, i32 %y) {
; CHECK-LABEL: deep_or2:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    cmp w2, #20
; CHECK-NEXT:    ccmp w2, #15, #4, ne
; CHECK-NEXT:    ccmp w1, #0, #4, eq
; CHECK-NEXT:    ccmp w0, #0, #4, ne
; CHECK-NEXT:    csel w0, w4, w5, ne
; CHECK-NEXT:    ret
  %c0 = icmp ne i32 %a0, 0
  %c1 = icmp ne i32 %a1, 0
  %c2 = icmp eq i32 %a2, 15
  %c3 = icmp eq i32 %a2, 20

  %or = or i1 %c2, %c3
  %and0 = and i1 %c0, %c1
  %and1 = and i1 %and0, %or
  %sel = select i1 %and1, i32 %x, i32 %y
  ret i32 %sel
}

; This test is trying to test that multiple ccmp's don't get created in a way
; that they would have multiple uses. It doesn't seem to.
define i32 @multiccmp(i32 %s0, i32 %s1, i32 %s2, i32 %s3, i32 %x, i32 %y) #0 {
; SDISEL-LABEL: multiccmp:
; SDISEL:       ; %bb.0: ; %entry
; SDISEL-NEXT:    stp x22, x21, [sp, #-48]! ; 16-byte Folded Spill
; SDISEL-NEXT:    stp x20, x19, [sp, #16] ; 16-byte Folded Spill
; SDISEL-NEXT:    stp x29, x30, [sp, #32] ; 16-byte Folded Spill
; SDISEL-NEXT:    mov x19, x5
; SDISEL-NEXT:    cmp w0, w1
; SDISEL-NEXT:    cset w20, gt
; SDISEL-NEXT:    cmp w2, w3
; SDISEL-NEXT:    cset w21, ne
; SDISEL-NEXT:    tst w20, w21
; SDISEL-NEXT:    csel w0, w5, w4, ne
; SDISEL-NEXT:    bl _callee
; SDISEL-NEXT:    tst w20, w21
; SDISEL-NEXT:    csel w0, w0, w19, ne
; SDISEL-NEXT:    bl _callee
; SDISEL-NEXT:    ldp x29, x30, [sp, #32] ; 16-byte Folded Reload
; SDISEL-NEXT:    ldp x20, x19, [sp, #16] ; 16-byte Folded Reload
; SDISEL-NEXT:    ldp x22, x21, [sp], #48 ; 16-byte Folded Reload
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: multiccmp:
; GISEL:       ; %bb.0: ; %entry
; GISEL-NEXT:    stp x20, x19, [sp, #-32]! ; 16-byte Folded Spill
; GISEL-NEXT:    stp x29, x30, [sp, #16] ; 16-byte Folded Spill
; GISEL-NEXT:    mov x19, x5
; GISEL-NEXT:    cmp w0, w1
; GISEL-NEXT:    cset w8, gt
; GISEL-NEXT:    cmp w2, w3
; GISEL-NEXT:    cset w9, ne
; GISEL-NEXT:    and w20, w8, w9
; GISEL-NEXT:    tst w20, #0x1
; GISEL-NEXT:    csel w0, w5, w4, ne
; GISEL-NEXT:    bl _callee
; GISEL-NEXT:    tst w20, #0x1
; GISEL-NEXT:    csel w0, w0, w19, ne
; GISEL-NEXT:    bl _callee
; GISEL-NEXT:    ldp x29, x30, [sp, #16] ; 16-byte Folded Reload
; GISEL-NEXT:    ldp x20, x19, [sp], #32 ; 16-byte Folded Reload
; GISEL-NEXT:    ret
entry:
  %c0 = icmp sgt i32 %s0, %s1
  %c1 = icmp ne i32 %s2, %s3
  %a = and i1 %c0, %c1
  %s = select i1 %a, i32 %y, i32 %x
  %o = call i32 @callee(i32 %s)
  %z1 = select i1 %a, i32 %o, i32 %y
  %p = call i32 @callee(i32 %z1)
  ret i32 %p
}

define i32 @multiccmp2(i32 %s0, i32 %s1, i32 %s2, i32 %s3, i32 %x, i32 %y) #0 {
; SDISEL-LABEL: multiccmp2:
; SDISEL:       ; %bb.0: ; %entry
; SDISEL-NEXT:    stp x22, x21, [sp, #-48]! ; 16-byte Folded Spill
; SDISEL-NEXT:    stp x20, x19, [sp, #16] ; 16-byte Folded Spill
; SDISEL-NEXT:    stp x29, x30, [sp, #32] ; 16-byte Folded Spill
; SDISEL-NEXT:    mov x19, x5
; SDISEL-NEXT:    mov x20, x3
; SDISEL-NEXT:    mov x21, x0
; SDISEL-NEXT:    cmp w0, w1
; SDISEL-NEXT:    cset w8, gt
; SDISEL-NEXT:    cmp w2, w3
; SDISEL-NEXT:    cset w22, ne
; SDISEL-NEXT:    tst w8, w22
; SDISEL-NEXT:    csel w0, w5, w4, ne
; SDISEL-NEXT:    bl _callee
; SDISEL-NEXT:    cmp w21, w20
; SDISEL-NEXT:    cset w8, eq
; SDISEL-NEXT:    tst w22, w8
; SDISEL-NEXT:    csel w0, w0, w19, ne
; SDISEL-NEXT:    bl _callee
; SDISEL-NEXT:    ldp x29, x30, [sp, #32] ; 16-byte Folded Reload
; SDISEL-NEXT:    ldp x20, x19, [sp, #16] ; 16-byte Folded Reload
; SDISEL-NEXT:    ldp x22, x21, [sp], #48 ; 16-byte Folded Reload
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: multiccmp2:
; GISEL:       ; %bb.0: ; %entry
; GISEL-NEXT:    stp x22, x21, [sp, #-48]! ; 16-byte Folded Spill
; GISEL-NEXT:    stp x20, x19, [sp, #16] ; 16-byte Folded Spill
; GISEL-NEXT:    stp x29, x30, [sp, #32] ; 16-byte Folded Spill
; GISEL-NEXT:    mov x19, x0
; GISEL-NEXT:    mov x20, x3
; GISEL-NEXT:    mov x21, x5
; GISEL-NEXT:    cmp w0, w1
; GISEL-NEXT:    cset w8, gt
; GISEL-NEXT:    cmp w2, w3
; GISEL-NEXT:    cset w22, ne
; GISEL-NEXT:    and w8, w8, w22
; GISEL-NEXT:    tst w8, #0x1
; GISEL-NEXT:    csel w0, w5, w4, ne
; GISEL-NEXT:    bl _callee
; GISEL-NEXT:    cmp w19, w20
; GISEL-NEXT:    cset w8, eq
; GISEL-NEXT:    and w8, w22, w8
; GISEL-NEXT:    tst w8, #0x1
; GISEL-NEXT:    csel w0, w0, w21, ne
; GISEL-NEXT:    bl _callee
; GISEL-NEXT:    ldp x29, x30, [sp, #32] ; 16-byte Folded Reload
; GISEL-NEXT:    ldp x20, x19, [sp, #16] ; 16-byte Folded Reload
; GISEL-NEXT:    ldp x22, x21, [sp], #48 ; 16-byte Folded Reload
; GISEL-NEXT:    ret
entry:
  %c0 = icmp sgt i32 %s0, %s1
  %c1 = icmp ne i32 %s2, %s3
  %a = and i1 %c0, %c1
  %z = zext i1 %a to i32
  %s = select i1 %a, i32 %y, i32 %x
  %o = call i32 @callee(i32 %s)

  %c2 = icmp eq i32 %s0, %s3
  %a1 = and i1 %c1, %c2
  %z1 = select i1 %a1, i32 %o, i32 %y
  %p = call i32 @callee(i32 %z1)
  ret i32 %p
}
declare i32 @callee(i32)

define i1 @cmp_and_negative_const(i32 %0, i32 %1) {
; SDISEL-LABEL: cmp_and_negative_const:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmn w0, #1
; SDISEL-NEXT:    ccmn w1, #2, #0, eq
; SDISEL-NEXT:    cset w0, eq
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: cmp_and_negative_const:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    cmn w0, #1
; GISEL-NEXT:    cset w8, eq
; GISEL-NEXT:    cmn w1, #2
; GISEL-NEXT:    cset w9, eq
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %3 = icmp eq i32 %0, -1
  %4 = icmp eq i32 %1, -2
  %5 = and i1 %3, %4
  ret i1 %5
}

define i1 @cmp_or_negative_const(i32 %a, i32 %b) {
; SDISEL-LABEL: cmp_or_negative_const:
; SDISEL:       ; %bb.0:
; SDISEL-NEXT:    cmn w0, #1
; SDISEL-NEXT:    ccmn w1, #2, #4, ne
; SDISEL-NEXT:    cset w0, eq
; SDISEL-NEXT:    ret
;
; GISEL-LABEL: cmp_or_negative_const:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    cmn w0, #1
; GISEL-NEXT:    cset w8, eq
; GISEL-NEXT:    cmn w1, #2
; GISEL-NEXT:    cset w9, eq
; GISEL-NEXT:    orr w0, w8, w9
; GISEL-NEXT:    ret
  %cmp = icmp eq i32 %a, -1
  %cmp1 = icmp eq i32 %b, -2
  %or.cond = or i1 %cmp, %cmp1
  ret i1 %or.cond
}
attributes #0 = { nounwind }