; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -o - %s | FileCheck %s

target triple = "arm64-apple-ios"

%struct.s = type {double, double }

declare void @fn(ptr, ptr)

; %l.a and %l.b read memory allocated in the caller and should not block
; shrink-wrapping.
define void @test_regular_pointers(ptr %a, ptr %b) {
; CHECK-LABEL: test_regular_pointers:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1, #8]
; CHECK-NEXT:    mov x8, #1 ; =0x1
; CHECK-NEXT:    movk x8, #2047, lsl #16
; CHECK-NEXT:    fadd d0, d0, d1
; CHECK-NEXT:    fmov d1, x8
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    str d0, [x1]
; CHECK-NEXT:    b.mi LBB0_2
; CHECK-NEXT:    b.gt LBB0_2
; CHECK-NEXT:  ; %bb.1: ; %then
; CHECK-NEXT:    stp x20, x19, [sp, #-32]! ; 16-byte Folded Spill
; CHECK-NEXT:    stp x29, x30, [sp, #16] ; 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    .cfi_offset w19, -24
; CHECK-NEXT:    .cfi_offset w20, -32
; CHECK-NEXT:    mov x19, x1
; CHECK-NEXT:    bl _fn
; CHECK-NEXT:    ldp x29, x30, [sp, #16] ; 16-byte Folded Reload
; CHECK-NEXT:    str xzr, [x19]
; CHECK-NEXT:    ldp x20, x19, [sp], #32 ; 16-byte Folded Reload
; CHECK-NEXT:  LBB0_2: ; %exit
; CHECK-NEXT:    ret
entry:
  %l.a = load double, ptr %a, align 8
  %gep.b = getelementptr inbounds %struct.s, ptr %b, i64 0, i32 1
  %l.b = load double, ptr %gep.b, align 8
  %add = fadd double %l.a, %l.b
  store double %add, ptr %b, align 8
  %c = fcmp ueq double %add, 0x7FF0001
  br i1 %c, label %then, label %exit

then:
  tail call void @fn(ptr %a, ptr %b)
  store double 0.000000e+00, ptr %b, align 8
  br label %exit

exit:
  ret void
}

; %l.b may read memory from the callee's stack due to byval.
define void @test_byval_pointers(ptr %a, ptr byval(%struct.s) %b) {
; CHECK-LABEL: test_byval_pointers:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    stp x20, x19, [sp, #-32]! ; 16-byte Folded Spill
; CHECK-NEXT:    stp x29, x30, [sp, #16] ; 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    .cfi_offset w19, -24
; CHECK-NEXT:    .cfi_offset w20, -32
; CHECK-NEXT:    ldr d0, [sp, #40]
; CHECK-NEXT:    ldr d1, [x0]
; CHECK-NEXT:    mov x8, #1 ; =0x1
; CHECK-NEXT:    movk x8, #2047, lsl #16
; CHECK-NEXT:    fadd d0, d1, d0
; CHECK-NEXT:    fmov d1, x8
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    str d0, [sp, #32]
; CHECK-NEXT:    b.mi LBB1_2
; CHECK-NEXT:    b.gt LBB1_2
; CHECK-NEXT:  ; %bb.1: ; %then
; CHECK-NEXT:    add x1, sp, #32
; CHECK-NEXT:    add x19, sp, #32
; CHECK-NEXT:    bl _fn
; CHECK-NEXT:    str xzr, [x19]
; CHECK-NEXT:  LBB1_2: ; %exit
; CHECK-NEXT:    ldp x29, x30, [sp, #16] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x20, x19, [sp], #32 ; 16-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  %l.a = load double, ptr %a, align 8
  %gep.b = getelementptr inbounds %struct.s, ptr %b, i64 0, i32 1
  %l.b = load double, ptr %gep.b, align 8
  %add = fadd double %l.a, %l.b
  store double %add, ptr %b, align 8
  %c = fcmp ueq double %add, 0x7FF0001
  br i1 %c, label %then, label %exit

then:
  tail call void @fn(ptr %a, ptr %b)
  store double 0.000000e+00, ptr %b, align 8
  br label %exit

exit:
  ret void
}

; %l.b may read memory from the callee's stack due to inalloca.
define void @test_inalloca_pointers(ptr %a, ptr inalloca(%struct.s) %b) {
; CHECK-LABEL: test_inalloca_pointers:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    stp x20, x19, [sp, #-32]! ; 16-byte Folded Spill
; CHECK-NEXT:    stp x29, x30, [sp, #16] ; 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    .cfi_offset w19, -24
; CHECK-NEXT:    .cfi_offset w20, -32
; CHECK-NEXT:    ldr d0, [sp, #40]
; CHECK-NEXT:    ldr d1, [x0]
; CHECK-NEXT:    mov x8, #1 ; =0x1
; CHECK-NEXT:    movk x8, #2047, lsl #16
; CHECK-NEXT:    fadd d0, d1, d0
; CHECK-NEXT:    fmov d1, x8
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    str d0, [sp, #32]
; CHECK-NEXT:    b.mi LBB2_2
; CHECK-NEXT:    b.gt LBB2_2
; CHECK-NEXT:  ; %bb.1: ; %then
; CHECK-NEXT:    add x1, sp, #32
; CHECK-NEXT:    add x19, sp, #32
; CHECK-NEXT:    bl _fn
; CHECK-NEXT:    str xzr, [x19]
; CHECK-NEXT:  LBB2_2: ; %exit
; CHECK-NEXT:    ldp x29, x30, [sp, #16] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x20, x19, [sp], #32 ; 16-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  %l.a = load double, ptr %a, align 8
  %gep.b = getelementptr inbounds %struct.s, ptr %b, i64 0, i32 1
  %l.b = load double, ptr %gep.b, align 8
  %add = fadd double %l.a, %l.b
  store double %add, ptr %b, align 8
  %c = fcmp ueq double %add, 0x7FF0001
  br i1 %c, label %then, label %exit

then:
  tail call void @fn(ptr %a, ptr %b)
  store double 0.000000e+00, ptr %b, align 8
  br label %exit

exit:
  ret void
}

; %l.b may read memory from the callee's stack due to preallocated.
define void @test_preallocated_pointers(ptr %a, ptr preallocated(%struct.s) %b) {
; CHECK-LABEL: test_preallocated_pointers:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    stp x20, x19, [sp, #-32]! ; 16-byte Folded Spill
; CHECK-NEXT:    stp x29, x30, [sp, #16] ; 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    .cfi_offset w19, -24
; CHECK-NEXT:    .cfi_offset w20, -32
; CHECK-NEXT:    ldr d0, [sp, #40]
; CHECK-NEXT:    ldr d1, [x0]
; CHECK-NEXT:    mov x8, #1 ; =0x1
; CHECK-NEXT:    movk x8, #2047, lsl #16
; CHECK-NEXT:    fadd d0, d1, d0
; CHECK-NEXT:    fmov d1, x8
; CHECK-NEXT:    fcmp d0, d1
; CHECK-NEXT:    str d0, [sp, #32]
; CHECK-NEXT:    b.mi LBB3_2
; CHECK-NEXT:    b.gt LBB3_2
; CHECK-NEXT:  ; %bb.1: ; %then
; CHECK-NEXT:    add x1, sp, #32
; CHECK-NEXT:    add x19, sp, #32
; CHECK-NEXT:    bl _fn
; CHECK-NEXT:    str xzr, [x19]
; CHECK-NEXT:  LBB3_2: ; %exit
; CHECK-NEXT:    ldp x29, x30, [sp, #16] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x20, x19, [sp], #32 ; 16-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  %l.a = load double, ptr %a, align 8
  %gep.b = getelementptr inbounds %struct.s, ptr %b, i64 0, i32 1
  %l.b = load double, ptr %gep.b, align 8
  %add = fadd double %l.a, %l.b
  store double %add, ptr %b, align 8
  %c = fcmp ueq double %add, 0x7FF0001
  br i1 %c, label %then, label %exit

then:
  tail call void @fn(ptr %a, ptr %b)
  store double 0.000000e+00, ptr %b, align 8
  br label %exit

exit:
  ret void
}