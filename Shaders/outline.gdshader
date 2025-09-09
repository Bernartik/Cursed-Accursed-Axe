shader_type canvas_item;

uniform int width : hint_range(0, 5, 1);
uniform vec4 outline_color : source_color;

void fragment() {
	vec2 pixel_size = vec2(	1.0/float(textureSize(TEXTURE,0).x),
							1.0/float(textureSize(TEXTURE,0).y));
	if (texture(TEXTURE, UV).a == 0.0)
	{
		for(int x = -width; x <= width; x++)
		{
			for(int y = -width; y <= width; y++)
			{
				if (abs(x) != abs(y)) {
					vec2 pixel_offset = vec2(float(x),float(y));
					if(texture(TEXTURE, UV+(pixel_offset*pixel_size)).a > 0.0) {
						COLOR = outline_color;
					}
				}
			}
		}
	}
}