//@author: vux
//@help: simple pixel shader demo
//@tags: template,demo
//@credits:

float4x4 tWVP: WORLDVIEWPROJECTION;

struct vs2ps 
{
	float4 Pos : POSITION; 
	float4 TexCd : TEXCOORD0;
};

vs2ps VS(float4 Pos : POSITION,float4 TexCd : TEXCOORD0)
{
    vs2ps Out = (vs2ps)0;
    Out.Pos = mul(Pos, tWVP);
	Out.TexCd = TexCd;
    return Out;
}

/*Pixel shader will be processed once per pixel.
Each Pixel will receive data from vs2ps including:
input.TexCd (texture coordinates, from 0 to 1
 0,0 if left/top, 1,1 is bottom/right */
float4 PSSolid(vs2ps input): COLOR
{
	/*Here we just return a solid color.
	Change the values and save to change the color
	Please note colors are always mapped from 0 to 1
	*/
	
	float r = 0.4f;
	float g = 0.9f;
	float b = 0.6f;
	float a = 1.0f;
	
    return float4(r,g,b,a);
}

float Scale = 1.0f;

float4 PSScalar(vs2ps input): COLOR
{
	/* Same as above, but now we can use the Scale parameter
	in the patch to modify color component intensity*/
	
	float r = 0.4f;
	float g = 0.9f;
	float b = 0.6f;
	float a = 1.0f;
	
    float4 col = float4(r,g,b,a);
	col.rgb *= Scale;
	
	return col;
}

float4 result : COLOR = 1.0f; 

float4 PSStatic(vs2ps input): COLOR
{
	/* Now we can use a static color that we can change
	from outside the code*/
	return result;
}

float4 PSFirstUV(vs2ps input): COLOR
{
	/* Here we use texture coordinate (from 0 to 1)
	to alter our color parameter. e
	Since Texture coordinates are mapped from 0 to 1
	we can easily generate simple gradients,
	here it is just linear for the demo*/
	return result * input.TexCd.x;
}

float r = 0.5;

float4 PSCircle(vs2ps input): COLOR
{
	/* Here we want to draw a circle, since we receive TexCd
	from 0 to 1, and we like to have coordinates systems
	with center at 0,0 , we gonna remap TexCd to screen coordinates
	*/
	
	float2 p = input.TexCd.xy * 2.0; //now we from 0 to 2
	p.xy -= 1.0f; //Back to -1 to 1
	p.y *= -1.0f; //Remember that TexCd Y axis is flipped
	
	/*now to calculate distance, we use dot(p,p),
	which is simple trick to center distance*distance 
	from origin. Then we need sqrt to get the real distance */
	
	/*Please note that this is not optimised at all,
	but that will do for the sample */
	float dist = sqrt(dot(p,p));
	/*Now if dist < our r parameter, draw white pixel
	else draw black pixel */
	return dist < r;

}


technique SolidColor
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSSolid();
    }
}
	
	
technique ScalarColor
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSScalar();
    }
}

technique StaticColor
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSStatic();
    }
}

technique FirstUV
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSFirstUV();
    }
}

technique Circle
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSCircle();
    }
}
