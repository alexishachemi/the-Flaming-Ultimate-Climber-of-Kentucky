shader_type canvas_item;

uniform sampler2D noise_tex;
uniform sampler2D gradient_tex;
uniform sampler2D original_tex;

uniform vec4 brighter_color : source_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform vec4 middle_color : source_color = vec4(1.0, 0.56, 0.0, 1.0);
uniform vec4 darker_color : source_color = vec4(0.64, 0.2, 0.05, 1.0);

uniform float spread : hint_range(0.0, 1.0) = 0.5;
uniform float wobble_strength = 0.02;

void fragment() {
    vec2 wobble = vec2(sin(TIME * 1.5 + UV.y * 3.0), sin(TIME * 1.5 + UV.x * 3.0)) * wobble_strength;
    vec2 uv = UV + wobble;

    vec2 noise_uv = fract(uv + vec2(0.0, TIME * 0.1));
    float noise_value = texture(noise_tex, noise_uv).r;
    float gradient_value = texture(gradient_tex, uv.yx).r;

    gradient_value -= smoothstep(spread, spread + 0.5, length(uv + vec2(-0.5, -0.5)) / spread);

    float step1 = step(noise_value, gradient_value);
    float step2 = step(noise_value, gradient_value - 0.2);
    float step3 = step(noise_value, gradient_value - 0.4);

    vec3 bd_color = mix(brighter_color.rgb, darker_color.rgb, step1 - step2);
    vec3 final_color = mix(bd_color, middle_color.rgb, step2 - step3);

    vec4 original_color = texture(original_tex, uv);

    float visibility = step1 * (1.0 - step3);
    vec3 average_color = (original_color.rgb + final_color * visibility) / 2.0;

    COLOR = vec4(average_color, original_color.a * visibility);
}
