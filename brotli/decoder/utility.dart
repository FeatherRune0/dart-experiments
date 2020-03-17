import 'dart:ffi';

// BROTLI_DEC_API uint32_t BrotliDecoderVersion(void);
typedef brotli_decoder_version_nt = Uint32 Function();

class BrotliDecoderUtility
{
  int Function() _version;

  BrotliDecoderUtility(DynamicLibrary dynamicLibrary) {
    _version = dynamicLibrary
      .lookup<NativeFunction<brotli_decoder_version_nt>>('BrotliDecoderVersion')
      .asFunction();
  }

  /// Get the version of the library
  int version() => _version();
}