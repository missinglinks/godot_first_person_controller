shader_type canvas_item;

uniform float amount : hint_range(0,10);
void fragment() {
	vec4 c = texture(SCREEN_TEXTURE, SCREEN_UV);
	
    COLOR.rgb = (textureLod(SCREEN_TEXTURE,SCREEN_UV,amount).rgb - c.rgb) * 5.0;
}