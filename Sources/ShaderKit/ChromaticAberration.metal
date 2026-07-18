#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 chromaticAberration(float2 position, SwiftUI::Layer layer, float2 size, float strength, float time) {
    if (size.x == 0 || size.y == 0) { return layer.sample(position); }
    float2 uv = position / size;
    float2 direction = uv - float2(0.5, 0.5);
    float dist = length(direction);
    float pulse = 1.0 + 0.25 * sin(time * 2.4);
    float scale = strength * pulse;
    float2 rOffset = direction * dist * scale;
    float2 bOffset = direction * dist * scale * -1.2;
    float r = layer.sample(position + rOffset).r;
    float g = layer.sample(position).g;
    float b = layer.sample(position + bOffset).b;
    float a = layer.sample(position).a;
    float fringeMask = smoothstep(0.3, 0.7, dist);
    r += fringeMask * 0.06 * pulse;
    b += fringeMask * 0.04 * pulse;
    return half4(half(r), half(g), half(b), half(a));
}
