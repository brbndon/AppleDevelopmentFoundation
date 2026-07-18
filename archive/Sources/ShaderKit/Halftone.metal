#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 halftone(float2 position, SwiftUI::Layer layer, float2 size, float dotSize, float progress) {
    if (size.x == 0 || size.y == 0 || dotSize <= 0) { return layer.sample(position); }
    float2 cell = floor(position / dotSize);
    float2 cellCenter = (cell + 0.5) * dotSize;
    half4 source = layer.sample(cellCenter);
    float luma = dot(float3(source.rgb), float3(0.2126, 0.7152, 0.0722));
    float2 offset = (position - cellCenter) / (dotSize * 0.5);
    float distanceFromCenter = length(offset);
    float dotRadius = (1.0 - luma) * 0.92;
    float inDot = 1.0 - smoothstep(dotRadius - 0.06, dotRadius + 0.06, distanceFromCenter);
    half4 ink = half4(0.04, 0.04, 0.08, source.a);
    half4 paper = half4(0.96, 0.94, 0.89, source.a);
    half4 halftoneColor = mix(paper, ink, half(inDot));
    return mix(source, halftoneColor, half(progress));
}
