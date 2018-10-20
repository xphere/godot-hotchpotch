shader_type canvas_item;
render_mode unshaded;

uniform vec2 repeat = vec2(1.0, 1.0);
uniform float cutoff : hint_range(0.0, 1.0) = 1.0;
uniform float delta_cutoff : hint_range(0.0, 1.0) = 0.05;
uniform sampler2D mask : hint_albedo;
uniform bool inverted = false;

void fragment() {
	float mask_value = texture(mask, UV * repeat).r;
	float alpha = smoothstep(cutoff + delta_cutoff, cutoff, mask_value * (1.0 - delta_cutoff) + delta_cutoff);
	COLOR = vec4(texture(TEXTURE, UV).rgb, inverted ? 1.0 - alpha : alpha);
}
