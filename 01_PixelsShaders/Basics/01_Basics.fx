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
    return Out;
}

/*Pixel shader will be processed once per pixel.
Each Pixel will receive data from vs2ps including:
input.Pos (screen space position , from -1 to 1
 -1/-1 is left/bottom, 1,1 is top/right
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
