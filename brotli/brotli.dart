import 'dart:convert';
import 'dart:io';
import 'package:ffi/ffi.dart'; // needed for utf-8 arrays and manual pointer allocations
import 'dart:ffi';

import 'common/types.dart';
import 'encoder/encoder.dart';
import 'decoder/decoder.dart';

main() {
  print("Enter a string");
  var input_string = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  var encoder_path = 'lib/libbrotlienc.so';
  var decoder_path = 'lib/libbrotlidec.so';

  final encoder_dylib = DynamicLibrary.open(encoder_path);
  final encoder = new BrotliEncoder(encoder_dylib);
  print("Loaded ${encoder_path} version: 0x${encoder.utility.version().toRadixString(16)}");
  
  final decoder_dylib = DynamicLibrary.open(decoder_path);
  final decoder = BrotliDecoder(decoder_dylib);
  print("Loaded ${decoder_path} version: 0x${decoder.utility.version().toRadixString(16)}");

  singleshot(input_string, encoder, decoder);
}

void singleshot(String input, BrotliEncoder encoder, BrotliDecoder decoder) {
  // ENCODING

  var input_bytes = Utf8.toUtf8(input);
  var buffer_size = encoder.utility.max_compressed_size(Utf8.strlen(input_bytes));
  final Pointer<Uint8> input_buffer = input_bytes.cast();
  final Pointer<Int32> encoded_size = allocate();
  encoded_size.value = buffer_size;
  final Pointer<Uint8> encoded_buffer = allocate<Uint8>(count: encoded_size.value);

  print("Using a buffer size of ${encoded_size.value}");
  int result = encoder.compress(
    11, 22, BrotliEncoderMode.BROTLI_MODE_TEXT,
    Utf8.strlen(input_bytes) + 1, input_buffer,
    encoded_size, encoded_buffer
  );

  print("Encoding: ${input}");
  print("BrotliEncoderCompress returned ${result == BROTLI_FALSE ? "BROTLI_FALSE" : "BROTLI_TRUE"}");
  print("Encoded size is ${encoded_size.value}");
  String r = "";
  for (var i = 0; i < encoded_size.value; i++) {
    r += (encoded_buffer.elementAt(i).value).toRadixString(16).padLeft(2, '0') + " ";
  }
  print("Result: $r");

  print("");
  // DECODING

  final Pointer<Int32> decoded_size = allocate();
  decoded_size.value = buffer_size;
  final Pointer<Uint8> decoded_buffer = allocate<Uint8>(count: decoded_size.value);

  print("Decoding: ${r}");
  print("Using a buffer size of ${decoded_size.value}");
  result = decoder.decompress(
    encoded_size.value,
    encoded_buffer,
    decoded_size,
    decoded_buffer
  );
  print("BrotliDecoderDecompress returned ${result == BrotliDecoderResult.BROTLI_DECODER_RESULT_ERROR ? "DECODER_ERROR" : "DECODER_SUCCESS"}");
  print("Decoded size is ${decoded_size.value}");
  
  print("Result: " + String.fromCharCodes(decoded_buffer.asTypedList(decoded_size.value)));
}