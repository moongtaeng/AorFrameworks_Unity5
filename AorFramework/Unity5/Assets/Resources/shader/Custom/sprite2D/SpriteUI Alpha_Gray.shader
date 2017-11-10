﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Sprites/SpriteUI Alpha Gray"
{
 Properties
 {
     [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
       _AlphaTex ("Alpha Texture", 2D) = "white" {}
     [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0

	_StencilComp ("Stencil Comparison", Float) = 8
	_Stencil ("Stencil ID", Float) = 0
	_StencilOp ("Stencil Operation", Float) = 0
	_StencilWriteMask ("Stencil Write Mask", Float) = 255
	_StencilReadMask ("Stencil Read Mask", Float) = 255
	_ColorMask ("Color Mask", Float) = 15
 }
Category {
     Tags
     { 
		 "Queue"="Transparent"
         "IgnoreProjector"="True" 
         "RenderType"="Transparent" 
         "PreviewType"="Plane"
         "CanUseSpriteAtlas"="True"
     }

	 Stencil
	{
		Ref [_Stencil]
		Comp [_StencilComp]
		Pass [_StencilOp] 
		ReadMask [_StencilReadMask]
		WriteMask [_StencilWriteMask]
	}

  	Cull Off
	Lighting Off
	ZWrite Off
	ZTest [unity_GUIZTestMode]
	Fog { Mode Off }
	Blend SrcAlpha OneMinusSrcAlpha
	ColorMask [_ColorMask]
	       
 SubShader
 {

  Pass
     {
     Name "SPRITE_BASE"
     CGPROGRAM
         #pragma vertex vert
         #pragma fragment frag
         #pragma multi_compile DUMMY PIXELSNAP_ON
         #include "UnityCG.cginc"
     
         struct appdata_t
         {
             float4 vertex   : POSITION;
             float4 color    : COLOR;
             float2 texcoord : TEXCOORD0;
         };

         struct v2f
         {
             float4 vertex   : SV_POSITION;
             fixed4 color    : COLOR;
             half2 texcoord  : TEXCOORD0;
         };

         v2f vert(appdata_t IN)
         {
             v2f OUT;
             OUT.vertex = UnityObjectToClipPos(IN.vertex);
             OUT.texcoord = IN.texcoord;
             OUT.color = IN.color ;
             #ifdef PIXELSNAP_ON
             OUT.vertex = UnityPixelSnap (OUT.vertex);
             #endif

             return OUT;
         }

         sampler2D _MainTex;
  		 sampler2D _AlphaTex;
         fixed4 frag(v2f IN) : COLOR
         {
        	fixed4 col=tex2D(_MainTex, IN.texcoord);
        	fixed3 alpha=tex2D(_AlphaTex, IN.texcoord).rgb;
			col.rgb = dot(col.rgb, fixed3(.422,.807,.271)); 
        	col.a=alpha;
             return  col * IN.color;
         }
     ENDCG
     }
 
 }
 }
}
