Shader "Hidden/ARCoreBestPractices/SeparableBlur" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 42279
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = _glesVertex.xyz;
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					}
					
					
					#endif
					#ifdef FRAGMENT
					#extension GL_EXT_shader_texture_lod : enable
					lowp vec4 impl_low_texture2DLodEXT(lowp sampler2D sampler, highp vec2 coord, mediump float lod)
					{
					#if defined(GL_EXT_shader_texture_lod)
						return texture2DLodEXT(sampler, coord, lod);
					#else
						return texture2D(sampler, coord, lod);
					#endif
					}
					
					uniform sampler2D _MainTex;
					uniform highp vec2 _BlurVector;
					uniform highp float _MipLevel;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec4 color_1;
					  lowp vec4 tmpvar_2;
					  tmpvar_2 = impl_low_texture2DLodEXT (_MainTex, xlv_TEXCOORD0, _MipLevel);
					  highp vec4 tmpvar_3;
					  tmpvar_3 = tmpvar_2;
					  highp vec4 tmpvar_4;
					  tmpvar_4.z = 0.0;
					  tmpvar_4.xy = (xlv_TEXCOORD0 + _BlurVector);
					  tmpvar_4.w = _MipLevel;
					  lowp vec4 tmpvar_5;
					  tmpvar_5 = impl_low_texture2DLodEXT (_MainTex, tmpvar_4.xy, _MipLevel);
					  color_1 = (tmpvar_3 + tmpvar_5);
					  highp vec4 tmpvar_6;
					  tmpvar_6.z = 0.0;
					  tmpvar_6.xy = (xlv_TEXCOORD0 - _BlurVector);
					  tmpvar_6.w = _MipLevel;
					  lowp vec4 tmpvar_7;
					  tmpvar_7 = impl_low_texture2DLodEXT (_MainTex, tmpvar_6.xy, _MipLevel);
					  color_1 = (color_1 + tmpvar_7);
					  color_1 = (color_1 / 3.0);
					  gl_FragData[0] = color_1;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = _glesVertex.xyz;
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					}
					
					
					#endif
					#ifdef FRAGMENT
					#extension GL_EXT_shader_texture_lod : enable
					lowp vec4 impl_low_texture2DLodEXT(lowp sampler2D sampler, highp vec2 coord, mediump float lod)
					{
					#if defined(GL_EXT_shader_texture_lod)
						return texture2DLodEXT(sampler, coord, lod);
					#else
						return texture2D(sampler, coord, lod);
					#endif
					}
					
					uniform sampler2D _MainTex;
					uniform highp vec2 _BlurVector;
					uniform highp float _MipLevel;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec4 color_1;
					  lowp vec4 tmpvar_2;
					  tmpvar_2 = impl_low_texture2DLodEXT (_MainTex, xlv_TEXCOORD0, _MipLevel);
					  highp vec4 tmpvar_3;
					  tmpvar_3 = tmpvar_2;
					  highp vec4 tmpvar_4;
					  tmpvar_4.z = 0.0;
					  tmpvar_4.xy = (xlv_TEXCOORD0 + _BlurVector);
					  tmpvar_4.w = _MipLevel;
					  lowp vec4 tmpvar_5;
					  tmpvar_5 = impl_low_texture2DLodEXT (_MainTex, tmpvar_4.xy, _MipLevel);
					  color_1 = (tmpvar_3 + tmpvar_5);
					  highp vec4 tmpvar_6;
					  tmpvar_6.z = 0.0;
					  tmpvar_6.xy = (xlv_TEXCOORD0 - _BlurVector);
					  tmpvar_6.w = _MipLevel;
					  lowp vec4 tmpvar_7;
					  tmpvar_7 = impl_low_texture2DLodEXT (_MainTex, tmpvar_6.xy, _MipLevel);
					  color_1 = (color_1 + tmpvar_7);
					  color_1 = (color_1 / 3.0);
					  gl_FragData[0] = color_1;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = _glesVertex.xyz;
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					}
					
					
					#endif
					#ifdef FRAGMENT
					#extension GL_EXT_shader_texture_lod : enable
					lowp vec4 impl_low_texture2DLodEXT(lowp sampler2D sampler, highp vec2 coord, mediump float lod)
					{
					#if defined(GL_EXT_shader_texture_lod)
						return texture2DLodEXT(sampler, coord, lod);
					#else
						return texture2D(sampler, coord, lod);
					#endif
					}
					
					uniform sampler2D _MainTex;
					uniform highp vec2 _BlurVector;
					uniform highp float _MipLevel;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec4 color_1;
					  lowp vec4 tmpvar_2;
					  tmpvar_2 = impl_low_texture2DLodEXT (_MainTex, xlv_TEXCOORD0, _MipLevel);
					  highp vec4 tmpvar_3;
					  tmpvar_3 = tmpvar_2;
					  highp vec4 tmpvar_4;
					  tmpvar_4.z = 0.0;
					  tmpvar_4.xy = (xlv_TEXCOORD0 + _BlurVector);
					  tmpvar_4.w = _MipLevel;
					  lowp vec4 tmpvar_5;
					  tmpvar_5 = impl_low_texture2DLodEXT (_MainTex, tmpvar_4.xy, _MipLevel);
					  color_1 = (tmpvar_3 + tmpvar_5);
					  highp vec4 tmpvar_6;
					  tmpvar_6.z = 0.0;
					  tmpvar_6.xy = (xlv_TEXCOORD0 - _BlurVector);
					  tmpvar_6.w = _MipLevel;
					  lowp vec4 tmpvar_7;
					  tmpvar_7 = impl_low_texture2DLodEXT (_MainTex, tmpvar_6.xy, _MipLevel);
					  color_1 = (color_1 + tmpvar_7);
					  color_1 = (color_1 / 3.0);
					  gl_FragData[0] = color_1;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
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
					#ifdef GL_EXT_shader_texture_lod
					#extension GL_EXT_shader_texture_lod : enable
					#endif
					
					precision highp int;
					uniform 	vec2 _BlurVector;
					uniform 	float _MipLevel;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec2 u_xlat0;
					mediump vec4 u_xlat16_0;
					lowp vec4 u_xlat10_0;
					vec2 u_xlat1;
					lowp vec4 u_xlat10_1;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy + _BlurVector.xy;
					    u_xlat10_0 = textureLod(_MainTex, u_xlat0.xy, _MipLevel);
					    u_xlat10_1 = textureLod(_MainTex, vs_TEXCOORD0.xy, _MipLevel);
					    u_xlat16_0 = u_xlat10_0 + u_xlat10_1;
					    u_xlat1.xy = vs_TEXCOORD0.xy + (-_BlurVector.xy);
					    u_xlat10_1 = textureLod(_MainTex, u_xlat1.xy, _MipLevel);
					    u_xlat16_0 = u_xlat16_0 + u_xlat10_1;
					    SV_Target0 = u_xlat16_0 * vec4(0.333333343, 0.333333343, 0.333333343, 0.333333343);
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
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
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
					#ifdef GL_EXT_shader_texture_lod
					#extension GL_EXT_shader_texture_lod : enable
					#endif
					
					precision highp int;
					uniform 	vec2 _BlurVector;
					uniform 	float _MipLevel;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec2 u_xlat0;
					mediump vec4 u_xlat16_0;
					lowp vec4 u_xlat10_0;
					vec2 u_xlat1;
					lowp vec4 u_xlat10_1;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy + _BlurVector.xy;
					    u_xlat10_0 = textureLod(_MainTex, u_xlat0.xy, _MipLevel);
					    u_xlat10_1 = textureLod(_MainTex, vs_TEXCOORD0.xy, _MipLevel);
					    u_xlat16_0 = u_xlat10_0 + u_xlat10_1;
					    u_xlat1.xy = vs_TEXCOORD0.xy + (-_BlurVector.xy);
					    u_xlat10_1 = textureLod(_MainTex, u_xlat1.xy, _MipLevel);
					    u_xlat16_0 = u_xlat16_0 + u_xlat10_1;
					    SV_Target0 = u_xlat16_0 * vec4(0.333333343, 0.333333343, 0.333333343, 0.333333343);
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
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
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
					#ifdef GL_EXT_shader_texture_lod
					#extension GL_EXT_shader_texture_lod : enable
					#endif
					
					precision highp int;
					uniform 	vec2 _BlurVector;
					uniform 	float _MipLevel;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec2 u_xlat0;
					mediump vec4 u_xlat16_0;
					lowp vec4 u_xlat10_0;
					vec2 u_xlat1;
					lowp vec4 u_xlat10_1;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD0.xy + _BlurVector.xy;
					    u_xlat10_0 = textureLod(_MainTex, u_xlat0.xy, _MipLevel);
					    u_xlat10_1 = textureLod(_MainTex, vs_TEXCOORD0.xy, _MipLevel);
					    u_xlat16_0 = u_xlat10_0 + u_xlat10_1;
					    u_xlat1.xy = vs_TEXCOORD0.xy + (-_BlurVector.xy);
					    u_xlat10_1 = textureLod(_MainTex, u_xlat1.xy, _MipLevel);
					    u_xlat16_0 = u_xlat16_0 + u_xlat10_1;
					    SV_Target0 = u_xlat16_0 * vec4(0.333333343, 0.333333343, 0.333333343, 0.333333343);
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