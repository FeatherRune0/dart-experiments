import 'package:ffi/ffi.dart'; // needed for utf-8 arrays and manual pointer allocations
import 'dart:ffi';

// BROTLI_BOOL
int BROTLI_FALSE = 0;
int BROTLI_TRUE = 1;

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

class BrotliEncoder
{
  // enum BrotliEncoderMode
  static int MODE_GENERIC = 0; // Default mode, compressor does not know anything
  static int MODE_TEXT = 1; // for UTF-8 input
  static int MODE_FONT = 2; // for WOFF 2.0

  int Function() version;
  int Function(
    int quality, int lgwin, int mode,
    int input_size, Pointer<Uint8> input_buffer,
    Pointer<Int32> encoded_size, Pointer<Uint8> encoded_buffer
  ) compress;

  BrotliEncoder(DynamicLibrary dynamicLibrary) {
    version = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_version_nt>>('BrotliEncoderVersion')
      .asFunction();
    compress = dynamicLibrary
      .lookup<NativeFunction<brotli_encoder_compress_nt>>('BrotliEncoderCompress')
      .asFunction();
  }
}

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

class BrotliDecoder 
{
  // enum BrotliDecoderResult
  static int RESULT_ERROR = 0; // Decoding error
  static int RESULT_SUCCESS = 1; // Decoding success

  int Function() version;
  int Function(
    int encoded_size,
    Pointer<Uint8> encoded_buffer,
    Pointer<Int32> decoded_size,
    Pointer<Uint8> decoded_buffer
  ) decompress;

  BrotliDecoder(DynamicLibrary dynamicLibrary) {
    version = dynamicLibrary
      .lookup<NativeFunction<brotli_decoder_version_nt>>('BrotliDecoderVersion')
      .asFunction();
    decompress = dynamicLibrary
      .lookup<NativeFunction<brotli_decoder_decompress_nt>>('BrotliDecoderDecompress')
      .asFunction();
  }
}

main() {
  var input_string = "Hello Brotli!";
  var buffer_size = 150;
  var encoder_path = 'lib/libbrotlienc.so';
  var decoder_path = 'lib/libbrotlidec.so';

  // ENCODING

  final encoder_dylib = DynamicLibrary.open(encoder_path);
  final encoder = new BrotliEncoder(encoder_dylib);
  print("Loaded ${encoder_path} version: 0x${encoder.version().toRadixString(16)}");

  var input_bytes = Utf8.toUtf8(input_string);
  final Pointer<Uint8> input_buffer = input_bytes.cast();
  final Pointer<Int32> encoded_size = allocate();
  encoded_size.value = buffer_size;
  final Pointer<Uint8> encoded_buffer = allocate<Uint8>(count: encoded_size.value);

  int result = encoder.compress(
    11, 22, BrotliEncoder.MODE_TEXT,
    Utf8.strlen(input_bytes) + 1, input_buffer,
    encoded_size, encoded_buffer
  );

  print("Encoding: ${input_string}");
  print("BrotliEncoderCompress returned ${result == 0 ? "BROTLI_FALSE" : "BROTLI_TRUE"}");
  print("Encoded size is ${encoded_size.value}");
  String r = "";
  for (var i = 0; i < encoded_size.value; i++) {
    r += (encoded_buffer.elementAt(i).value).toRadixString(16).padLeft(2, '0') + " ";
  }
  print("Result: $r");

  print("");
  // DECODING

  final decoder_dylib = DynamicLibrary.open(decoder_path);
  final decoder = BrotliDecoder(decoder_dylib);
  print("Loaded ${decoder_path} version: 0x${decoder.version().toRadixString(16)}");

  final Pointer<Int32> decoded_size = allocate();
  decoded_size.value = buffer_size;
  final Pointer<Uint8> decoded_buffer = allocate<Uint8>(count: decoded_size.value);

  print("Decoding: ${r}");
  result = decoder.decompress(
    encoded_size.value,
    encoded_buffer,
    decoded_size,
    decoded_buffer
  );
  print("BrotliDecoderDecompress returned ${result == BrotliDecoder.RESULT_ERROR ? "DECODER_ERROR" : "DECODER_SUCCESS"}");
  print("Decoded size is ${decoded_size.value}");
  
  print("Result: " + String.fromCharCodes(decoded_buffer.asTypedList(decoded_size.value)));
}