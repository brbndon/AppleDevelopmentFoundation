#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] float2 waveRipple(float2 position, float2 size, float2 touchPoint, float time, float progress) {
    if (size.x == 0 || size.y == 0) { return position; }
    float2 uv = position / size;
    float2 touchUV = touchPoint / size;
    float2 delta = uv - touchUV;
    float dist = length(delta);
    float waveFront = progress * 1.4;
    float envelope = exp(-pow((dist - waveFront) * 12.0, 2.0));
    float2 direction = dist > 0.001 ? normalize(delta) : float2(0.0, 1.0);
    float displacement = sin(dist * 28.0 - time * 22.0) * 0.018 * envelope * (1.0 - progress);
    return (uv + direction * displacement) * size;
}
