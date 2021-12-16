Shader "ARBestPractices/Hologram" {
	Properties {
		_SolidColor ("SolidColor", Vector) = (1,1,1,1)
		_Color ("Color", Vector) = (1,1,1,1)
		_Color2 ("Color2", Vector) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Tags { "RenderType" = "Opaque" }
			Blend One One, One One
			ZWrite Off
			Offset -1, -1
			GpuProgramID 20521
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec3 _glesNormal;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp vec3 _WorldSpaceCameraPos;
					uniform highp vec4 _ProjectionParams;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _MainTex_ST;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec3 xlv_TEXCOORD1;
					varying highp vec4 xlv_TEXCOORD2;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 0.0;
					  tmpvar_1.xyz = _glesNormal;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  tmpvar_2 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  highp vec4 o_4;
					  highp vec4 tmpvar_5;
					  tmpvar_5 = (tmpvar_2 * 0.5);
					  highp vec2 tmpvar_6;
					  tmpvar_6.x = tmpvar_5.x;
					  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
					  o_4.xy = (tmpvar_6 + tmpvar_5.w);
					  o_4.zw = tmpvar_2.zw;
					  highp vec4 tmpvar_7;
					  tmpvar_7.w = 1.0;
					  tmpvar_7.xyz = _WorldSpaceCameraPos;
					  highp vec4 tmpvar_8;
					  tmpvar_8.w = 0.0;
					  tmpvar_8.xyz = normalize(((unity_WorldToObject * tmpvar_7).xyz - _glesVertex.xyz));
					  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  gl_Position = tmpvar_2;
					  xlv_TEXCOORD1 = (unity_ObjectToWorld * _glesVertex).xyz;
					  xlv_TEXCOORD2 = o_4;
					  xlv_TEXCOORD3 = (1.0 - clamp (dot (tmpvar_1, tmpvar_8), 0.0, 1.0));
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _Time;
					uniform highp vec4 _ScreenParams;
					uniform highp vec4 _SolidColor;
					uniform highp vec4 _Color;
					uniform highp vec4 _Color2;
					uniform highp float _HologramGlobalIntensity;
					varying highp vec4 xlv_TEXCOORD2;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 color_1;
					  color_1.w = 1.0;
					  color_1.xyz = (_SolidColor.xyz + (mix (_Color, _Color2, vec4(
					    abs(((fract(
					      ((((xlv_TEXCOORD2.xy / xlv_TEXCOORD2.w) * _ScreenParams.xy).y / 5.0) - (_Time.y * 5.0))
					    ) * 2.0) - 1.0))
					  )) * xlv_TEXCOORD3).xyz);
					  color_1.xyz = (color_1.xyz * _HologramGlobalIntensity);
					  gl_FragData[0] = color_1;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec3 _glesNormal;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp vec3 _WorldSpaceCameraPos;
					uniform highp vec4 _ProjectionParams;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _MainTex_ST;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec3 xlv_TEXCOORD1;
					varying highp vec4 xlv_TEXCOORD2;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 0.0;
					  tmpvar_1.xyz = _glesNormal;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  tmpvar_2 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  highp vec4 o_4;
					  highp vec4 tmpvar_5;
					  tmpvar_5 = (tmpvar_2 * 0.5);
					  highp vec2 tmpvar_6;
					  tmpvar_6.x = tmpvar_5.x;
					  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
					  o_4.xy = (tmpvar_6 + tmpvar_5.w);
					  o_4.zw = tmpvar_2.zw;
					  highp vec4 tmpvar_7;
					  tmpvar_7.w = 1.0;
					  tmpvar_7.xyz = _WorldSpaceCameraPos;
					  highp vec4 tmpvar_8;
					  tmpvar_8.w = 0.0;
					  tmpvar_8.xyz = normalize(((unity_WorldToObject * tmpvar_7).xyz - _glesVertex.xyz));
					  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  gl_Position = tmpvar_2;
					  xlv_TEXCOORD1 = (unity_ObjectToWorld * _glesVertex).xyz;
					  xlv_TEXCOORD2 = o_4;
					  xlv_TEXCOORD3 = (1.0 - clamp (dot (tmpvar_1, tmpvar_8), 0.0, 1.0));
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _Time;
					uniform highp vec4 _ScreenParams;
					uniform highp vec4 _SolidColor;
					uniform highp vec4 _Color;
					uniform highp vec4 _Color2;
					uniform highp float _HologramGlobalIntensity;
					varying highp vec4 xlv_TEXCOORD2;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 color_1;
					  color_1.w = 1.0;
					  color_1.xyz = (_SolidColor.xyz + (mix (_Color, _Color2, vec4(
					    abs(((fract(
					      ((((xlv_TEXCOORD2.xy / xlv_TEXCOORD2.w) * _ScreenParams.xy).y / 5.0) - (_Time.y * 5.0))
					    ) * 2.0) - 1.0))
					  )) * xlv_TEXCOORD3).xyz);
					  color_1.xyz = (color_1.xyz * _HologramGlobalIntensity);
					  gl_FragData[0] = color_1;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec3 _glesNormal;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp vec3 _WorldSpaceCameraPos;
					uniform highp vec4 _ProjectionParams;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _MainTex_ST;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec3 xlv_TEXCOORD1;
					varying highp vec4 xlv_TEXCOORD2;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 0.0;
					  tmpvar_1.xyz = _glesNormal;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  tmpvar_2 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  highp vec4 o_4;
					  highp vec4 tmpvar_5;
					  tmpvar_5 = (tmpvar_2 * 0.5);
					  highp vec2 tmpvar_6;
					  tmpvar_6.x = tmpvar_5.x;
					  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
					  o_4.xy = (tmpvar_6 + tmpvar_5.w);
					  o_4.zw = tmpvar_2.zw;
					  highp vec4 tmpvar_7;
					  tmpvar_7.w = 1.0;
					  tmpvar_7.xyz = _WorldSpaceCameraPos;
					  highp vec4 tmpvar_8;
					  tmpvar_8.w = 0.0;
					  tmpvar_8.xyz = normalize(((unity_WorldToObject * tmpvar_7).xyz - _glesVertex.xyz));
					  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  gl_Position = tmpvar_2;
					  xlv_TEXCOORD1 = (unity_ObjectToWorld * _glesVertex).xyz;
					  xlv_TEXCOORD2 = o_4;
					  xlv_TEXCOORD3 = (1.0 - clamp (dot (tmpvar_1, tmpvar_8), 0.0, 1.0));
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _Time;
					uniform highp vec4 _ScreenParams;
					uniform highp vec4 _SolidColor;
					uniform highp vec4 _Color;
					uniform highp vec4 _Color2;
					uniform highp float _HologramGlobalIntensity;
					varying highp vec4 xlv_TEXCOORD2;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 color_1;
					  color_1.w = 1.0;
					  color_1.xyz = (_SolidColor.xyz + (mix (_Color, _Color2, vec4(
					    abs(((fract(
					      ((((xlv_TEXCOORD2.xy / xlv_TEXCOORD2.w) * _ScreenParams.xy).y / 5.0) - (_Time.y * 5.0))
					    ) * 2.0) - 1.0))
					  )) * xlv_TEXCOORD3).xyz);
					  color_1.xyz = (color_1.xyz * _HologramGlobalIntensity);
					  gl_FragData[0] = color_1;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec3 _WorldSpaceCameraPos;
					uniform 	vec4 _ProjectionParams;
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_NORMAL0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD3;
					out highp vec3 vs_TEXCOORD1;
					out highp vec4 vs_TEXCOORD2;
					vec4 u_xlat0;
					vec4 u_xlat1;
					float u_xlat6;
					void main()
					{
					    u_xlat0.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
					    u_xlat0.xyz = u_xlat0.xyz + (-in_POSITION0.xyz);
					    u_xlat6 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat6 = inversesqrt(u_xlat6);
					    u_xlat0.xyz = vec3(u_xlat6) * u_xlat0.xyz;
					    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
					#else
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					#endif
					    vs_TEXCOORD3 = (-u_xlat0.x) + 1.0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    vs_TEXCOORD1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD2.zw = u_xlat0.zw;
					    vs_TEXCOORD2.xy = u_xlat1.zz + u_xlat1.xw;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _ScreenParams;
					uniform 	vec4 _SolidColor;
					uniform 	vec4 _Color;
					uniform 	vec4 _Color2;
					uniform 	float _HologramGlobalIntensity;
					in highp float vs_TEXCOORD3;
					in highp vec4 vs_TEXCOORD2;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					vec3 u_xlat1;
					void main()
					{
					    u_xlat0.x = vs_TEXCOORD2.y / vs_TEXCOORD2.w;
					    u_xlat0.x = u_xlat0.x * _ScreenParams.y;
					    u_xlat1.x = _Time.y * 5.0;
					    u_xlat0.x = u_xlat0.x * 0.200000003 + (-u_xlat1.x);
					    u_xlat0.x = fract(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * 2.0 + -1.0;
					    u_xlat1.xyz = (-_Color.xyz) + _Color2.xyz;
					    u_xlat0.xyz = abs(u_xlat0.xxx) * u_xlat1.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vs_TEXCOORD3) + _SolidColor.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * vec3(_HologramGlobalIntensity);
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec3 _WorldSpaceCameraPos;
					uniform 	vec4 _ProjectionParams;
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_NORMAL0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD3;
					out highp vec3 vs_TEXCOORD1;
					out highp vec4 vs_TEXCOORD2;
					vec4 u_xlat0;
					vec4 u_xlat1;
					float u_xlat6;
					void main()
					{
					    u_xlat0.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
					    u_xlat0.xyz = u_xlat0.xyz + (-in_POSITION0.xyz);
					    u_xlat6 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat6 = inversesqrt(u_xlat6);
					    u_xlat0.xyz = vec3(u_xlat6) * u_xlat0.xyz;
					    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
					#else
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					#endif
					    vs_TEXCOORD3 = (-u_xlat0.x) + 1.0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    vs_TEXCOORD1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD2.zw = u_xlat0.zw;
					    vs_TEXCOORD2.xy = u_xlat1.zz + u_xlat1.xw;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _ScreenParams;
					uniform 	vec4 _SolidColor;
					uniform 	vec4 _Color;
					uniform 	vec4 _Color2;
					uniform 	float _HologramGlobalIntensity;
					in highp float vs_TEXCOORD3;
					in highp vec4 vs_TEXCOORD2;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					vec3 u_xlat1;
					void main()
					{
					    u_xlat0.x = vs_TEXCOORD2.y / vs_TEXCOORD2.w;
					    u_xlat0.x = u_xlat0.x * _ScreenParams.y;
					    u_xlat1.x = _Time.y * 5.0;
					    u_xlat0.x = u_xlat0.x * 0.200000003 + (-u_xlat1.x);
					    u_xlat0.x = fract(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * 2.0 + -1.0;
					    u_xlat1.xyz = (-_Color.xyz) + _Color2.xyz;
					    u_xlat0.xyz = abs(u_xlat0.xxx) * u_xlat1.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vs_TEXCOORD3) + _SolidColor.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * vec3(_HologramGlobalIntensity);
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec3 _WorldSpaceCameraPos;
					uniform 	vec4 _ProjectionParams;
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_NORMAL0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD3;
					out highp vec3 vs_TEXCOORD1;
					out highp vec4 vs_TEXCOORD2;
					vec4 u_xlat0;
					vec4 u_xlat1;
					float u_xlat6;
					void main()
					{
					    u_xlat0.xyz = _WorldSpaceCameraPos.yyy * hlslcc_mtx4x4unity_WorldToObject[1].xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToObject[0].xyz * _WorldSpaceCameraPos.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToObject[2].xyz * _WorldSpaceCameraPos.zzz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToObject[3].xyz;
					    u_xlat0.xyz = u_xlat0.xyz + (-in_POSITION0.xyz);
					    u_xlat6 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat6 = inversesqrt(u_xlat6);
					    u_xlat0.xyz = vec3(u_xlat6) * u_xlat0.xyz;
					    u_xlat0.x = dot(in_NORMAL0.xyz, u_xlat0.xyz);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
					#else
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					#endif
					    vs_TEXCOORD3 = (-u_xlat0.x) + 1.0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    vs_TEXCOORD1.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    gl_Position = u_xlat0;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
					    vs_TEXCOORD2.zw = u_xlat0.zw;
					    vs_TEXCOORD2.xy = u_xlat1.zz + u_xlat1.xw;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _ScreenParams;
					uniform 	vec4 _SolidColor;
					uniform 	vec4 _Color;
					uniform 	vec4 _Color2;
					uniform 	float _HologramGlobalIntensity;
					in highp float vs_TEXCOORD3;
					in highp vec4 vs_TEXCOORD2;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					vec3 u_xlat1;
					void main()
					{
					    u_xlat0.x = vs_TEXCOORD2.y / vs_TEXCOORD2.w;
					    u_xlat0.x = u_xlat0.x * _ScreenParams.y;
					    u_xlat1.x = _Time.y * 5.0;
					    u_xlat0.x = u_xlat0.x * 0.200000003 + (-u_xlat1.x);
					    u_xlat0.x = fract(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * 2.0 + -1.0;
					    u_xlat1.xyz = (-_Color.xyz) + _Color2.xyz;
					    u_xlat0.xyz = abs(u_xlat0.xxx) * u_xlat1.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vs_TEXCOORD3) + _SolidColor.xyz;
					    SV_Target0.xyz = u_xlat0.xyz * vec3(_HologramGlobalIntensity);
					    SV_Target0.w = 1.0;
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