Shader "Unlit/HSBCube" {
	Properties {
		_Hue ("Hue", Range(0, 1)) = 0
	}
	SubShader {
		LOD 100
		Tags { "RenderType" = "Opaque" }
		Pass {
			LOD 100
			Tags { "RenderType" = "Opaque" }
			GpuProgramID 56167
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
					uniform lowp float _Hue;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  lowp vec4 col_1;
					  lowp float v_2;
					  lowp float s_3;
					  highp float tmpvar_4;
					  tmpvar_4 = (1.0 - xlv_TEXCOORD0.x);
					  s_3 = tmpvar_4;
					  highp float tmpvar_5;
					  tmpvar_5 = (1.0 - xlv_TEXCOORD0.y);
					  v_2 = tmpvar_5;
					  lowp vec3 tmpvar_6;
					  tmpvar_6.x = _Hue;
					  tmpvar_6.y = s_3;
					  tmpvar_6.z = v_2;
					  highp vec3 HSV_7;
					  HSV_7 = tmpvar_6;
					  highp vec3 tmpvar_8;
					  tmpvar_8.x = (abs((
					    (HSV_7.x * 6.0)
					   - 3.0)) - 1.0);
					  tmpvar_8.y = (2.0 - abs((
					    (HSV_7.x * 6.0)
					   - 2.0)));
					  tmpvar_8.z = (2.0 - abs((
					    (HSV_7.x * 6.0)
					   - 4.0)));
					  highp vec4 tmpvar_9;
					  tmpvar_9.w = 1.0;
					  tmpvar_9.xyz = (((
					    (clamp (tmpvar_8, 0.0, 1.0) - 1.0)
					   * HSV_7.y) + 1.0) * HSV_7.z);
					  col_1 = tmpvar_9;
					  gl_FragData[0] = col_1;
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
					uniform lowp float _Hue;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  lowp vec4 col_1;
					  lowp float v_2;
					  lowp float s_3;
					  highp float tmpvar_4;
					  tmpvar_4 = (1.0 - xlv_TEXCOORD0.x);
					  s_3 = tmpvar_4;
					  highp float tmpvar_5;
					  tmpvar_5 = (1.0 - xlv_TEXCOORD0.y);
					  v_2 = tmpvar_5;
					  lowp vec3 tmpvar_6;
					  tmpvar_6.x = _Hue;
					  tmpvar_6.y = s_3;
					  tmpvar_6.z = v_2;
					  highp vec3 HSV_7;
					  HSV_7 = tmpvar_6;
					  highp vec3 tmpvar_8;
					  tmpvar_8.x = (abs((
					    (HSV_7.x * 6.0)
					   - 3.0)) - 1.0);
					  tmpvar_8.y = (2.0 - abs((
					    (HSV_7.x * 6.0)
					   - 2.0)));
					  tmpvar_8.z = (2.0 - abs((
					    (HSV_7.x * 6.0)
					   - 4.0)));
					  highp vec4 tmpvar_9;
					  tmpvar_9.w = 1.0;
					  tmpvar_9.xyz = (((
					    (clamp (tmpvar_8, 0.0, 1.0) - 1.0)
					   * HSV_7.y) + 1.0) * HSV_7.z);
					  col_1 = tmpvar_9;
					  gl_FragData[0] = col_1;
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
					uniform lowp float _Hue;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  lowp vec4 col_1;
					  lowp float v_2;
					  lowp float s_3;
					  highp float tmpvar_4;
					  tmpvar_4 = (1.0 - xlv_TEXCOORD0.x);
					  s_3 = tmpvar_4;
					  highp float tmpvar_5;
					  tmpvar_5 = (1.0 - xlv_TEXCOORD0.y);
					  v_2 = tmpvar_5;
					  lowp vec3 tmpvar_6;
					  tmpvar_6.x = _Hue;
					  tmpvar_6.y = s_3;
					  tmpvar_6.z = v_2;
					  highp vec3 HSV_7;
					  HSV_7 = tmpvar_6;
					  highp vec3 tmpvar_8;
					  tmpvar_8.x = (abs((
					    (HSV_7.x * 6.0)
					   - 3.0)) - 1.0);
					  tmpvar_8.y = (2.0 - abs((
					    (HSV_7.x * 6.0)
					   - 2.0)));
					  tmpvar_8.z = (2.0 - abs((
					    (HSV_7.x * 6.0)
					   - 4.0)));
					  highp vec4 tmpvar_9;
					  tmpvar_9.w = 1.0;
					  tmpvar_9.xyz = (((
					    (clamp (tmpvar_8, 0.0, 1.0) - 1.0)
					   * HSV_7.y) + 1.0) * HSV_7.z);
					  col_1 = tmpvar_9;
					  gl_FragData[0] = col_1;
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
					
					precision highp int;
					uniform 	mediump float _Hue;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec2 u_xlat1;
					void main()
					{
					    u_xlat16_0.xyz = vec3(_Hue) * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -2.0, -4.0);
					    u_xlat16_0.xyz = abs(u_xlat16_0.xyz) * vec3(1.0, -1.0, -1.0) + vec3(-1.0, 2.0, 2.0);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_0.xyz = min(max(u_xlat16_0.xyz, 0.0), 1.0);
					#else
					    u_xlat16_0.xyz = clamp(u_xlat16_0.xyz, 0.0, 1.0);
					#endif
					    u_xlat16_0.xyz = u_xlat16_0.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat1.xy = (-vs_TEXCOORD0.xy) + vec2(1.0, 1.0);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat1.xxx + vec3(1.0, 1.0, 1.0);
					    u_xlat0.xyz = u_xlat1.yyy * u_xlat0.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					
					precision highp int;
					uniform 	mediump float _Hue;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec2 u_xlat1;
					void main()
					{
					    u_xlat16_0.xyz = vec3(_Hue) * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -2.0, -4.0);
					    u_xlat16_0.xyz = abs(u_xlat16_0.xyz) * vec3(1.0, -1.0, -1.0) + vec3(-1.0, 2.0, 2.0);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_0.xyz = min(max(u_xlat16_0.xyz, 0.0), 1.0);
					#else
					    u_xlat16_0.xyz = clamp(u_xlat16_0.xyz, 0.0, 1.0);
					#endif
					    u_xlat16_0.xyz = u_xlat16_0.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat1.xy = (-vs_TEXCOORD0.xy) + vec2(1.0, 1.0);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat1.xxx + vec3(1.0, 1.0, 1.0);
					    u_xlat0.xyz = u_xlat1.yyy * u_xlat0.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					
					precision highp int;
					uniform 	mediump float _Hue;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec2 u_xlat1;
					void main()
					{
					    u_xlat16_0.xyz = vec3(_Hue) * vec3(6.0, 6.0, 6.0) + vec3(-3.0, -2.0, -4.0);
					    u_xlat16_0.xyz = abs(u_xlat16_0.xyz) * vec3(1.0, -1.0, -1.0) + vec3(-1.0, 2.0, 2.0);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_0.xyz = min(max(u_xlat16_0.xyz, 0.0), 1.0);
					#else
					    u_xlat16_0.xyz = clamp(u_xlat16_0.xyz, 0.0, 1.0);
					#endif
					    u_xlat16_0.xyz = u_xlat16_0.xyz + vec3(-1.0, -1.0, -1.0);
					    u_xlat1.xy = (-vs_TEXCOORD0.xy) + vec2(1.0, 1.0);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat1.xxx + vec3(1.0, 1.0, 1.0);
					    u_xlat0.xyz = u_xlat1.yyy * u_xlat0.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
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