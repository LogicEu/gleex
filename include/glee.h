#ifndef GLEE_GRAPHICS_H
#define GLEE_GRAPHICS_H

#ifdef __cplusplus
extern "C" {
#endif

#ifndef __APPLE__
    #include <GL/glew.h>
#else
    #define GL_SILENCE_DEPRECATION
    #define GLFW_INCLUDE_GLCOREARB
#endif

#include <GLFW/glfw3.h>

/*

======================================================

>>>>>>>>>>>>>>  GLEE OPENGL FRAMEWORK   >>>>>>>>>>>>>>

Simple wrap around glfw3 and glew, ment to be platform
independent and easy to use.

============================================  @eulogic

*/

#define GLEE_MODE_2D 0
#define GLEE_MODE_3D 1
#define GLEE_MODE_FULL 2

// ...

void glee_init();
void glee_deinit();
void glee_mode_set();

GLFWwindow* glee_window_get();
void glee_window_create(const char* title, int width, int height, unsigned int fullscreen, unsigned int resizable);
void glee_window_set_size(int width, int height);
void glee_window_get_size(int* width, int* height);
void glee_window_get_framebuffer_size(int* width, int* height);
void glee_window_set_position(int x, int y);
void glee_window_get_position(int* x, int* y);
unsigned int glee_window_is_open();

void glee_screen_color(float r, float g, float b, float a);
void glee_screen_clear(int mode);
void glee_screen_refresh();

char* glee_shader_file_read(const char* path);
char* glee_shader_parse(const char* path);
void glee_shader_compile(const GLchar* buffer, unsigned int shader);
void glee_shader_link(GLuint shader, unsigned int vshader, unsigned int fshader);
void glee_shader_link_geometry(GLuint shader, unsigned int vshader, unsigned int gshader, unsigned int fshader);
unsigned int glee_shader_load(const char *vpath, const char *fpath);
unsigned int glee_shader_load_geometry(const char *vpath, const char *gpath, const char *fpath);
void glee_shader_uniform_set(unsigned int shader, unsigned int float_count, const char* uniform, float* data);

unsigned int glee_buffer_id();
void glee_buffer_attribute_set(unsigned int attribute, unsigned int float_pack, unsigned int stride, size_t offset);
void glee_buffer_create(unsigned int id, void* buffer, unsigned int size);
void glee_buffer_create_indexed(unsigned int id, void* buffer, unsigned int buffer_size, unsigned int* indices, unsigned int indices_size);
unsigned int glee_buffer_quad_create();
unsigned int glee_buffer_voxel_create();
unsigned int glee_buffer_skybox_create();
void glee_buffer_voxel_texcoords(unsigned int id);

char* glee_file_read(const char* path);
unsigned int glee_window_file_check();
char* glee_window_file_get();

float glee_time_get();
float glee_time_delta(float* last_time);

void glee_mouse_pos(float* x, float* y);
void glee_mouse_pos_3d(float* x, float* y);
unsigned int glee_mouse_down(unsigned int button);
unsigned int glee_mouse_pressed(unsigned int button);
unsigned int glee_mouse_released(unsigned int button);
void glee_mouse_mode(unsigned int mouse_lock);

unsigned int glee_key_down(unsigned int k);
unsigned int glee_key_pressed(unsigned int k);
unsigned int glee_key_released(unsigned int k);
char glee_key_char();

#ifdef __cplusplus
}
#endif
#endif
