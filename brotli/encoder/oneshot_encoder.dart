import 'dart:ffi';

// uint32_t BrotliEncoderVersion(void);
typedef brotli_encoder_version_nt = Uint32 Function();

// BROTLI_ENC_API BROTLI_BOOL BrotliEncoderCompress(
//   int quality, int lgwin, BrotliEncoderMode mode, size_t input_size,
//   const uint8_t input_buffer[BROTLI_ARRAY_PARAM(input_size)],
//   size_t* encoded_size,
//   uint8_t encoded_buffer[BROTLI_ARRAY_PARAM(*encoded_size)]);
typedef brotli_encoder_compress_nt = Int32 Function(
  Int32, Int32, Int32, IntPtr,
  Pointer<Uint8>,
  Pointer<Int32>,
  Pointer<Uint8>
);

// BROTLI_ENC_API size_t BrotliEncoderMaxCompressedSize(size_t input_size);
typedef brotli_encoder_max_compressed_size_nt = Int32 Function(Int32);

class BrotliOneshotEncoder
{
  int Function() _version;
  int Function(int) _max_compressed_size;
  int Function(
    int, int, int,
    int, Pointer<Uint8>,
    Pointer<Int32>, Pointer<Uint8>
  ) _compress;

  BrotliOneshotEncoder(DynamicLibrary dynamicLibrary) {
    _version = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_version_nt>>('BrotliEncoderVersion')
      .asFunction();
    _max_compressed_size = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_max_compressed_size_nt>>('BrotliEncoderMaxCompressedSize')
      .asFunction();
    _compress = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_compress_nt>>('BrotliEncoderCompress')
      .asFunction();
  }

  /// Gets the version of the library
  int version() => _version();

  /// Calculates the output size bound for the given [input_size].
  /// 
  /// Result is only valid if quality is at least 2 and, in
  /// case BrotliEncoderCompressStream was used, no flushes
  /// (BROTLI_OPERATION_FLUSH) were performed.
  /// 
  /// Returns 0 if result does not fit size_t
  int max_compressed_size(int input_size) => _max_compressed_size(input_size);

  /// Performs one-shot memory-to-memory compression.
  /// 
  /// Compresses the data in [input_buffer] into [encoded_buffer], and sets
  /// [encoded_size] to the compressed length.
  int compress(
    int quality, int lgwin, int mode,
    int input_size, Pointer<Uint8> input_buffer,
    Pointer<Int32> encoded_size, Pointer<Uint8> encoded_buffer
  ) => _compress(quality, lgwin, mode, input_size, input_buffer, encoded_size, encoded_buffer);
}