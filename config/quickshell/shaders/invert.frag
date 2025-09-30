#version 440

layout(binding = 0) uniform sampler2D source;
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

void main()
{
    vec4 color = texture(source, qt_TexCoord0);
    fragColor = vec4(1.0 - color.rgb, color.a);
}
