Shader "Custom/Transparent"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        // _Alpha ("Alpha", Range(0,1)) = 0.5 //インスペクタにAlphaスライダーを表示する場合に使用

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" } //
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:fade //Alpha設定する場合は alpha:fadeにする
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        // half _Alpha; //インスペクタにAlphaスライダーを表示する場合に使用
        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
            // o.Alpha = _Alpha; //インスペクタにAlphaスライダーを表示する場合に使用
        }
        ENDCG
    }
    FallBack "Diffuse"
}
