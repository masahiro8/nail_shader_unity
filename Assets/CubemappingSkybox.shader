Shader "Custom/CubemappingSkybox"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex: POSITION;
                half3 normal: NORMAL;
                half2 uv: TEXCOORD0;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                float3 pos2 : TEXCOORD1;
                half3 normal : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.pos2 = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.normal = normalize(i.normal);
                half3 viewDir = normalize(_WorldSpaceCameraPos - i.pos2);
                half3 reflDir = reflect(-viewDir, i.normal);

                // キューブマップと反射方向のベクトルから反射先の色を取得する
                half4 refColor = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, reflDir);

                return half4(refColor.rgb, 1);
            }
            ENDCG
        }
    }
}