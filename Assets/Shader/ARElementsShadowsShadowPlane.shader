Shader "ARElements/Shadows/ShadowPlane" {
	Properties {
		_Color ("Color", Vector) = (1,1,1,1)
		_Bias ("Bias", Range(0, 0.2)) = 0.01
		_EdgeInset ("Edge Inset", Range(0, 0.5)) = 0.1
		_FalloffStrength ("Falloff Strength", Range(1, 7)) = 4
	}
	SubShader {
		LOD 100
		Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			LOD 100
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 64449
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp mat4 _CustomShadowMatrix;
					uniform highp mat4 _CustomShadowWorldToCamera;
					uniform highp float _CustomShadowFarClipPlane;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp float xlv_TEXCOORD1;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec2 xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = _glesVertex.xyz;
					  highp vec4 tmpvar_2;
					  tmpvar_2 = (unity_ObjectToWorld * _glesVertex);
					  highp vec4 tmpvar_3;
					  tmpvar_3 = (_CustomShadowMatrix * tmpvar_2);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					  xlv_TEXCOORD0 = tmpvar_2;
					  xlv_TEXCOORD1 = (clamp (-(
					    (_CustomShadowWorldToCamera * tmpvar_2)
					  .z), 0.0, _CustomShadowFarClipPlane) / _CustomShadowFarClipPlane);
					  xlv_TEXCOORD2 = (((tmpvar_3 / tmpvar_3.w).xyz + 1.0) / 2.0).xy;
					  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _Color;
					uniform highp float _Bias;
					uniform highp float _EdgeInset;
					uniform highp int _FalloffStrength;
					uniform sampler2D _CustomShadowMap;
					varying highp float xlv_TEXCOORD1;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec2 xlv_TEXCOORD3;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp float weight_2;
					  highp vec4 shadowMapValue_3;
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_CustomShadowMap, xlv_TEXCOORD2);
					  shadowMapValue_3 = tmpvar_4;
					  weight_2 = (float((xlv_TEXCOORD1 >= 
					    (shadowMapValue_3.x + _Bias)
					  )) * shadowMapValue_3.y);
					  highp float tmpvar_5;
					  highp float tmpvar_6;
					  tmpvar_6 = (1.0 - _EdgeInset);
					  tmpvar_5 = clamp (((xlv_TEXCOORD3.x - 1.0) / (tmpvar_6 - 1.0)), 0.0, 1.0);
					  weight_2 = (pow (weight_2, float(_FalloffStrength)) * (tmpvar_5 * (tmpvar_5 * 
					    (3.0 - (2.0 * tmpvar_5))
					  )));
					  highp vec2 tmpvar_7;
					  highp vec2 tmpvar_8;
					  tmpvar_8 = clamp ((xlv_TEXCOORD2 / vec2(_EdgeInset)), 0.0, 1.0);
					  tmpvar_7 = (tmpvar_8 * (tmpvar_8 * (3.0 - 
					    (2.0 * tmpvar_8)
					  )));
					  weight_2 = (weight_2 * (tmpvar_7.x * tmpvar_7.y));
					  highp vec2 tmpvar_9;
					  highp vec2 tmpvar_10;
					  tmpvar_10 = clamp (((xlv_TEXCOORD2 - vec2(1.0, 1.0)) / (vec2(tmpvar_6) - vec2(1.0, 1.0))), 0.0, 1.0);
					  tmpvar_9 = (tmpvar_10 * (tmpvar_10 * (3.0 - 
					    (2.0 * tmpvar_10)
					  )));
					  weight_2 = (weight_2 * (tmpvar_9.x * tmpvar_9.y));
					  highp vec4 tmpvar_11;
					  tmpvar_11.xyz = _Color.xyz;
					  tmpvar_11.w = (weight_2 * _Color.w);
					  tmpvar_1 = tmpvar_11;
					  gl_FragData[0] = tmpvar_1;
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
					uniform highp mat4 _CustomShadowMatrix;
					uniform highp mat4 _CustomShadowWorldToCamera;
					uniform highp float _CustomShadowFarClipPlane;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp float xlv_TEXCOORD1;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec2 xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = _glesVertex.xyz;
					  highp vec4 tmpvar_2;
					  tmpvar_2 = (unity_ObjectToWorld * _glesVertex);
					  highp vec4 tmpvar_3;
					  tmpvar_3 = (_CustomShadowMatrix * tmpvar_2);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					  xlv_TEXCOORD0 = tmpvar_2;
					  xlv_TEXCOORD1 = (clamp (-(
					    (_CustomShadowWorldToCamera * tmpvar_2)
					  .z), 0.0, _CustomShadowFarClipPlane) / _CustomShadowFarClipPlane);
					  xlv_TEXCOORD2 = (((tmpvar_3 / tmpvar_3.w).xyz + 1.0) / 2.0).xy;
					  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _Color;
					uniform highp float _Bias;
					uniform highp float _EdgeInset;
					uniform highp int _FalloffStrength;
					uniform sampler2D _CustomShadowMap;
					varying highp float xlv_TEXCOORD1;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec2 xlv_TEXCOORD3;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp float weight_2;
					  highp vec4 shadowMapValue_3;
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_CustomShadowMap, xlv_TEXCOORD2);
					  shadowMapValue_3 = tmpvar_4;
					  weight_2 = (float((xlv_TEXCOORD1 >= 
					    (shadowMapValue_3.x + _Bias)
					  )) * shadowMapValue_3.y);
					  highp float tmpvar_5;
					  highp float tmpvar_6;
					  tmpvar_6 = (1.0 - _EdgeInset);
					  tmpvar_5 = clamp (((xlv_TEXCOORD3.x - 1.0) / (tmpvar_6 - 1.0)), 0.0, 1.0);
					  weight_2 = (pow (weight_2, float(_FalloffStrength)) * (tmpvar_5 * (tmpvar_5 * 
					    (3.0 - (2.0 * tmpvar_5))
					  )));
					  highp vec2 tmpvar_7;
					  highp vec2 tmpvar_8;
					  tmpvar_8 = clamp ((xlv_TEXCOORD2 / vec2(_EdgeInset)), 0.0, 1.0);
					  tmpvar_7 = (tmpvar_8 * (tmpvar_8 * (3.0 - 
					    (2.0 * tmpvar_8)
					  )));
					  weight_2 = (weight_2 * (tmpvar_7.x * tmpvar_7.y));
					  highp vec2 tmpvar_9;
					  highp vec2 tmpvar_10;
					  tmpvar_10 = clamp (((xlv_TEXCOORD2 - vec2(1.0, 1.0)) / (vec2(tmpvar_6) - vec2(1.0, 1.0))), 0.0, 1.0);
					  tmpvar_9 = (tmpvar_10 * (tmpvar_10 * (3.0 - 
					    (2.0 * tmpvar_10)
					  )));
					  weight_2 = (weight_2 * (tmpvar_9.x * tmpvar_9.y));
					  highp vec4 tmpvar_11;
					  tmpvar_11.xyz = _Color.xyz;
					  tmpvar_11.w = (weight_2 * _Color.w);
					  tmpvar_1 = tmpvar_11;
					  gl_FragData[0] = tmpvar_1;
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
					uniform highp mat4 _CustomShadowMatrix;
					uniform highp mat4 _CustomShadowWorldToCamera;
					uniform highp float _CustomShadowFarClipPlane;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp float xlv_TEXCOORD1;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec2 xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = _glesVertex.xyz;
					  highp vec4 tmpvar_2;
					  tmpvar_2 = (unity_ObjectToWorld * _glesVertex);
					  highp vec4 tmpvar_3;
					  tmpvar_3 = (_CustomShadowMatrix * tmpvar_2);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					  xlv_TEXCOORD0 = tmpvar_2;
					  xlv_TEXCOORD1 = (clamp (-(
					    (_CustomShadowWorldToCamera * tmpvar_2)
					  .z), 0.0, _CustomShadowFarClipPlane) / _CustomShadowFarClipPlane);
					  xlv_TEXCOORD2 = (((tmpvar_3 / tmpvar_3.w).xyz + 1.0) / 2.0).xy;
					  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _Color;
					uniform highp float _Bias;
					uniform highp float _EdgeInset;
					uniform highp int _FalloffStrength;
					uniform sampler2D _CustomShadowMap;
					varying highp float xlv_TEXCOORD1;
					varying highp vec2 xlv_TEXCOORD2;
					varying highp vec2 xlv_TEXCOORD3;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp float weight_2;
					  highp vec4 shadowMapValue_3;
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_CustomShadowMap, xlv_TEXCOORD2);
					  shadowMapValue_3 = tmpvar_4;
					  weight_2 = (float((xlv_TEXCOORD1 >= 
					    (shadowMapValue_3.x + _Bias)
					  )) * shadowMapValue_3.y);
					  highp float tmpvar_5;
					  highp float tmpvar_6;
					  tmpvar_6 = (1.0 - _EdgeInset);
					  tmpvar_5 = clamp (((xlv_TEXCOORD3.x - 1.0) / (tmpvar_6 - 1.0)), 0.0, 1.0);
					  weight_2 = (pow (weight_2, float(_FalloffStrength)) * (tmpvar_5 * (tmpvar_5 * 
					    (3.0 - (2.0 * tmpvar_5))
					  )));
					  highp vec2 tmpvar_7;
					  highp vec2 tmpvar_8;
					  tmpvar_8 = clamp ((xlv_TEXCOORD2 / vec2(_EdgeInset)), 0.0, 1.0);
					  tmpvar_7 = (tmpvar_8 * (tmpvar_8 * (3.0 - 
					    (2.0 * tmpvar_8)
					  )));
					  weight_2 = (weight_2 * (tmpvar_7.x * tmpvar_7.y));
					  highp vec2 tmpvar_9;
					  highp vec2 tmpvar_10;
					  tmpvar_10 = clamp (((xlv_TEXCOORD2 - vec2(1.0, 1.0)) / (vec2(tmpvar_6) - vec2(1.0, 1.0))), 0.0, 1.0);
					  tmpvar_9 = (tmpvar_10 * (tmpvar_10 * (3.0 - 
					    (2.0 * tmpvar_10)
					  )));
					  weight_2 = (weight_2 * (tmpvar_9.x * tmpvar_9.y));
					  highp vec4 tmpvar_11;
					  tmpvar_11.xyz = _Color.xyz;
					  tmpvar_11.w = (weight_2 * _Color.w);
					  tmpvar_1 = tmpvar_11;
					  gl_FragData[0] = tmpvar_1;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 hlslcc_mtx4x4_CustomShadowMatrix[4];
					uniform 	vec4 hlslcc_mtx4x4_CustomShadowWorldToCamera[4];
					uniform 	float _CustomShadowFarClipPlane;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec4 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec2 vs_TEXCOORD2;
					out highp vec2 vs_TEXCOORD3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0 = u_xlat0;
					    u_xlat1.x = u_xlat0.y * hlslcc_mtx4x4_CustomShadowWorldToCamera[1].z;
					    u_xlat1.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[0].z * u_xlat0.x + u_xlat1.x;
					    u_xlat1.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[2].z * u_xlat0.z + u_xlat1.x;
					    u_xlat1.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[3].z * u_xlat0.w + u_xlat1.x;
					    u_xlat1.x = max((-u_xlat1.x), 0.0);
					    u_xlat1.x = min(u_xlat1.x, _CustomShadowFarClipPlane);
					    vs_TEXCOORD1 = u_xlat1.x / _CustomShadowFarClipPlane;
					    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_CustomShadowMatrix[1].xyw;
					    u_xlat1.xyz = hlslcc_mtx4x4_CustomShadowMatrix[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4_CustomShadowMatrix[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4_CustomShadowMatrix[3].xyw * u_xlat0.www + u_xlat0.xyz;
					    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
					    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
					    vs_TEXCOORD2.xy = u_xlat0.xy * vec2(0.5, 0.5);
					    vs_TEXCOORD3.xy = in_TEXCOORD0.xy;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Color;
					uniform 	float _Bias;
					uniform 	float _EdgeInset;
					uniform 	int _FalloffStrength;
					uniform lowp sampler2D _CustomShadowMap;
					in highp float vs_TEXCOORD1;
					in highp vec2 vs_TEXCOORD2;
					in highp vec2 vs_TEXCOORD3;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					lowp vec2 u_xlat10_0;
					bool u_xlatb0;
					vec2 u_xlat1;
					vec3 u_xlat2;
					float u_xlat4;
					float u_xlat6;
					void main()
					{
					    u_xlat10_0.xy = texture(_CustomShadowMap, vs_TEXCOORD2.xy).xy;
					    u_xlat0.x = u_xlat10_0.x + _Bias;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb0 = !!(vs_TEXCOORD1>=u_xlat0.x);
					#else
					    u_xlatb0 = vs_TEXCOORD1>=u_xlat0.x;
					#endif
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat0.x = u_xlat10_0.y * u_xlat0.x;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat2.x = float(_FalloffStrength);
					    u_xlat0.x = u_xlat0.x * u_xlat2.x;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat2.x = vs_TEXCOORD3.x + -1.0;
					    u_xlat4 = float(1.0) / (-_EdgeInset);
					    u_xlat2.x = u_xlat4 * u_xlat2.x;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.x = min(max(u_xlat2.x, 0.0), 1.0);
					#else
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					#endif
					    u_xlat6 = u_xlat2.x * -2.0 + 3.0;
					    u_xlat2.x = u_xlat2.x * u_xlat2.x;
					    u_xlat2.x = u_xlat2.x * u_xlat6;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x;
					    u_xlat2.x = float(1.0) / _EdgeInset;
					    u_xlat2.xz = vec2(u_xlat2.x * vs_TEXCOORD2.x, u_xlat2.x * vs_TEXCOORD2.y);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.xz = min(max(u_xlat2.xz, 0.0), 1.0);
					#else
					    u_xlat2.xz = clamp(u_xlat2.xz, 0.0, 1.0);
					#endif
					    u_xlat1.xy = u_xlat2.xz * vec2(-2.0, -2.0) + vec2(3.0, 3.0);
					    u_xlat2.xz = u_xlat2.xz * u_xlat2.xz;
					    u_xlat2.xz = u_xlat2.xz * u_xlat1.xy;
					    u_xlat2.x = u_xlat2.z * u_xlat2.x;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x;
					    u_xlat2.xz = vec2(vs_TEXCOORD2.x + float(-1.0), vs_TEXCOORD2.y + float(-1.0));
					    u_xlat2.xy = vec2(u_xlat4) * u_xlat2.xz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.xy = min(max(u_xlat2.xy, 0.0), 1.0);
					#else
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					#endif
					    u_xlat1.xy = u_xlat2.xy * vec2(-2.0, -2.0) + vec2(3.0, 3.0);
					    u_xlat2.xy = u_xlat2.xy * u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * u_xlat1.xy;
					    u_xlat2.x = u_xlat2.y * u_xlat2.x;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x;
					    u_xlat0.w = u_xlat0.x * _Color.w;
					    u_xlat0.xyz = _Color.xyz;
					    SV_Target0 = u_xlat0;
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
					uniform 	vec4 hlslcc_mtx4x4_CustomShadowMatrix[4];
					uniform 	vec4 hlslcc_mtx4x4_CustomShadowWorldToCamera[4];
					uniform 	float _CustomShadowFarClipPlane;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec4 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec2 vs_TEXCOORD2;
					out highp vec2 vs_TEXCOORD3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0 = u_xlat0;
					    u_xlat1.x = u_xlat0.y * hlslcc_mtx4x4_CustomShadowWorldToCamera[1].z;
					    u_xlat1.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[0].z * u_xlat0.x + u_xlat1.x;
					    u_xlat1.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[2].z * u_xlat0.z + u_xlat1.x;
					    u_xlat1.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[3].z * u_xlat0.w + u_xlat1.x;
					    u_xlat1.x = max((-u_xlat1.x), 0.0);
					    u_xlat1.x = min(u_xlat1.x, _CustomShadowFarClipPlane);
					    vs_TEXCOORD1 = u_xlat1.x / _CustomShadowFarClipPlane;
					    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_CustomShadowMatrix[1].xyw;
					    u_xlat1.xyz = hlslcc_mtx4x4_CustomShadowMatrix[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4_CustomShadowMatrix[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4_CustomShadowMatrix[3].xyw * u_xlat0.www + u_xlat0.xyz;
					    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
					    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
					    vs_TEXCOORD2.xy = u_xlat0.xy * vec2(0.5, 0.5);
					    vs_TEXCOORD3.xy = in_TEXCOORD0.xy;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Color;
					uniform 	float _Bias;
					uniform 	float _EdgeInset;
					uniform 	int _FalloffStrength;
					uniform lowp sampler2D _CustomShadowMap;
					in highp float vs_TEXCOORD1;
					in highp vec2 vs_TEXCOORD2;
					in highp vec2 vs_TEXCOORD3;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					lowp vec2 u_xlat10_0;
					bool u_xlatb0;
					vec2 u_xlat1;
					vec3 u_xlat2;
					float u_xlat4;
					float u_xlat6;
					void main()
					{
					    u_xlat10_0.xy = texture(_CustomShadowMap, vs_TEXCOORD2.xy).xy;
					    u_xlat0.x = u_xlat10_0.x + _Bias;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb0 = !!(vs_TEXCOORD1>=u_xlat0.x);
					#else
					    u_xlatb0 = vs_TEXCOORD1>=u_xlat0.x;
					#endif
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat0.x = u_xlat10_0.y * u_xlat0.x;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat2.x = float(_FalloffStrength);
					    u_xlat0.x = u_xlat0.x * u_xlat2.x;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat2.x = vs_TEXCOORD3.x + -1.0;
					    u_xlat4 = float(1.0) / (-_EdgeInset);
					    u_xlat2.x = u_xlat4 * u_xlat2.x;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.x = min(max(u_xlat2.x, 0.0), 1.0);
					#else
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					#endif
					    u_xlat6 = u_xlat2.x * -2.0 + 3.0;
					    u_xlat2.x = u_xlat2.x * u_xlat2.x;
					    u_xlat2.x = u_xlat2.x * u_xlat6;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x;
					    u_xlat2.x = float(1.0) / _EdgeInset;
					    u_xlat2.xz = vec2(u_xlat2.x * vs_TEXCOORD2.x, u_xlat2.x * vs_TEXCOORD2.y);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.xz = min(max(u_xlat2.xz, 0.0), 1.0);
					#else
					    u_xlat2.xz = clamp(u_xlat2.xz, 0.0, 1.0);
					#endif
					    u_xlat1.xy = u_xlat2.xz * vec2(-2.0, -2.0) + vec2(3.0, 3.0);
					    u_xlat2.xz = u_xlat2.xz * u_xlat2.xz;
					    u_xlat2.xz = u_xlat2.xz * u_xlat1.xy;
					    u_xlat2.x = u_xlat2.z * u_xlat2.x;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x;
					    u_xlat2.xz = vec2(vs_TEXCOORD2.x + float(-1.0), vs_TEXCOORD2.y + float(-1.0));
					    u_xlat2.xy = vec2(u_xlat4) * u_xlat2.xz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.xy = min(max(u_xlat2.xy, 0.0), 1.0);
					#else
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					#endif
					    u_xlat1.xy = u_xlat2.xy * vec2(-2.0, -2.0) + vec2(3.0, 3.0);
					    u_xlat2.xy = u_xlat2.xy * u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * u_xlat1.xy;
					    u_xlat2.x = u_xlat2.y * u_xlat2.x;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x;
					    u_xlat0.w = u_xlat0.x * _Color.w;
					    u_xlat0.xyz = _Color.xyz;
					    SV_Target0 = u_xlat0;
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
					uniform 	vec4 hlslcc_mtx4x4_CustomShadowMatrix[4];
					uniform 	vec4 hlslcc_mtx4x4_CustomShadowWorldToCamera[4];
					uniform 	float _CustomShadowFarClipPlane;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec4 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec2 vs_TEXCOORD2;
					out highp vec2 vs_TEXCOORD3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
					    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    vs_TEXCOORD0 = u_xlat0;
					    u_xlat1.x = u_xlat0.y * hlslcc_mtx4x4_CustomShadowWorldToCamera[1].z;
					    u_xlat1.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[0].z * u_xlat0.x + u_xlat1.x;
					    u_xlat1.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[2].z * u_xlat0.z + u_xlat1.x;
					    u_xlat1.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[3].z * u_xlat0.w + u_xlat1.x;
					    u_xlat1.x = max((-u_xlat1.x), 0.0);
					    u_xlat1.x = min(u_xlat1.x, _CustomShadowFarClipPlane);
					    vs_TEXCOORD1 = u_xlat1.x / _CustomShadowFarClipPlane;
					    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_CustomShadowMatrix[1].xyw;
					    u_xlat1.xyz = hlslcc_mtx4x4_CustomShadowMatrix[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4_CustomShadowMatrix[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4_CustomShadowMatrix[3].xyw * u_xlat0.www + u_xlat0.xyz;
					    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
					    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
					    vs_TEXCOORD2.xy = u_xlat0.xy * vec2(0.5, 0.5);
					    vs_TEXCOORD3.xy = in_TEXCOORD0.xy;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Color;
					uniform 	float _Bias;
					uniform 	float _EdgeInset;
					uniform 	int _FalloffStrength;
					uniform lowp sampler2D _CustomShadowMap;
					in highp float vs_TEXCOORD1;
					in highp vec2 vs_TEXCOORD2;
					in highp vec2 vs_TEXCOORD3;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					lowp vec2 u_xlat10_0;
					bool u_xlatb0;
					vec2 u_xlat1;
					vec3 u_xlat2;
					float u_xlat4;
					float u_xlat6;
					void main()
					{
					    u_xlat10_0.xy = texture(_CustomShadowMap, vs_TEXCOORD2.xy).xy;
					    u_xlat0.x = u_xlat10_0.x + _Bias;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb0 = !!(vs_TEXCOORD1>=u_xlat0.x);
					#else
					    u_xlatb0 = vs_TEXCOORD1>=u_xlat0.x;
					#endif
					    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
					    u_xlat0.x = u_xlat10_0.y * u_xlat0.x;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat2.x = float(_FalloffStrength);
					    u_xlat0.x = u_xlat0.x * u_xlat2.x;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat2.x = vs_TEXCOORD3.x + -1.0;
					    u_xlat4 = float(1.0) / (-_EdgeInset);
					    u_xlat2.x = u_xlat4 * u_xlat2.x;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.x = min(max(u_xlat2.x, 0.0), 1.0);
					#else
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					#endif
					    u_xlat6 = u_xlat2.x * -2.0 + 3.0;
					    u_xlat2.x = u_xlat2.x * u_xlat2.x;
					    u_xlat2.x = u_xlat2.x * u_xlat6;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x;
					    u_xlat2.x = float(1.0) / _EdgeInset;
					    u_xlat2.xz = vec2(u_xlat2.x * vs_TEXCOORD2.x, u_xlat2.x * vs_TEXCOORD2.y);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.xz = min(max(u_xlat2.xz, 0.0), 1.0);
					#else
					    u_xlat2.xz = clamp(u_xlat2.xz, 0.0, 1.0);
					#endif
					    u_xlat1.xy = u_xlat2.xz * vec2(-2.0, -2.0) + vec2(3.0, 3.0);
					    u_xlat2.xz = u_xlat2.xz * u_xlat2.xz;
					    u_xlat2.xz = u_xlat2.xz * u_xlat1.xy;
					    u_xlat2.x = u_xlat2.z * u_xlat2.x;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x;
					    u_xlat2.xz = vec2(vs_TEXCOORD2.x + float(-1.0), vs_TEXCOORD2.y + float(-1.0));
					    u_xlat2.xy = vec2(u_xlat4) * u_xlat2.xz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.xy = min(max(u_xlat2.xy, 0.0), 1.0);
					#else
					    u_xlat2.xy = clamp(u_xlat2.xy, 0.0, 1.0);
					#endif
					    u_xlat1.xy = u_xlat2.xy * vec2(-2.0, -2.0) + vec2(3.0, 3.0);
					    u_xlat2.xy = u_xlat2.xy * u_xlat2.xy;
					    u_xlat2.xy = u_xlat2.xy * u_xlat1.xy;
					    u_xlat2.x = u_xlat2.y * u_xlat2.x;
					    u_xlat0.x = u_xlat2.x * u_xlat0.x;
					    u_xlat0.w = u_xlat0.x * _Color.w;
					    u_xlat0.xyz = _Color.xyz;
					    SV_Target0 = u_xlat0;
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