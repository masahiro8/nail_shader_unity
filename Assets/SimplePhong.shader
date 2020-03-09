Shader "Custom/SimplePhong"
{
    Properties {
        _Color("Diffuse Color",Color) = (1.0, 1.0, 1.0)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf SimplePhong //サーフィスシェーダであることを宣言し、ライティングモデルをSimplePhongに指定している
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
        }
        //SimplePhongライティング関数
		half4 LightingSimplePhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
            half NdotL = max(0, dot (s.Normal, lightDir));
			float3 R = normalize( - lightDir + 2.0 * s.Normal * NdotL ); //反射ベクトル
            float3 spec = pow(max(0, dot(R, viewDir)), 24.0); //反射の強さ 指数を大きくすればするほどハイライトの減衰が速くなり、ピンポイントで光る

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * NdotL + spec +  fixed4(0.1f, 0.1f, 0.1f, 1);
            c.a = s.Alpha;
			return c;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
