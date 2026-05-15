#version 460

layout(location = 0) in vec3 fragColor;
layout(location = 0) out vec4 outColor;

void main() {
    // Soft circular particles instead of harsh squares
    vec2 coord = gl_PointCoord - vec2(0.5);
    if(length(coord) > 0.5) discard;

    // Apply the depth gradient
    outColor = vec4(fragColor, 0.8);
}
