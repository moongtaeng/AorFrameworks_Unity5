// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//@@@DynamicShaderInfoStart
//根据另外一张贴图的RGB扭曲最终效果
//@@@DynamicShaderInfoEnd
Shader "Custom/NoLight/Unlit - TextureNoise##"{

Properties{

 _MainTex("Base(RGB)",2D)="white"{}
_noiseTex("Noise(RGB)",2D)="white"{}
  _size("noise Size",range(0,1))=0.1
  _speed("water speed",range(-1,1))=1
   _Scale("wave Scale",range(0.01,2))=1
  _alpha("wave  alpha", float)=1

	  [Enum(Off, 0, On, 1)] _ZWrite("ZWrite", Float) = 1
	  [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4
	  [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float) = 5
	  [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float) = 10
	  [Enum(UnityEngine.Rendering.BlendMode)] _SrcAlphaBlend("Src Alpha Blend Mode", Float) = 1
	  [Enum(UnityEngine.Rendering.BlendMode)] _DstAlphaBlend("Dst Alpha Blend Mode", Float) = 10
	  [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull Mode", Float) = 2


 }
// 	PC
	SubShader {
	 	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
 
		Pass {
 
	  Blend[_SrcBlend][_DstBlend],[_SrcAlphaBlend][_DstAlphaBlend]
	  ZWrite[_ZWrite]
	  ZTest[_ZTest]
	  Cull[_Cull]

 
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

    
                        uniform sampler2D _MainTex;
                     		float4 _MainTex_ST;  
                     		
                     		     
                        uniform sampler2D _noiseTex;
                     		float4 _noiseTex_ST;   
                     		   
            

             float  _size; 
            float  _speed; 
          float  _Scale;              
      float  _alpha;      
           
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
                 float4 color : COLOR;
            };
           
           
           struct appdata {
    float4 vertex : POSITION;
    float2 texcoord:TEXCOORD0;
    float4 color : COLOR;
};

            //顶点函数没什么特别的，和常规一样
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
               	o.color=v.color;
                return o;
            }
									
			fixed4 frag(v2f i) : COLOR {

			  	
			float2 noiseUV=i.uv;
		noiseUV+=_Time*_speed;
		//只要RG
    fixed2 noiseCol = tex2D(_noiseTex,noiseUV);
    fixed2 mainUV=i.uv;
   
		mainUV+=noiseCol*0.2*_size*_Scale;
           
			  	fixed4 mainCol = tex2D(_MainTex,mainUV);		

                return mainCol*i.color*fixed4(1,1,1,_alpha);
            }
			ENDCG
		}
	}

	
}


