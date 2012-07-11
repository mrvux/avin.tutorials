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


texture Tex <string uiname="Texture";>;
sampler Samp = sampler_state 
{
    Texture   = (Tex); 
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

//Second texture we will use for blending
texture Tex2 <string uiname="Texture 2";>;
sampler Samp2 = sampler_state 
{
    Texture   = (Tex2); 
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

//Second texture we will use as mask
texture TexMask <string uiname="Texture Mask";>;
sampler SampMask = sampler_state 
{
    Texture   = (TexMask); 
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

float alpha = 0.5f;

float4 PSBlend(vs2ps input): COLOR
{
	//Get color from each texture
	float4 c1 = tex2D(Samp,input.TexCd);
	float4 c2 = tex2D(Samp2,input.TexCd);
	
	//Lerp just mixes color using the alpha parameter
	c1.rgb = lerp(c1.rgb,c2.rgb,alpha);
	
	return c1;
}

float4 PSAdd(vs2ps input): COLOR
{
	//Get color from each texture
	float4 c1 = tex2D(Samp,input.TexCd);
	float4 c2 = tex2D(Samp2,input.TexCd);
	
	//Add both colors (saturate makes sure is stays in 0-1 range)
	c2.rgb = saturate(c1.rgb+c2.rgb);
	
	c1.rgb = lerp(c1.rgb,c2.rgb,alpha);
	return c1;
}

float4 PSMul(vs2ps input): COLOR
{
	//Get color from each texture
	float4 c1 = tex2D(Samp,input.TexCd);
	float4 c2 = tex2D(Samp2,input.TexCd);
	
	//Add both colors (saturate makes sure is stays in 0-1 range)
	c2.rgb = saturate(c1.rgb*c2.rgb);
	
	c1.rgb = lerp(c1.rgb,c2.rgb,alpha);
	return c1;
}

float4 PSBlendMask(vs2ps input): COLOR
{
	//Get color from each texture
	float4 c1 = tex2D(Samp,input.TexCd);
	float4 c2 = tex2D(Samp2,input.TexCd);
	
	//Get mask color, since here it is black and white we
	//just use the red channel
	float cmask = tex2D(SampMask,input.TexCd).r;
	
	//Use the mask color as alpha value instead of
	// static value
	c1.rgb = lerp(c1.rgb,c2.rgb,cmask);
	
	return c1;
}

float4 PSAddMask(vs2ps input): COLOR
{
	//Get color from each texture
	float4 c1 = tex2D(Samp,input.TexCd);
	float4 c2 = tex2D(Samp2,input.TexCd);
	float cmask = tex2D(SampMask,input.TexCd).r;
	
	c2.rgb = saturate(c1.rgb+c2.rgb);
	
	//Here we add a little trick, we change the strength
	//or our mask over time
	float a = cmask * alpha;
	
	c1.rgb = lerp(c1.rgb,c2.rgb,a);
	
	return c1;
}


technique BlendStatic
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
       PixelShader = compile ps_3_0 PSBlend();
    }
}

technique AddStatic
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
       PixelShader = compile ps_3_0 PSAdd();
    }
}

technique MultiplyStatic
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
       PixelShader = compile ps_3_0 PSMul();
    }
}

technique BlendMask
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
       PixelShader = compile ps_3_0 PSBlendMask();
    }
}

technique AddMask
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
       PixelShader = compile ps_3_0 PSAddMask();
    }
}



