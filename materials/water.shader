shader_type canvas_item;

void fragment()
{
	//vec2 uv = UV;
	//float r = TEXTURE_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.y;
	//vec2 suv = vec2( SCREEN_UV.x, 1.0-SCREEN_UV.y );
	
	//float mix_ratio = 0.5;
	//float vstretch = 1.0;
	
	// compute ration between the screen uv and the texture uv
	vec2 tex_to_screen_uv_ratio = SCREEN_PIXEL_SIZE / TEXTURE_PIXEL_SIZE;
	
	// compute UV of the flipped screen
	vec2 flipped_screen_uv = vec2( SCREEN_UV.x, 
		SCREEN_UV.y + 2.0 * UV.y * tex_to_screen_uv_ratio.y );
	vec2 suv = vec2( SCREEN_UV.x, SCREEN_UV.y + 2.0 * UV.y * tex_to_screen_uv_ratio.y );
	suv.x += 10.0 * SCREEN_PIXEL_SIZE.x * sin( 20.0 * UV.y  + TIME ) * UV.y;
	
	
	vec4 c1 = textureLod( SCREEN_TEXTURE, suv, 0.0 );
	//vec4 c2 = textureLod( SCREEN_TEXTURE, SCREEN_UV, 0.0 );
	c1 = mix( c1, vec4( 0.1, 0.1, 0.25, 1.0 ), 0.3 );
	
	COLOR = c1;//mix( c1, c2, 0.0 );
}