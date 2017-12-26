Shader "Custom/glow2" {
	Properties {
		_ColorTint ("Color Tint", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "Bump" {}
		_RimColor ("Rim Color", Color) =(1,1,1,1)
			_Alpha("Alpha", Range(0.0, 1.0)) = 0.5
		_RimPower("Rim Power",Range(0.0,6.0)) = 3.0 
	}	
	SubShader {
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			//Tags { "Queue" = "Transparent" }
			ZWrite On
			Blend SrcAlpha OneMinusSrcAlpha
			LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
	//	#pragma surface surf Standard fullforwardshadows
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
				
		//sampler2D _MainTex;

		struct Input {
			float4 color : Color;
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
			
			//float2 uv_MainTex;
		};

		float4 _ColorTint;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;
		float _Alpha;
		

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		//UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		//UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			
			IN.color = _ColorTint;
			//_ColorTint.a = 0;

			//o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb  *_ColorTint;
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb  *_ColorTint;
			//o.Alpha = 1;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			//_RimColor.a = rim;
			o.Alpha = 0.5;
			//o.Emission = _RimColor.rgb * pow(rim, _RimPower);
			
			
			/*// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
			*/
		}
		ENDCG
	}
	FallBack "Diffuse"
}
