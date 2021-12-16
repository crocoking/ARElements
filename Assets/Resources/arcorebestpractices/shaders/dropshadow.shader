Shader "ARBestPractices/DropShadow" {
	Properties {
		[HDR] _Color ("Color", Vector) = (1,1,1,1)
		_MainTex ("Particle Texture", 2D) = "white" {}
		[Toggle(VERTEXCOLORISMASK)] _VertexColorIsMask ("Vertex Color Is Mask", Float) = 0
		_InvFade ("Soft Particles Factor", Float) = 1
		_DepthOffset ("DepthOffset", Float) = 0
		_DepthOffsetAngleFactor ("DepthOffsetAngleFactor", Float) = 0
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend DstColor SrcColor, DstColor SrcColor
			ZWrite Off
			Cull Off
			GpuProgramID 1545
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _Color;
					uniform highp vec4 _MainTex_ST;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					varying lowp vec4 xlv_TEXCOORD3;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp vec4 tmpvar_2;
					  tmpvar_2.w = 1.0;
					  tmpvar_2.xyz = _glesVertex.xyz;
					  tmpvar_1 = (_glesColor * _Color);
					  tmpvar_1.xyz = (tmpvar_1.xyz * 0.5);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
					  xlv_COLOR = tmpvar_1;
					  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  xlv_TEXCOORD3 = _glesColor;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  lowp vec4 col_1;
					  mediump vec4 prev_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = (xlv_COLOR * texture2D (_MainTex, xlv_TEXCOORD0));
					  prev_2 = tmpvar_3;
					  mediump vec4 tmpvar_4;
					  tmpvar_4 = mix (vec4(0.5, 0.5, 0.5, 1.0), prev_2, prev_2.wwww);
					  col_1 = tmpvar_4;
					  gl_FragData[0] = col_1;
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
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _Color;
					uniform highp vec4 _MainTex_ST;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					varying lowp vec4 xlv_TEXCOORD3;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp vec4 tmpvar_2;
					  tmpvar_2.w = 1.0;
					  tmpvar_2.xyz = _glesVertex.xyz;
					  tmpvar_1 = (_glesColor * _Color);
					  tmpvar_1.xyz = (tmpvar_1.xyz * 0.5);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
					  xlv_COLOR = tmpvar_1;
					  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  xlv_TEXCOORD3 = _glesColor;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  lowp vec4 col_1;
					  mediump vec4 prev_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = (xlv_COLOR * texture2D (_MainTex, xlv_TEXCOORD0));
					  prev_2 = tmpvar_3;
					  mediump vec4 tmpvar_4;
					  tmpvar_4 = mix (vec4(0.5, 0.5, 0.5, 1.0), prev_2, prev_2.wwww);
					  col_1 = tmpvar_4;
					  gl_FragData[0] = col_1;
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
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _Color;
					uniform highp vec4 _MainTex_ST;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					varying lowp vec4 xlv_TEXCOORD3;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp vec4 tmpvar_2;
					  tmpvar_2.w = 1.0;
					  tmpvar_2.xyz = _glesVertex.xyz;
					  tmpvar_1 = (_glesColor * _Color);
					  tmpvar_1.xyz = (tmpvar_1.xyz * 0.5);
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
					  xlv_COLOR = tmpvar_1;
					  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  xlv_TEXCOORD3 = _glesColor;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					void main ()
					{
					  lowp vec4 col_1;
					  mediump vec4 prev_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = (xlv_COLOR * texture2D (_MainTex, xlv_TEXCOORD0));
					  prev_2 = tmpvar_3;
					  mediump vec4 tmpvar_4;
					  tmpvar_4 = mix (vec4(0.5, 0.5, 0.5, 1.0), prev_2, prev_2.wwww);
					  col_1 = tmpvar_4;
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
					uniform 	vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in mediump vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out mediump vec4 vs_TEXCOORD3;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0.xyz = u_xlat0.xyz * vec3(0.5, 0.5, 0.5);
					    vs_COLOR0.w = u_xlat0.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD3 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform lowp sampler2D _MainTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					mediump vec4 u_xlat16_0;
					lowp vec4 u_xlat10_0;
					mediump float u_xlat16_1;
					void main()
					{
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat16_1 = u_xlat10_0.w * vs_COLOR0.w;
					    u_xlat16_0 = vs_COLOR0 * u_xlat10_0 + vec4(-0.5, -0.5, -0.5, -1.0);
					    SV_Target0 = vec4(u_xlat16_1) * u_xlat16_0 + vec4(0.5, 0.5, 0.5, 1.0);
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
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in mediump vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out mediump vec4 vs_TEXCOORD3;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0.xyz = u_xlat0.xyz * vec3(0.5, 0.5, 0.5);
					    vs_COLOR0.w = u_xlat0.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD3 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform lowp sampler2D _MainTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					mediump vec4 u_xlat16_0;
					lowp vec4 u_xlat10_0;
					mediump float u_xlat16_1;
					void main()
					{
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat16_1 = u_xlat10_0.w * vs_COLOR0.w;
					    u_xlat16_0 = vs_COLOR0 * u_xlat10_0 + vec4(-0.5, -0.5, -0.5, -1.0);
					    SV_Target0 = vec4(u_xlat16_1) * u_xlat16_0 + vec4(0.5, 0.5, 0.5, 1.0);
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
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in mediump vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out mediump vec4 vs_TEXCOORD3;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0.xyz = u_xlat0.xyz * vec3(0.5, 0.5, 0.5);
					    vs_COLOR0.w = u_xlat0.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD3 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform lowp sampler2D _MainTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					mediump vec4 u_xlat16_0;
					lowp vec4 u_xlat10_0;
					mediump float u_xlat16_1;
					void main()
					{
					    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat16_1 = u_xlat10_0.w * vs_COLOR0.w;
					    u_xlat16_0 = vs_COLOR0 * u_xlat10_0 + vec4(-0.5, -0.5, -0.5, -1.0);
					    SV_Target0 = vec4(u_xlat16_1) * u_xlat16_0 + vec4(0.5, 0.5, 0.5, 1.0);
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp vec4 _ProjectionParams;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixV;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _Color;
					uniform highp vec4 _MainTex_ST;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD2;
					varying lowp vec4 xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1 = _glesVertex;
					  lowp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  highp vec4 tmpvar_4;
					  highp vec4 tmpvar_5;
					  tmpvar_5.w = 1.0;
					  tmpvar_5.xyz = tmpvar_1.xyz;
					  tmpvar_4 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_5));
					  highp vec4 o_6;
					  highp vec4 tmpvar_7;
					  tmpvar_7 = (tmpvar_4 * 0.5);
					  highp vec2 tmpvar_8;
					  tmpvar_8.x = tmpvar_7.x;
					  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
					  o_6.xy = (tmpvar_8 + tmpvar_7.w);
					  o_6.zw = tmpvar_4.zw;
					  tmpvar_3.xyw = o_6.xyw;
					  highp vec4 tmpvar_9;
					  tmpvar_9.w = 1.0;
					  tmpvar_9.xyz = tmpvar_1.xyz;
					  tmpvar_3.z = -((unity_MatrixV * (unity_ObjectToWorld * tmpvar_9)).z);
					  tmpvar_2 = (_glesColor * _Color);
					  tmpvar_2.xyz = (tmpvar_2.xyz * 0.5);
					  gl_Position = tmpvar_4;
					  xlv_COLOR = tmpvar_2;
					  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  xlv_TEXCOORD2 = tmpvar_3;
					  xlv_TEXCOORD3 = _glesColor;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _ZBufferParams;
					uniform sampler2D _MainTex;
					uniform highp sampler2D _CameraDepthTexture;
					uniform highp float _InvFade;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD2;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  tmpvar_1.xyz = xlv_COLOR.xyz;
					  lowp vec4 col_2;
					  mediump vec4 prev_3;
					  highp float tmpvar_4;
					  tmpvar_4 = clamp ((_InvFade * (
					    (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD2).x) + _ZBufferParams.w)))
					   - xlv_TEXCOORD2.z)), 0.0, 1.0);
					  tmpvar_1.w = (xlv_COLOR.w * tmpvar_4);
					  lowp vec4 tmpvar_5;
					  tmpvar_5 = (tmpvar_1 * texture2D (_MainTex, xlv_TEXCOORD0));
					  prev_3 = tmpvar_5;
					  mediump vec4 tmpvar_6;
					  tmpvar_6 = mix (vec4(0.5, 0.5, 0.5, 1.0), prev_3, prev_3.wwww);
					  col_2 = tmpvar_6;
					  gl_FragData[0] = col_2;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp vec4 _ProjectionParams;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixV;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _Color;
					uniform highp vec4 _MainTex_ST;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD2;
					varying lowp vec4 xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1 = _glesVertex;
					  lowp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  highp vec4 tmpvar_4;
					  highp vec4 tmpvar_5;
					  tmpvar_5.w = 1.0;
					  tmpvar_5.xyz = tmpvar_1.xyz;
					  tmpvar_4 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_5));
					  highp vec4 o_6;
					  highp vec4 tmpvar_7;
					  tmpvar_7 = (tmpvar_4 * 0.5);
					  highp vec2 tmpvar_8;
					  tmpvar_8.x = tmpvar_7.x;
					  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
					  o_6.xy = (tmpvar_8 + tmpvar_7.w);
					  o_6.zw = tmpvar_4.zw;
					  tmpvar_3.xyw = o_6.xyw;
					  highp vec4 tmpvar_9;
					  tmpvar_9.w = 1.0;
					  tmpvar_9.xyz = tmpvar_1.xyz;
					  tmpvar_3.z = -((unity_MatrixV * (unity_ObjectToWorld * tmpvar_9)).z);
					  tmpvar_2 = (_glesColor * _Color);
					  tmpvar_2.xyz = (tmpvar_2.xyz * 0.5);
					  gl_Position = tmpvar_4;
					  xlv_COLOR = tmpvar_2;
					  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  xlv_TEXCOORD2 = tmpvar_3;
					  xlv_TEXCOORD3 = _glesColor;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _ZBufferParams;
					uniform sampler2D _MainTex;
					uniform highp sampler2D _CameraDepthTexture;
					uniform highp float _InvFade;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD2;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  tmpvar_1.xyz = xlv_COLOR.xyz;
					  lowp vec4 col_2;
					  mediump vec4 prev_3;
					  highp float tmpvar_4;
					  tmpvar_4 = clamp ((_InvFade * (
					    (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD2).x) + _ZBufferParams.w)))
					   - xlv_TEXCOORD2.z)), 0.0, 1.0);
					  tmpvar_1.w = (xlv_COLOR.w * tmpvar_4);
					  lowp vec4 tmpvar_5;
					  tmpvar_5 = (tmpvar_1 * texture2D (_MainTex, xlv_TEXCOORD0));
					  prev_3 = tmpvar_5;
					  mediump vec4 tmpvar_6;
					  tmpvar_6 = mix (vec4(0.5, 0.5, 0.5, 1.0), prev_3, prev_3.wwww);
					  col_2 = tmpvar_6;
					  gl_FragData[0] = col_2;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp vec4 _ProjectionParams;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixV;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _Color;
					uniform highp vec4 _MainTex_ST;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD2;
					varying lowp vec4 xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1 = _glesVertex;
					  lowp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  highp vec4 tmpvar_4;
					  highp vec4 tmpvar_5;
					  tmpvar_5.w = 1.0;
					  tmpvar_5.xyz = tmpvar_1.xyz;
					  tmpvar_4 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_5));
					  highp vec4 o_6;
					  highp vec4 tmpvar_7;
					  tmpvar_7 = (tmpvar_4 * 0.5);
					  highp vec2 tmpvar_8;
					  tmpvar_8.x = tmpvar_7.x;
					  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
					  o_6.xy = (tmpvar_8 + tmpvar_7.w);
					  o_6.zw = tmpvar_4.zw;
					  tmpvar_3.xyw = o_6.xyw;
					  highp vec4 tmpvar_9;
					  tmpvar_9.w = 1.0;
					  tmpvar_9.xyz = tmpvar_1.xyz;
					  tmpvar_3.z = -((unity_MatrixV * (unity_ObjectToWorld * tmpvar_9)).z);
					  tmpvar_2 = (_glesColor * _Color);
					  tmpvar_2.xyz = (tmpvar_2.xyz * 0.5);
					  gl_Position = tmpvar_4;
					  xlv_COLOR = tmpvar_2;
					  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
					  xlv_TEXCOORD2 = tmpvar_3;
					  xlv_TEXCOORD3 = _glesColor;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _ZBufferParams;
					uniform sampler2D _MainTex;
					uniform highp sampler2D _CameraDepthTexture;
					uniform highp float _InvFade;
					varying lowp vec4 xlv_COLOR;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec4 xlv_TEXCOORD2;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  tmpvar_1.xyz = xlv_COLOR.xyz;
					  lowp vec4 col_2;
					  mediump vec4 prev_3;
					  highp float tmpvar_4;
					  tmpvar_4 = clamp ((_InvFade * (
					    (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD2).x) + _ZBufferParams.w)))
					   - xlv_TEXCOORD2.z)), 0.0, 1.0);
					  tmpvar_1.w = (xlv_COLOR.w * tmpvar_4);
					  lowp vec4 tmpvar_5;
					  tmpvar_5 = (tmpvar_1 * texture2D (_MainTex, xlv_TEXCOORD0));
					  prev_3 = tmpvar_5;
					  mediump vec4 tmpvar_6;
					  tmpvar_6 = mix (vec4(0.5, 0.5, 0.5, 1.0), prev_3, prev_3.wwww);
					  col_2 = tmpvar_6;
					  gl_FragData[0] = col_2;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 _ProjectionParams;
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in mediump vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD2;
					out mediump vec4 vs_TEXCOORD3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					float u_xlat3;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat1;
					    u_xlat2 = in_COLOR0 * _Color;
					    vs_COLOR0.xyz = u_xlat2.xyz * vec3(0.5, 0.5, 0.5);
					    vs_COLOR0.w = u_xlat2.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat3 = u_xlat0.y * hlslcc_mtx4x4unity_MatrixV[1].z;
					    u_xlat0.x = hlslcc_mtx4x4unity_MatrixV[0].z * u_xlat0.x + u_xlat3;
					    u_xlat0.x = hlslcc_mtx4x4unity_MatrixV[2].z * u_xlat0.z + u_xlat0.x;
					    u_xlat0.x = hlslcc_mtx4x4unity_MatrixV[3].z * u_xlat0.w + u_xlat0.x;
					    vs_TEXCOORD2.z = (-u_xlat0.x);
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * vec2(0.5, 0.5);
					    vs_TEXCOORD2.w = u_xlat1.w;
					    vs_TEXCOORD2.xy = u_xlat0.zz + u_xlat0.xw;
					    vs_TEXCOORD3 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _ZBufferParams;
					uniform 	float _InvFade;
					uniform highp sampler2D _CameraDepthTexture;
					uniform lowp sampler2D _MainTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD2;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_1;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD2.xy / vs_TEXCOORD2.ww;
					    u_xlat0.x = texture(_CameraDepthTexture, u_xlat0.xy).x;
					    u_xlat0.x = _ZBufferParams.z * u_xlat0.x + _ZBufferParams.w;
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlat0.x = u_xlat0.x + (-vs_TEXCOORD2.z);
					    u_xlat0.x = u_xlat0.x * _InvFade;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
					#else
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat0.x * vs_COLOR0.w;
					    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat0.w = u_xlat0.x * u_xlat10_1.w;
					    u_xlat0.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat16_1 = u_xlat0 + vec4(-0.5, -0.5, -0.5, -1.0);
					    SV_Target0 = u_xlat0.wwww * u_xlat16_1 + vec4(0.5, 0.5, 0.5, 1.0);
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 _ProjectionParams;
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in mediump vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD2;
					out mediump vec4 vs_TEXCOORD3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					float u_xlat3;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat1;
					    u_xlat2 = in_COLOR0 * _Color;
					    vs_COLOR0.xyz = u_xlat2.xyz * vec3(0.5, 0.5, 0.5);
					    vs_COLOR0.w = u_xlat2.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat3 = u_xlat0.y * hlslcc_mtx4x4unity_MatrixV[1].z;
					    u_xlat0.x = hlslcc_mtx4x4unity_MatrixV[0].z * u_xlat0.x + u_xlat3;
					    u_xlat0.x = hlslcc_mtx4x4unity_MatrixV[2].z * u_xlat0.z + u_xlat0.x;
					    u_xlat0.x = hlslcc_mtx4x4unity_MatrixV[3].z * u_xlat0.w + u_xlat0.x;
					    vs_TEXCOORD2.z = (-u_xlat0.x);
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * vec2(0.5, 0.5);
					    vs_TEXCOORD2.w = u_xlat1.w;
					    vs_TEXCOORD2.xy = u_xlat0.zz + u_xlat0.xw;
					    vs_TEXCOORD3 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _ZBufferParams;
					uniform 	float _InvFade;
					uniform highp sampler2D _CameraDepthTexture;
					uniform lowp sampler2D _MainTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD2;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_1;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD2.xy / vs_TEXCOORD2.ww;
					    u_xlat0.x = texture(_CameraDepthTexture, u_xlat0.xy).x;
					    u_xlat0.x = _ZBufferParams.z * u_xlat0.x + _ZBufferParams.w;
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlat0.x = u_xlat0.x + (-vs_TEXCOORD2.z);
					    u_xlat0.x = u_xlat0.x * _InvFade;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
					#else
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat0.x * vs_COLOR0.w;
					    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat0.w = u_xlat0.x * u_xlat10_1.w;
					    u_xlat0.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat16_1 = u_xlat0 + vec4(-0.5, -0.5, -0.5, -1.0);
					    SV_Target0 = u_xlat0.wwww * u_xlat16_1 + vec4(0.5, 0.5, 0.5, 1.0);
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 _ProjectionParams;
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in mediump vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD2;
					out mediump vec4 vs_TEXCOORD3;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					float u_xlat3;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat1;
					    u_xlat2 = in_COLOR0 * _Color;
					    vs_COLOR0.xyz = u_xlat2.xyz * vec3(0.5, 0.5, 0.5);
					    vs_COLOR0.w = u_xlat2.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat3 = u_xlat0.y * hlslcc_mtx4x4unity_MatrixV[1].z;
					    u_xlat0.x = hlslcc_mtx4x4unity_MatrixV[0].z * u_xlat0.x + u_xlat3;
					    u_xlat0.x = hlslcc_mtx4x4unity_MatrixV[2].z * u_xlat0.z + u_xlat0.x;
					    u_xlat0.x = hlslcc_mtx4x4unity_MatrixV[3].z * u_xlat0.w + u_xlat0.x;
					    vs_TEXCOORD2.z = (-u_xlat0.x);
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * vec2(0.5, 0.5);
					    vs_TEXCOORD2.w = u_xlat1.w;
					    vs_TEXCOORD2.xy = u_xlat0.zz + u_xlat0.xw;
					    vs_TEXCOORD3 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _ZBufferParams;
					uniform 	float _InvFade;
					uniform highp sampler2D _CameraDepthTexture;
					uniform lowp sampler2D _MainTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD2;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec4 u_xlat16_1;
					lowp vec4 u_xlat10_1;
					void main()
					{
					    u_xlat0.xy = vs_TEXCOORD2.xy / vs_TEXCOORD2.ww;
					    u_xlat0.x = texture(_CameraDepthTexture, u_xlat0.xy).x;
					    u_xlat0.x = _ZBufferParams.z * u_xlat0.x + _ZBufferParams.w;
					    u_xlat0.x = float(1.0) / u_xlat0.x;
					    u_xlat0.x = u_xlat0.x + (-vs_TEXCOORD2.z);
					    u_xlat0.x = u_xlat0.x * _InvFade;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
					#else
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat0.x * vs_COLOR0.w;
					    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat0.w = u_xlat0.x * u_xlat10_1.w;
					    u_xlat0.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat16_1 = u_xlat0 + vec4(-0.5, -0.5, -0.5, -1.0);
					    SV_Target0 = u_xlat0.wwww * u_xlat16_1 + vec4(0.5, 0.5, 0.5, 1.0);
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
				SubProgram "gles hw_tier00 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "SOFTPARTICLES_ON" }
					"!!GLES3"
				}
			}
		}
	}
}