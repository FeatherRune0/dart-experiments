import 'package:ffi/ffi.dart'; // needed for utf-8 arrays and manual pointer allocations
import 'dart:ffi';

import 'encoder/oneshot_encoder.dart';
import 'decoder/oneshot_decoder.dart';

// BROTLI_BOOL
int BROTLI_FALSE = 0;
int BROTLI_TRUE = 1;

main() {
  var input_string = "Hello Brotli!";
  var buffer_size = 150;
  var encoder_path = 'lib/libbrotlienc.so';
  var decoder_path = 'lib/libbrotlidec.so';

  // ENCODING

  final encoder_dylib = DynamicLibrary.open(encoder_path);
  final encoder = new BrotliOneshotEncoder(encoder_dylib);
  print("Loaded ${encoder_path} version: 0x${encoder.version().toRadixString(16)}");

  var input_bytes = Utf8.toUtf8(input_string);
  final Pointer<Uint8> input_buffer = input_bytes.cast();
  final Pointer<Int32> encoded_size = allocate();
  encoded_size.value = buffer_size;
  final Pointer<Uint8> encoded_buffer = allocate<Uint8>(count: encoded_size.value);

  int result = encoder.compress(
    11, 22, BrotliOneshotEncoder.MODE_TEXT,
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
  final decoder = BrotliOneshotDecoder(decoder_dylib);
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
  print("BrotliDecoderDecompress returned ${result == BrotliOneshotDecoder.RESULT_ERROR ? "DECODER_ERROR" : "DECODER_SUCCESS"}");
  print("Decoded size is ${decoded_size.value}");
  
  print("Result: " + String.fromCharCodes(decoded_buffer.asTypedList(decoded_size.value)));
}