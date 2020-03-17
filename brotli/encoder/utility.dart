import 'dart:ffi';

// uint32_t BrotliEncoderVersion(void);
typedef brotli_encoder_version_nt = Uint32 Function();

// BROTLI_ENC_API size_t BrotliEncoderMaxCompressedSize(size_t input_size);
typedef brotli_encoder_max_compressed_size_nt = Int32 Function(Int32);

class BrotliEncoderUtility
{
  int Function() _version;
  int Function(int) _max_compressed_size;

  BrotliEncoderUtility(DynamicLibrary dynamicLibrary) {
    _version = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_version_nt>>('BrotliEncoderVersion')
      .asFunction();
    _max_compressed_size = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_max_compressed_size_nt>>('BrotliEncoderMaxCompressedSize')
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
}