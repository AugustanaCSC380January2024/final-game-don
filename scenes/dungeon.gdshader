shader_type canvas_item;

const float scale: hint_range(0.1, 10) = 2.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 distoredUV = UV;
	distoredUV.x += distoredUV.y * .2;
	
	vec4 pixelColor = texture(TEXTURE, UV * 2.0);
	COLOR = pixelColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
