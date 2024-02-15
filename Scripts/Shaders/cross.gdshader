shader_type canvas_item;
render_mode blend_mix;

uniform vec3 color1;
uniform vec3 color2;
void fragment() {
	vec4 nColor = texture(TEXTURE, UV);
	// Called for every pixel the material is visible on.
	if(UV.y > UV.x && UV.x < UV.y){
		COLOR.rgb = nColor.rgb * color1;
		COLOR.a = nColor.a;
	}else{
		COLOR.rgb = nColor.rgb * color2;
		COLOR.a = nColor.a;
	}
}