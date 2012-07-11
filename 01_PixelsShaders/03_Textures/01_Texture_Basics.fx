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

/* Here we define a texture so we can use any picture
source in our shader (image/video/camera/generated content*/
texture Tex <string uiname="Texture";>;

/* Texture needs a sampler to access it
sampler is covered in next example */
sampler Samp = sampler_state 
{
    Texture   = (Tex); 
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

float4 PSTexture(vs2ps input): COLOR
{
	/*Here we simply use our texture coordinate 
	to lookup texture color for our pixel */
	return tex2D(Samp,input.TexCd);
}

float4 PSInvert(vs2ps input): COLOR
{
	float4 color = tex2D(Samp,input.TexCd);

	/*Color is 4 channels, 
	generally we want to leave alpha
	unmodified, hence the color.rgb */
	
	//Invert r,g and b channels.
	//We could also invert a single channel
	//By doing color.r = 1- color.r; for example
	color.rgb = 1.0f -color.rgb;
	
	return color;
}

float scale = 1.0f;
float power = 1.0f;

float4 PSGray(vs2ps input): COLOR
{
	float4 color = tex2D(Samp,input.TexCd);
	
	/*Multiply each channel by a different value
	since color channel luminance is different */
	float l = color.rgb * float3(0.27,0.67,0.06);
	
	return float4(l,l,l,1.0f);
}

float4 PSPostBlend(vs2ps input): COLOR
{
	float4 color = tex2D(Samp,input.TexCd);
	
	/*Multiply each channel by a different value
	since color channel luminance is different */
	float l = color.rgb * float3(0.27,0.67,0.06);
	
	//Modify color curve
	l = pow(l,power) * scale;
	
	//Apply our luminance back to the original color
	return color * float4(l,l,l,1.0f);
}


technique TextureBase
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
       PixelShader = compile ps_3_0 PSTexture();
    }
}

technique TextureInvert
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSInvert();
    }
}

technique TextureGray
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSGray();
    }
}

technique TexturePostBlend
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSPostBlend();
    }
}