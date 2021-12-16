Shader "ARBestPractices/PlaneGrid" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_GridColor ("Grid Color", Vector) = (1,1,0,1)
		_UvRotation ("UV Rotation", Float) = 30
		_MaxDepth ("MaxDepth", Float) = 15
	}
	SubShader {
		Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 47764
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _MainTex_ST;
					uniform highp vec4 _GridColor;
					uniform lowp float _UvRotation;
					varying highp vec2 xlv_TEXCOORD0;
					varying lowp vec4 xlv_COLOR;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  tmpvar_2 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  lowp float tmpvar_4;
					  tmpvar_4 = cos(_UvRotation);
					  lowp float tmpvar_5;
					  tmpvar_5 = sin(_UvRotation);
					  lowp mat2 tmpvar_6;
					  tmpvar_6[0].x = tmpvar_4;
					  tmpvar_6[0].y = tmpvar_5;
					  tmpvar_6[1].x = -(tmpvar_5);
					  tmpvar_6[1].y = tmpvar_4;
					  tmpvar_1 = (_glesColor * _GridColor);
					  gl_Position = tmpvar_2;
					  xlv_TEXCOORD0 = (tmpvar_6 * ((unity_ObjectToWorld * _glesVertex).xz * _MainTex_ST.xy));
					  xlv_COLOR = tmpvar_1;
					  xlv_TEXCOORD1 = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _ScreenParams;
					uniform highp vec4 _ZBufferParams;
					uniform sampler2D _MainTex;
					uniform highp float _MaxDepth;
					varying highp vec2 xlv_TEXCOORD0;
					varying lowp vec4 xlv_COLOR;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp float screenMask_2;
					  highp vec2 screenPos_3;
					  highp vec2 tmpvar_4;
					  tmpvar_4 = (xlv_TEXCOORD1.xy / xlv_TEXCOORD1.w);
					  screenPos_3 = tmpvar_4;
					  highp float tmpvar_5;
					  tmpvar_5 = (max (_ScreenParams.x, _ScreenParams.y) / min (_ScreenParams.x, _ScreenParams.y));
					  if ((_ScreenParams.x > _ScreenParams.y)) {
					    screenPos_3.x = (tmpvar_4.x * tmpvar_5);
					  } else {
					    screenPos_3.y = (tmpvar_4.y * tmpvar_5);
					  };
					  highp float tmpvar_6;
					  tmpvar_6 = clamp (((1.0 - 
					    clamp (sqrt(dot (screenPos_3, screenPos_3)), 0.0, 1.0)
					  ) * 4.0), 0.0, 1.0);
					  screenMask_2 = tmpvar_6;
					  highp float tmpvar_7;
					  tmpvar_7 = (1.0/(((_ZBufferParams.z * 
					    (xlv_TEXCOORD1.z / xlv_TEXCOORD1.w)
					  ) + _ZBufferParams.w)));
					  if ((_MaxDepth > 0.0)) {
					    screenMask_2 = (tmpvar_6 * (1.0 - clamp (
					      (tmpvar_7 / _MaxDepth)
					    , 0.0, 1.0)));
					  };
					  lowp vec4 tmpvar_8;
					  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
					  highp vec4 tmpvar_9;
					  tmpvar_9.xyz = xlv_COLOR.xyz;
					  tmpvar_9.w = ((tmpvar_8.x * xlv_COLOR.w) * screenMask_2);
					  tmpvar_1 = tmpvar_9;
					  gl_FragData[0] = tmpvar_1;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _MainTex_ST;
					uniform highp vec4 _GridColor;
					uniform lowp float _UvRotation;
					varying highp vec2 xlv_TEXCOORD0;
					varying lowp vec4 xlv_COLOR;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  tmpvar_2 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  lowp float tmpvar_4;
					  tmpvar_4 = cos(_UvRotation);
					  lowp float tmpvar_5;
					  tmpvar_5 = sin(_UvRotation);
					  lowp mat2 tmpvar_6;
					  tmpvar_6[0].x = tmpvar_4;
					  tmpvar_6[0].y = tmpvar_5;
					  tmpvar_6[1].x = -(tmpvar_5);
					  tmpvar_6[1].y = tmpvar_4;
					  tmpvar_1 = (_glesColor * _GridColor);
					  gl_Position = tmpvar_2;
					  xlv_TEXCOORD0 = (tmpvar_6 * ((unity_ObjectToWorld * _glesVertex).xz * _MainTex_ST.xy));
					  xlv_COLOR = tmpvar_1;
					  xlv_TEXCOORD1 = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _ScreenParams;
					uniform highp vec4 _ZBufferParams;
					uniform sampler2D _MainTex;
					uniform highp float _MaxDepth;
					varying highp vec2 xlv_TEXCOORD0;
					varying lowp vec4 xlv_COLOR;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp float screenMask_2;
					  highp vec2 screenPos_3;
					  highp vec2 tmpvar_4;
					  tmpvar_4 = (xlv_TEXCOORD1.xy / xlv_TEXCOORD1.w);
					  screenPos_3 = tmpvar_4;
					  highp float tmpvar_5;
					  tmpvar_5 = (max (_ScreenParams.x, _ScreenParams.y) / min (_ScreenParams.x, _ScreenParams.y));
					  if ((_ScreenParams.x > _ScreenParams.y)) {
					    screenPos_3.x = (tmpvar_4.x * tmpvar_5);
					  } else {
					    screenPos_3.y = (tmpvar_4.y * tmpvar_5);
					  };
					  highp float tmpvar_6;
					  tmpvar_6 = clamp (((1.0 - 
					    clamp (sqrt(dot (screenPos_3, screenPos_3)), 0.0, 1.0)
					  ) * 4.0), 0.0, 1.0);
					  screenMask_2 = tmpvar_6;
					  highp float tmpvar_7;
					  tmpvar_7 = (1.0/(((_ZBufferParams.z * 
					    (xlv_TEXCOORD1.z / xlv_TEXCOORD1.w)
					  ) + _ZBufferParams.w)));
					  if ((_MaxDepth > 0.0)) {
					    screenMask_2 = (tmpvar_6 * (1.0 - clamp (
					      (tmpvar_7 / _MaxDepth)
					    , 0.0, 1.0)));
					  };
					  lowp vec4 tmpvar_8;
					  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
					  highp vec4 tmpvar_9;
					  tmpvar_9.xyz = xlv_COLOR.xyz;
					  tmpvar_9.w = ((tmpvar_8.x * xlv_COLOR.w) * screenMask_2);
					  tmpvar_1 = tmpvar_9;
					  gl_FragData[0] = tmpvar_1;
					}
					
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesColor;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp vec4 _MainTex_ST;
					uniform highp vec4 _GridColor;
					uniform lowp float _UvRotation;
					varying highp vec2 xlv_TEXCOORD0;
					varying lowp vec4 xlv_COLOR;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp vec4 tmpvar_2;
					  highp vec4 tmpvar_3;
					  tmpvar_3.w = 1.0;
					  tmpvar_3.xyz = _glesVertex.xyz;
					  tmpvar_2 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
					  lowp float tmpvar_4;
					  tmpvar_4 = cos(_UvRotation);
					  lowp float tmpvar_5;
					  tmpvar_5 = sin(_UvRotation);
					  lowp mat2 tmpvar_6;
					  tmpvar_6[0].x = tmpvar_4;
					  tmpvar_6[0].y = tmpvar_5;
					  tmpvar_6[1].x = -(tmpvar_5);
					  tmpvar_6[1].y = tmpvar_4;
					  tmpvar_1 = (_glesColor * _GridColor);
					  gl_Position = tmpvar_2;
					  xlv_TEXCOORD0 = (tmpvar_6 * ((unity_ObjectToWorld * _glesVertex).xz * _MainTex_ST.xy));
					  xlv_COLOR = tmpvar_1;
					  xlv_TEXCOORD1 = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp vec4 _ScreenParams;
					uniform highp vec4 _ZBufferParams;
					uniform sampler2D _MainTex;
					uniform highp float _MaxDepth;
					varying highp vec2 xlv_TEXCOORD0;
					varying lowp vec4 xlv_COLOR;
					varying highp vec4 xlv_TEXCOORD1;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp float screenMask_2;
					  highp vec2 screenPos_3;
					  highp vec2 tmpvar_4;
					  tmpvar_4 = (xlv_TEXCOORD1.xy / xlv_TEXCOORD1.w);
					  screenPos_3 = tmpvar_4;
					  highp float tmpvar_5;
					  tmpvar_5 = (max (_ScreenParams.x, _ScreenParams.y) / min (_ScreenParams.x, _ScreenParams.y));
					  if ((_ScreenParams.x > _ScreenParams.y)) {
					    screenPos_3.x = (tmpvar_4.x * tmpvar_5);
					  } else {
					    screenPos_3.y = (tmpvar_4.y * tmpvar_5);
					  };
					  highp float tmpvar_6;
					  tmpvar_6 = clamp (((1.0 - 
					    clamp (sqrt(dot (screenPos_3, screenPos_3)), 0.0, 1.0)
					  ) * 4.0), 0.0, 1.0);
					  screenMask_2 = tmpvar_6;
					  highp float tmpvar_7;
					  tmpvar_7 = (1.0/(((_ZBufferParams.z * 
					    (xlv_TEXCOORD1.z / xlv_TEXCOORD1.w)
					  ) + _ZBufferParams.w)));
					  if ((_MaxDepth > 0.0)) {
					    screenMask_2 = (tmpvar_6 * (1.0 - clamp (
					      (tmpvar_7 / _MaxDepth)
					    , 0.0, 1.0)));
					  };
					  lowp vec4 tmpvar_8;
					  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
					  highp vec4 tmpvar_9;
					  tmpvar_9.xyz = xlv_COLOR.xyz;
					  tmpvar_9.w = ((tmpvar_8.x * xlv_COLOR.w) * screenMask_2);
					  tmpvar_1 = tmpvar_9;
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
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _GridColor;
					uniform 	mediump float _UvRotation;
					in highp vec4 in_POSITION0;
					in mediump vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					mediump float u_xlat16_3;
					mediump float u_xlat16_4;
					mediump vec3 u_xlat16_5;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat0.xy = hlslcc_mtx4x4unity_ObjectToWorld[3].xz * in_POSITION0.ww + u_xlat0.xz;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy;
					    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    gl_Position = u_xlat1;
					    vs_TEXCOORD1 = u_xlat1;
					    u_xlat16_3 = sin(_UvRotation);
					    u_xlat16_4 = cos(_UvRotation);
					    u_xlat16_5.x = (-u_xlat16_3);
					    u_xlat16_5.y = u_xlat16_4;
					    u_xlat16_5.z = u_xlat16_3;
					    vs_TEXCOORD0.y = dot(u_xlat16_5.zy, u_xlat0.xy);
					    vs_TEXCOORD0.x = dot(u_xlat16_5.yx, u_xlat0.xy);
					    u_xlat0 = in_COLOR0 * _GridColor;
					    vs_COLOR0 = u_xlat0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	vec4 _ZBufferParams;
					uniform 	float _MaxDepth;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					in mediump vec4 vs_COLOR0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec2 u_xlat0;
					bool u_xlatb0;
					vec4 u_xlat1;
					vec3 u_xlat2;
					mediump float u_xlat16_3;
					float u_xlat4;
					lowp float u_xlat10_4;
					float u_xlat8;
					bool u_xlatb8;
					void main()
					{
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb0 = !!(_ScreenParams.y<_ScreenParams.x);
					#else
					    u_xlatb0 = _ScreenParams.y<_ScreenParams.x;
					#endif
					    u_xlat4 = max(_ScreenParams.y, _ScreenParams.x);
					    u_xlat8 = min(_ScreenParams.y, _ScreenParams.x);
					    u_xlat4 = u_xlat4 / u_xlat8;
					    u_xlat1.xyz = vs_TEXCOORD1.xyz / vs_TEXCOORD1.www;
					    u_xlat2.xy = vec2(u_xlat4) * u_xlat1.xy;
					    u_xlat1.w = u_xlat2.y;
					    u_xlat2.z = u_xlat1.y;
					    u_xlat0.xy = (bool(u_xlatb0)) ? u_xlat2.xz : u_xlat1.xw;
					    u_xlat8 = _ZBufferParams.z * u_xlat1.z + _ZBufferParams.w;
					    u_xlat8 = float(1.0) / u_xlat8;
					    u_xlat8 = u_xlat8 / _MaxDepth;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
					#else
					    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
					#endif
					    u_xlat8 = (-u_xlat8) + 1.0;
					    u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = u_xlat0.x * 4.0;
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat4 = u_xlat8 * u_xlat0.x;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb8 = !!(0.0<_MaxDepth);
					#else
					    u_xlatb8 = 0.0<_MaxDepth;
					#endif
					    u_xlat0.x = (u_xlatb8) ? u_xlat4 : u_xlat0.x;
					    u_xlat10_4 = texture(_MainTex, vs_TEXCOORD0.xy).x;
					    u_xlat16_3 = u_xlat10_4 * vs_COLOR0.w;
					    u_xlat0.x = u_xlat0.x * u_xlat16_3;
					    SV_Target0.w = u_xlat0.x;
					    SV_Target0.xyz = vs_COLOR0.xyz;
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
					uniform 	vec4 _GridColor;
					uniform 	mediump float _UvRotation;
					in highp vec4 in_POSITION0;
					in mediump vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					mediump float u_xlat16_3;
					mediump float u_xlat16_4;
					mediump vec3 u_xlat16_5;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat0.xy = hlslcc_mtx4x4unity_ObjectToWorld[3].xz * in_POSITION0.ww + u_xlat0.xz;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy;
					    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    gl_Position = u_xlat1;
					    vs_TEXCOORD1 = u_xlat1;
					    u_xlat16_3 = sin(_UvRotation);
					    u_xlat16_4 = cos(_UvRotation);
					    u_xlat16_5.x = (-u_xlat16_3);
					    u_xlat16_5.y = u_xlat16_4;
					    u_xlat16_5.z = u_xlat16_3;
					    vs_TEXCOORD0.y = dot(u_xlat16_5.zy, u_xlat0.xy);
					    vs_TEXCOORD0.x = dot(u_xlat16_5.yx, u_xlat0.xy);
					    u_xlat0 = in_COLOR0 * _GridColor;
					    vs_COLOR0 = u_xlat0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	vec4 _ZBufferParams;
					uniform 	float _MaxDepth;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					in mediump vec4 vs_COLOR0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec2 u_xlat0;
					bool u_xlatb0;
					vec4 u_xlat1;
					vec3 u_xlat2;
					mediump float u_xlat16_3;
					float u_xlat4;
					lowp float u_xlat10_4;
					float u_xlat8;
					bool u_xlatb8;
					void main()
					{
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb0 = !!(_ScreenParams.y<_ScreenParams.x);
					#else
					    u_xlatb0 = _ScreenParams.y<_ScreenParams.x;
					#endif
					    u_xlat4 = max(_ScreenParams.y, _ScreenParams.x);
					    u_xlat8 = min(_ScreenParams.y, _ScreenParams.x);
					    u_xlat4 = u_xlat4 / u_xlat8;
					    u_xlat1.xyz = vs_TEXCOORD1.xyz / vs_TEXCOORD1.www;
					    u_xlat2.xy = vec2(u_xlat4) * u_xlat1.xy;
					    u_xlat1.w = u_xlat2.y;
					    u_xlat2.z = u_xlat1.y;
					    u_xlat0.xy = (bool(u_xlatb0)) ? u_xlat2.xz : u_xlat1.xw;
					    u_xlat8 = _ZBufferParams.z * u_xlat1.z + _ZBufferParams.w;
					    u_xlat8 = float(1.0) / u_xlat8;
					    u_xlat8 = u_xlat8 / _MaxDepth;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
					#else
					    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
					#endif
					    u_xlat8 = (-u_xlat8) + 1.0;
					    u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = u_xlat0.x * 4.0;
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat4 = u_xlat8 * u_xlat0.x;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb8 = !!(0.0<_MaxDepth);
					#else
					    u_xlatb8 = 0.0<_MaxDepth;
					#endif
					    u_xlat0.x = (u_xlatb8) ? u_xlat4 : u_xlat0.x;
					    u_xlat10_4 = texture(_MainTex, vs_TEXCOORD0.xy).x;
					    u_xlat16_3 = u_xlat10_4 * vs_COLOR0.w;
					    u_xlat0.x = u_xlat0.x * u_xlat16_3;
					    SV_Target0.w = u_xlat0.x;
					    SV_Target0.xyz = vs_COLOR0.xyz;
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
					uniform 	vec4 _GridColor;
					uniform 	mediump float _UvRotation;
					in highp vec4 in_POSITION0;
					in mediump vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec4 u_xlat2;
					mediump float u_xlat16_3;
					mediump float u_xlat16_4;
					mediump vec3 u_xlat16_5;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat0.xy = hlslcc_mtx4x4unity_ObjectToWorld[3].xz * in_POSITION0.ww + u_xlat0.xz;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy;
					    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat2;
					    u_xlat2 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat2;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat2;
					    gl_Position = u_xlat1;
					    vs_TEXCOORD1 = u_xlat1;
					    u_xlat16_3 = sin(_UvRotation);
					    u_xlat16_4 = cos(_UvRotation);
					    u_xlat16_5.x = (-u_xlat16_3);
					    u_xlat16_5.y = u_xlat16_4;
					    u_xlat16_5.z = u_xlat16_3;
					    vs_TEXCOORD0.y = dot(u_xlat16_5.zy, u_xlat0.xy);
					    vs_TEXCOORD0.x = dot(u_xlat16_5.yx, u_xlat0.xy);
					    u_xlat0 = in_COLOR0 * _GridColor;
					    vs_COLOR0 = u_xlat0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	vec4 _ZBufferParams;
					uniform 	float _MaxDepth;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					in mediump vec4 vs_COLOR0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec2 u_xlat0;
					bool u_xlatb0;
					vec4 u_xlat1;
					vec3 u_xlat2;
					mediump float u_xlat16_3;
					float u_xlat4;
					lowp float u_xlat10_4;
					float u_xlat8;
					bool u_xlatb8;
					void main()
					{
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb0 = !!(_ScreenParams.y<_ScreenParams.x);
					#else
					    u_xlatb0 = _ScreenParams.y<_ScreenParams.x;
					#endif
					    u_xlat4 = max(_ScreenParams.y, _ScreenParams.x);
					    u_xlat8 = min(_ScreenParams.y, _ScreenParams.x);
					    u_xlat4 = u_xlat4 / u_xlat8;
					    u_xlat1.xyz = vs_TEXCOORD1.xyz / vs_TEXCOORD1.www;
					    u_xlat2.xy = vec2(u_xlat4) * u_xlat1.xy;
					    u_xlat1.w = u_xlat2.y;
					    u_xlat2.z = u_xlat1.y;
					    u_xlat0.xy = (bool(u_xlatb0)) ? u_xlat2.xz : u_xlat1.xw;
					    u_xlat8 = _ZBufferParams.z * u_xlat1.z + _ZBufferParams.w;
					    u_xlat8 = float(1.0) / u_xlat8;
					    u_xlat8 = u_xlat8 / _MaxDepth;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
					#else
					    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
					#endif
					    u_xlat8 = (-u_xlat8) + 1.0;
					    u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat0.x = sqrt(u_xlat0.x);
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = u_xlat0.x * 4.0;
					    u_xlat0.x = min(u_xlat0.x, 1.0);
					    u_xlat4 = u_xlat8 * u_xlat0.x;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb8 = !!(0.0<_MaxDepth);
					#else
					    u_xlatb8 = 0.0<_MaxDepth;
					#endif
					    u_xlat0.x = (u_xlatb8) ? u_xlat4 : u_xlat0.x;
					    u_xlat10_4 = texture(_MainTex, vs_TEXCOORD0.xy).x;
					    u_xlat16_3 = u_xlat10_4 * vs_COLOR0.w;
					    u_xlat0.x = u_xlat0.x * u_xlat16_3;
					    SV_Target0.w = u_xlat0.x;
					    SV_Target0.xyz = vs_COLOR0.xyz;
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