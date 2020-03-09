Shader "Custom/Noise"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

		sampler2D _MaskTex;

        struct Input
        {
            float2 uv_MaskTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        fixed4 _SubColor;

        void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 c1 = _Color.rgba;
            fixed4 c2 = _SubColor.rgba;
            fixed4 p = tex2D (_MaskTex, IN.uv_MaskTex) * _Color;
            o.Albedo = lerp(c1, c2, p);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c1.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
