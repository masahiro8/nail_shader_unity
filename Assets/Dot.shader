Shader "Custom/Dot"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float3 worldPos;
            float2 uv_MainTex;
        };

        fixed4 _Color;

        float random (fixed2 p) {
            //0~1未満の乱数を返す→0.5以上の乱数を返す
            float rand = frac(sin(dot(p, fixed2(12.9898, 78.233))) * 43758.5453123);
            return rand;
        }

        float circle(float2 p, float radius){
            return length(p) - radius;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // float c = random(floor(IN.uv_MainTex * 10));
            //円の中のときに色にcをかけたい
            float c = random(IN.uv_MainTex);
            float ci = circle(IN.uv_MainTex, 0.1);
            // if (ci <= 0.2) {
                o.Albedo = fixed4(_Color.r * c, _Color.g * c, _Color.b * c, 1);
            // }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
