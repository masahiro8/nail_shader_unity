Shader "Custom/Noise"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color ("Diffuse Color",Color) = (1.0, 1.0, 1.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf SimplePhong
        #pragma target 3.0

		sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        float4 _Color;

        float random (fixed2 p) {
            //0~1未満の乱数を返す→0.5以上の乱数を返す
            float rangeAll = 0.6;//ラメの明るさの分布幅 0〜1未満の値を指定する
            float shift = 0.5; //ラメの集団全体の明るさをどれぐらい持ち上げるか 0〜1未満の値を指定する
            float rand = frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453123) * rangeAll + shift;
            float minBrightness = 0.5;
            float rangeMin = rangeAll * minBrightness + shift; // 黒い点をなくす
            if (rand <= rangeMin){ return rand = rangeMin; }
            return rand;
        }

        void surf (Input IN, inout SurfaceOutput o) {
            float c = random(floor(IN.uv_MainTex * 300)); //テクスチャ座標をn倍してからランダムノイズ→nxnのブロックノイズ
            o.Albedo = fixed4(_Color.r * c, _Color.g * c, _Color.b * c, 1);
        }

        half4 LightingSimplePhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
            half NdotL = max(0, dot (s.Normal, lightDir));
			float3 R = normalize( - lightDir + 2.0 * s.Normal * NdotL );
            float3 spec = pow(max(0, dot(R, viewDir)), 15.0);//ツヤの減衰

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * NdotL + spec +  fixed4(0.1f, 0.1f, 0.1f, 1);
			c.a = s.Alpha;
			return c;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
