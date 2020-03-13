import 'dart:ffi';

// BROTLI_DEC_API uint32_t BrotliDecoderVersion(void);
typedef brotli_decoder_version_nt = Uint32 Function();

// BROTLI_DEC_API BrotliDecoderResult BrotliDecoderDecompress(
//    size_t encoded_size,
//    const uint8_t encoded_buffer[BROTLI_ARRAY_PARAM(encoded_size)],
//    size_t* decoded_size,
//    uint8_t decoded_buffer[BROTLI_ARRAY_PARAM(*decoded_size)]);
typedef brotli_decoder_decompress_nt = Int32 Function(
  Int32,
  Pointer<Uint8>,
  Pointer<Int32>,
  Pointer<Uint8>
);

class BrotliOneshotDecoder 
{
  int Function() _version;
  int Function(
    int, Pointer<Uint8>,
    Pointer<Int32>, Pointer<Uint8>
  ) _decompress;

  BrotliOneshotDecoder(DynamicLibrary dynamicLibrary) {
    _version = dynamicLibrary
      .lookup<NativeFunction<brotli_decoder_version_nt>>('BrotliDecoderVersion')
      .asFunction();
    _decompress = dynamicLibrary
      .lookup<NativeFunction<brotli_decoder_decompress_nt>>('BrotliDecoderDecompress')
      .asFunction();
  }

  /// Get the version of the library
  int version() => _version();

  /// Performs one-shot memory-to-memory decompression.
  /// 
  /// Decompresses the data in [encoded_buffer] into [decoded_buffer], and sets
  /// [decoded_size] to the decompressed length.
  int decompress(
    int encoded_size,
    Pointer<Uint8> encoded_buffer,
    Pointer<Int32> decoded_size,
    Pointer<Uint8> decoded_buffer
  ) => _decompress(encoded_size, encoded_buffer, decoded_size, decoded_buffer);
}