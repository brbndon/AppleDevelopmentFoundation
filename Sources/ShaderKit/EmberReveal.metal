#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float hashTwo(float2 p) {
    return fract(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
}

float valueNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float bottom = mix(hashTwo(i), hashTwo(i + float2(1, 0)), f.x);
    float top = mix(hashTwo(i + float2(0, 1)), hashTwo(i + float2(1, 1)), f.x);
    return mix(bottom, top, f.y);
}

[[ stitchable ]] half4 emberReveal(float2 position, SwiftUI::Layer layer, float progress, float2 size) {
    if (size.x == 0 || size.y == 0) { return layer.sample(position); }
    float2 uv = position / size;
    float noiseValue = valueNoise(uv * 10.0);
    float dist = distance(uv, float2(0.5, 0.5));
    float threshold = progress * 1.5 - dist + noiseValue * 0.2;
    half4 color = layer.sample(position);
    if (threshold < 0.0) { return half4(0, 0, 0, 0); }
    if (threshold < 0.15) { return color + half4(1.0, 0.5, 0.0, 1.0); }
    return color;
}
