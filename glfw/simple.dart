/// recreation of https://www.glfw.org/docs/3.3/quick_guide.html

import 'glfw3/glfw3.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:gl_dart/gl.dart';
import 'dart:io';
import 'dart:math';

// global so we can call glfw functions from callbacks
GLFW glfw;

void error_callback(int error, Pointer<Uint8> description) {
  print("Error: 0x${error.toRadixString(16).padLeft(8, '0')}");
  Pointer<Utf8> description_utf8 = description.cast();
  print(Utf8.fromUtf8(description_utf8));
}

void key_callback(
  Pointer<GLFWwindow> window,
  int key, int scancode, int action, int mods
) {
  if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
    glfw.SetWindowShouldClose(window, GLFW_TRUE);
  }
}

main() {
  var glfw_path = '/usr/lib/libglfw.so';
  var glfw_file = File(glfw_path);
  if (!glfw_file.existsSync()) {
    print("GLFW library not found at ${glfw_path}");
    print("Edit the value of glfw_path in main() and try again");
    return;
  }
  final dynamicLibrary = DynamicLibrary.open(glfw_path);
  glfw = new GLFW(dynamicLibrary);

  glfw.SetErrorCallback(Pointer.fromFunction(error_callback));

  if (glfw.Init() == GLFW_FALSE) {
    print("Failed to initialize GLFW!");
    return;
  }

  // Necessary for running on wayland
  // https://github.com/glfw/glfw/issues/1121#issuecomment-345111777
  glfw.WindowHint(GLFW_FOCUSED, GLFW_FALSE);
  glfw.WindowHint(GLFW_CONTEXT_VERSION_MAJOR, 2);
  glfw.WindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);

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

  glfw.SetKeyCallback(window, Pointer.fromFunction(key_callback));

  glfw.MakeContextCurrent(window);
  var libGL = File("/usr/lib/libGL.so");
  if (libGL.existsSync()) {
    gl = Gl(
      customPath: "/usr/lib/libGL.so",
      version: GlVersion.GL_VERSION_2_1
    );
  } else {
    gl = Gl(version: GlVersion.GL_VERSION_2_1);
  }
  glfw.SwapInterval(1);
  
  Pointer<Int32> width = allocate();
  Pointer<Int32> height = allocate();
  gl.matrixMode(GL_PROJECTION);
  gl.ortho(0, 640, 480, 0, -1, 1);
  double theta = 0.0, theta_rate = 0.01;
  while (glfw.WindowShouldClose(window) != GLFW_TRUE) {
    glfw.GetFramebufferSize(window, width, height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(GL_COLOR_BUFFER_BIT);

    var px = 200, py = 200;
    var cx = width.value / 2;
    var cy = height.value / 2;

    theta = theta + theta_rate;
    if (theta >= (2.0 * pi)) 
      theta = theta - (2.0 * pi);
    var xf = cx + ((px - cx) * cos(theta)) 
      - ((py - cy) * sin(theta)); 
    var yf = cy + ((px - cx) * sin(theta)) 
      + ((py - cy) * cos(theta)); 

    // draw center point
    gl.pointSize(2.0);
    gl.color3f(1.0, 0.0, 0.0); 
    gl.begin(GL_POINTS); 
    gl.vertex2f(cx, cy); 
    gl.end(); 

    // draw rotating point
    gl.pointSize(3.0); 
    gl.color3f(0.0, 1.0, 0.0); 
    gl.begin(GL_POINTS); 
    gl.vertex2f(xf, yf); 
    gl.end(); 

    gl.flush();
    glfw.SwapBuffers(window);
    glfw.PollEvents();
  }

  glfw.DestroyWindow(window);

  glfw.Terminate();
}
