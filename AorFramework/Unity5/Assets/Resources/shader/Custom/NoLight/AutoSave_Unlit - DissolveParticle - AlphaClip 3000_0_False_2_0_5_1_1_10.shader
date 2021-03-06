//@@@DynamicShaderInfoStart
//不写深度的双面的叠加的shader,层:Transparent
//@@@DynamicShaderInfoEnd

//@@@DynamicShaderTitleRepaceStart
Shader "Hidden/Custom/NoLight/Unlit - DissolveParticle - AlphaClip 3000_0_False_2_0_5_1_1_10"  {  
//@@@DynamicShaderTitleRepaceEnd
Properties {
	_MainTex ("Texture", 2D) = "white" {}
	_noiseTex ("Noise Texture", 2D) = "black" {}
	_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
    _mask("Mask", Range(0,1))=0 
		_Light("Light", float) = 1
}
	SubShader {
//@@@DynamicShaderTagsRepaceStart
Tags {   "Queue"="Transparent0" } 
//@@@DynamicShaderTagsRepaceEnd

 	Lighting Off
  ColorMask RGB
  Pass {


  	 //@@@DynamicShaderBlendRepaceStart
Blend SrcAlpha One,One OneMinusSrcAlpha
ZTest Less
 ZWrite Off
 Cull Off
//@@@DynamicShaderBlendRepaceEnd

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            sampler2D _noiseTex;   
            float4 _MainTex_ST;
           
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
                 float4  Color : Color;
            };
           
           
           struct appdata {
    float4 vertex : POSITION;
    float2 texcoord:TEXCOORD0;
      float4 Color:Color;
};

            //顶点函数没什么特别的，和常规一样
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
                o.Color=v.Color;
                return o;
            }
 
		 float4 _TintColor;
		  float _mask;
		  float _Light;
		  
            float4 frag (v2f i) : COLOR
            {
                    float4 noiseCol= tex2D(_noiseTex,i.uv);
                    float4 col= tex2D(_MainTex,i.uv);
                    col.a=min( col.a,noiseCol.r)  ;
                    col*=_TintColor*i.Color;
                   

				 	clip(col.a- _mask);
					col.rgb *= _Light;
                return col;
             
            }
            ENDCG
        }
 
}



}