import 'dart:ffi';
import 'structs.dart';

// typedef void (* GLFWerrorfun)(int,const char*);
typedef GLFWerrorfun = Void Function(Int32, Pointer<Uint8>);

// typedef void (* GLFWkeyfun)(GLFWwindow*,int,int,int,int);
typedef GLFWkeyfun = Void Function(Pointer<GLFWwindow>, Int32, Int32, Int32, Int32);