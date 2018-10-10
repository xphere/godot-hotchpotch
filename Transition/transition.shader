shader_type canvas_item;

uniform sampler2D transition;
uniform vec2 repeat = vec2(1.0, -1.0);
uniform float value : hint_range(0.0, 1.0) = 0.5;
uniform float delta_smooth : hint_range(0.0, 1.0) = 0.05;

float mixer(vec2 uv) {
	float current = texture(transition, uv).r;
	float delta_amount = (1.0 - value) * delta_smooth;
	float mixed = (current - value + delta_amount) / delta_smooth;

	return 1.0 - clamp(mixed, 0.0, 1.0);
}

void fragment() {
	float mix_amount = mixer(SCREEN_UV * repeat);
	if (mix_amount == 0.0) {
		discard;
	}

	vec4 screen_pixel = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 texture_pixel = texture(TEXTURE, UV);
	COLOR.rgb = mix(screen_pixel, texture_pixel, mix_amount).rgb;
	COLOR.a = mix_amount;
}
