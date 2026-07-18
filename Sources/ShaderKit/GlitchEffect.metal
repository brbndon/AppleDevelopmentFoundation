#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float glitchHash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

[[ stitchable ]] half4 glitchEffect(float2 position, SwiftUI::Layer layer, float2 size, float time, float intensity) {
    if (size.x == 0 || size.y == 0) { return layer.sample(position); }
    float2 uv = position / size;
    float tick = floor(time * 14.0);
    float band = floor(uv.y / 0.06);
    float n1 = glitchHash(float2(band, tick));
    float n2 = glitchHash(float2(band * 0.5 + 7.3, tick + 1.0));
    float threshold = 1.0 - clamp(intensity * 0.45, 0.0, 0.45);
    float active = step(threshold, n1);
    float bandShift = (n2 * 2.0 - 1.0) * 0.07 * intensity * active;
    float rgbSplit = 0.012 * intensity * active;
    float2 uvR = float2(fract(uv.x + bandShift + rgbSplit), uv.y);
    float2 uvG = float2(fract(uv.x + bandShift), uv.y);
    float2 uvB = float2(fract(uv.x + bandShift - rgbSplit), uv.y);
    float r = layer.sample(uvR * size).r;
    float g = layer.sample(uvG * size).g;
    float b = layer.sample(uvB * size).b;
    float a = layer.sample(uvG * size).a;
    float flashBand = floor(uv.y / 0.02);
    float flash = step(0.96, glitchHash(float2(flashBand, floor(time * 20.0)))) * active;
    float bright = flash * 0.35 * intensity;
    float grain = (glitchHash(uv * size) - 0.5) * 0.06 * intensity * active;
    return half4(half(clamp(r + bright + grain, 0.0, 1.0)), half(clamp(g + bright + grain, 0.0, 1.0)), half(clamp(b + bright, 0.0, 1.0)), half(a));
}
