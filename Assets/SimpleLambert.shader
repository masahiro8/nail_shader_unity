Shader "Unlit/SimpleLambert"
{
    Properties {
        _Color("Diffuse Color",Color) = (1.0, 1.0, 1.0)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        #include "UnityCG.cginc"

        struct Input {
            float4 color : COLOR;
        };

        float4 _Color;

        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
