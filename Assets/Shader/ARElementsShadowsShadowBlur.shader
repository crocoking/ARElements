Shader "ARElements/Shadows/ShadowBlur" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Spread ("Spread", Range(0, 0.1)) = 0.01
		_Samples ("Samples", Range(0, 12)) = 6
	}
	SubShader {
		LOD 100
		Tags { "RenderType" = "Opaque" }
		Pass {
			LOD 100
			Tags { "RenderType" = "Opaque" }
			GpuProgramID 40568
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
					uniform sampler2D _MainTex;
					uniform highp float _Spread;
					uniform highp int _Samples;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec2 uv_1;
					  uv_1 = xlv_TEXCOORD0;
					  highp float spread_2;
					  spread_2 = _Spread;
					  highp float avgGreen_4;
					  highp vec2 poissonDisc_5[12];
					  poissonDisc_5[0] = vec2(0.185, -0.893);
					  poissonDisc_5[1] = vec2(0.962, -0.195);
					  poissonDisc_5[2] = vec2(-0.696, 0.457);
					  poissonDisc_5[3] = vec2(-0.84, -0.074);
					  poissonDisc_5[4] = vec2(-0.203, 0.621);
					  poissonDisc_5[5] = vec2(0.473, -0.48);
					  poissonDisc_5[6] = vec2(0.519, 0.767);
					  poissonDisc_5[7] = vec2(-0.326, -0.406);
					  poissonDisc_5[8] = vec2(0.507, 0.064);
					  poissonDisc_5[9] = vec2(0.896, 0.412);
					  poissonDisc_5[10] = vec2(-0.322, -0.933);
					  poissonDisc_5[11] = vec2(-0.792, -0.598);
					  lowp vec4 tmpvar_6;
					  tmpvar_6 = texture2D (_MainTex, xlv_TEXCOORD0);
					  highp vec4 tmpvar_7;
					  tmpvar_7 = tmpvar_6;
					  avgGreen_4 = tmpvar_7.y;
					  for (highp int i_3 = 0; i_3 < _Samples; i_3++) {
					    lowp vec4 tmpvar_8;
					    highp vec2 P_9;
					    P_9 = (uv_1 + (poissonDisc_5[i_3] * spread_2));
					    tmpvar_8 = texture2D (_MainTex, P_9);
					    avgGreen_4 = (avgGreen_4 + tmpvar_8.y);
					  };
					  avgGreen_4 = (avgGreen_4 * tmpvar_7.y);
					  avgGreen_4 = (avgGreen_4 / float((_Samples + 1)));
					  highp vec4 tmpvar_10;
					  tmpvar_10.x = tmpvar_7.x;
					  tmpvar_10.y = avgGreen_4;
					  tmpvar_10.zw = tmpvar_7.zw;
					  gl_FragData[0] = tmpvar_10;
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
					uniform sampler2D _MainTex;
					uniform highp float _Spread;
					uniform highp int _Samples;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec2 uv_1;
					  uv_1 = xlv_TEXCOORD0;
					  highp float spread_2;
					  spread_2 = _Spread;
					  highp float avgGreen_4;
					  highp vec2 poissonDisc_5[12];
					  poissonDisc_5[0] = vec2(0.185, -0.893);
					  poissonDisc_5[1] = vec2(0.962, -0.195);
					  poissonDisc_5[2] = vec2(-0.696, 0.457);
					  poissonDisc_5[3] = vec2(-0.84, -0.074);
					  poissonDisc_5[4] = vec2(-0.203, 0.621);
					  poissonDisc_5[5] = vec2(0.473, -0.48);
					  poissonDisc_5[6] = vec2(0.519, 0.767);
					  poissonDisc_5[7] = vec2(-0.326, -0.406);
					  poissonDisc_5[8] = vec2(0.507, 0.064);
					  poissonDisc_5[9] = vec2(0.896, 0.412);
					  poissonDisc_5[10] = vec2(-0.322, -0.933);
					  poissonDisc_5[11] = vec2(-0.792, -0.598);
					  lowp vec4 tmpvar_6;
					  tmpvar_6 = texture2D (_MainTex, xlv_TEXCOORD0);
					  highp vec4 tmpvar_7;
					  tmpvar_7 = tmpvar_6;
					  avgGreen_4 = tmpvar_7.y;
					  for (highp int i_3 = 0; i_3 < _Samples; i_3++) {
					    lowp vec4 tmpvar_8;
					    highp vec2 P_9;
					    P_9 = (uv_1 + (poissonDisc_5[i_3] * spread_2));
					    tmpvar_8 = texture2D (_MainTex, P_9);
					    avgGreen_4 = (avgGreen_4 + tmpvar_8.y);
					  };
					  avgGreen_4 = (avgGreen_4 * tmpvar_7.y);
					  avgGreen_4 = (avgGreen_4 / float((_Samples + 1)));
					  highp vec4 tmpvar_10;
					  tmpvar_10.x = tmpvar_7.x;
					  tmpvar_10.y = avgGreen_4;
					  tmpvar_10.zw = tmpvar_7.zw;
					  gl_FragData[0] = tmpvar_10;
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
					uniform sampler2D _MainTex;
					uniform highp float _Spread;
					uniform highp int _Samples;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec2 uv_1;
					  uv_1 = xlv_TEXCOORD0;
					  highp float spread_2;
					  spread_2 = _Spread;
					  highp float avgGreen_4;
					  highp vec2 poissonDisc_5[12];
					  poissonDisc_5[0] = vec2(0.185, -0.893);
					  poissonDisc_5[1] = vec2(0.962, -0.195);
					  poissonDisc_5[2] = vec2(-0.696, 0.457);
					  poissonDisc_5[3] = vec2(-0.84, -0.074);
					  poissonDisc_5[4] = vec2(-0.203, 0.621);
					  poissonDisc_5[5] = vec2(0.473, -0.48);
					  poissonDisc_5[6] = vec2(0.519, 0.767);
					  poissonDisc_5[7] = vec2(-0.326, -0.406);
					  poissonDisc_5[8] = vec2(0.507, 0.064);
					  poissonDisc_5[9] = vec2(0.896, 0.412);
					  poissonDisc_5[10] = vec2(-0.322, -0.933);
					  poissonDisc_5[11] = vec2(-0.792, -0.598);
					  lowp vec4 tmpvar_6;
					  tmpvar_6 = texture2D (_MainTex, xlv_TEXCOORD0);
					  highp vec4 tmpvar_7;
					  tmpvar_7 = tmpvar_6;
					  avgGreen_4 = tmpvar_7.y;
					  for (highp int i_3 = 0; i_3 < _Samples; i_3++) {
					    lowp vec4 tmpvar_8;
					    highp vec2 P_9;
					    P_9 = (uv_1 + (poissonDisc_5[i_3] * spread_2));
					    tmpvar_8 = texture2D (_MainTex, P_9);
					    avgGreen_4 = (avgGreen_4 + tmpvar_8.y);
					  };
					  avgGreen_4 = (avgGreen_4 * tmpvar_7.y);
					  avgGreen_4 = (avgGreen_4 / float((_Samples + 1)));
					  highp vec4 tmpvar_10;
					  tmpvar_10.x = tmpvar_7.x;
					  tmpvar_10.y = avgGreen_4;
					  tmpvar_10.zw = tmpvar_7.zw;
					  gl_FragData[0] = tmpvar_10;
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
					uniform 	float _Spread;
					uniform 	int _Samples;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out highp vec4 SV_Target0;
					lowp vec4 u_xlat10_0;
					float u_xlat1;
					int u_xlati1;
					float u_xlat2;
					int u_xlati3;
					vec2 u_xlat5;
					lowp float u_xlat10_5;
					bool u_xlatb5;
					vec4 TempArray0[12];
					void main()
					{
					    TempArray0[0].xy = vec2(0.185000002, -0.893000007);
					    TempArray0[1].xy = vec2(0.962000012, -0.194999993);
					    TempArray0[2].xy = vec2(-0.69599998, 0.456999987);
					    TempArray0[3].xy = vec2(-0.839999974, -0.074000001);
					    TempArray0[4].xy = vec2(-0.202999994, 0.620999992);
					    TempArray0[5].xy = vec2(0.47299999, -0.479999989);
					    TempArray0[6].xy = vec2(0.518999994, 0.76700002);
					    TempArray0[7].xy = vec2(-0.326000005, -0.405999988);
					    TempArray0[8].xy = vec2(0.507000029, 0.064000003);
					    TempArray0[9].xy = vec2(0.896000028, 0.412);
					    TempArray0[10].xy = vec2(-0.321999997, -0.933000028);
					    TempArray0[11].xy = vec2(-0.791999996, -0.59799999);
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_0.y;
					    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<_Samples ; u_xlati_loop_1++)
					    {
					        u_xlat5.xy = TempArray0[u_xlati_loop_1].xy;
					        u_xlat5.xy = u_xlat5.xy * vec2(_Spread) + vs_TEXCOORD0.xy;
					        u_xlat10_5 = texture(_MainTex, u_xlat5.xy).y;
					        u_xlat1 = u_xlat10_5 + u_xlat1;
					    }
					    u_xlat2 = u_xlat10_0.y * u_xlat1;
					    u_xlati1 = _Samples + 1;
					    u_xlat1 = float(u_xlati1);
					    SV_Target0.y = u_xlat2 / u_xlat1;
					    SV_Target0.xzw = u_xlat10_0.xzw;
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
					uniform 	float _Spread;
					uniform 	int _Samples;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out highp vec4 SV_Target0;
					lowp vec4 u_xlat10_0;
					float u_xlat1;
					int u_xlati1;
					float u_xlat2;
					int u_xlati3;
					vec2 u_xlat5;
					lowp float u_xlat10_5;
					bool u_xlatb5;
					vec4 TempArray0[12];
					void main()
					{
					    TempArray0[0].xy = vec2(0.185000002, -0.893000007);
					    TempArray0[1].xy = vec2(0.962000012, -0.194999993);
					    TempArray0[2].xy = vec2(-0.69599998, 0.456999987);
					    TempArray0[3].xy = vec2(-0.839999974, -0.074000001);
					    TempArray0[4].xy = vec2(-0.202999994, 0.620999992);
					    TempArray0[5].xy = vec2(0.47299999, -0.479999989);
					    TempArray0[6].xy = vec2(0.518999994, 0.76700002);
					    TempArray0[7].xy = vec2(-0.326000005, -0.405999988);
					    TempArray0[8].xy = vec2(0.507000029, 0.064000003);
					    TempArray0[9].xy = vec2(0.896000028, 0.412);
					    TempArray0[10].xy = vec2(-0.321999997, -0.933000028);
					    TempArray0[11].xy = vec2(-0.791999996, -0.59799999);
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_0.y;
					    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<_Samples ; u_xlati_loop_1++)
					    {
					        u_xlat5.xy = TempArray0[u_xlati_loop_1].xy;
					        u_xlat5.xy = u_xlat5.xy * vec2(_Spread) + vs_TEXCOORD0.xy;
					        u_xlat10_5 = texture(_MainTex, u_xlat5.xy).y;
					        u_xlat1 = u_xlat10_5 + u_xlat1;
					    }
					    u_xlat2 = u_xlat10_0.y * u_xlat1;
					    u_xlati1 = _Samples + 1;
					    u_xlat1 = float(u_xlati1);
					    SV_Target0.y = u_xlat2 / u_xlat1;
					    SV_Target0.xzw = u_xlat10_0.xzw;
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
					uniform 	float _Spread;
					uniform 	int _Samples;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out highp vec4 SV_Target0;
					lowp vec4 u_xlat10_0;
					float u_xlat1;
					int u_xlati1;
					float u_xlat2;
					int u_xlati3;
					vec2 u_xlat5;
					lowp float u_xlat10_5;
					bool u_xlatb5;
					vec4 TempArray0[12];
					void main()
					{
					    TempArray0[0].xy = vec2(0.185000002, -0.893000007);
					    TempArray0[1].xy = vec2(0.962000012, -0.194999993);
					    TempArray0[2].xy = vec2(-0.69599998, 0.456999987);
					    TempArray0[3].xy = vec2(-0.839999974, -0.074000001);
					    TempArray0[4].xy = vec2(-0.202999994, 0.620999992);
					    TempArray0[5].xy = vec2(0.47299999, -0.479999989);
					    TempArray0[6].xy = vec2(0.518999994, 0.76700002);
					    TempArray0[7].xy = vec2(-0.326000005, -0.405999988);
					    TempArray0[8].xy = vec2(0.507000029, 0.064000003);
					    TempArray0[9].xy = vec2(0.896000028, 0.412);
					    TempArray0[10].xy = vec2(-0.321999997, -0.933000028);
					    TempArray0[11].xy = vec2(-0.791999996, -0.59799999);
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_0.y;
					    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<_Samples ; u_xlati_loop_1++)
					    {
					        u_xlat5.xy = TempArray0[u_xlati_loop_1].xy;
					        u_xlat5.xy = u_xlat5.xy * vec2(_Spread) + vs_TEXCOORD0.xy;
					        u_xlat10_5 = texture(_MainTex, u_xlat5.xy).y;
					        u_xlat1 = u_xlat10_5 + u_xlat1;
					    }
					    u_xlat2 = u_xlat10_0.y * u_xlat1;
					    u_xlati1 = _Samples + 1;
					    u_xlat1 = float(u_xlati1);
					    SV_Target0.y = u_xlat2 / u_xlat1;
					    SV_Target0.xzw = u_xlat10_0.xzw;
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