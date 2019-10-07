shader_type canvas_item;

uniform vec4 col: hint_color;

void fragment() {
	float alpha = texture(SCREEN_TEXTURE, SCREEN_UV).a;
	COLOR = vec4(col.rgb, alpha);
}