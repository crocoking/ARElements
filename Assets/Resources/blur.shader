Shader "Screen Space Outline/Blur" {
	Properties {
		_MainTex ("Main Texture", 2D) = "black" {}
		[HideInInspector] _Intensity ("", Range(0, 0.5)) = 0.3
		[HideInInspector] _BlurOffset ("", Range(0, 1)) = 1
	}
	SubShader {
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {
				Mode Off
			}
			GpuProgramID 12898
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _MainTex_ST;
					uniform highp vec4 _MainTex_TexelSize;
					uniform highp float _BlurOffset;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  highp vec2 tmpvar_4;
					  tmpvar_4 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  highp vec2 tmpvar_5;
					  tmpvar_5 = (_BlurOffset * _MainTex_TexelSize.xy);
					  tmpvar_1.xy = (tmpvar_4 - tmpvar_5);
					  tmpvar_1.z = (tmpvar_4.x + tmpvar_5.x);
					  tmpvar_1.w = (tmpvar_4.y - tmpvar_5.y);
					  tmpvar_2.xy = (tmpvar_4 + tmpvar_5);
					  tmpvar_2.z = (tmpvar_4.x - tmpvar_5.x);
					  tmpvar_2.w = (tmpvar_4.y + tmpvar_5.y);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  xlv_TEXCOORD0 = tmpvar_1;
					  xlv_TEXCOORD1 = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform mediump float _Intensity;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  mediump vec4 color1_1;
					  lowp vec4 tmpvar_2;
					  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
					  color1_1 = tmpvar_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0.zw);
					  color1_1.xyz = max (color1_1.xyz, tmpvar_3.xyz);
					  color1_1.w = (color1_1.w + tmpvar_3.w);
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD1.xy);
					  color1_1.xyz = max (color1_1.xyz, tmpvar_4.xyz);
					  color1_1.w = (color1_1.w + tmpvar_4.w);
					  lowp vec4 tmpvar_5;
					  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD1.zw);
					  color1_1.xyz = max (color1_1.xyz, tmpvar_5.xyz);
					  color1_1.w = (color1_1.w + tmpvar_5.w);
					  color1_1.w = (color1_1.w * _Intensity);
					  gl_FragData[0] = color1_1;
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
					uniform highp vec4 _MainTex_ST;
					uniform highp vec4 _MainTex_TexelSize;
					uniform highp float _BlurOffset;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  highp vec2 tmpvar_4;
					  tmpvar_4 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  highp vec2 tmpvar_5;
					  tmpvar_5 = (_BlurOffset * _MainTex_TexelSize.xy);
					  tmpvar_1.xy = (tmpvar_4 - tmpvar_5);
					  tmpvar_1.z = (tmpvar_4.x + tmpvar_5.x);
					  tmpvar_1.w = (tmpvar_4.y - tmpvar_5.y);
					  tmpvar_2.xy = (tmpvar_4 + tmpvar_5);
					  tmpvar_2.z = (tmpvar_4.x - tmpvar_5.x);
					  tmpvar_2.w = (tmpvar_4.y + tmpvar_5.y);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  xlv_TEXCOORD0 = tmpvar_1;
					  xlv_TEXCOORD1 = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform mediump float _Intensity;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  mediump vec4 color1_1;
					  lowp vec4 tmpvar_2;
					  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
					  color1_1 = tmpvar_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0.zw);
					  color1_1.xyz = max (color1_1.xyz, tmpvar_3.xyz);
					  color1_1.w = (color1_1.w + tmpvar_3.w);
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD1.xy);
					  color1_1.xyz = max (color1_1.xyz, tmpvar_4.xyz);
					  color1_1.w = (color1_1.w + tmpvar_4.w);
					  lowp vec4 tmpvar_5;
					  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD1.zw);
					  color1_1.xyz = max (color1_1.xyz, tmpvar_5.xyz);
					  color1_1.w = (color1_1.w + tmpvar_5.w);
					  color1_1.w = (color1_1.w * _Intensity);
					  gl_FragData[0] = color1_1;
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
					uniform highp vec4 _MainTex_ST;
					uniform highp vec4 _MainTex_TexelSize;
					uniform highp float _BlurOffset;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  highp vec2 tmpvar_4;
					  tmpvar_4 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  highp vec2 tmpvar_5;
					  tmpvar_5 = (_BlurOffset * _MainTex_TexelSize.xy);
					  tmpvar_1.xy = (tmpvar_4 - tmpvar_5);
					  tmpvar_1.z = (tmpvar_4.x + tmpvar_5.x);
					  tmpvar_1.w = (tmpvar_4.y - tmpvar_5.y);
					  tmpvar_2.xy = (tmpvar_4 + tmpvar_5);
					  tmpvar_2.z = (tmpvar_4.x - tmpvar_5.x);
					  tmpvar_2.w = (tmpvar_4.y + tmpvar_5.y);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  xlv_TEXCOORD0 = tmpvar_1;
					  xlv_TEXCOORD1 = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform mediump float _Intensity;
					varying highp vec4 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  mediump vec4 color1_1;
					  lowp vec4 tmpvar_2;
					  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
					  color1_1 = tmpvar_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0.zw);
					  color1_1.xyz = max (color1_1.xyz, tmpvar_3.xyz);
					  color1_1.w = (color1_1.w + tmpvar_3.w);
					  lowp vec4 tmpvar_4;
					  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD1.xy);
					  color1_1.xyz = max (color1_1.xyz, tmpvar_4.xyz);
					  color1_1.w = (color1_1.w + tmpvar_4.w);
					  lowp vec4 tmpvar_5;
					  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD1.zw);
					  color1_1.xyz = max (color1_1.xyz, tmpvar_5.xyz);
					  color1_1.w = (color1_1.w + tmpvar_5.w);
					  color1_1.w = (color1_1.w * _Intensity);
					  gl_FragData[0] = color1_1;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _MainTex_TexelSize;
					uniform 	float _BlurOffset;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec4 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
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
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat1.xy = (-vec2(_BlurOffset)) * _MainTex_TexelSize.xy + u_xlat0.xy;
					    u_xlat1.zw = vec2(_BlurOffset) * _MainTex_TexelSize.xy + u_xlat0.xy;
					    vs_TEXCOORD0 = u_xlat1.xyzy;
					    vs_TEXCOORD1 = u_xlat1.zwxw;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump float _Intensity;
					uniform lowp sampler2D _MainTex;
					in highp vec4 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					lowp vec4 u_xlat10_0;
					lowp vec4 u_xlat10_1;
					mediump float u_xlat16_2;
					mediump vec3 u_xlat16_5;
					void main()
					{
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.zw);
					    u_xlat16_2 = u_xlat10_0.w + u_xlat10_1.w;
					    u_xlat16_5.xyz = max(u_xlat10_0.xyz, u_xlat10_1.xyz);
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.xy);
					    u_xlat16_2 = u_xlat10_0.w + u_xlat16_2;
					    u_xlat16_5.xyz = max(u_xlat10_0.xyz, u_xlat16_5.xyz);
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.zw);
					    u_xlat16_2 = u_xlat10_0.w + u_xlat16_2;
					    SV_Target0.xyz = max(u_xlat10_0.xyz, u_xlat16_5.xyz);
					    SV_Target0.w = u_xlat16_2 * _Intensity;
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
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _MainTex_TexelSize;
					uniform 	float _BlurOffset;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec4 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
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
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat1.xy = (-vec2(_BlurOffset)) * _MainTex_TexelSize.xy + u_xlat0.xy;
					    u_xlat1.zw = vec2(_BlurOffset) * _MainTex_TexelSize.xy + u_xlat0.xy;
					    vs_TEXCOORD0 = u_xlat1.xyzy;
					    vs_TEXCOORD1 = u_xlat1.zwxw;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump float _Intensity;
					uniform lowp sampler2D _MainTex;
					in highp vec4 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					lowp vec4 u_xlat10_0;
					lowp vec4 u_xlat10_1;
					mediump float u_xlat16_2;
					mediump vec3 u_xlat16_5;
					void main()
					{
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.zw);
					    u_xlat16_2 = u_xlat10_0.w + u_xlat10_1.w;
					    u_xlat16_5.xyz = max(u_xlat10_0.xyz, u_xlat10_1.xyz);
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.xy);
					    u_xlat16_2 = u_xlat10_0.w + u_xlat16_2;
					    u_xlat16_5.xyz = max(u_xlat10_0.xyz, u_xlat16_5.xyz);
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.zw);
					    u_xlat16_2 = u_xlat10_0.w + u_xlat16_2;
					    SV_Target0.xyz = max(u_xlat10_0.xyz, u_xlat16_5.xyz);
					    SV_Target0.w = u_xlat16_2 * _Intensity;
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
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _MainTex_TexelSize;
					uniform 	float _BlurOffset;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec4 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
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
					    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat1.xy = (-vec2(_BlurOffset)) * _MainTex_TexelSize.xy + u_xlat0.xy;
					    u_xlat1.zw = vec2(_BlurOffset) * _MainTex_TexelSize.xy + u_xlat0.xy;
					    vs_TEXCOORD0 = u_xlat1.xyzy;
					    vs_TEXCOORD1 = u_xlat1.zwxw;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	mediump float _Intensity;
					uniform lowp sampler2D _MainTex;
					in highp vec4 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					lowp vec4 u_xlat10_0;
					lowp vec4 u_xlat10_1;
					mediump float u_xlat16_2;
					mediump vec3 u_xlat16_5;
					void main()
					{
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.zw);
					    u_xlat16_2 = u_xlat10_0.w + u_xlat10_1.w;
					    u_xlat16_5.xyz = max(u_xlat10_0.xyz, u_xlat10_1.xyz);
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.xy);
					    u_xlat16_2 = u_xlat10_0.w + u_xlat16_2;
					    u_xlat16_5.xyz = max(u_xlat10_0.xyz, u_xlat16_5.xyz);
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD1.zw);
					    u_xlat16_2 = u_xlat10_0.w + u_xlat16_2;
					    SV_Target0.xyz = max(u_xlat10_0.xyz, u_xlat16_5.xyz);
					    SV_Target0.w = u_xlat16_2 * _Intensity;
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
		Pass {
			GpuProgramID 88258
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
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform highp vec2 _MainTex_TexelSize;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = xlv_TEXCOORD0;
					  mediump vec4 colorIntensityInRadius_3;
					  highp float texelX_4;
					  texelX_4 = _MainTex_TexelSize.x;
					  colorIntensityInRadius_3 = vec4(0.0, 0.0, 0.0, 0.0);
					  for (highp int k_2 = 0; k_2 < 10; k_2++) {
					    highp vec2 tmpvar_5;
					    tmpvar_5.y = 0.0;
					    tmpvar_5.x = (float((k_2 - 5)) * texelX_4);
					    lowp vec4 tmpvar_6;
					    highp vec2 P_7;
					    P_7 = (tmpvar_1 + tmpvar_5);
					    tmpvar_6 = texture2D (_MainTex, P_7);
					    colorIntensityInRadius_3 = (colorIntensityInRadius_3 + tmpvar_6);
					  };
					  colorIntensityInRadius_3 = (colorIntensityInRadius_3 / 10.0);
					  gl_FragData[0] = colorIntensityInRadius_3;
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
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform highp vec2 _MainTex_TexelSize;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = xlv_TEXCOORD0;
					  mediump vec4 colorIntensityInRadius_3;
					  highp float texelX_4;
					  texelX_4 = _MainTex_TexelSize.x;
					  colorIntensityInRadius_3 = vec4(0.0, 0.0, 0.0, 0.0);
					  for (highp int k_2 = 0; k_2 < 10; k_2++) {
					    highp vec2 tmpvar_5;
					    tmpvar_5.y = 0.0;
					    tmpvar_5.x = (float((k_2 - 5)) * texelX_4);
					    lowp vec4 tmpvar_6;
					    highp vec2 P_7;
					    P_7 = (tmpvar_1 + tmpvar_5);
					    tmpvar_6 = texture2D (_MainTex, P_7);
					    colorIntensityInRadius_3 = (colorIntensityInRadius_3 + tmpvar_6);
					  };
					  colorIntensityInRadius_3 = (colorIntensityInRadius_3 / 10.0);
					  gl_FragData[0] = colorIntensityInRadius_3;
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
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform highp vec2 _MainTex_TexelSize;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = xlv_TEXCOORD0;
					  mediump vec4 colorIntensityInRadius_3;
					  highp float texelX_4;
					  texelX_4 = _MainTex_TexelSize.x;
					  colorIntensityInRadius_3 = vec4(0.0, 0.0, 0.0, 0.0);
					  for (highp int k_2 = 0; k_2 < 10; k_2++) {
					    highp vec2 tmpvar_5;
					    tmpvar_5.y = 0.0;
					    tmpvar_5.x = (float((k_2 - 5)) * texelX_4);
					    lowp vec4 tmpvar_6;
					    highp vec2 P_7;
					    P_7 = (tmpvar_1 + tmpvar_5);
					    tmpvar_6 = texture2D (_MainTex, P_7);
					    colorIntensityInRadius_3 = (colorIntensityInRadius_3 + tmpvar_6);
					  };
					  colorIntensityInRadius_3 = (colorIntensityInRadius_3 / 10.0);
					  gl_FragData[0] = colorIntensityInRadius_3;
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
					in highp vec4 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
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
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec2 _MainTex_TexelSize;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_2;
					bool u_xlatb2;
					ivec2 u_xlati6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.y = 0.0;
					    u_xlat16_1.x = float(0.0);
					    u_xlat16_1.y = float(0.0);
					    u_xlat16_1.z = float(0.0);
					    u_xlat16_1.w = float(0.0);
					    u_xlati6.x = 0;
					    while(true){
					#ifdef UNITY_ADRENO_ES3
					        u_xlatb2 = !!(u_xlati6.x>=10);
					#else
					        u_xlatb2 = u_xlati6.x>=10;
					#endif
					        if(u_xlatb2){break;}
					        u_xlati6.xy = u_xlati6.xx + ivec2(1, -5);
					        u_xlat9 = float(u_xlati6.y);
					        u_xlat0.x = u_xlat9 * _MainTex_TexelSize.x;
					        u_xlat0.xw = u_xlat0.xy + vs_TEXCOORD0.xy;
					        u_xlat10_2 = texture(_MainTex, u_xlat0.xw);
					        u_xlat16_1 = u_xlat16_1 + u_xlat10_2;
					        u_xlat16_1 = u_xlat16_1;
					    }
					    SV_Target0 = u_xlat16_1 * vec4(0.100000001, 0.100000001, 0.100000001, 0.100000001);
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
					in highp vec4 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
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
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec2 _MainTex_TexelSize;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_2;
					bool u_xlatb2;
					ivec2 u_xlati6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.y = 0.0;
					    u_xlat16_1.x = float(0.0);
					    u_xlat16_1.y = float(0.0);
					    u_xlat16_1.z = float(0.0);
					    u_xlat16_1.w = float(0.0);
					    u_xlati6.x = 0;
					    while(true){
					#ifdef UNITY_ADRENO_ES3
					        u_xlatb2 = !!(u_xlati6.x>=10);
					#else
					        u_xlatb2 = u_xlati6.x>=10;
					#endif
					        if(u_xlatb2){break;}
					        u_xlati6.xy = u_xlati6.xx + ivec2(1, -5);
					        u_xlat9 = float(u_xlati6.y);
					        u_xlat0.x = u_xlat9 * _MainTex_TexelSize.x;
					        u_xlat0.xw = u_xlat0.xy + vs_TEXCOORD0.xy;
					        u_xlat10_2 = texture(_MainTex, u_xlat0.xw);
					        u_xlat16_1 = u_xlat16_1 + u_xlat10_2;
					        u_xlat16_1 = u_xlat16_1;
					    }
					    SV_Target0 = u_xlat16_1 * vec4(0.100000001, 0.100000001, 0.100000001, 0.100000001);
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
					in highp vec4 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
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
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec2 _MainTex_TexelSize;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_2;
					bool u_xlatb2;
					ivec2 u_xlati6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.y = 0.0;
					    u_xlat16_1.x = float(0.0);
					    u_xlat16_1.y = float(0.0);
					    u_xlat16_1.z = float(0.0);
					    u_xlat16_1.w = float(0.0);
					    u_xlati6.x = 0;
					    while(true){
					#ifdef UNITY_ADRENO_ES3
					        u_xlatb2 = !!(u_xlati6.x>=10);
					#else
					        u_xlatb2 = u_xlati6.x>=10;
					#endif
					        if(u_xlatb2){break;}
					        u_xlati6.xy = u_xlati6.xx + ivec2(1, -5);
					        u_xlat9 = float(u_xlati6.y);
					        u_xlat0.x = u_xlat9 * _MainTex_TexelSize.x;
					        u_xlat0.xw = u_xlat0.xy + vs_TEXCOORD0.xy;
					        u_xlat10_2 = texture(_MainTex, u_xlat0.xw);
					        u_xlat16_1 = u_xlat16_1 + u_xlat10_2;
					        u_xlat16_1 = u_xlat16_1;
					    }
					    SV_Target0 = u_xlat16_1 * vec4(0.100000001, 0.100000001, 0.100000001, 0.100000001);
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
		Pass {
			GpuProgramID 190106
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
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform highp vec4 _MainTex_TexelSize;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = xlv_TEXCOORD0;
					  mediump vec4 colorIntensityInRadius_3;
					  highp float texelY_4;
					  texelY_4 = _MainTex_TexelSize.y;
					  colorIntensityInRadius_3 = vec4(0.0, 0.0, 0.0, 0.0);
					  for (highp int j_2 = 0; j_2 < 10; j_2++) {
					    highp vec2 tmpvar_5;
					    tmpvar_5.x = 0.0;
					    tmpvar_5.y = (float((j_2 - 5)) * texelY_4);
					    lowp vec4 tmpvar_6;
					    highp vec2 P_7;
					    P_7 = (tmpvar_1 + tmpvar_5);
					    tmpvar_6 = texture2D (_MainTex, P_7);
					    colorIntensityInRadius_3 = (colorIntensityInRadius_3 + tmpvar_6);
					  };
					  colorIntensityInRadius_3 = (colorIntensityInRadius_3 / 10.0);
					  gl_FragData[0] = colorIntensityInRadius_3;
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
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform highp vec4 _MainTex_TexelSize;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = xlv_TEXCOORD0;
					  mediump vec4 colorIntensityInRadius_3;
					  highp float texelY_4;
					  texelY_4 = _MainTex_TexelSize.y;
					  colorIntensityInRadius_3 = vec4(0.0, 0.0, 0.0, 0.0);
					  for (highp int j_2 = 0; j_2 < 10; j_2++) {
					    highp vec2 tmpvar_5;
					    tmpvar_5.x = 0.0;
					    tmpvar_5.y = (float((j_2 - 5)) * texelY_4);
					    lowp vec4 tmpvar_6;
					    highp vec2 P_7;
					    P_7 = (tmpvar_1 + tmpvar_5);
					    tmpvar_6 = texture2D (_MainTex, P_7);
					    colorIntensityInRadius_3 = (colorIntensityInRadius_3 + tmpvar_6);
					  };
					  colorIntensityInRadius_3 = (colorIntensityInRadius_3 / 10.0);
					  gl_FragData[0] = colorIntensityInRadius_3;
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
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform highp vec4 _MainTex_TexelSize;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  highp vec2 tmpvar_1;
					  tmpvar_1 = xlv_TEXCOORD0;
					  mediump vec4 colorIntensityInRadius_3;
					  highp float texelY_4;
					  texelY_4 = _MainTex_TexelSize.y;
					  colorIntensityInRadius_3 = vec4(0.0, 0.0, 0.0, 0.0);
					  for (highp int j_2 = 0; j_2 < 10; j_2++) {
					    highp vec2 tmpvar_5;
					    tmpvar_5.x = 0.0;
					    tmpvar_5.y = (float((j_2 - 5)) * texelY_4);
					    lowp vec4 tmpvar_6;
					    highp vec2 P_7;
					    P_7 = (tmpvar_1 + tmpvar_5);
					    tmpvar_6 = texture2D (_MainTex, P_7);
					    colorIntensityInRadius_3 = (colorIntensityInRadius_3 + tmpvar_6);
					  };
					  colorIntensityInRadius_3 = (colorIntensityInRadius_3 / 10.0);
					  gl_FragData[0] = colorIntensityInRadius_3;
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
					in highp vec4 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
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
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _MainTex_TexelSize;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec2 u_xlat0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_2;
					bool u_xlatb2;
					vec3 u_xlat3;
					ivec2 u_xlati6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.x = 0.0;
					    u_xlat16_1.x = float(0.0);
					    u_xlat16_1.y = float(0.0);
					    u_xlat16_1.z = float(0.0);
					    u_xlat16_1.w = float(0.0);
					    u_xlati6.x = 0;
					    while(true){
					#ifdef UNITY_ADRENO_ES3
					        u_xlatb2 = !!(u_xlati6.x>=10);
					#else
					        u_xlatb2 = u_xlati6.x>=10;
					#endif
					        if(u_xlatb2){break;}
					        u_xlati6.xy = u_xlati6.xx + ivec2(1, -5);
					        u_xlat9 = float(u_xlati6.y);
					        u_xlat0.y = u_xlat9 * _MainTex_TexelSize.y;
					        u_xlat3.xz = u_xlat0.xy + vs_TEXCOORD0.xy;
					        u_xlat10_2 = texture(_MainTex, u_xlat3.xz);
					        u_xlat16_1 = u_xlat16_1 + u_xlat10_2;
					        u_xlat16_1 = u_xlat16_1;
					    }
					    SV_Target0 = u_xlat16_1 * vec4(0.100000001, 0.100000001, 0.100000001, 0.100000001);
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
					in highp vec4 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
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
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _MainTex_TexelSize;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec2 u_xlat0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_2;
					bool u_xlatb2;
					vec3 u_xlat3;
					ivec2 u_xlati6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.x = 0.0;
					    u_xlat16_1.x = float(0.0);
					    u_xlat16_1.y = float(0.0);
					    u_xlat16_1.z = float(0.0);
					    u_xlat16_1.w = float(0.0);
					    u_xlati6.x = 0;
					    while(true){
					#ifdef UNITY_ADRENO_ES3
					        u_xlatb2 = !!(u_xlati6.x>=10);
					#else
					        u_xlatb2 = u_xlati6.x>=10;
					#endif
					        if(u_xlatb2){break;}
					        u_xlati6.xy = u_xlati6.xx + ivec2(1, -5);
					        u_xlat9 = float(u_xlati6.y);
					        u_xlat0.y = u_xlat9 * _MainTex_TexelSize.y;
					        u_xlat3.xz = u_xlat0.xy + vs_TEXCOORD0.xy;
					        u_xlat10_2 = texture(_MainTex, u_xlat3.xz);
					        u_xlat16_1 = u_xlat16_1 + u_xlat10_2;
					        u_xlat16_1 = u_xlat16_1;
					    }
					    SV_Target0 = u_xlat16_1 * vec4(0.100000001, 0.100000001, 0.100000001, 0.100000001);
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
					in highp vec4 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
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
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _MainTex_TexelSize;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec2 u_xlat0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_2;
					bool u_xlatb2;
					vec3 u_xlat3;
					ivec2 u_xlati6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.x = 0.0;
					    u_xlat16_1.x = float(0.0);
					    u_xlat16_1.y = float(0.0);
					    u_xlat16_1.z = float(0.0);
					    u_xlat16_1.w = float(0.0);
					    u_xlati6.x = 0;
					    while(true){
					#ifdef UNITY_ADRENO_ES3
					        u_xlatb2 = !!(u_xlati6.x>=10);
					#else
					        u_xlatb2 = u_xlati6.x>=10;
					#endif
					        if(u_xlatb2){break;}
					        u_xlati6.xy = u_xlati6.xx + ivec2(1, -5);
					        u_xlat9 = float(u_xlati6.y);
					        u_xlat0.y = u_xlat9 * _MainTex_TexelSize.y;
					        u_xlat3.xz = u_xlat0.xy + vs_TEXCOORD0.xy;
					        u_xlat10_2 = texture(_MainTex, u_xlat3.xz);
					        u_xlat16_1 = u_xlat16_1 + u_xlat10_2;
					        u_xlat16_1 = u_xlat16_1;
					    }
					    SV_Target0 = u_xlat16_1 * vec4(0.100000001, 0.100000001, 0.100000001, 0.100000001);
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