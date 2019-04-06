//Shader "Custom/Chapter8-AlphaBlend"
Shader "Unity Shaders Book/Chapter 8/Alpha Blend"
{
    Properties
    {
        _Color("Main Tint",Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white"{}
		//_Cutoff("Alpha Cutoff",Range(0,1)) = 0.5
		_AlphaScale("Alpha Scale",Range(0,1)) = 1
    }
    SubShader
    {
        //Tags{"Queue" = "AlphaTest" "IgnorePorjector" = "True" "RenderTpye" = "TransparentCutout"}
		// 在Unity中透明度混合使用Transparent队列
		Tags{"Queue"="Transparent" "IgnorePorjector" = "True" "RenderTpye" = "Transparent"}

		Pass{
			Tags{"LightMode"= "ForwardBase"}

			// 透明度混合的双面渲染 关闭剔除
			Cull Front
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha


			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			//fixed _Cutoff;
			fixed _AlphaScale;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal:NORMAL;
				float4 texcoord :  TEXCOORD0;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}

			fixed4 frag(v2f i):SV_Target{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed4 texColor = tex2D(_MainTex,i.uv);
				fixed3 albedo = texColor.rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 diffuse = _LightColor0.rgb * albedo * max(0,dot(worldNormal,worldLightDir));
				return fixed4(ambient + diffuse,texColor.a * _AlphaScale);
			}

			ENDCG


		}

        Pass{
			Tags{"LightMode"= "ForwardBase"}

			// 透明度混合的双面渲染 关闭剔除
			Cull Back
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha


			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			//fixed _Cutoff;
			fixed _AlphaScale;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal:NORMAL;
				float4 texcoord :  TEXCOORD0;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}

			fixed4 frag(v2f i):SV_Target{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed4 texColor = tex2D(_MainTex,i.uv);
				fixed3 albedo = texColor.rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 diffuse = _LightColor0.rgb * albedo * max(0,dot(worldNormal,worldLightDir));
				return fixed4(ambient + diffuse,texColor.a * _AlphaScale);
			}

			ENDCG


		}
    }
    FallBack "Transparent/Cutout/VertexLit"
}
