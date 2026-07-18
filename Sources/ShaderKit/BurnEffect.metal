#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float randomBurn(float2 st) {
    return fract(sin(dot(st, float2(12.9898, 78.233))) * 43758.5453123);
}

float noise(float2 st) {
    float2 i = floor(st);
    float2 f = fract(st);
    float a = randomBurn(i);
    float b = randomBurn(i + float2(1.0, 0.0));
    float c = randomBurn(i + float2(0.0, 1.0));
    float d = randomBurn(i + float2(1.0, 1.0));
    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbmBurn(float2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

[[ stitchable ]] half4 burnEffect(float2 position, SwiftUI::Layer layer, float2 size, float progress, float time) {
    if (size.x == 0 || size.y == 0) { return layer.sample(position); }
    float2 uv = position / size;
    float n = fbmBurn(uv * 8.0 + float2(0, time * 0.1));
    float burnPath = uv.y + n * 0.15;
    float threshold = (1.0 - progress) * 1.3 - 0.15;
    float dist = burnPath - threshold;
    if (dist < 0.0) { return half4(0, 0, 0, 0); }
    if (dist < 0.04) { return half4(1.0, 0.5, 0.0, 1); }
    if (dist < 0.08) { return half4(1.0, 0.9, 0.4, 1); }
    return layer.sample(position);
}
