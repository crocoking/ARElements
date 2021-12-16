Shader "Screen Space Outline/Composite" {
	Properties {
		[HideInInspector] _MainTex ("", 2D) = "" {}
		[HideInInspector] _OutlineBuffer ("", 2D) = "" {}
	}
	SubShader {
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {
				Mode Off
			}
			GpuProgramID 25511
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					varying mediump vec2 xlv_TEXCOORD0;
					varying mediump vec2 xlv_TEXCOORD1;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = _glesMultiTexCoord0.xy;
					  mediump vec2 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  tmpvar_2 = tmpvar_1;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  xlv_TEXCOORD0 = tmpvar_2;
					  xlv_TEXCOORD1 = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform sampler2D _OutlineBuffer;
					uniform mediump float _GlobalLightEstimationScale;
					uniform mediump float _GlobalLightEstimation;
					varying mediump vec2 xlv_TEXCOORD0;
					varying mediump vec2 xlv_TEXCOORD1;
					void main ()
					{
					  lowp vec4 c2_1;
					  lowp vec4 c1_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
					  c1_2.w = tmpvar_3.w;
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_OutlineBuffer, xlv_TEXCOORD1);
					  c2_1 = ((_GlobalLightEstimationScale * (tmpvar_4 * _GlobalLightEstimation)) + ((1.0 - _GlobalLightEstimationScale) * tmpvar_4));
					  c1_2.xyz = mix (tmpvar_3.xyz, c2_1.xyz, c2_1.www);
					  gl_FragData[0] = c1_2;
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
					varying mediump vec2 xlv_TEXCOORD0;
					varying mediump vec2 xlv_TEXCOORD1;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = _glesMultiTexCoord0.xy;
					  mediump vec2 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  tmpvar_2 = tmpvar_1;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  xlv_TEXCOORD0 = tmpvar_2;
					  xlv_TEXCOORD1 = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform sampler2D _OutlineBuffer;
					uniform mediump float _GlobalLightEstimationScale;
					uniform mediump float _GlobalLightEstimation;
					varying mediump vec2 xlv_TEXCOORD0;
					varying mediump vec2 xlv_TEXCOORD1;
					void main ()
					{
					  lowp vec4 c2_1;
					  lowp vec4 c1_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
					  c1_2.w = tmpvar_3.w;
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_OutlineBuffer, xlv_TEXCOORD1);
					  c2_1 = ((_GlobalLightEstimationScale * (tmpvar_4 * _GlobalLightEstimation)) + ((1.0 - _GlobalLightEstimationScale) * tmpvar_4));
					  c1_2.xyz = mix (tmpvar_3.xyz, c2_1.xyz, c2_1.www);
					  gl_FragData[0] = c1_2;
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
					varying mediump vec2 xlv_TEXCOORD0;
					varying mediump vec2 xlv_TEXCOORD1;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = _glesMultiTexCoord0.xy;
					  mediump vec2 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  tmpvar_2 = tmpvar_1;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  xlv_TEXCOORD0 = tmpvar_2;
					  xlv_TEXCOORD1 = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform sampler2D _OutlineBuffer;
					uniform mediump float _GlobalLightEstimationScale;
					uniform mediump float _GlobalLightEstimation;
					varying mediump vec2 xlv_TEXCOORD0;
					varying mediump vec2 xlv_TEXCOORD1;
					void main ()
					{
					  lowp vec4 c2_1;
					  lowp vec4 c1_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
					  c1_2.w = tmpvar_3.w;
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_OutlineBuffer, xlv_TEXCOORD1);
					  c2_1 = ((_GlobalLightEstimationScale * (tmpvar_4 * _GlobalLightEstimation)) + ((1.0 - _GlobalLightEstimationScale) * tmpvar_4));
					  c1_2.xyz = mix (tmpvar_3.xyz, c2_1.xyz, c2_1.www);
					  gl_FragData[0] = c1_2;
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
					out mediump vec2 vs_TEXCOORD0;
					mediump  vec4 phase0_Output0_1;
					out mediump vec2 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    phase0_Output0_1 = in_TEXCOORD0.xyxy;
					vs_TEXCOORD0 = phase0_Output0_1.xy;
					vs_TEXCOORD1 = phase0_Output0_1.zw;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump float _GlobalLightEstimationScale;
					uniform 	mediump float _GlobalLightEstimation;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _OutlineBuffer;
					in mediump vec2 vs_TEXCOORD0;
					in mediump vec2 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					mediump vec4 u_xlat16_0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_1;
					void main()
					{
					    u_xlat16_0.x = (-_GlobalLightEstimationScale) + 1.0;
					    u_xlat10_1 = texture(_OutlineBuffer, vs_TEXCOORD1.xy);
					    u_xlat16_0 = u_xlat16_0.xxxx * u_xlat10_1;
					    u_xlat16_1 = u_xlat10_1 * vec4(vec4(_GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation));
					    u_xlat16_0 = vec4(_GlobalLightEstimationScale) * u_xlat16_1 + u_xlat16_0;
					    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat16_0.xyz = u_xlat16_0.xyz + (-u_xlat10_1.xyz);
					    SV_Target0.xyz = u_xlat16_0.www * u_xlat16_0.xyz + u_xlat10_1.xyz;
					    SV_Target0.w = u_xlat10_1.w;
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
					out mediump vec2 vs_TEXCOORD0;
					mediump  vec4 phase0_Output0_1;
					out mediump vec2 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    phase0_Output0_1 = in_TEXCOORD0.xyxy;
					vs_TEXCOORD0 = phase0_Output0_1.xy;
					vs_TEXCOORD1 = phase0_Output0_1.zw;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump float _GlobalLightEstimationScale;
					uniform 	mediump float _GlobalLightEstimation;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _OutlineBuffer;
					in mediump vec2 vs_TEXCOORD0;
					in mediump vec2 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					mediump vec4 u_xlat16_0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_1;
					void main()
					{
					    u_xlat16_0.x = (-_GlobalLightEstimationScale) + 1.0;
					    u_xlat10_1 = texture(_OutlineBuffer, vs_TEXCOORD1.xy);
					    u_xlat16_0 = u_xlat16_0.xxxx * u_xlat10_1;
					    u_xlat16_1 = u_xlat10_1 * vec4(vec4(_GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation));
					    u_xlat16_0 = vec4(_GlobalLightEstimationScale) * u_xlat16_1 + u_xlat16_0;
					    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat16_0.xyz = u_xlat16_0.xyz + (-u_xlat10_1.xyz);
					    SV_Target0.xyz = u_xlat16_0.www * u_xlat16_0.xyz + u_xlat10_1.xyz;
					    SV_Target0.w = u_xlat10_1.w;
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
					out mediump vec2 vs_TEXCOORD0;
					mediump  vec4 phase0_Output0_1;
					out mediump vec2 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    phase0_Output0_1 = in_TEXCOORD0.xyxy;
					vs_TEXCOORD0 = phase0_Output0_1.xy;
					vs_TEXCOORD1 = phase0_Output0_1.zw;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump float _GlobalLightEstimationScale;
					uniform 	mediump float _GlobalLightEstimation;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _OutlineBuffer;
					in mediump vec2 vs_TEXCOORD0;
					in mediump vec2 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					mediump vec4 u_xlat16_0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_1;
					void main()
					{
					    u_xlat16_0.x = (-_GlobalLightEstimationScale) + 1.0;
					    u_xlat10_1 = texture(_OutlineBuffer, vs_TEXCOORD1.xy);
					    u_xlat16_0 = u_xlat16_0.xxxx * u_xlat10_1;
					    u_xlat16_1 = u_xlat10_1 * vec4(vec4(_GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation));
					    u_xlat16_0 = vec4(_GlobalLightEstimationScale) * u_xlat16_1 + u_xlat16_0;
					    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat16_0.xyz = u_xlat16_0.xyz + (-u_xlat10_1.xyz);
					    SV_Target0.xyz = u_xlat16_0.www * u_xlat16_0.xyz + u_xlat10_1.xyz;
					    SV_Target0.w = u_xlat10_1.w;
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