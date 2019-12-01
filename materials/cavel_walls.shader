shader_type canvas_item;

void light()
{
	vec4 c = texture( TEXTURE, UV ).rgba;
	if( c.r > 0.5 || c.b > 0.5 )
	{
		//LIGHT *= 1.0;
		if( LIGHT.a > 0.3 )
		{
			LIGHT = LIGHT_COLOR;
		}
		else
		{
			LIGHT *= 0.0;
		}
	}
	else
	{
		LIGHT *= 0.0;
	}
	
}