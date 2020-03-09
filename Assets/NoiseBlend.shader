Shader "Custom/NoiseBlend"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _SubColor ("Sub Diffuse Color",Color) = (1.0, 1.0, 1.0)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf NoiseBlend
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MaskTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskTex;
        };

        fixed4 _Color;
        fixed4 _SubColor;

        float random (fixed2 p) {
            //0~1未満の乱数を返す→0.4以上の乱数を返す
            return (frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453123) * 0.4)+0.4;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float c = random(floor(IN.uv_MainTex * 800))*2 + 0.5; // ノイズのブロック分割数、色の暗さのオフセット
            fixed4 c1 = fixed4(_Color.r * c, _Color.g * c, _Color.b * c, 1);
            fixed4 c2 = _SubColor.rgba; //重ねる色
            fixed4 p = tex2D (_MaskTex, IN.uv_MaskTex); //マスク用のテクスチャ

            o.Albedo = lerp(c1, c2, p);
            // o.Albedo = c1;
        }

        half4 LightingNoiseBlend(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
            half NdotL = max(0, dot (s.Normal, lightDir));
			float3 R = normalize( - lightDir + 2.0 * s.Normal * NdotL );
            float3 spec = pow(max(0, dot(R, viewDir)), 10.0); //ハイライトの減衰はここで調整

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * NdotL + spec +  fixed4(0.1f, 0.1f, 0.1f, 1);
			c.a = s.Alpha;
			return c;
		}


        ENDCG
    }
    FallBack "Diffuse"
}
