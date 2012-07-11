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

//we use this parameter to change the final intensity result
float4 result : COLOR = 1.0f; 

//Frequency for our trigonometric functions
float freq = 50;

//Power function allows to alter curve
float power = 1.0f;

//Timer
float time = 0.0f;

float4 PSLine(vs2ps input): COLOR
{
	//Same as previous sample
	float2 p = input.TexCd.xy * 2.0 - 1.0;
	p.y *= -1.0f;
	
	/*Apply sine function on x,
	we multiply x by frequency to alter line width/count,
	we also add time to animate */
	float i = sin((p.x+time)  * freq); 
	
	/* Since sin/cos functions return data from -1 to 1
	we use abs to remap from 0 to 1 */
	i = abs(i);
	
	/*Power function changes thichkness */
	i = pow(i,power);
	
	return result * i;
}

float4 PSCircleLine(vs2ps input): COLOR
{
	//Same as previous sample
	float2 p = input.TexCd.xy * 2.0 - 1.0;
	p.y *= -1.0f;
	
	//Now we want circles, remember the radius?
	float d = sqrt(dot(p,p));
	
	/*Apply sine function on radius instead */
	float i = sin((d+time) * freq); 
	
	/* Since sin/cos functions return data from -1 to 1
	we use abs to remap from 0 to 1 */
	i = abs(i);
	
	/*Power function changes thichkness */
	i = pow(i,power);
	
	return result * i;
}

float4 PSSquareLine(vs2ps input): COLOR
{
	//Same as previous sample
	float2 p = input.TexCd.xy * 2.0 - 1.0;
	p.y *= -1.0f;
	
	/*Here we need absolute so each corner is seen 
	as max distance */
	p = abs(p);
	
	/*Now we can just take the value furtest from origin
	per axis*/
	float d = max(p.x,p.y);
	
	/*Apply sine function on d */
	float i = sin((d+time) * freq); 
	
	/* here smooth edges look bit strange to get hard
	edges from sin function, we can simply use this,
	which is equivalent to:
	if (i > 0) { i = 1 } else { i = 0 } */
	i = i > 0;
	
	return result * i;
}

float4 PSLastOne(vs2ps input): COLOR
{
	/*Just for fun, combining some functions together
	to generate abstract pattern */
	
	//Same as previous sample
	float2 p = input.TexCd.xy * 2.0 - 1.0;
	p.y *= -1.0f;
	
	//distance to center
	float d = sqrt(dot(p,p));
	//angle to center
	float a = atan2(p.y,p.x);

	//Alter our y a bit so it's not linear
	float y =  sin (p.y * 5); 
	
	//Apply horizontal line with out modded y
	float i = sin((y+time)  * freq); 
	
	//This removes some of the edges, 
	int f2 = 5; 
	// High value of f2 will change to somethisn different
	i *= cos(p.x * f2) * sin(a);
	
    //Applies circular shape;
	i += sin(d *15 + time * 5);
	
	return result * i;
}


technique Line
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSLine();
    }
}

technique CircleLine
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSCircleLine();
    }
}

technique SquareLine
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSSquareLine();
    }
}

technique LastOne
{
    pass P0
    {
       VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PSLastOne();
    }
}
	
	

