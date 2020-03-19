/// Main functions and definitions needed to use glfw3

import 'dart:ffi';
import 'signatures.dart';
import 'callbacks.dart';
import 'structs.dart';

class GLFW
{
  int Function() _glfwInit;
  void Function() _glfwTerminate;
  Pointer<NativeFunction<GLFWerrorfun>> Function(
    Pointer<NativeFunction<GLFWerrorfun>>
  ) _glfwSetErrorCallback;
  void Function(int, int) _glfwWindowHint;
  Pointer<GLFWwindow> Function(
    int, int, Pointer<Uint8>,
    Pointer<GLFWmonitor>,
    Pointer<GLFWwindow>
  ) _glfwCreateWindow;
  void Function(Pointer<GLFWwindow>) _glfwMakeContextCurrent;
  int Function(Pointer<GLFWwindow>) _glfwWindowShouldClose;
  void Function(int) _glfwSwapInterval;
  void Function(Pointer<GLFWwindow>) _glfwSwapBuffers;
  void Function(
    Pointer<GLFWwindow>,
    Pointer<Int32>, Pointer<Int32>
  ) _glfwGetFramebufferSize;
  void Function() _glfwPollEvents;
  Pointer<NativeFunction<GLFWkeyfun>> Function(
    Pointer<GLFWwindow>,
    Pointer<NativeFunction<GLFWkeyfun>>
  ) _glfwSetKeyCallback;
  void Function(
    Pointer<GLFWwindow>,
    int
  ) _glfwSetWindowShouldClose;
  void Function(Pointer<GLFWwindow>) _glfwDestroyWindow;
  double Function() _glfwGetTime;

  GLFW(DynamicLibrary dynamicLibrary) {
    _glfwInit = dynamicLibrary
      .lookup<NativeFunction<glfwInit_nt>>('glfwInit')
      .asFunction();
    _glfwTerminate = dynamicLibrary
      .lookup<NativeFunction<glfwTerminate_nt>>('glfwTerminate')
      .asFunction();
    _glfwSetErrorCallback = dynamicLibrary
      .lookup<NativeFunction<glfwSetErrorCallback_nt>>('glfwSetErrorCallback')
      .asFunction();
    _glfwWindowHint = dynamicLibrary
      .lookup<NativeFunction<glfwWindowHint_nt>>('glfwWindowHint')
      .asFunction();
    _glfwCreateWindow = dynamicLibrary
      .lookup<NativeFunction<glfwCreateWindow_nt>>('glfwCreateWindow')
      .asFunction();
    _glfwMakeContextCurrent = dynamicLibrary
      .lookup<NativeFunction<glfwMakeContextCurrent_nt>>('glfwMakeContextCurrent')
      .asFunction();
    _glfwWindowShouldClose = dynamicLibrary
      .lookup<NativeFunction<glfwWindowShouldClose_nt>>('glfwWindowShouldClose')
      .asFunction();
    _glfwSwapBuffers = dynamicLibrary
      .lookup<NativeFunction<glfwSwapBuffers_nt>>('glfwSwapBuffers')
      .asFunction();
    _glfwSwapInterval = dynamicLibrary
      .lookup<NativeFunction<glfwSwapInterval_nt>>('glfwSwapInterval')
      .asFunction();
    _glfwGetFramebufferSize = dynamicLibrary
      .lookup<NativeFunction<glfwGetFramebufferSize_nt>>('glfwGetFramebufferSize')
      .asFunction();
    _glfwPollEvents = dynamicLibrary
      .lookup<NativeFunction<glfwPollEvents_nt>>('glfwPollEvents')
      .asFunction();
    _glfwSetKeyCallback = dynamicLibrary
      .lookup<NativeFunction<glfwSetKeyCallback_nt>>('glfwSetKeyCallback')
      .asFunction();
    _glfwSetWindowShouldClose = dynamicLibrary
      .lookup<NativeFunction<glfwSetWindowShouldClose_nt>>('glfwSetWindowShouldClose')
      .asFunction();
    _glfwDestroyWindow = dynamicLibrary
      .lookup<NativeFunction<glfwDestroyWindow_nt>>('glfwDestroyWindow')
      .asFunction();
    _glfwGetTime = dynamicLibrary
      .lookup<NativeFunction<glfwGetTime_nt>>('glfwGetTime')
      .asFunction();
  }

  /// Initializes the GLFW library
  /// 
  /// If this function fails, it calls [glfwTerminate] before returning.  If it
  /// succeeds, you should call [glfwTerminate] before the application exits.
  /// 
  /// Additional calls to this function after successful initialization but before
  /// termination will return GLFW_TRUE immediately.
  /// 
  /// Returns GLFW_TRUE if successful, or GLFW_FALSE if an error occured.
  /// 
  /// Note: This function must only be called from the main thread.
  int Init() => _glfwInit();

  /// Terminates the GLFW library.
  /// 
  /// If GLFW has been successfully initialized, this function should be called
  /// before the application exits. If initialization fails, there is no need to
  /// call this function, as it is called by [glfwInit] before it returns
  /// failure.
  /// 
  /// Warning: The contexts of any remaining windows must not be current on any
  ///          other thread when this function is called.
  /// 
  /// Note: This function must only be called from the main thread.
  void Terminate() => _glfwTerminate();

  /// Sets the error callback.
  /// 
  /// [callback]: The new callback, or `NULL` to remove the currently set
  ///             callback.
  /// Returns the previously set callback, or `NULL` if no callback was set.
  /// 
  /// Note: This function must only be called from the main thread.
  Pointer<NativeFunction<GLFWerrorfun>> SetErrorCallback(
    Pointer<NativeFunction<GLFWerrorfun>> callback
  ) => _glfwSetErrorCallback(callback);

  /// Sets the specified window hint to the desired value.
  /// 
  /// [hint]  : The window hint to set.
  /// [value] : The new value of the window hint.
  /// 
  /// Note: This function must only be called from the main thread.
  void WindowHint(int hint, int value) => _glfwWindowHint(hint, value);

  /// Creates a window and its associated context.
  /// 
  /// [width]  : The desired width, in screen coordinates, of the window.
  ///            This must be greater than zero.
  /// [height] : The desired height, in screen coordinates, of the window.
  ///            This must be greater than zero.
  /// [title]  : The initial, UTF-8 encoded window title.
  /// [monitor]: The monitor to use for full screen mode, or `NULL` for
  ///            windowed mode.
  /// [share]  : The window whose context to share resources with, or `NULL`
  ///            to not share resources.
  /// Returns the handle of the created window, or `NULL` if an
  /// error occurred.
  /// 
  /// Note: This function must only be called from the main thread.
  Pointer<GLFWwindow> CreateWindow(
    int width, int height, Pointer<Uint8> title,
    Pointer<GLFWmonitor> monitor,
    Pointer<GLFWwindow> share
  ) => _glfwCreateWindow(width, height, title, monitor, share);

  /// Makes the context of the specified window current for the calling
  /// thread.
  /// 
  /// [window]: The window whose context to make current, or `NULL` to
  /// detach the current context.
  /// 
  /// Note: This function may be called from any thread.
  void MakeContextCurrent(Pointer<GLFWwindow> window) => _glfwMakeContextCurrent(window);

  /// Checks the close flag of the specified window.
  ///
  /// [window]: The window to query.
  /// 
  /// Returns the value of the close flag.
  /// 
  /// Note: This function may be called from any thread.  Access is not
  ///       synchronized.
  int WindowShouldClose(Pointer<GLFWwindow> window) => _glfwWindowShouldClose(window);
  
  /// Sets the swap interval for the current context.
  /// 
  /// [interval]: The minimum number of screen updates to wait for
  /// until the buffers are swapped by glfwSwapBuffers.
  /// 
  /// Note: This function may be called from any thread.
  void SwapInterval(int interval) => _glfwSwapInterval(interval);

  /// Swaps the front and back buffers of the specified window.
  ///
  /// [window]: The window whose buffers to swap.
  /// 
  /// Note: This function may be called from any thread.
  void SwapBuffers(Pointer<GLFWwindow> window) => _glfwSwapBuffers(window);
  
  /// Retrieves the size of the framebuffer of the specified window.
  /// 
  /// [window] : The window whose framebuffer to query.
  /// [width]  : Where to store the width, in pixels, of the framebuffer,
  ///            or `NULL`.
  /// [height] : Where to store the height, in pixels, of the framebuffer,
  ///            or `NULL`.
  void GetFramebufferSize(
    Pointer<GLFWwindow> window,
    Pointer<Int32> width, Pointer<Int32> height
  ) => _glfwGetFramebufferSize(window, width, height);

  /// Processes all pending events.
  void PollEvents() => _glfwPollEvents();

  /// Sets the key callback.
  /// 
  /// [window]   : The window whose callback to set.
  /// [callback] : The new key callback, or `NULL` to remove the currently
  ///              set callback.
  /// Returns the previously set callback, or `NULL` if no callback was set or the
  ///         library had not been [initialized](@ref intro_init).
  /// 
  /// Note: This function must only be called from the main thread.
  Pointer<NativeFunction<GLFWkeyfun>> SetKeyCallback(
    Pointer<GLFWwindow> window,
    Pointer<NativeFunction<GLFWkeyfun>> callback
  ) => _glfwSetKeyCallback(window, callback);

  /// Sets the close flag of the specified window.
  /// 
  /// [window] : The window whose flag to change.
  /// [value]  : The new value.
  void SetWindowShouldClose(
    Pointer<GLFWwindow> window,
    int value
  ) => _glfwSetWindowShouldClose(window, value);

  /// Destroys the specified window and its context.
  /// 
  /// [window] : The window to destroy.
  /// 
  /// Note: This function must only be called from the main thread.
  void DestroyWindow(Pointer<GLFWwindow> window) => _glfwDestroyWindow(window);

  /// Returns the current GLFW time, in seconds.
  /// 
  /// Unless the time has been set using [glfwSetTime] it measures
  /// time elapsed since GLFW was initialized.
  /// 
  /// Returns : The current time, in seconds, or zero if an
  ///           error occurred.
  double GetTime() => _glfwGetTime();
}