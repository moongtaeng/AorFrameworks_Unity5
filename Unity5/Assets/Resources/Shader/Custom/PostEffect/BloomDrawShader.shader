﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/PostEffect/BloomDrawShader" {
Properties {
	_MainTex ("MainRt", 2D) = "white" {}
	_CurveTex ("CurveTex", 2D) = "Black" {}
 
}


SubShader {

	     Tags
     { 
         "Queue"="Transparent" 
         "IgnoreProjector"="True" 
         "RenderType"="Transparent" 
         "PreviewType"="Plane"
       //  "CanUseSpriteAtlas"="True"
     }


	Pass {

	//   Blend SrcAlpha OneMinusSrcAlpha
	    Cull Off
     Lighting Off
     ZWrite Off
     Fog { Mode Off }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
		//	#pragma multi_compile DUMMY PIXELSNAP_ON
            #include "UnityCG.cginc"
            
        
			sampler2D _MainTex;
			sampler2D _CurveTex;
			float4 _MainTex_ST;
 
 

			         struct appdata_t
         {
             float4 vertex   : POSITION;
             float4 color    : COLOR;
             float2 texcoord : TEXCOORD0;
         };

	         struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD2;
				 float4 color    : COLOR;
            };
           
            //顶点函数没什么特别的，和常规一样
            v2f vert (appdata_t v)
            {
                v2f o;
             o.pos = UnityObjectToClipPos(v.vertex);
				o.uv =TRANSFORM_TEX(v.texcoord,_MainTex);
				 o.pos = UnityPixelSnap ( o.pos);
				 o.color=v.color;
                return o;
            }
     
              
           float4 frag (v2f i) : COLOR
         {
 
			float4 mainCol = tex2D(_MainTex, i.uv);
		
 
			fixed4 curveCol = tex2D(_CurveTex, i.uv);
		 
			mainCol.rgb =  mainCol.rgb + curveCol.rgb ;
 
		 	return  mainCol ;

            }
    
ENDCG

		}


	}

}