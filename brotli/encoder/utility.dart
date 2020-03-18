import 'dart:ffi';
import '../common/types.dart';

// uint32_t BrotliEncoderVersion(void);
typedef brotli_encoder_version_nt = Uint32 Function();

// BROTLI_ENC_API size_t BrotliEncoderMaxCompressedSize(size_t input_size);
typedef brotli_encoder_max_compressed_size_nt = Int32 Function(Int32);

// BROTLI_ENC_API BROTLI_BOOL BrotliEncoderIsFinished(BrotliEncoderState* state);
typedef brotli_encoder_is_finished_nt = Int32 Function(Pointer<BrotliEncoderState>);

// BROTLI_ENC_API BROTLI_BOOL BrotliEncoderHasMoreOutput(BrotliEncoderState* state);
typedef brotli_encoder_has_more_output_nt = Int32 Function(Pointer<BrotliEncoderState>);

class BrotliEncoderUtility
{
  int Function() _version;
  int Function(int) _max_compressed_size;
  int Function(Pointer<BrotliEncoderState>) _is_finished;
  int Function(Pointer<BrotliEncoderState>) _has_more_output;

  BrotliEncoderUtility(DynamicLibrary dynamicLibrary) {
    _version = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_version_nt>>('BrotliEncoderVersion')
      .asFunction();
    _max_compressed_size = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_max_compressed_size_nt>>('BrotliEncoderMaxCompressedSize')
      .asFunction();
    _is_finished = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_is_finished_nt>>('BrotliEncoderMaxCompressedSize')
      .asFunction();
    _has_more_output = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_has_more_output_nt>>('BrotliEncoderMaxCompressedSize')
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

  /// Checks if encoder instance reached the final state.
  ///
  /// [state] encoder instance
  /// Returns: BROTLI_TRUE if encoder is in a state where it reached the end of
  ///          the input and produced all of the output
  /// Returns: BROTLI_FALSE otherwise
  int is_finished(Pointer<BrotliEncoderState> state) => _is_finished(state);

  /// Checks if encoder has more output.
  /// 
  /// [state] encoder instance
  /// Returns: BROTLI_TRUE, if encoder has some unconsumed output
  /// Returns: BROTLI_FALSE otherwise
  int has_more_output(Pointer<BrotliEncoderState> state) => _has_more_output(state);
}