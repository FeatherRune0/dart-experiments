// As enums do not cover interop situations well(https://github.com/dart-lang/sdk/issues/21966), 
// using classes and static members to represent enums

/// Portable C false replacement
int BROTLI_FALSE = 0;
/// Portable C true replacement
int BROTLI_TRUE = 1;

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