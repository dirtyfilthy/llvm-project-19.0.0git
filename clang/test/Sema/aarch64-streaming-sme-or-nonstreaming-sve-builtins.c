// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -fsyntax-only -verify %s

// REQUIRES: aarch64-registered-target

#include <arm_sve.h>

__attribute__((target("+sve2p1")))
svfloat32_t good1(svfloat32_t a, svfloat32_t b, svfloat32_t c) {
  return svclamp(a, b, c);
}

__attribute__((target("+sme2")))
svfloat32_t good2(svfloat32_t a, svfloat32_t b, svfloat32_t c) __arm_streaming {
  return svclamp(a, b, c);
}

__attribute__((target("+sve2p1,+sme2")))
svfloat32_t good3(svfloat32_t a, svfloat32_t b, svfloat32_t c) __arm_streaming_compatible {
  return svclamp(a, b, c);
}

__attribute__((target("+sve2p1,+sme2")))
svfloat32_t good4(svfloat32_t a, svfloat32_t b, svfloat32_t c) __arm_streaming {
  return svclamp(a, b, c);
}

__attribute__((target("+sve2p1")))
svfloat32_t good5(svfloat32_t a, svfloat32_t b, svfloat32_t c) __arm_streaming_compatible {
  return svclamp(a, b, c);
}

// Even though svclamp is not available in streaming mode without +sme2,
// the behaviour should be the same as above, irrespective of whether +sme
// is passed or not.
__attribute__((target("+sve2p1,+sme")))
svfloat32_t good6(svfloat32_t a, svfloat32_t b, svfloat32_t c) __arm_streaming_compatible {
  return svclamp(a, b, c);
}

// Without '+sme2', the builtin is only valid in non-streaming mode.
__attribute__((target("+sve2p1,+sme")))
svfloat32_t bad1(svfloat32_t a, svfloat32_t b, svfloat32_t c) __arm_streaming {
  return svclamp(a, b, c) + svclamp(a, b, c); // expected-error{{builtin can only be called from a non-streaming function}} \
                                              // expected-error{{builtin can only be called from a non-streaming function}}
}

// Without '+sve2p1', the builtin is only valid in streaming mode.
__attribute__((target("+sve2,+sme2")))
svfloat32_t bad2(svfloat32_t a, svfloat32_t b, svfloat32_t c) {
  return svclamp(a, b, c) + svclamp(a, b, c); // expected-error{{builtin can only be called from a streaming function}} \
                                              // expected-error{{builtin can only be called from a streaming function}}
}

__attribute__((target("+sve2,+sme2")))
svfloat32_t bad4(svfloat32_t a, svfloat32_t b, svfloat32_t c) __arm_streaming_compatible {
  return svclamp(a, b, c) + svclamp(a, b, c); // expected-error{{builtin can only be called from a streaming function}} \
                                              // expected-error{{builtin can only be called from a streaming function}}
}

// We don't want a warning about undefined behaviour if none of the feature requirements of the builtin are satisfied.
// (this results in a target-guard error emitted by Clang CodeGen)
svfloat32_t bad5(svfloat32_t a, svfloat32_t b, svfloat32_t c) {
  return svclamp(a, b, c);
}