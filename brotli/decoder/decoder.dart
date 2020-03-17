import 'dart:ffi';
import 'utility.dart';

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

class BrotliDecoder 
{
  BrotliDecoderUtility utility;

  int Function(
    int, Pointer<Uint8>,
    Pointer<Int32>, Pointer<Uint8>
  ) _decompress;

  BrotliDecoder(DynamicLibrary dynamicLibrary) {
    utility = BrotliDecoderUtility(dynamicLibrary);
    
    _decompress = dynamicLibrary
      .lookup<NativeFunction<brotli_decoder_decompress_nt>>('BrotliDecoderDecompress')
      .asFunction();
  }

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