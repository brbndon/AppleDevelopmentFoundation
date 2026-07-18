#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 pixelSnap(float2 position, SwiftUI::Layer layer, float progress, float2 size) {
    float p = 1.0 - progress;
    float pxSize = 1.0 + p * p * 50.0;
    float2 blockPos = floor(position / pxSize) * pxSize;
    half4 color = layer.sample(blockPos + pxSize / 2.0);
    return color * progress;
}
