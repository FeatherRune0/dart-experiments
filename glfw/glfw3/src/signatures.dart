/// Contains all the function signatures

import 'dart:ffi';
import 'callbacks.dart';
import 'structs.dart';

// GLFWAPI int glfwInit(void);
typedef glfwInit_nt = Int32 Function();

// GLFWAPI void glfwTerminate(void);
typedef glfwTerminate_nt = Void Function();

// GLFWAPI GLFWerrorfun glfwSetErrorCallback(GLFWerrorfun callback);
typedef glfwSetErrorCallback_nt = Pointer<NativeFunction<GLFWerrorfun>> Function(Pointer<NativeFunction<GLFWerrorfun>>);

// GLFWAPI void glfwWindowHint(int hint, int value);
typedef glfwWindowHint_nt = Void Function(Int32, Int32);

// GLFWAPI GLFWwindow* glfwCreateWindow(int width, int height, const char* title, GLFWmonitor* monitor, GLFWwindow* share);
typedef glfwCreateWindow_nt = Pointer<GLFWwindow> Function(
  Int32, Int32, Pointer<Uint8>, 
  Pointer<GLFWmonitor>, Pointer<GLFWwindow>
);

// GLFWAPI void glfwMakeContextCurrent(GLFWwindow* window);
typedef glfwMakeContextCurrent_nt = Void Function(Pointer<GLFWwindow>);

// GLFWAPI int glfwWindowShouldClose(GLFWwindow* window);
typedef glfwWindowShouldClose_nt = Int32 Function(Pointer<GLFWwindow>);

// GLFWAPI void glfwSwapInterval(int interval);
typedef glfwSwapInterval_nt = Void Function(Int32);

// GLFWAPI void glfwSwapBuffers(GLFWwindow* window);
typedef glfwSwapBuffers_nt = Void Function(Pointer<GLFWwindow>);

// GLFWAPI void glfwGetFramebufferSize(GLFWwindow* window, int* width, int* height);
typedef glfwGetFramebufferSize_nt = Void Function(Pointer<GLFWwindow>, Pointer<Int32>, Pointer<Int32>);

// GLFWAPI void glfwPollEvents(void);
typedef glfwPollEvents_nt = Void Function();

// GLFWAPI GLFWkeyfun glfwSetKeyCallback(GLFWwindow* window, GLFWkeyfun callback);
typedef glfwSetKeyCallback_nt = Pointer<NativeFunction<GLFWkeyfun>> Function(
  Pointer<GLFWwindow>,
  Pointer<NativeFunction<GLFWkeyfun>>
);

// GLFWAPI void glfwSetWindowShouldClose(GLFWwindow* window, int value);
typedef glfwSetWindowShouldClose_nt = Void Function(
  Pointer<GLFWwindow>,
  Int32
);

// GLFWAPI void glfwDestroyWindow(GLFWwindow* window);
typedef glfwDestroyWindow_nt = Void Function(Pointer<GLFWwindow>);

// GLFWAPI double glfwGetTime(void);
typedef glfwGetTime_nt = Double Function();