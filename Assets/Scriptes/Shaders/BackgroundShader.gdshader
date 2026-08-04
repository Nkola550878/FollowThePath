shader_type canvas_item;
uniform float bias : hint_range(0.00, 1.00, 0.10);
uniform float number = 7;

void vertex() 
{
	// Called for every vertex the material is visible on.
}

void fragment() 
{
	COLOR.rgb = vec3(0, COLOR.g, 0) * bias + vec3(0, 1, 0) * (1.0 - bias);
	
	vec2 position = UV * number;
	if (pow(position.x - round(position.x), 2) < 0.001 || pow(position.y - round(position.y), 2) < 0.001)
	{
		COLOR.rgb = vec3(1, 1, 1);
	}
}