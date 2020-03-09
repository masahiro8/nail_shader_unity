Shader "Custom/TextureBlending"
{
    Properties
    {
        _Color ("Diffuse Color",Color) = (1.0, 1.0, 1.0)
        _SubColor ("Diffuse Color",Color) = (1.0, 1.0, 1.0)
		_MaskTex ("Mask Texture", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
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
            fixed4 p = tex2D (_MaskTex, IN.uv_MaskTex);
            o.Albedo = lerp(c1, c2, p);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c1.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
