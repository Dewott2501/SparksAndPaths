shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

void fragment() {
	vec4 bg = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR.rgb = vec3(circle(UV, 0.7, -0.4) );
	float avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
	float abg = (bg.r + bg.g + bg.b) / 6.0;
	COLOR.a -= avg;
	COLOR.rgb = vec3(abg - 0.6, abg - 0.6, bg.b  - 0.8);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
