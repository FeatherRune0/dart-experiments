import 'dart:ffi';

// typedef void (* GLFWerrorfun)(int,const char*);
typedef GLFWerrorfun = Void Function(Int32, Pointer<Uint8>);