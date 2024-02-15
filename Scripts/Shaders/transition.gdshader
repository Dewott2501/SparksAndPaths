shader_type canvas_item;

// Ranges from 0 to 1 over the course of the transition.
// We use this to actually animate the shader.
uniform bool enable = true;
uniform float progress : hint_range(0, 1);

// Size of each diamond, in pixels.
uniform float PixelSize = 10.0;

uniform vec3 color;

void fragment() {
	if(enable){
	float xFraction = fract(FRAGCOORD.x / PixelSize - (progress));
	float yFraction = fract(FRAGCOORD.y / PixelSize - (progress));
	float xDistance = floor((xFraction - UV.x) + progress * 2.0);
	float yDistance = floor((yFraction - UV.x) + progress * 2.0);
	if ((xDistance + yDistance) > progress) {
		COLOR = vec4(color.x, color.y, color.z, ((progress * -1.0) + 1.0));
	}
	else{COLOR = vec4(color.x, color.y, color.z, 1.0);}
	}else{
		COLOR.a = 0.0;
	}
}