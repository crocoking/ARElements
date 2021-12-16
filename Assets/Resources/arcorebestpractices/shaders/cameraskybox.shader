Shader "ARBestPractices/CameraSkybox" {
	Properties {
		[Gamma] _Exposure ("Exposure", Range(0, 8)) = 1
		_Rotation ("Rotation", Range(0, 360)) = 0
		[NoScaleOffset] _MainTex ("Camera Image", 2D) = "white" {}
	}
	SubShader {
		Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZWrite Off
			Cull Off
			GpuProgramID 33157
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp float _Rotation;
					varying highp vec3 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1 = _glesVertex;
					  highp float tmpvar_2;
					  tmpvar_2 = ((_Rotation * 3.141593) / 180.0);
					  highp float tmpvar_3;
					  tmpvar_3 = sin(tmpvar_2);
					  highp float tmpvar_4;
					  tmpvar_4 = cos(tmpvar_2);
					  highp mat2 tmpvar_5;
					  tmpvar_5[0].x = tmpvar_4;
					  tmpvar_5[0].y = tmpvar_3;
					  tmpvar_5[1].x = -(tmpvar_3);
					  tmpvar_5[1].y = tmpvar_4;
					  highp vec3 tmpvar_6;
					  tmpvar_6.xy = (tmpvar_5 * _glesVertex.xz);
					  tmpvar_6.z = tmpvar_1.y;
					  highp vec4 tmpvar_7;
					  tmpvar_7.w = 1.0;
					  tmpvar_7.xyz = tmpvar_6.xzy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_7));
					  xlv_TEXCOORD0 = tmpvar_1.xyz;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform mediump vec4 _MainTex_HDR;
					uniform mediump float _Exposure;
					varying highp vec3 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec3 color_1;
					  highp vec4 texSample_2;
					  highp vec2 tmpvar_3;
					  tmpvar_3 = fract(xlv_TEXCOORD0.xy);
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
					  texSample_2 = tmpvar_4;
					  mediump vec3 tmpvar_5;
					  mediump vec4 data_6;
					  data_6 = texSample_2;
					  tmpvar_5 = ((_MainTex_HDR.x * (
					    (_MainTex_HDR.w * (data_6.w - 1.0))
					   + 1.0)) * data_6.xyz);
					  color_1 = tmpvar_5;
					  color_1 = (color_1 * _Exposure);
					  highp vec4 tmpvar_7;
					  tmpvar_7.w = 1.0;
					  tmpvar_7.xyz = color_1;
					  gl_FragData[0] = tmpvar_7;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp float _Rotation;
					varying highp vec3 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1 = _glesVertex;
					  highp float tmpvar_2;
					  tmpvar_2 = ((_Rotation * 3.141593) / 180.0);
					  highp float tmpvar_3;
					  tmpvar_3 = sin(tmpvar_2);
					  highp float tmpvar_4;
					  tmpvar_4 = cos(tmpvar_2);
					  highp mat2 tmpvar_5;
					  tmpvar_5[0].x = tmpvar_4;
					  tmpvar_5[0].y = tmpvar_3;
					  tmpvar_5[1].x = -(tmpvar_3);
					  tmpvar_5[1].y = tmpvar_4;
					  highp vec3 tmpvar_6;
					  tmpvar_6.xy = (tmpvar_5 * _glesVertex.xz);
					  tmpvar_6.z = tmpvar_1.y;
					  highp vec4 tmpvar_7;
					  tmpvar_7.w = 1.0;
					  tmpvar_7.xyz = tmpvar_6.xzy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_7));
					  xlv_TEXCOORD0 = tmpvar_1.xyz;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform mediump vec4 _MainTex_HDR;
					uniform mediump float _Exposure;
					varying highp vec3 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec3 color_1;
					  highp vec4 texSample_2;
					  highp vec2 tmpvar_3;
					  tmpvar_3 = fract(xlv_TEXCOORD0.xy);
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
					  texSample_2 = tmpvar_4;
					  mediump vec3 tmpvar_5;
					  mediump vec4 data_6;
					  data_6 = texSample_2;
					  tmpvar_5 = ((_MainTex_HDR.x * (
					    (_MainTex_HDR.w * (data_6.w - 1.0))
					   + 1.0)) * data_6.xyz);
					  color_1 = tmpvar_5;
					  color_1 = (color_1 * _Exposure);
					  highp vec4 tmpvar_7;
					  tmpvar_7.w = 1.0;
					  tmpvar_7.xyz = color_1;
					  gl_FragData[0] = tmpvar_7;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp float _Rotation;
					varying highp vec3 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1 = _glesVertex;
					  highp float tmpvar_2;
					  tmpvar_2 = ((_Rotation * 3.141593) / 180.0);
					  highp float tmpvar_3;
					  tmpvar_3 = sin(tmpvar_2);
					  highp float tmpvar_4;
					  tmpvar_4 = cos(tmpvar_2);
					  highp mat2 tmpvar_5;
					  tmpvar_5[0].x = tmpvar_4;
					  tmpvar_5[0].y = tmpvar_3;
					  tmpvar_5[1].x = -(tmpvar_3);
					  tmpvar_5[1].y = tmpvar_4;
					  highp vec3 tmpvar_6;
					  tmpvar_6.xy = (tmpvar_5 * _glesVertex.xz);
					  tmpvar_6.z = tmpvar_1.y;
					  highp vec4 tmpvar_7;
					  tmpvar_7.w = 1.0;
					  tmpvar_7.xyz = tmpvar_6.xzy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_7));
					  xlv_TEXCOORD0 = tmpvar_1.xyz;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform mediump vec4 _MainTex_HDR;
					uniform mediump float _Exposure;
					varying highp vec3 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec3 color_1;
					  highp vec4 texSample_2;
					  highp vec2 tmpvar_3;
					  tmpvar_3 = fract(xlv_TEXCOORD0.xy);
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
					  texSample_2 = tmpvar_4;
					  mediump vec3 tmpvar_5;
					  mediump vec4 data_6;
					  data_6 = texSample_2;
					  tmpvar_5 = ((_MainTex_HDR.x * (
					    (_MainTex_HDR.w * (data_6.w - 1.0))
					   + 1.0)) * data_6.xyz);
					  color_1 = tmpvar_5;
					  color_1 = (color_1 * _Exposure);
					  highp vec4 tmpvar_7;
					  tmpvar_7.w = 1.0;
					  tmpvar_7.xyz = color_1;
					  gl_FragData[0] = tmpvar_7;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	float _Rotation;
					in highp vec4 in_POSITION0;
					out highp vec3 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec3 u_xlat2;
					float u_xlat3;
					void main()
					{
					    u_xlat0.x = _Rotation * 0.0174532942;
					    u_xlat1.x = cos(u_xlat0.x);
					    u_xlat0.x = sin(u_xlat0.x);
					    u_xlat2.x = (-u_xlat0.x);
					    u_xlat2.y = u_xlat1.x;
					    u_xlat2.z = u_xlat0.x;
					    u_xlat0.x = dot(u_xlat2.zy, in_POSITION0.xz);
					    u_xlat3 = dot(u_xlat2.yx, in_POSITION0.xz);
					    u_xlat1 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * vec4(u_xlat3) + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xyz = in_POSITION0.xyz;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump vec4 _MainTex_HDR;
					uniform 	mediump float _Exposure;
					uniform lowp sampler2D _MainTex;
					in highp vec3 vs_TEXCOORD0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec2 u_xlat0;
					lowp vec4 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					void main()
					{
					    u_xlat0.xy = fract(vs_TEXCOORD0.xy);
					    u_xlat10_0 = texture(_MainTex, u_xlat0.xy);
					    u_xlat16_1.x = u_xlat10_0.w + -1.0;
					    u_xlat16_1.x = _MainTex_HDR.w * u_xlat16_1.x + 1.0;
					    u_xlat16_1.x = u_xlat16_1.x * _MainTex_HDR.x;
					    u_xlat16_1.xyz = u_xlat10_0.xyz * u_xlat16_1.xxx;
					    SV_Target0.xyz = u_xlat16_1.xyz * vec3(_Exposure);
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
					uniform 	float _Rotation;
					in highp vec4 in_POSITION0;
					out highp vec3 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec3 u_xlat2;
					float u_xlat3;
					void main()
					{
					    u_xlat0.x = _Rotation * 0.0174532942;
					    u_xlat1.x = cos(u_xlat0.x);
					    u_xlat0.x = sin(u_xlat0.x);
					    u_xlat2.x = (-u_xlat0.x);
					    u_xlat2.y = u_xlat1.x;
					    u_xlat2.z = u_xlat0.x;
					    u_xlat0.x = dot(u_xlat2.zy, in_POSITION0.xz);
					    u_xlat3 = dot(u_xlat2.yx, in_POSITION0.xz);
					    u_xlat1 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * vec4(u_xlat3) + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xyz = in_POSITION0.xyz;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump vec4 _MainTex_HDR;
					uniform 	mediump float _Exposure;
					uniform lowp sampler2D _MainTex;
					in highp vec3 vs_TEXCOORD0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec2 u_xlat0;
					lowp vec4 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					void main()
					{
					    u_xlat0.xy = fract(vs_TEXCOORD0.xy);
					    u_xlat10_0 = texture(_MainTex, u_xlat0.xy);
					    u_xlat16_1.x = u_xlat10_0.w + -1.0;
					    u_xlat16_1.x = _MainTex_HDR.w * u_xlat16_1.x + 1.0;
					    u_xlat16_1.x = u_xlat16_1.x * _MainTex_HDR.x;
					    u_xlat16_1.xyz = u_xlat10_0.xyz * u_xlat16_1.xxx;
					    SV_Target0.xyz = u_xlat16_1.xyz * vec3(_Exposure);
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
					uniform 	float _Rotation;
					in highp vec4 in_POSITION0;
					out highp vec3 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec3 u_xlat2;
					float u_xlat3;
					void main()
					{
					    u_xlat0.x = _Rotation * 0.0174532942;
					    u_xlat1.x = cos(u_xlat0.x);
					    u_xlat0.x = sin(u_xlat0.x);
					    u_xlat2.x = (-u_xlat0.x);
					    u_xlat2.y = u_xlat1.x;
					    u_xlat2.z = u_xlat0.x;
					    u_xlat0.x = dot(u_xlat2.zy, in_POSITION0.xz);
					    u_xlat3 = dot(u_xlat2.yx, in_POSITION0.xz);
					    u_xlat1 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * vec4(u_xlat3) + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xyz = in_POSITION0.xyz;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump vec4 _MainTex_HDR;
					uniform 	mediump float _Exposure;
					uniform lowp sampler2D _MainTex;
					in highp vec3 vs_TEXCOORD0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec2 u_xlat0;
					lowp vec4 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					void main()
					{
					    u_xlat0.xy = fract(vs_TEXCOORD0.xy);
					    u_xlat10_0 = texture(_MainTex, u_xlat0.xy);
					    u_xlat16_1.x = u_xlat10_0.w + -1.0;
					    u_xlat16_1.x = _MainTex_HDR.w * u_xlat16_1.x + 1.0;
					    u_xlat16_1.x = u_xlat16_1.x * _MainTex_HDR.x;
					    u_xlat16_1.xyz = u_xlat10_0.xyz * u_xlat16_1.xxx;
					    SV_Target0.xyz = u_xlat16_1.xyz * vec3(_Exposure);
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