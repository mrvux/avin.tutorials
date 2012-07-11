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
sampler SampLinear = sampler_state 
{
    Texture   = (Tex); 
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

sampler SampPoint = sampler_state 
{
    Texture   = (Tex); 
    MipFilter = POINT;
    MinFilter = POINT;
    MagFilter = POINT;
};

sampler SampWrap = sampler_state 
{
    Texture   = (Tex); 
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
	AddressU = WRAP; //Adressing
	AddressV = WRAP;
};

sampler SampClamp = sampler_state 
{
    Texture   = (Tex); 
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
	AddressU = CLAMP; //Adressing
	AddressV = CLAMP;
};

sampler SampMirror = sampler_state 
{
    Texture   = (Tex); 
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
	AddressU = MIRROR; //Adressing
	AddressV = MIRROR;
};

sampler SampBorder = sampler_state 
{
    Texture   = (Tex); 
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
	AddressU = BORDER; //Adressing
	AddressV = BORDER;
};

//Use to sample a texture at lower resolution
int level = 5;

//Use to show adressing
int2 scale = 3;

float4 PSLinear(vs2ps input): COLOR
{
	/*Here we use linear sampler above, 
	when we sample at lower resolution, it will take several 
	pixels and smooth them (linear interploation) 
	image will look blurred */
	
	/*We use tex2dlod to force looking 
	in a smaller size texture */	
	return tex2Dlod(SampLinear,float4(input.TexCd.xy,0, level));
}

float4 PSPoint(vs2ps input): COLOR
{
	/*Here we use point sampler above, 
	when we sample at lower resolution, it will take pixel
	value simply (no smoothing)
	image will look pixelated*/
	
	return tex2Dlod(SampPoint,float4(input.TexCd.xy,0, level));
}

float4 PSWrap(vs2ps input): COLOR
{
	/*Texture addressing tells what to do if we sample 
	outside the 0 to 1 range.
	So we multiply our quad texture coordinates by a number to make
	sure it happens */
	float2 uv = input.TexCd.xy * scale;
	
	/*Wrap means it will use a standard modulo operator,
	like uv.x = uv.x % 1.0f; uv.y = uv.y % 1.0f;
	then sample normally */
	float4 col = tex2D(SampWrap,uv);
	
	return col;
}

float4 PSClamp(vs2ps input): COLOR
{
	float2 uv = input.TexCd.xy * scale;
	
	/* Clamp will just take border pixel. 
	For example if uv.x = 1.5f it will sample 1.0f,
	if uv.x = -2.0f it will sample 0.0f 
	
	in hlsl it would be : uv = saturate(uv);
	*/
	
	float4 col = tex2D(SampClamp,uv);
	
	return col;
}

float4 PSMirror(vs2ps input): COLOR
{
	float2 uv = input.TexCd.xy * scale;

	/*Mirror is same as wrap, but will reverse texture once,
	then reverse back 
	int2 iuv = uv - frac(uv);
	uv = frac(uv);
	uv.xy = iuv.xy % 2 == 0 ? uv.xy : 1.0 - uv.xy;
	*/
	float4 col = tex2D(SampMirror,uv);
	
	return col;
}

float4 PSBorder(vs2ps input): COLOR
{
	float2 uv = input.TexCd.xy * scale;
	
	/* Border will just use another color if 
	coordinates outside the range:
	bool outside = uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1;
	if (outside) { return colorfromtex; } else { return bordercolor; }
	*/
	float4 col = tex2D(SampBorder,uv);
	
	return col;
}




technique TextureLinear
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSLinear();
    }
}

technique TexturePoint
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSPoint();
    }
}

technique TextureWrap
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSWrap();
    }
}

technique TextureClamp
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
       PixelShader = compile ps_3_0 PSClamp();
    }
}

technique TextureMirror
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
       PixelShader = compile ps_3_0 PSMirror();
    }
}

technique TextureBorder
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
       PixelShader = compile ps_3_0 PSBorder();
    }
}