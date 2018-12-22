﻿Shader "Unlit/Keiwando/Gaussian Blur"
{
	Properties
	{
		_Radius("Radius", Range(1, 255)) = 1
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Opaque" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" }		

		CGINCLUDE
		#include "UnityCG.cginc"

		static const int weightCount = 256;
		static const float weights [256] = { 0.311673656564, 0.311664145184, 0.311635612785, 0.311588064592, 0.311521509309, 0.31143595912, 0.311331429683, 0.311207940125, 0.311065513037, 0.310904174468, 0.310723953916, 0.310524884318, 0.310307002042, 0.310070346876, 0.309814962013, 0.30954089404, 0.309248192926, 0.308936912, 0.308607107944, 0.308258840767, 0.307892173794, 0.307507173642, 0.307103910202, 0.306682456617, 0.30624288926, 0.305785287711, 0.305309734735, 0.304816316253, 0.304305121319, 0.303776242092, 0.303229773811, 0.302665814762, 0.302084466252, 0.301485832577, 0.30087002099, 0.300237141674, 0.299587307701, 0.298920635006, 0.298237242347, 0.297537251275, 0.296820786093, 0.29608797382, 0.295338944158, 0.294573829448,0.293792764634, 0.292995887225, 0.292183337249, 0.291355257219, 0.290511792086, 0.289653089199, 0.288779298263, 0.287890571293, 0.286987062572, 0.286068928606, 0.285136328078, 0.284189421805, 0.283228372688, 0.282253345667, 0.281264507675, 0.280262027591, 0.279246076187, 0.278216826088, 0.277174451714, 0.276119129238, 0.275051036535, 0.273970353127, 0.272877260141, 0.271771940253, 0.270654577638, 0.269525357921, 0.268384468124, 0.267232096617, 0.266068433062,0.264893668367, 0.263707994628, 0.262511605083, 0.261304694053, 0.260087456899, 0.258860089959, 0.257622790503, 0.25637575668, 0.255119187461, 0.253853282591, 0.252578242535, 0.251294268427, 0.250001562013, 0.248700325604, 0.247390762024, 0.246073074552, 0.244747466877, 0.243414143041, 0.242073307392, 0.240725164528, 0.23936991925, 0.238007776506, 0.236638941347, 0.235263618871, 0.233882014174, 0.232494332302, 0.231100778199, 0.229701556659, 0.228296872279, 0.226886929404, 0.225471932088, 0.224052084036, 0.222627588567, 0.221198648557, 0.219765466401, 0.218328243962, 0.216887182524, 0.215442482751, 0.213994344642, 0.212542967483, 0.211088549806, 0.209631289345, 0.208171382995, 0.206709026767, 0.205244415749, 0.203777744063, 0.202309204828, 0.200838990115, 0.199367290912, 0.197894297084, 0.196420197336, 0.194945179174, 0.193469428868, 0.19199313142, 0.190516470523, 0.189039628531, 0.187562786421, 0.186086123763, 0.184609818687, 0.183134047848, 0.181658986398, 0.180184807953, 0.178711684566, 0.177239786694, 0.175769283175, 0.174300341194, 0.17283312626, 0.171367802181, 0.169904531033, 0.168443473141, 0.166984787052, 0.165528629512, 0.164075155446, 0.162624517932, 0.161176868182, 0.159732355523, 0.158291127376, 0.156853329239, 0.155419104665, 0.153988595249, 0.15256194061, 0.151139278375, 0.149720744164, 0.148306471575, 0.146896592174, 0.145491235478, 0.144090528944, 0.14269459796, 0.141303565832, 0.139917553775, 0.138536680905, 0.137161064229, 0.135790818637, 0.134426056899, 0.133066889653, 0.131713425405, 0.130365770519, 0.129024029219, 0.12768830358, 0.126358693528, 0.125035296838, 0.123718209131, 0.122407523876, 0.121103332389, 0.119805723832, 0.118514785214, 0.117230601398, 0.115953255098, 0.114682826883, 0.113419395184, 0.112163036294, 0.110913824379, 0.109671831476, 0.108437127506, 0.107209780276, 0.105989855489, 0.10477741675, 0.103572525578, 0.10237524141, 0.101185621614, 0.100003721497, 0.098829594318, 0.097663291296, 0.0965048616237, 0.0953543524785, 0.0942118090352, 0.0930772744791, 0.091950790019, 0.0908323949011, 0.0897221264234, 0.0886200199503, 0.0875261089273, 0.0864404248972, 0.0853629975151, 0.0842938545652, 0.083233021977, 0.0821805238427, 0.0811363824339, 0.0801006182197, 0.0790732498844, 0.0780542943457, 0.0770437667736, 0.0760416806088, 0.0750480475821, 0.0740628777337, 0.0730861794327, 0.0721179593976, 0.0711582227157, 0.0702069728638, 0.0692642117289, 0.0683299396288, 0.0674041553332, 0.0664868560849, 0.0655780376211, 0.0646776941948, 0.0637858185968, 0.0629024021771, 0.0620274348674,0.0611609052026, 0.0603028003435, 0.0594531060988, 0.0586118069475, 0.0577788860617, 0.056954325329, 0.0561381053748, 0.0553302055858, 0.0545306041319, 0.0537392779896, 0.0529562029644, 0.0521813537142, 0.0514147037714, 0.0506562255665, 0.0499058904506, 0.0491636687184, 0.0484295296309, 0.0477034414383, 0.046985371403, 0.0462752858218, 0.0455731500493, 0.0448789285199, 0.0441925847708, 0.0435140814643, 0.0428433804102 };

		struct v2f
		{
			float4 pos : POSITION;
			float4 uv : TEXCOORD0;
		};

		sampler2D _GrabTexture;
		float4 _GrabTexture_TexelSize;
		float _Radius;
			
		v2f vert (appdata_base v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = ComputeGrabScreenPos(o.pos);
			return o;
		}

		#define pixel(inData, offset) tex2D(_GrabTexture, (inData.uv.xy + _GrabTexture_TexelSize.xy * offset) / inData.uv.w)

		half4 blur(v2f inData, float2 direction)
		{
			float indexStep = weightCount / _Radius;
			float4 sum = weights[0] * pixel(inData, float2(0.0, 0.0));
			float totalWeight = weights[0];

			for (float i = 1; i < _Radius; i++)
			{	
				int weightIndex = int(min(weightCount - 1, i * indexStep));
				float weight = weights[weightIndex];
				float2 offset = i * direction;

				sum += weight * (pixel(inData, -offset) + pixel(inData, offset));
				totalWeight += 2.0 * weight;
			}

			return sum / totalWeight;
		}
		
		half4 horizBlur (v2f inData) : COLOR
		{
			return blur(inData, float2(1.0, 0.0));
		}

		half4 vertBlur (v2f inData) : COLOR
		{
			return blur(inData, float2(0.0, 1.0));
		}
		ENDCG

		GrabPass 
		{
			Tags { "LightMode" = "Always" }
		}

		Pass
		{
			Tags { "LightMode" = "Always" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment vertBlur
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}

		GrabPass 
		{
			Tags { "LightMode" = "Always" }
		}

		Pass
		{
			Tags { "LightMode" = "Always" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment horizBlur
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
	}
}