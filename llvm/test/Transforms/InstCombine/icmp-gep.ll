; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S  < %s | FileCheck %s

target datalayout = "e-p:64:64:64-p1:16:16:16-p2:32:32:32-p3:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

declare ptr @getptr()
declare void @use(ptr)
declare void @use.i1(i1)

define i1 @eq_base(ptr %x, i64 %y) {
; CHECK-LABEL: @eq_base(
; CHECK-NEXT:    [[R:%.*]] = icmp eq i64 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr i8, ptr %x, i64 %y
  %r = icmp eq ptr %g, %x
  ret i1 %r
}

define i1 @ne_base_commute(i64 %y) {
; CHECK-LABEL: @ne_base_commute(
; CHECK-NEXT:    [[X:%.*]] = call ptr @getptr()
; CHECK-NEXT:    [[R:%.*]] = icmp ne i64 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call ptr @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr i8, ptr %x, i64 %y
  %r = icmp ne ptr %x, %g
  ret i1 %r
}

define i1 @ne_base_inbounds(ptr %x, i64 %y) {
; CHECK-LABEL: @ne_base_inbounds(
; CHECK-NEXT:    [[R:%.*]] = icmp ne i64 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr inbounds i8, ptr %x, i64 %y
  %r = icmp ne ptr %g, %x
  ret i1 %r
}

define i1 @eq_base_inbounds_commute(i64 %y) {
; CHECK-LABEL: @eq_base_inbounds_commute(
; CHECK-NEXT:    [[X:%.*]] = call ptr @getptr()
; CHECK-NEXT:    [[R:%.*]] = icmp eq i64 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call ptr @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr inbounds i8, ptr %x, i64 %y
  %r = icmp eq ptr %x, %g
  ret i1 %r
}

define i1 @slt_base(ptr %x, i64 %y) {
; CHECK-LABEL: @slt_base(
; CHECK-NEXT:    [[G:%.*]] = getelementptr i8, ptr [[X:%.*]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt ptr [[G]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr i8, ptr %x, i64 %y
  %r = icmp slt ptr %g, %x
  ret i1 %r
}

define i1 @sgt_base_commute(i64 %y) {
; CHECK-LABEL: @sgt_base_commute(
; CHECK-NEXT:    [[X:%.*]] = call ptr @getptr()
; CHECK-NEXT:    [[G:%.*]] = getelementptr i8, ptr [[X]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt ptr [[X]], [[G]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call ptr @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr i8, ptr %x, i64 %y
  %r = icmp sgt ptr %x, %g
  ret i1 %r
}

define i1 @slt_base_inbounds(ptr %x, i64 %y) {
; CHECK-LABEL: @slt_base_inbounds(
; CHECK-NEXT:    [[G:%.*]] = getelementptr inbounds i8, ptr [[X:%.*]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt ptr [[G]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr inbounds i8, ptr %x, i64 %y
  %r = icmp slt ptr %g, %x
  ret i1 %r
}

define i1 @sgt_base_inbounds_commute(i64 %y) {
; CHECK-LABEL: @sgt_base_inbounds_commute(
; CHECK-NEXT:    [[X:%.*]] = call ptr @getptr()
; CHECK-NEXT:    [[G:%.*]] = getelementptr inbounds i8, ptr [[X]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt ptr [[X]], [[G]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call ptr @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr inbounds i8, ptr %x, i64 %y
  %r = icmp sgt ptr %x, %g
  ret i1 %r
}

define i1 @ult_base(ptr %x, i64 %y) {
; CHECK-LABEL: @ult_base(
; CHECK-NEXT:    [[G:%.*]] = getelementptr i8, ptr [[X:%.*]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ult ptr [[G]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr i8, ptr %x, i64 %y
  %r = icmp ult ptr %g, %x
  ret i1 %r
}

define i1 @ugt_base_commute(i64 %y) {
; CHECK-LABEL: @ugt_base_commute(
; CHECK-NEXT:    [[X:%.*]] = call ptr @getptr()
; CHECK-NEXT:    [[G:%.*]] = getelementptr i8, ptr [[X]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ugt ptr [[X]], [[G]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call ptr @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr i8, ptr %x, i64 %y
  %r = icmp ugt ptr %x, %g
  ret i1 %r
}

define i1 @ult_base_inbounds(ptr %x, i64 %y) {
; CHECK-LABEL: @ult_base_inbounds(
; CHECK-NEXT:    [[R:%.*]] = icmp slt i64 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr inbounds i8, ptr %x, i64 %y
  %r = icmp ult ptr %g, %x
  ret i1 %r
}

define i1 @ugt_base_inbounds_commute(i64 %y) {
; CHECK-LABEL: @ugt_base_inbounds_commute(
; CHECK-NEXT:    [[X:%.*]] = call ptr @getptr()
; CHECK-NEXT:    [[R:%.*]] = icmp slt i64 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call ptr @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr inbounds i8, ptr %x, i64 %y
  %r = icmp ugt ptr %x, %g
  ret i1 %r
}

define i1 @ne_base_inbounds_use(ptr %x, i64 %y) {
; CHECK-LABEL: @ne_base_inbounds_use(
; CHECK-NEXT:    [[G:%.*]] = getelementptr inbounds i8, ptr [[X:%.*]], i64 [[Y:%.*]]
; CHECK-NEXT:    call void @use(ptr [[G]])
; CHECK-NEXT:    [[R:%.*]] = icmp ne i64 [[Y]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr inbounds i8, ptr %x, i64 %y
  call void @use(ptr %g)
  %r = icmp ne ptr %g, %x
  ret i1 %r
}

define i1 @eq_base_inbounds_commute_use(i64 %y) {
; CHECK-LABEL: @eq_base_inbounds_commute_use(
; CHECK-NEXT:    [[X:%.*]] = call ptr @getptr()
; CHECK-NEXT:    [[G:%.*]] = getelementptr inbounds i8, ptr [[X]], i64 [[Y:%.*]]
; CHECK-NEXT:    call void @use(ptr [[G]])
; CHECK-NEXT:    [[R:%.*]] = icmp eq i64 [[Y]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call ptr @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr inbounds i8, ptr %x, i64 %y
  call void @use(ptr %g)
  %r = icmp eq ptr %x, %g
  ret i1 %r
}

define i1 @eq_bitcast_base(ptr %p, i64 %x) {
; CHECK-LABEL: @eq_bitcast_base(
; CHECK-NEXT:    [[GEP_IDX_MASK:%.*]] = and i64 [[X:%.*]], 9223372036854775807
; CHECK-NEXT:    [[R:%.*]] = icmp eq i64 [[GEP_IDX_MASK]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %gep = getelementptr [2 x i8], ptr %p, i64 %x, i64 0
  %r = icmp eq ptr %gep, %p
  ret i1 %r
}

define i1 @eq_bitcast_base_inbounds(ptr %p, i64 %x) {
; CHECK-LABEL: @eq_bitcast_base_inbounds(
; CHECK-NEXT:    [[R:%.*]] = icmp eq i64 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %gep = getelementptr inbounds [2 x i8], ptr %p, i64 %x, i64 0
  %r = icmp eq ptr %gep, %p
  ret i1 %r
}

@X = global [1000 x i32] zeroinitializer

define i1 @PR8882(i64 %i) {
; CHECK-LABEL: @PR8882(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[I:%.*]], 1000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %p1 = getelementptr inbounds i32, ptr @X, i64 %i
  %cmp = icmp eq ptr %p1, getelementptr inbounds ([1000 x i32], ptr @X, i64 1, i64 0)
  ret i1 %cmp
}

@X_as1 = addrspace(1) global [1000 x i32] zeroinitializer

define i1 @test24_as1(i64 %i) {
; CHECK-LABEL: @test24_as1(
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[I:%.*]], 65535
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[TMP1]], 1000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %p1 = getelementptr inbounds i32, ptr addrspace(1) @X_as1, i64 %i
  %cmp = icmp eq ptr addrspace(1) %p1, getelementptr inbounds ([1000 x i32], ptr addrspace(1) @X_as1, i64 1, i64 0)
  ret i1 %cmp
}

; PR16244
define i1 @test71(ptr %x) {
; CHECK-LABEL: @test71(
; CHECK-NEXT:    ret i1 false
;
  %a = getelementptr i8, ptr %x, i64 8
  %b = getelementptr inbounds i8, ptr %x, i64 8
  %c = icmp ugt ptr %a, %b
  ret i1 %c
}

define i1 @test71_as1(ptr addrspace(1) %x) {
; CHECK-LABEL: @test71_as1(
; CHECK-NEXT:    ret i1 false
;
  %a = getelementptr i8, ptr addrspace(1) %x, i64 8
  %b = getelementptr inbounds i8, ptr addrspace(1) %x, i64 8
  %c = icmp ugt ptr addrspace(1) %a, %b
  ret i1 %c
}

declare i32 @test58_d(i64)

define i1 @test59(ptr %foo) {
; CHECK-LABEL: @test59(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds i8, ptr [[FOO:%.*]], i64 8
; CHECK-NEXT:    [[USE:%.*]] = ptrtoint ptr [[GEP1]] to i64
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @test58_d(i64 [[USE]])
; CHECK-NEXT:    ret i1 true
;
  %gep1 = getelementptr inbounds i32, ptr %foo, i64 2
  %gep2 = getelementptr inbounds i8, ptr %foo, i64 10
  %cmp = icmp ult ptr %gep1, %gep2
  %use = ptrtoint ptr %gep1 to i64
  %call = call i32 @test58_d(i64 %use)
  ret i1 %cmp
}

define i1 @test59_as1(ptr addrspace(1) %foo) {
; CHECK-LABEL: @test59_as1(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds i8, ptr addrspace(1) [[FOO:%.*]], i16 8
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint ptr addrspace(1) [[GEP1]] to i16
; CHECK-NEXT:    [[USE:%.*]] = zext i16 [[TMP1]] to i64
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @test58_d(i64 [[USE]])
; CHECK-NEXT:    ret i1 true
;
  %gep1 = getelementptr inbounds i32, ptr addrspace(1) %foo, i64 2
  %gep2 = getelementptr inbounds i8, ptr addrspace(1) %foo, i64 10
  %cmp = icmp ult ptr addrspace(1) %gep1, %gep2
  %use = ptrtoint ptr addrspace(1) %gep1 to i64
  %call = call i32 @test58_d(i64 %use)
  ret i1 %cmp
}

define i1 @test60(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test60(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i64 [[I:%.*]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[GEP1_IDX]], [[J:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr inbounds i32, ptr %foo, i64 %i
  %gep2 = getelementptr inbounds i8, ptr %foo, i64 %j
  %cmp = icmp ult ptr %gep1, %gep2
  ret i1 %cmp
}

define i1 @test_gep_ult_no_inbounds(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test_gep_ult_no_inbounds(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i32, ptr [[FOO:%.*]], i64 [[I:%.*]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i8, ptr [[FOO]], i64 [[J:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult ptr [[GEP1]], [[GEP2]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr i32, ptr %foo, i64 %i
  %gep2 = getelementptr i8, ptr %foo, i64 %j
  %cmp = icmp ult ptr %gep1, %gep2
  ret i1 %cmp
}

define i1 @test_gep_eq_no_inbounds(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test_gep_eq_no_inbounds(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl i64 [[I:%.*]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[GEP1_IDX]], [[J:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr i32, ptr %foo, i64 %i
  %gep2 = getelementptr i8, ptr %foo, i64 %j
  %cmp = icmp eq ptr %gep1, %gep2
  ret i1 %cmp
}

define i1 @test60_as1(ptr addrspace(1) %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test60_as1(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[I:%.*]] to i16
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i16 [[TMP1]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i64 [[J:%.*]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[GEP1_IDX]], [[TMP2]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr inbounds i32, ptr addrspace(1) %foo, i64 %i
  %gep2 = getelementptr inbounds i8, ptr addrspace(1) %foo, i64 %j
  %cmp = icmp ult ptr addrspace(1) %gep1, %gep2
  ret i1 %cmp
}

; Same as test60, but look through an addrspacecast instead of a
; bitcast. This uses the same sized addrspace.
define i1 @test60_addrspacecast(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test60_addrspacecast(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i64 [[I:%.*]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[GEP1_IDX]], [[J:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %bit = addrspacecast ptr %foo to ptr addrspace(3)
  %gep1 = getelementptr inbounds i32, ptr addrspace(3) %bit, i64 %i
  %gep2 = getelementptr inbounds i8, ptr %foo, i64 %j
  %cast1 = addrspacecast ptr addrspace(3) %gep1 to ptr
  %cmp = icmp ult ptr %cast1, %gep2
  ret i1 %cmp
}

define i1 @test60_addrspacecast_smaller(ptr %foo, i16 %i, i64 %j) {
; CHECK-LABEL: @test60_addrspacecast_smaller(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i16 [[I:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[J:%.*]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[GEP1_IDX]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %bit = addrspacecast ptr %foo to ptr addrspace(1)
  %gep1 = getelementptr inbounds i32, ptr addrspace(1) %bit, i16 %i
  %gep2 = getelementptr inbounds i8, ptr %foo, i64 %j
  %cast1 = addrspacecast ptr addrspace(1) %gep1 to ptr
  %cmp = icmp ult ptr %cast1, %gep2
  ret i1 %cmp
}

define i1 @test60_addrspacecast_larger(ptr addrspace(1) %foo, i32 %i, i16 %j) {
; CHECK-LABEL: @test60_addrspacecast_larger(
; CHECK-NEXT:    [[I_TR:%.*]] = trunc i32 [[I:%.*]] to i16
; CHECK-NEXT:    [[TMP1:%.*]] = shl i16 [[I_TR]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[TMP1]], [[J:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %bit = addrspacecast ptr addrspace(1) %foo to ptr addrspace(2)
  %gep1 = getelementptr inbounds i32, ptr addrspace(2) %bit, i32 %i
  %gep2 = getelementptr inbounds i8, ptr addrspace(1) %foo, i16 %j
  %cast1 = addrspacecast ptr addrspace(2) %gep1 to ptr addrspace(1)
  %cmp = icmp ult ptr addrspace(1) %cast1, %gep2
  ret i1 %cmp
}

define i1 @test61(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test61(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i32, ptr [[FOO:%.*]], i64 [[I:%.*]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i8, ptr [[FOO]], i64 [[J:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult ptr [[GEP1]], [[GEP2]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr i32, ptr %foo, i64 %i
  %gep2 = getelementptr  i8,  ptr %foo, i64 %j
  %cmp = icmp ult ptr %gep1, %gep2
  ret i1 %cmp
; Don't transform non-inbounds GEPs.
}

define i1 @test61_as1(ptr addrspace(1) %foo, i16 %i, i16 %j) {
; CHECK-LABEL: @test61_as1(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i32, ptr addrspace(1) [[FOO:%.*]], i16 [[I:%.*]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i8, ptr addrspace(1) [[FOO]], i16 [[J:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult ptr addrspace(1) [[GEP1]], [[GEP2]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr i32, ptr addrspace(1) %foo, i16 %i
  %gep2 = getelementptr i8, ptr addrspace(1) %foo, i16 %j
  %cmp = icmp ult ptr addrspace(1) %gep1, %gep2
  ret i1 %cmp
; Don't transform non-inbounds GEPs.
}

define i1 @test60_extra_use(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test60_extra_use(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i64 [[I:%.*]], 2
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds i8, ptr [[FOO:%.*]], i64 [[GEP1_IDX]]
; CHECK-NEXT:    [[GEP2_IDX:%.*]] = shl nsw i64 [[J:%.*]], 1
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds i8, ptr [[FOO]], i64 [[GEP2_IDX]]
; CHECK-NEXT:    call void @use(ptr [[GEP1]])
; CHECK-NEXT:    call void @use(ptr [[GEP2]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[GEP1_IDX]], [[GEP2_IDX]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr inbounds i32, ptr %foo, i64 %i
  %gep2 = getelementptr inbounds i16, ptr %foo, i64 %j
  call void @use(ptr %gep1)
  call void @use(ptr %gep2)
  %cmp = icmp ult ptr %gep1, %gep2
  ret i1 %cmp
}

define i1 @test60_extra_use_const_operands_inbounds(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test60_extra_use_const_operands_inbounds(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds i8, ptr [[FOO:%.*]], i64 4
; CHECK-NEXT:    call void @use(ptr nonnull [[GEP1]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[J:%.*]], 2
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr inbounds i32, ptr %foo, i64 1
  %gep2 = getelementptr inbounds i16, ptr %foo, i64 %j
  call void @use(ptr %gep1)
  %cmp = icmp eq ptr %gep1, %gep2
  ret i1 %cmp
}

define i1 @test60_extra_use_const_operands_no_inbounds(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test60_extra_use_const_operands_no_inbounds(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i8, ptr [[FOO:%.*]], i64 4
; CHECK-NEXT:    call void @use(ptr [[GEP1]])
; CHECK-NEXT:    [[GEP2_IDX_MASK:%.*]] = and i64 [[J:%.*]], 9223372036854775807
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[GEP2_IDX_MASK]], 2
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr i32, ptr %foo, i64 1
  %gep2 = getelementptr i16, ptr %foo, i64 %j
  call void @use(ptr %gep1)
  %cmp = icmp eq ptr %gep1, %gep2
  ret i1 %cmp
}

define void @test60_extra_use_fold(ptr %foo, i64 %start.idx, i64 %end.offset) {
; CHECK-LABEL: @test60_extra_use_fold(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i64 [[START_IDX:%.*]], 2
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds i8, ptr [[FOO:%.*]], i64 [[GEP1_IDX]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds i8, ptr [[FOO]], i64 [[END_OFFSET:%.*]]
; CHECK-NEXT:    call void @use(ptr [[GEP1]])
; CHECK-NEXT:    call void @use(ptr [[GEP2]])
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i64 [[GEP1_IDX]], [[END_OFFSET]]
; CHECK-NEXT:    call void @use.i1(i1 [[CMP1]])
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i64 [[GEP1_IDX]], [[END_OFFSET]]
; CHECK-NEXT:    call void @use.i1(i1 [[CMP2]])
; CHECK-NEXT:    ret void
;
  %gep1 = getelementptr inbounds i32, ptr %foo, i64 %start.idx
  %gep2 = getelementptr inbounds i8, ptr %foo, i64 %end.offset
  call void @use(ptr %gep1)
  call void @use(ptr %gep2)
  %cmp1 = icmp eq ptr %gep1, %gep2
  call void @use.i1(i1 %cmp1)
  %cmp2 = icmp ult ptr %gep1, %gep2
  call void @use.i1(i1 %cmp2)
  ret void
}

define i1 @test_scalable_same(ptr %x) {
; CHECK-LABEL: @test_scalable_same(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[A_IDX:%.*]] = shl i64 [[TMP1]], 5
; CHECK-NEXT:    [[A:%.*]] = getelementptr i8, ptr [[X:%.*]], i64 [[A_IDX]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[B_IDX:%.*]] = shl i64 [[TMP2]], 5
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i8, ptr [[X]], i64 [[B_IDX]]
; CHECK-NEXT:    [[C:%.*]] = icmp ugt ptr [[A]], [[B]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %a = getelementptr <vscale x 4 x i8>, ptr %x, i64 8
  %b = getelementptr inbounds <vscale x 4 x i8>, ptr %x, i64 8
  %c = icmp ugt ptr %a, %b
  ret i1 %c
}

define i1 @test_scalable_x(ptr %x) {
; CHECK-LABEL: @test_scalable_x(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[A_IDX_MASK:%.*]] = and i64 [[TMP1]], 576460752303423487
; CHECK-NEXT:    [[C:%.*]] = icmp eq i64 [[A_IDX_MASK]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %a = getelementptr <vscale x 4 x i8>, ptr %x, i64 8
  %c = icmp eq ptr %a, %x
  ret i1 %c
}

define i1 @test_scalable_xc(ptr %x) {
; CHECK-LABEL: @test_scalable_xc(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[A_IDX_MASK:%.*]] = and i64 [[TMP1]], 576460752303423487
; CHECK-NEXT:    [[C:%.*]] = icmp eq i64 [[A_IDX_MASK]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %a = getelementptr <vscale x 4 x i8>, ptr %x, i64 8
  %c = icmp eq ptr %x, %a
  ret i1 %c
}

define i1 @test_scalable_xy(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test_scalable_xy(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP1]], 4
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = mul nsw i64 [[TMP2]], [[I:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP4:%.*]] = shl i64 [[TMP3]], 2
; CHECK-NEXT:    [[GEP2_IDX:%.*]] = mul nsw i64 [[TMP4]], [[J:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i64 [[GEP2_IDX]], [[GEP1_IDX]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %bit = addrspacecast ptr %foo to ptr addrspace(3)
  %gep1 = getelementptr inbounds <vscale x 4 x i32>, ptr addrspace(3) %bit, i64 %i
  %gep2 = getelementptr inbounds <vscale x 4 x i8>, ptr %foo, i64 %j
  %cast1 = addrspacecast ptr addrspace(3) %gep1 to ptr
  %cmp = icmp ult ptr %cast1, %gep2
  ret i1 %cmp
}

define i1 @test_scalable_ij(ptr %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test_scalable_ij(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP1]], 4
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = mul nsw i64 [[TMP2]], [[I:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP4:%.*]] = shl i64 [[TMP3]], 2
; CHECK-NEXT:    [[GEP2_IDX:%.*]] = mul nsw i64 [[TMP4]], [[J:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[GEP1_IDX]], [[GEP2_IDX]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr inbounds <vscale x 4 x i32>, ptr %foo, i64 %i
  %gep2 = getelementptr inbounds <vscale x 4 x i8>, ptr %foo, i64 %j
  %cmp = icmp ult ptr %gep1, %gep2
  ret i1 %cmp
}

define i1 @gep_nuw(ptr %p, i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: @gep_nuw(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nuw i64 [[A:%.*]], 2
; CHECK-NEXT:    [[GEP1_IDX1:%.*]] = shl nuw i64 [[B:%.*]], 1
; CHECK-NEXT:    [[GEP1_OFFS:%.*]] = add nuw i64 [[GEP1_IDX]], [[GEP1_IDX1]]
; CHECK-NEXT:    [[GEP2_IDX:%.*]] = shl nuw i64 [[C:%.*]], 3
; CHECK-NEXT:    [[GEP2_IDX2:%.*]] = shl nuw i64 [[D:%.*]], 2
; CHECK-NEXT:    [[GEP2_OFFS:%.*]] = add nuw i64 [[GEP2_IDX]], [[GEP2_IDX2]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[GEP1_OFFS]], [[GEP2_OFFS]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr nuw [2 x i16], ptr %p, i64 %a, i64 %b
  %gep2 = getelementptr nuw [2 x i32], ptr %p, i64 %c, i64 %d
  %cmp = icmp eq ptr %gep1, %gep2
  ret i1 %cmp
}

define i1 @gep_nusw(ptr %p, i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: @gep_nusw(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i64 [[A:%.*]], 2
; CHECK-NEXT:    [[GEP1_IDX1:%.*]] = shl nsw i64 [[B:%.*]], 1
; CHECK-NEXT:    [[GEP1_OFFS:%.*]] = add nsw i64 [[GEP1_IDX]], [[GEP1_IDX1]]
; CHECK-NEXT:    [[GEP2_IDX:%.*]] = shl nsw i64 [[C:%.*]], 3
; CHECK-NEXT:    [[GEP2_IDX2:%.*]] = shl nsw i64 [[D:%.*]], 2
; CHECK-NEXT:    [[GEP2_OFFS:%.*]] = add nsw i64 [[GEP2_IDX]], [[GEP2_IDX2]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[GEP1_OFFS]], [[GEP2_OFFS]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr nusw [2 x i16], ptr %p, i64 %a, i64 %b
  %gep2 = getelementptr nusw [2 x i32], ptr %p, i64 %c, i64 %d
  %cmp = icmp eq ptr %gep1, %gep2
  ret i1 %cmp
}