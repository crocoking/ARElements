Shader "ARBestPractices/ARStandardUnlit" {
	Properties {
		[HDR] _Color ("Color", Vector) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_UseVertexColor ("Use Vertex Color", Range(0, 1)) = 1
		[Header(Ambient Occlusion)] [Toggle(USE_AO)] _UseAO ("Use Ambient Occlusion", Float) = 0
		_AmbientOcclusionTex ("AmbientOcclusionTex", 2D) = "white" {}
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTestFunc ("ZTest", Float) = 4
		[Header(Blend State)] [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("SrcBlend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("DestBlend", Float) = 0
		[Space(20)] [Header(Other)] [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2
		[Enum(Off,0,On,1)] _ZWrite ("ZWrite", Float) = 1
		_OffsetFalloff ("OffsetFalloff", Float) = 0
		_Offset ("Offset", Float) = 0
	}
	SubShader {
		LOD 100
		Tags { "RenderType" = "Opaque" }
		Pass {
			LOD 100
			Tags { "RenderType" = "Opaque" }
			Blend Zero Zero, Zero Zero
			ZWrite Off
			Cull Off
			GpuProgramID 8521
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					attribute vec4 _glesMultiTexCoord0;
					attribute vec4 _glesMultiTexCoord1;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _Color;
					uniform highp float _UseVertexColor;
					uniform highp vec4 _MainTex_ST;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec2 xlv_TEXCOORD3;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec4 xlv_COLOR;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = _glesVertex.xyz;
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  xlv_TEXCOORD3 = _glesMultiTexCoord1.xy;
					  xlv_TEXCOORD2 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  xlv_COLOR = (((_glesColor * _UseVertexColor) + (1.0 - _UseVertexColor)) * _Color);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _Color;
					uniform sampler2D _MainTex;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec4 xlv_COLOR;
					void main ()
					{
					  highp vec4 outColor_1;
					  highp vec4 textureSample_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD2);
					  textureSample_2 = tmpvar_3;
					  outColor_1 = (textureSample_2 * _Color);
					  outColor_1 = (outColor_1 * xlv_COLOR);
					  gl_FragData[0] = outColor_1;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					attribute vec4 _glesMultiTexCoord0;
					attribute vec4 _glesMultiTexCoord1;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _Color;
					uniform highp float _UseVertexColor;
					uniform highp vec4 _MainTex_ST;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec2 xlv_TEXCOORD3;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec4 xlv_COLOR;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = _glesVertex.xyz;
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  xlv_TEXCOORD3 = _glesMultiTexCoord1.xy;
					  xlv_TEXCOORD2 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  xlv_COLOR = (((_glesColor * _UseVertexColor) + (1.0 - _UseVertexColor)) * _Color);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _Color;
					uniform sampler2D _MainTex;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec4 xlv_COLOR;
					void main ()
					{
					  highp vec4 outColor_1;
					  highp vec4 textureSample_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD2);
					  textureSample_2 = tmpvar_3;
					  outColor_1 = (textureSample_2 * _Color);
					  outColor_1 = (outColor_1 * xlv_COLOR);
					  gl_FragData[0] = outColor_1;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					attribute vec4 _glesMultiTexCoord0;
					attribute vec4 _glesMultiTexCoord1;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _Color;
					uniform highp float _UseVertexColor;
					uniform highp vec4 _MainTex_ST;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec2 xlv_TEXCOORD3;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec4 xlv_COLOR;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = _glesVertex.xyz;
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  xlv_TEXCOORD3 = _glesMultiTexCoord1.xy;
					  xlv_TEXCOORD2 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  xlv_COLOR = (((_glesColor * _UseVertexColor) + (1.0 - _UseVertexColor)) * _Color);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _Color;
					uniform sampler2D _MainTex;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec4 xlv_COLOR;
					void main ()
					{
					  highp vec4 outColor_1;
					  highp vec4 textureSample_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD2);
					  textureSample_2 = tmpvar_3;
					  outColor_1 = (textureSample_2 * _Color);
					  outColor_1 = (outColor_1 * xlv_COLOR);
					  gl_FragData[0] = outColor_1;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _Color;
					uniform 	float _UseVertexColor;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_TEXCOORD0;
					in highp vec4 in_TEXCOORD1;
					in mediump vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec2 vs_TEXCOORD3;
					out highp vec2 vs_TEXCOORD2;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD3.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat0.x = (-_UseVertexColor) + 1.0;
					    u_xlat0 = in_COLOR0 * vec4(_UseVertexColor) + u_xlat0.xxxx;
					    vs_COLOR0 = u_xlat0 * _Color;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Color;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD2;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec4 u_xlat0;
					lowp vec4 u_xlat10_0;
					void main()
					{
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD2.xy);
					    u_xlat0 = u_xlat10_0 * _Color;
					    SV_Target0 = u_xlat0 * vs_COLOR0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _Color;
					uniform 	float _UseVertexColor;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_TEXCOORD0;
					in highp vec4 in_TEXCOORD1;
					in mediump vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec2 vs_TEXCOORD3;
					out highp vec2 vs_TEXCOORD2;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD3.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat0.x = (-_UseVertexColor) + 1.0;
					    u_xlat0 = in_COLOR0 * vec4(_UseVertexColor) + u_xlat0.xxxx;
					    vs_COLOR0 = u_xlat0 * _Color;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Color;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD2;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec4 u_xlat0;
					lowp vec4 u_xlat10_0;
					void main()
					{
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD2.xy);
					    u_xlat0 = u_xlat10_0 * _Color;
					    SV_Target0 = u_xlat0 * vs_COLOR0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _Color;
					uniform 	float _UseVertexColor;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_TEXCOORD0;
					in highp vec4 in_TEXCOORD1;
					in mediump vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec2 vs_TEXCOORD3;
					out highp vec2 vs_TEXCOORD2;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_TEXCOORD3.xy = in_TEXCOORD1.xy;
					    vs_TEXCOORD2.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat0.x = (-_UseVertexColor) + 1.0;
					    u_xlat0 = in_COLOR0 * vec4(_UseVertexColor) + u_xlat0.xxxx;
					    vs_COLOR0 = u_xlat0 * _Color;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Color;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD2;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec4 u_xlat0;
					lowp vec4 u_xlat10_0;
					void main()
					{
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD2.xy);
					    u_xlat0 = u_xlat10_0 * _Color;
					    SV_Target0 = u_xlat0 * vs_COLOR0;
					    return;
					}
					
					#endif"
				}
			}
			Program "fp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					"!!GLES3"
				}
			}
		}
	}
}