#version 460

layout(std430, binding = 0) readonly buffer MegaBuffer {
    float data[];
};

layout(push_constant) uniform PushConstants {
    layout(offset = 0)  mat4 viewProj;
    layout(offset = 64) uint pos_x_idx;
    layout(offset = 68) uint pos_y_idx;
    layout(offset = 72) uint pos_z_idx;
    layout(offset = 76) uint particle_count;
    layout(offset = 80) float dt;
} pc;

layout(location = 0) out vec3 fragColor; // Changed to vec3

void main() {
    uint id = gl_VertexIndex;
    if (id >= pc.particle_count) {
        gl_Position = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }

    float x = data[pc.pos_x_idx + id];
    float y = data[pc.pos_y_idx + id];
    float z = data[pc.pos_z_idx + id];

    gl_Position = pc.viewProj * vec4(x, y, z, 1.0);
    
    // Closer particles get larger
    gl_PointSize = clamp(1000.0 / gl_Position.w, 1.0, 4.0);

    // Calculate depth intensity for the fragment shader (Cyberpunk gradient)
    float depth = clamp((z + 10000.0) / 20000.0, 0.0, 1.0);
    fragColor = mix(vec3(0.0, 0.8, 1.0), vec3(1.0, 0.0, 0.8), depth);
}
