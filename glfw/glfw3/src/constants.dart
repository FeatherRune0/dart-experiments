/// Constants as defined in glfw3.h

int GLFW_TRUE = 1;
int GLFW_FALSE = 0;

// Context hints
/// Context client API major version hint and attribute.
int GLFW_CONTEXT_VERSION_MAJOR = 0x00022002;
/// Context client API minor version hint and attribute.
int GLFW_CONTEXT_VERSION_MINOR = 0x00022003;

// Window hints
/// Input focus window hint and attribute
int GLFW_FOCUSED = 0x00020001;
/// Window iconification window attribute
int GLFW_ICONIFIED = 0x00020002;
/// Window resize-ability window hint and attribute
int GLFW_RESIZABLE = 0x00020003;
/// Window visibility window hint and attribute
int GLFW_VISIBLE = 0x00020004;
/// Window decoration window hint and attribute
int GLFW_DECORATED = 0x00020005;
/// Window auto-iconification window hint and attribute
int GLFW_AUTO_ICONIFY = 0x00020006;
/// Window decoration window hint and attribute
int GLFW_FLOATING = 0x00020007;
/// Window maximization window hint and attribute
int  GLFW_MAXIMIZED = 0x00020008;
/// Cursor centering window hint
int GLFW_CENTER_CURSOR = 0x00020009;
/// Window framebuffer transparency hint and attribute
int GLFW_TRANSPARENT_FRAMEBUFFER = 0x0002000A;
/// Mouse cursor hover window attribute.
int GLFW_HOVERED = 0x0002000B;
/// Input focus on calling show window hint and attribute
int GLFW_FOCUS_ON_SHOW = 0x0002000C;

// Key constants
int GLFW_KEY_ESCAPE = 256;

// Key and button activities
int GLFW_RELEASE = 0;
int GLFW_PRESS = 1;
int GLFW_REPEAT = 2;