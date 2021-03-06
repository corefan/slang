//TEST:COMPARE_HLSL:-no-mangle -target dxbc-assembly -profile ps_4_0 -entry main

// Confirm that resources inside constant buffers get correct locations,
// including the case where there are *multiple* constant buffers
// with reosurces.

#ifdef __SPIRE__
#define R(X) /**/
#else
#define R(X) X
#endif

float4 use(float  val) { return val; };
float4 use(float2 val) { return float4(val,0.0,0.0); };
float4 use(float3 val) { return float4(val,0.0); };
float4 use(float4 val) { return val; };
float4 use(Texture2D t, SamplerState s) { return t.Sample(s, 0.0); }

cbuffer CA R(: register(b0))
{
	float4 caa R(: packoffset(c0));
	float3 cab R(: packoffset(c1.x));
	float  cac R(: packoffset(c1.w));
	float2 cad R(: packoffset(c2.x));
	float2 cae R(: packoffset(c2.z));

	Texture2D ta R(: register(t0));
	SamplerState sa R(: register(s0));
}

cbuffer CB R(: register(b1))
{
	float4 cba R(: packoffset(c0));
	float3 cbb R(: packoffset(c1.x));
	float  cbc R(: packoffset(c1.w));
	float2 cbd R(: packoffset(c2.x));
	float2 cbe R(: packoffset(c2.z));

	Texture2D tbx R(: register(t1));
	Texture2D tby R(: register(t2));
	SamplerState sb R(: register(s1));
}

cbuffer CC R(: register(b2))
{
	float4 cca R(: packoffset(c0));
	float3 ccb R(: packoffset(c1.x));
	float  ccc R(: packoffset(c1.w));
	float2 ccd R(: packoffset(c2.x));
	float2 cce R(: packoffset(c2.z));

	Texture2D tc R(: register(t3));
	SamplerState scx R(: register(s2));
	SamplerState scy R(: register(s3));
}

float4 main() : SV_Target
{
	// Go ahead and use everything in this case:
	return use(ta,  sa)
		+  use(tbx, sb)
		+  use(tby, scx)
		+  use(tc,  scy)
		+  use(cae)
		+  use(cbe)
		+  use(cce)
		;
}