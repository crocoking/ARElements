Shader "ARElements/SpatialMapping/FeaturePoints" {
	Properties {
		_PointSize ("Point Size", Float) = 5
		[PerRendererData] _Color ("PointCloud Color", Vector) = (0.121,0.737,0.823,1)
		[HideInInspector] [PerRendererData] _ScreenWidth ("", Float) = 1440
		[HideInInspector] [PerRendererData] _ScreenHeight ("", Float) = 2560
	}
	SubShader {
		Pass {
			GpuProgramID 24569
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp vec4 _ProjectionParams;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp int _ScreenWidth;
					uniform highp int _ScreenHeight;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec2 xlv_TEXCOORD1;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = _glesMultiTexCoord0.xy;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  highp vec4 tmpvar_4;
					  tmpvar_4.w = 1.0;
					  tmpvar_4.xyz = _glesVertex.xyz;
					  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
					  highp vec4 o_5;
					  highp vec4 tmpvar_6;
					  tmpvar_6 = (tmpvar_3 * 0.5);
					  highp vec2 tmpvar_7;
					  tmpvar_7.x = tmpvar_6.x;
					  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
					  o_5.xy = (tmpvar_7 + tmpvar_6.w);
					  o_5.zw = tmpvar_3.zw;
					  tmpvar_2.zw = o_5.zw;
					  tmpvar_2.xy = (o_5.xy / tmpvar_3.w);
					  tmpvar_2.x = (tmpvar_2.x * float(_ScreenWidth));
					  tmpvar_2.y = (tmpvar_2.y * float(_ScreenHeight));
					  gl_Position = tmpvar_3;
					  gl_PointSize = tmpvar_1.x;
					  xlv_TEXCOORD0 = tmpvar_2;
					  xlv_TEXCOORD1 = tmpvar_1;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform lowp vec4 _Color;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec2 xlv_TEXCOORD1;
					void main ()
					{
					  highp float tmpvar_1;
					  highp vec2 tmpvar_2;
					  tmpvar_2 = (gl_FragCoord.xy - xlv_TEXCOORD0.xy);
					  tmpvar_1 = sqrt(dot (tmpvar_2, tmpvar_2));
					  if ((tmpvar_1 > (xlv_TEXCOORD1.x / 2.0))) {
					    discard;
					  };
					  gl_FragData[0] = _Color;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp vec4 _ProjectionParams;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp int _ScreenWidth;
					uniform highp int _ScreenHeight;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec2 xlv_TEXCOORD1;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = _glesMultiTexCoord0.xy;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  highp vec4 tmpvar_4;
					  tmpvar_4.w = 1.0;
					  tmpvar_4.xyz = _glesVertex.xyz;
					  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
					  highp vec4 o_5;
					  highp vec4 tmpvar_6;
					  tmpvar_6 = (tmpvar_3 * 0.5);
					  highp vec2 tmpvar_7;
					  tmpvar_7.x = tmpvar_6.x;
					  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
					  o_5.xy = (tmpvar_7 + tmpvar_6.w);
					  o_5.zw = tmpvar_3.zw;
					  tmpvar_2.zw = o_5.zw;
					  tmpvar_2.xy = (o_5.xy / tmpvar_3.w);
					  tmpvar_2.x = (tmpvar_2.x * float(_ScreenWidth));
					  tmpvar_2.y = (tmpvar_2.y * float(_ScreenHeight));
					  gl_Position = tmpvar_3;
					  gl_PointSize = tmpvar_1.x;
					  xlv_TEXCOORD0 = tmpvar_2;
					  xlv_TEXCOORD1 = tmpvar_1;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform lowp vec4 _Color;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec2 xlv_TEXCOORD1;
					void main ()
					{
					  highp float tmpvar_1;
					  highp vec2 tmpvar_2;
					  tmpvar_2 = (gl_FragCoord.xy - xlv_TEXCOORD0.xy);
					  tmpvar_1 = sqrt(dot (tmpvar_2, tmpvar_2));
					  if ((tmpvar_1 > (xlv_TEXCOORD1.x / 2.0))) {
					    discard;
					  };
					  gl_FragData[0] = _Color;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp vec4 _ProjectionParams;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp int _ScreenWidth;
					uniform highp int _ScreenHeight;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec2 xlv_TEXCOORD1;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = _glesMultiTexCoord0.xy;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  highp vec4 tmpvar_4;
					  tmpvar_4.w = 1.0;
					  tmpvar_4.xyz = _glesVertex.xyz;
					  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
					  highp vec4 o_5;
					  highp vec4 tmpvar_6;
					  tmpvar_6 = (tmpvar_3 * 0.5);
					  highp vec2 tmpvar_7;
					  tmpvar_7.x = tmpvar_6.x;
					  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
					  o_5.xy = (tmpvar_7 + tmpvar_6.w);
					  o_5.zw = tmpvar_3.zw;
					  tmpvar_2.zw = o_5.zw;
					  tmpvar_2.xy = (o_5.xy / tmpvar_3.w);
					  tmpvar_2.x = (tmpvar_2.x * float(_ScreenWidth));
					  tmpvar_2.y = (tmpvar_2.y * float(_ScreenHeight));
					  gl_Position = tmpvar_3;
					  gl_PointSize = tmpvar_1.x;
					  xlv_TEXCOORD0 = tmpvar_2;
					  xlv_TEXCOORD1 = tmpvar_1;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform lowp vec4 _Color;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec2 xlv_TEXCOORD1;
					void main ()
					{
					  highp float tmpvar_1;
					  highp vec2 tmpvar_2;
					  tmpvar_2 = (gl_FragCoord.xy - xlv_TEXCOORD0.xy);
					  tmpvar_1 = sqrt(dot (tmpvar_2, tmpvar_2));
					  if ((tmpvar_1 > (xlv_TEXCOORD1.x / 2.0))) {
					    discard;
					  };
					  gl_FragData[0] = _Color;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 _ProjectionParams;
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	int _ScreenWidth;
					uniform 	int _ScreenHeight;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD1;
					highp  vec4 phase0_Output0_0;
					out highp vec4 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec2 u_xlat5;
					void main()
					{
					    phase0_Output0_0.xyz = in_TEXCOORD0.xxy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.w = u_xlat1.x * 0.5;
					    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
					    u_xlat1.xy = u_xlat1.zz + u_xlat1.xw;
					    u_xlat1.xy = u_xlat1.xy / u_xlat0.ww;
					    u_xlat5.xy = vec2(ivec2(_ScreenWidth, _ScreenHeight));
					    vs_TEXCOORD0.xy = u_xlat5.xy * u_xlat1.xy;
					    vs_TEXCOORD0.zw = u_xlat0.zw;
					    gl_Position = u_xlat0;
					gl_PointSize = phase0_Output0_0.x;
					vs_TEXCOORD1 = phase0_Output0_0.yz;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump vec4 _Color;
					in highp vec2 vs_TEXCOORD1;
					in highp vec4 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec2 u_xlat0;
					bool u_xlatb0;
					float u_xlat1;
					void main()
					{
					    u_xlat0.xy = (-vs_TEXCOORD0.xy) + gl_FragCoord.xy;
					    u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat1 = vs_TEXCOORD1.x * 0.5;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb0 = !!(u_xlat1<u_xlat0.x);
					#else
					    u_xlatb0 = u_xlat1<u_xlat0.x;
					#endif
					    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
					    SV_Target0 = _Color;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 _ProjectionParams;
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	int _ScreenWidth;
					uniform 	int _ScreenHeight;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD1;
					highp  vec4 phase0_Output0_0;
					out highp vec4 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec2 u_xlat5;
					void main()
					{
					    phase0_Output0_0.xyz = in_TEXCOORD0.xxy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.w = u_xlat1.x * 0.5;
					    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
					    u_xlat1.xy = u_xlat1.zz + u_xlat1.xw;
					    u_xlat1.xy = u_xlat1.xy / u_xlat0.ww;
					    u_xlat5.xy = vec2(ivec2(_ScreenWidth, _ScreenHeight));
					    vs_TEXCOORD0.xy = u_xlat5.xy * u_xlat1.xy;
					    vs_TEXCOORD0.zw = u_xlat0.zw;
					    gl_Position = u_xlat0;
					gl_PointSize = phase0_Output0_0.x;
					vs_TEXCOORD1 = phase0_Output0_0.yz;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump vec4 _Color;
					in highp vec2 vs_TEXCOORD1;
					in highp vec4 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec2 u_xlat0;
					bool u_xlatb0;
					float u_xlat1;
					void main()
					{
					    u_xlat0.xy = (-vs_TEXCOORD0.xy) + gl_FragCoord.xy;
					    u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat1 = vs_TEXCOORD1.x * 0.5;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb0 = !!(u_xlat1<u_xlat0.x);
					#else
					    u_xlatb0 = u_xlat1<u_xlat0.x;
					#endif
					    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
					    SV_Target0 = _Color;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 _ProjectionParams;
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	int _ScreenWidth;
					uniform 	int _ScreenHeight;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD1;
					highp  vec4 phase0_Output0_0;
					out highp vec4 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec2 u_xlat5;
					void main()
					{
					    phase0_Output0_0.xyz = in_TEXCOORD0.xxy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.w = u_xlat1.x * 0.5;
					    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
					    u_xlat1.xy = u_xlat1.zz + u_xlat1.xw;
					    u_xlat1.xy = u_xlat1.xy / u_xlat0.ww;
					    u_xlat5.xy = vec2(ivec2(_ScreenWidth, _ScreenHeight));
					    vs_TEXCOORD0.xy = u_xlat5.xy * u_xlat1.xy;
					    vs_TEXCOORD0.zw = u_xlat0.zw;
					    gl_Position = u_xlat0;
					gl_PointSize = phase0_Output0_0.x;
					vs_TEXCOORD1 = phase0_Output0_0.yz;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump vec4 _Color;
					in highp vec2 vs_TEXCOORD1;
					in highp vec4 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec2 u_xlat0;
					bool u_xlatb0;
					float u_xlat1;
					void main()
					{
					    u_xlat0.xy = (-vs_TEXCOORD0.xy) + gl_FragCoord.xy;
					    u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat1 = vs_TEXCOORD1.x * 0.5;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb0 = !!(u_xlat1<u_xlat0.x);
					#else
					    u_xlatb0 = u_xlat1<u_xlat0.x;
					#endif
					    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
					    SV_Target0 = _Color;
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