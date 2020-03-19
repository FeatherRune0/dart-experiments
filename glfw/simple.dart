/// recreation of https://www.glfw.org/docs/3.3/quick_guide.html

import 'glfw3/glfw3.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

void error_callback(int error, Pointer<Uint8> description) {
  print("Error: 0x${error.toRadixString(16).padLeft(8, '0')}");
  Pointer<Utf8> description_utf8 = description.cast();
  print(Utf8.fromUtf8(description_utf8));
}

main() {
  var glfw_path = '/usr/lib/libglfw.so';
  final dynamicLibrary = DynamicLibrary.open(glfw_path);
  GLFW glfw = new GLFW(dynamicLibrary);

  glfw.SetErrorCallback(Pointer.fromFunction(error_callback));

  if (glfw.Init() == GLFW_FALSE) {
    print("Failed to initialize GLFW!");
    return;
  }

  // Necessary for running on wayland
  // https://github.com/glfw/glfw/issues/1121#issuecomment-345111777
  glfw.WindowHint(GLFW_FOCUSED, GLFW_FALSE);

  Pointer<Utf8> title_utf8 = Utf8.toUtf8("Simple Window");
  Pointer<Uint8> title= title_utf8.cast();
  final window = glfw.CreateWindow(
    640, 480, 
    title,
    nullptr, nullptr
  );
  if (window == nullptr) {
    print("Failed to create window!");
    glfw.Terminate();
    return;
  }

  glfw.MakeContextCurrent(window);
  glfw.SwapInterval(1);
  
  Pointer<Int32> width = allocate();
  Pointer<Int32> height = allocate();
  while (glfw.WindowShouldClose(window) != GLFW_TRUE) {
    glfw.GetFramebufferSize(window, width, height);
    glfw.SwapBuffers(window);
    glfw.PollEvents();
  }

  glfw.Terminate();
}
