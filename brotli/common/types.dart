// As enums do not cover interop situations well(https://github.com/dart-lang/sdk/issues/21966), 
// using classes and static members to represent enums

import 'dart:ffi';

/// Portable C false replacement
int BROTLI_FALSE = 0;
/// Portable C true replacement
int BROTLI_TRUE = 1;

/// typedef void* (*brotli_alloc_func)(void* opaque, size_t size);
typedef brotli_alloc_func_nt = Pointer<Void> Function(Pointer<Void>, Int32);

/// typedef void (*brotli_free_func)(void* opaque, void* address);
typedef brotli_free_func_nt = Pointer<Void> Function(Pointer<Void>, Pointer<Void>);

/// Result types for BrotliDecoderDecompress() and BrotliDecoderDecompressStream()
class BrotliDecoderResult {
  /// Decoding error, e.g. corrupted input or memory allocation problem.
  static int BROTLI_DECODER_RESULT_ERROR = 0;
  /// Decoding successfully completed.
  static int BROTLI_DECODER_RESULT_SUCCESS = 1;
  /// Partially done; should be called again with more input.
  static int BROTLI_DECODER_RESULT_NEEDS_MORE_INPUT = 2;
  /// Partially done; should be called again with more output.
  static int BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT = 3;
}

// From brotli's encode.h

/// Minimal value for BROTLI_PARAM_LGWIN parameter.
int BROTLI_MIN_WINDOW_BITS = 10;
/// Maximal value for BROTLI_PARAM_LGWIN parameter.
/// Note: equal to BROTLI_MAX_DISTANCE_BITS constant.
int BROTLI_MAX_WINDOW_BITS = 24;
/// Maximal value for BROTLI_PARAM_LGWIN parameter
/// in "Large Window Brotli" (32-bit).
int BROTLI_LARGE_MAX_WINDOW_BITS = 30;
/// Minimal value for BROTLI_PARAM_LGBLOCK parameter.
int BROTLI_MIN_INPUT_BLOCK_BITS = 16;
/// Maximal value for ::BROTLI_PARAM_LGBLOCK parameter.
int BROTLI_MAX_INPUT_BLOCK_BITS = 24;
/// Minimal value for ::BROTLI_PARAM_QUALITY parameter.
int BROTLI_MIN_QUALITY = 0;
/// Maximal value for ::BROTLI_PARAM_QUALITY parameter.
int BROTLI_MAX_QUALITY = 11;
/// Default value for ::BROTLI_PARAM_QUALITY parameter.
int BROTLI_DEFAULT_QUALITY = 11;
/// Default value for ::BROTLI_PARAM_LGWIN parameter.
int BROTLI_DEFAULT_WINDOW = 22;
/// Default value for ::BROTLI_PARAM_MODE parameter.
int BROTLI_DEFAULT_MODE = BrotliEncoderMode.BROTLI_MODE_GENERIC;

/// Options for BROTLI_PARAM_MODE parameter
class BrotliEncoderMode {
  /// Default compression mode.
  /// In this mode the compressor does not know anything in advance about the
  /// properties of the input.
  static int BROTLI_MODE_GENERIC = 0;
  /// Compression mode for UTF-8 formatted text input.
  static int BROTLI_MODE_TEXT = 1;
  /// Compression mode used in WOFF 2.0
  static int BROTLI_MODE_FONT = 2;
}

/// Operations that can be performed by streaming encoder.
class BrotliEncoderOperation {
  static int BROTLI_OPERATION_PROCESS = 0;
  static int BROTLI_OPERATION_FLUSH = 1;
  static int BROTLI_OPERATION_FINISH = 2;
  static int BROTLI_OPERATION_EMIT_METADATA = 3;
}

/// Options to be used with ::BrotliEncoderSetParameter.
class BrotliEncoderParameter {
  static int BROTLI_PARAM_MODE = 0;
  static int BROTLI_PARAM_QUALITY = 1;
  static int BROTLI_PARAM_LGWIN = 2;
  static int BROTLI_PARAM_LGBLOCK = 3;
  static int BROTLI_PARAM_DISABLE_LITERAL_CONTEXT_MODELING = 4;
  static int BROTLI_PARAM_SIZE_HINT = 5;
  static int BROTLI_PARAM_LARGE_WINDOW = 6;
  static int BROTLI_PARAM_NPOSTFIX = 7;
  static int BROTLI_PARAM_NDIRECT = 8;
  static int BROTLI_PARAM_STREAM_OFFSET = 9;
}

class BrotliEncoderState extends Struct {}