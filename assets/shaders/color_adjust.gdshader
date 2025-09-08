shader_type canvas_item;
uniform float sat:hint_range(0,1,0.01) = 1.0;
uniform float contrast:hint_range(0,1,0.01) = 1.0;
uniform float brightness:hint_range(0,1,0.01) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);
	vec3 average = vec3(0.5,0.5,0.5);
	vec3 bright_color = COLOR.rgb * brightness;
	vec3 instensity = vec3(dot(bright_color,LumCoeff));
	vec3 sat_color = mix(instensity,bright_color,sat);
	vec3 conCol = mix(average,sat_color,contrast);
	COLOR.rgb = conCol;

	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
