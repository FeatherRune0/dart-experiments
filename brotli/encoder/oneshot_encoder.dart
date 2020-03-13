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

class BrotliOneshotEncoder
{
  int Function() version;
  int Function(
    int quality, int lgwin, int mode,
    int input_size, Pointer<Uint8> input_buffer,
    Pointer<Int32> encoded_size, Pointer<Uint8> encoded_buffer
  ) compress;

  BrotliOneshotEncoder(DynamicLibrary dynamicLibrary) {
    version = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_version_nt>>('BrotliEncoderVersion')
      .asFunction();
    compress = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_compress_nt>>('BrotliEncoderCompress')
      .asFunction();
  }
}