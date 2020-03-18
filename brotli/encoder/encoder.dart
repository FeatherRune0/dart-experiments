import 'dart:ffi';
import 'utility.dart';
import '../common/types.dart';

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

// BROTLI_ENC_API BROTLI_BOOL BrotliEncoderSetParameter(
//    BrotliEncoderState* state, BrotliEncoderParameter param, uint32_t value);
typedef brotli_encoder_set_parameter_nt = Int32 Function(
  Pointer<Struct>, Int32, Uint32
);

// BROTLI_ENC_API BrotliEncoderState* BrotliEncoderCreateInstance(
//    brotli_alloc_func alloc_func, brotli_free_func free_func, void* opaque);
typedef brotli_encoder_create_instance_nt = Pointer<BrotliEncoderState> Function(
  Pointer<NativeFunction<brotli_alloc_func_nt>>,
  Pointer<NativeFunction<brotli_free_func_nt>>,
  Pointer<Void> opaque
);

// BROTLI_ENC_API void BrotliEncoderDestroyInstance(BrotliEncoderState* state);
typedef brotli_encoder_destroy_instance_nt = Void Function(Pointer<BrotliEncoderState>);

// BROTLI_ENC_API BROTLI_BOOL BrotliEncoderCompressStream(
//    BrotliEncoderState* state, BrotliEncoderOperation op, size_t* available_in,
//    const uint8_t** next_in, size_t* available_out, uint8_t** next_out,
//    size_t* total_out);
typedef brotli_encoder_compress_stream_nt = Int32 Function(
  Pointer<BrotliEncoderState>, Int32, Pointer<Int32>,
  Pointer<Pointer<Uint8>>, Pointer<Int32>, Pointer<Pointer<Uint8>>,
  Pointer<Int32>
);

// BROTLI_ENC_API const uint8_t* BrotliEncoderTakeOutput(
//    BrotliEncoderState* state, size_t* size);
typedef brotli_encoder_take_output_nt = Pointer<Uint8> Function(
  Pointer<BrotliEncoderState>, Pointer<Int32>
);

class BrotliEncoder
{
  BrotliEncoderUtility utility;

  int Function(
    int, int, int,
    int, Pointer<Uint8>,
    Pointer<Int32>, Pointer<Uint8>
  ) _compress;
  int Function(Pointer<BrotliEncoderState>, int, int) _set_parameter;
  Pointer<BrotliEncoderState> Function(
    Pointer<NativeFunction<brotli_alloc_func_nt>>,
    Pointer<NativeFunction<brotli_free_func_nt>>,
    Pointer<Void>
  ) _create_instance;
  void Function(Pointer<BrotliEncoderState>) _destroy_instance;
  int Function(
    Pointer<BrotliEncoderState>, int, Pointer<Int32>,
    Pointer<Pointer<Uint8>>, Pointer<Int32>, Pointer<Pointer<Uint8>>,
    Pointer<Int32>
  ) _compress_stream;
  Pointer<Uint8> Function(
    Pointer<BrotliEncoderState>, Pointer<Int32>
  ) _take_output;

  BrotliEncoder(DynamicLibrary dynamicLibrary) {
    utility = BrotliEncoderUtility(dynamicLibrary);

    _compress = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_compress_nt>>('BrotliEncoderCompress')
      .asFunction();
    _set_parameter = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_set_parameter_nt>>('BrotliEncoderSetParameter')
      .asFunction();
    _create_instance = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_create_instance_nt>>('BrotliEncoderCreateInstance')
      .asFunction();
    _destroy_instance = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_destroy_instance_nt>>('BrotliEncoderDestroyInstance')
      .asFunction();
    _compress_stream = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_compress_stream_nt>>('BrotliEncoderCompressStream')
      .asFunction();
    _take_output = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_take_output_nt>>('BrotliEncoderCompressStream')
      .asFunction();
  }

  /// Performs one-shot memory-to-memory compression.
  /// 
  /// Compresses the data in [input_buffer] into [encoded_buffer], and sets
  /// [encoded_size] to the compressed length.
  int compress(
    int quality, int lgwin, int mode,
    int input_size, Pointer<Uint8> input_buffer,
    Pointer<Int32> encoded_size, Pointer<Uint8> encoded_buffer
  ) => _compress(quality, lgwin, mode, input_size, input_buffer, encoded_size, encoded_buffer);

  /// Sets the specified parameter to the given encoder instance.
  /// 
  /// [state]: encoder instance
  /// [param]: parameter to set
  /// [value]: new parameter value
  /// 
  /// Returns BROTLI_FALSE if parameter is unrecognized, or value is invalid
  /// Returns BROTLI_FALSE if value of parameter can not be changed at current
  ///         encoder state (e.g. when encoding is started, window size might be
  ///         already encoded and therefore it is impossible to change it)
  /// Returns BROTLI_TRUE if value is accepted
  /// Warning:invalid values might be accepted in case they would not break
  ///         encoding process.
  int set_parameter(
    Pointer<BrotliEncoderState> state,
    int param,
    int value
  ) => _set_parameter(state, param, value);

  /// Creates an instance of BrotliEncoderState and initializes it.
  /// 
  /// [alloc_func] and [free_func] MUST be both zero or both non-zero. In the
  /// case they are both zero, default memory allocators are used. [opaque] is
  /// passed to [alloc_func] and [free_func] when they are called. [free_func]
  /// has to return without doing anything when asked to free a NULL pointer.
  /// 
  /// [alloc_func]: custom memory allocation function
  /// [free_func]: custom memory free function
  /// [opaque]: custom memory manager handle
  /// Returns 0 if instance can not be allocated or initialized
  /// Returns pointer to initialized BrotliEncoderState otherwise
  Pointer<BrotliEncoderState> create_instance(
    Pointer<NativeFunction<brotli_alloc_func_nt>> alloc_func,
    Pointer<NativeFunction<brotli_free_func_nt>> free_func,
    Pointer<Void> opaque
  ) => _create_instance(alloc_func, free_func, opaque);

  /// Deinitializes and frees BrotliEncoderState instance.
  /// 
  /// [state]: decoder instance to be cleaned up and deallocated
  void destroy_instance(Pointer<BrotliEncoderState> state) => _destroy_instance(state);

  /// Compresses input stream to output stream.
  /// 
  /// The values [*available_in] and [*available_out] must specify the number of
  /// bytes addressable at [*next_in] and [*next_out] respectively.
  /// When [*available_out] is 0, [next_out] is allowed to be NULL.
  /// 
  /// After each call, [*available_in] will be decremented by the amount of input
  /// bytes consumed, and the [*next_in] pointer will be incremented by that
  /// amount. Similarly, [*available_out] will be decremented by the amount of
  /// output bytes written, and the [*next_out] pointer will be incremented by
  /// that amount.
  /// 
  /// [total_out], if it is not a null-pointer, will be set to the number
  /// of bytes compressed since the last [state] initialization.
  /// 
  /// Internally workflow consists of 3 tasks:
  ///  -# (optionally) copy input data to internal buffer
  ///  -# actually compress data and (optionally) store it to internal buffer
  ///  -# (optionally) copy compressed bytes from internal buffer to output stream
  /// 
  /// Whenever all 3 tasks can't move forward anymore, or error occurs, this
  /// method returns the control flow to caller.
  /// 
  /// [op] is used to perform flush, finish the stream, or inject metadata block.
  /// See BrotliEncoderOperation for more information.
  /// 
  /// Flushing the stream means forcing encoding of all input passed to encoder and
  /// completing the current output block, so it could be fully decoded by stream
  /// decoder. To perform flush set [op] to BROTLI_OPERATION_FLUSH.
  /// Under some circumstances (e.g. lack of output stream capacity) this operation
  /// would require several calls to BrotliEncoderCompressStream. The method must
  /// be called again until both input stream is depleted and encoder has no more
  /// output (see BrotliEncoderHasMoreOutput) after the method is called.
  /// 
  /// Finishing the stream means encoding of all input passed to encoder and
  /// adding specific "final" marks, so stream decoder could determine that stream
  /// is complete. To perform finish set [op] to BROTLI_OPERATION_FINISH.
  /// Under some circumstances (e.g. lack of output stream capacity) this operation
  /// would require several calls to BrotliEncoderCompressStream. The method must
  /// be called again until both input stream is depleted and encoder has no more
  /// output (see BrotliEncoderHasMoreOutput) after the method is called.
  /// 
  /// Warning: When flushing and finishing, [op] should not change until operation
  ///          is complete; input stream should not be swapped, reduced or
  ///          extended as well.
  /// 
  /// [state] encoder instance
  /// [op] requested operation
  /// [available_in] in: amount of available input
  ///                out: amount of unused input
  /// [next_in] pointer to the next input byte
  /// [available_out] in: length of output buffer
  ///                 out: remaining size of output buffer
  /// [next_out] compressed output buffer cursor
  ///            can be NULL if [available_out] is 0
  /// [total_out] number of bytes produced so far; can be NULL
  /// Returns BROTLI_FALSE if there was an error
  /// Returns BROTLI_TRUE otherwise
  int compress_stream(
    Pointer<BrotliEncoderState> state, int op, Pointer<Int32> available_in,
    Pointer<Pointer<Uint8>> next_in, Pointer<Int32> available_out, Pointer<Pointer<Uint8>> next_out,
    Pointer<Int32> total_out
  ) => _compress_stream(state, op, available_in, next_in, available_out, next_out, total_out);

  /// Acquires pointer to internal output buffer.
  /// 
  /// This method is used to make language bindings easier and more efficient:
  /// -# push data to BrotliEncoderCompressStream,
  ///    until BrotliEncoderHasMoreOutput returns BROTLI_TRUE
  /// -# use BrotliEncoderTakeOutput to peek bytes and copy to language-specific
  ///    entity
  /// 
  /// Also this could be useful if there is an output stream that is able to
  /// consume all the provided data (e.g. when data is saved to file system).
  /// 
  /// Attention: After every call to BrotliEncoderTakeOutput [*size bytes] of
  ///            output are considered consumed for all consecutive calls to the
  ///            instance methods; returned pointer becomes invalidated as well.
  /// 
  /// Note: Encoder output is not guaranteed to be contiguous. This means that
  ///       after the size-unrestricted call to BrotliEncoderTakeOutput,
  ///       immediate next call to BrotliEncoderTakeOutput may return more data.
  /// 
  /// [state]: encoder instance
  /// [size] : in: number of bytes caller is ready to take, 0 if
  ///              any amount could be handled;
  ///          out: amount of data pointed by returned pointer and
  ///               considered consumed;
  ///               out value is never greater than in value, unless it is 0
  /// Returns pointer to output data
  Pointer<Uint8> take_output(
    Pointer<BrotliEncoderState> state, Pointer<Int32> size
  ) => _take_output(state, size);
}