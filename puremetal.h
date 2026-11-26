#pragma once
#ifdef __cplusplus
extern "C" {
#endif

// Returns 1 on success, 0 on failure.
// `caMetalLayer` is a CAMetalLayer* (pass it as void*).
int pm_init(void *caMetalLayer);
void pm_resize(int width, int height);
// Clears the drawable to the given colour and presents it.
int pm_present_clear(float r, float g, float b, float a);
const char *pm_device_name(void);
int pm_version(void);
void pm_shutdown(void);

#ifdef __cplusplus
}
#endif
