Shader "Custom/AnimatedLavaShaderWithWaves"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1, 0.3, 0, 1)
        _MainTex ("Lava Texture", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _EmissionColor ("Emission Color", Color) = (1, 0.3, 0, 1)
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _FlowSpeed ("Flow Speed", Float) = 0.5
        _WaveStrength ("Wave Strength", Float) = 0.05
        _WaveFrequency ("Wave Frequency", Float) = 10.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        fixed4 _Color;
        fixed4 _EmissionColor;
        half _Glossiness;
        half _Metallic;
        float _FlowSpeed;
        float _WaveStrength;
        float _WaveFrequency;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Animate UVs with vertical waves
            float waveOffset = sin(_Time.y * _WaveFrequency + IN.uv_MainTex.x * 10) * _WaveStrength;

            float2 animatedUV = IN.uv_MainTex;
            animatedUV.y += _Time.y * _FlowSpeed + waveOffset;

            fixed4 c = tex2D(_MainTex, animatedUV) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;

            // Animate Normal Map with same wave effect
            float2 bumpUV = IN.uv_BumpMap;
            bumpUV.y += _Time.y * _FlowSpeed + waveOffset;
            o.Normal = UnpackNormal(tex2D(_BumpMap, bumpUV));

            // Emission for glow
            o.Emission = _EmissionColor.rgb * c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
