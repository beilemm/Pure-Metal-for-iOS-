// Pure Metal - iOS skeleton (Objective-C++).
// Exposes a small C API so a launcher / JNI bridge can drive it.
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#include <string.h>
#include "puremetal.h"

#define PM_EXPORT extern "C" __attribute__((visibility("default")))

namespace {
struct State {
    id<MTLDevice> device;
    id<MTLCommandQueue> queue;
    CAMetalLayer *layer;
    char deviceName[128];
};
State g;
}

PM_EXPORT int pm_version(void) { return 1; }

PM_EXPORT int pm_init(void *caMetalLayer) {
    @autoreleasepool {
        CAMetalLayer *layer = (__bridge CAMetalLayer *)caMetalLayer;
        if (!layer) {
            NSLog(@"Pure Metal: null layer");
            return 0;
        }
        id<MTLDevice> dev = MTLCreateSystemDefaultDevice();
        if (!dev) {
            NSLog(@"Pure Metal: no Metal device");
            return 0;
        }
        g.device = dev;
        g.queue = [dev newCommandQueue];
        layer.device = dev;
        layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
        layer.framebufferOnly = YES;
        g.layer = layer;
        strlcpy(g.deviceName, dev.name.UTF8String, sizeof(g.deviceName));
        NSLog(@"Pure Metal: initialised on %s", g.deviceName);
        return 1;
    }
}

PM_EXPORT void pm_resize(int width, int height) {
    if (g.layer && width > 0 && height > 0) {
        g.layer.drawableSize = CGSizeMake(width, height);
    }
}

PM_EXPORT int pm_present_clear(float r, float gr, float b, float a) {
    @autoreleasepool {
        if (!g.layer || !g.queue) return 0;
        id<CAMetalDrawable> drawable = [g.layer nextDrawable];
        if (!drawable) return 0;

        MTLRenderPassDescriptor *pass = [MTLRenderPassDescriptor renderPassDescriptor];
        pass.colorAttachments[0].texture = drawable.texture;
        pass.colorAttachments[0].loadAction = MTLLoadActionClear;
        pass.colorAttachments[0].storeAction = MTLStoreActionStore;
        pass.colorAttachments[0].clearColor = MTLClearColorMake(r, gr, b, a);

        id<MTLCommandBuffer> cb = [g.queue commandBuffer];
        id<MTLRenderCommandEncoder> enc = [cb renderCommandEncoderWithDescriptor:pass];
        [enc endEncoding];
        [cb presentDrawable:drawable];
        [cb commit];
        return 1;
    }
}

PM_EXPORT const char *pm_device_name(void) { return g.deviceName; }

PM_EXPORT void pm_shutdown(void) {
    g.layer = nil;
    g.queue = nil;
    g.device = nil;
    g.deviceName[0] = 0;
}
