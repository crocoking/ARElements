Shader "ARElements/Annotations/Card Resize" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Vector) = (1,1,1,1)
		_Width ("Width Increase", Range(0, 10)) = 0.5
		_Height ("Height Increase", Range(0, 10)) = 0.5
		_AmbientLight ("Ambient Light", Range(0, 1)) = 0.5
		_LightDirection ("Light Direction", Vector) = (0,3,1,0)
	}
	SubShader {
		LOD 100
		Tags { "DisableBatching" = "true" "RenderType" = "Opaque" }
		Pass {
			LOD 100
			Tags { "DisableBatching" = "true" "RenderType" = "Opaque" }
			GpuProgramID 35067
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec3 _glesNormal;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp mat4 unity_MatrixVP;
					uniform highp float _Width;
					uniform highp float _Height;
					uniform highp float _AmbientLight;
					uniform highp vec3 _LightDirection;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec3 xlv_TEXCOORD1;
					varying highp vec3 xlv_TEXCOORD2;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.zw = _glesVertex.zw;
					  tmpvar_1.x = (((_Width / 2.0) * sign(_glesVertex.x)) + _glesVertex.x);
					  tmpvar_1.y = (((_Height / 2.0) * sign(_glesVertex.y)) + _glesVertex.y);
					  highp vec4 tmpvar_2;
					  tmpvar_2.w = 1.0;
					  tmpvar_2.xyz = tmpvar_1.xyz;
					  highp mat3 tmpvar_3;
					  tmpvar_3[0] = unity_ObjectToWorld[0].xyz;
					  tmpvar_3[1] = unity_ObjectToWorld[1].xyz;
					  tmpvar_3[2] = unity_ObjectToWorld[2].xyz;
					  highp mat3 tmpvar_4;
					  tmpvar_4[0] = unity_ObjectToWorld[0].xyz;
					  tmpvar_4[1] = unity_ObjectToWorld[1].xyz;
					  tmpvar_4[2] = unity_ObjectToWorld[2].xyz;
					  highp mat3 tmpvar_5;
					  tmpvar_5[0] = unity_WorldToObject[0].xyz;
					  tmpvar_5[1] = unity_WorldToObject[1].xyz;
					  tmpvar_5[2] = unity_WorldToObject[2].xyz;
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
					  xlv_TEXCOORD1 = _glesNormal;
					  xlv_TEXCOORD2 = (tmpvar_3 * tmpvar_1.xyz);
					  xlv_TEXCOORD3 = max (dot (normalize(
					    (_glesNormal * tmpvar_5)
					  ), normalize(
					    (tmpvar_4 * _LightDirection)
					  )), _AmbientLight);
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform highp vec4 _Color;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp vec4 shadedColor_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
					  shadedColor_2.xyz = ((tmpvar_3 * _Color) * xlv_TEXCOORD3).xyz;
					  shadedColor_2.w = 1.0;
					  tmpvar_1 = shadedColor_2;
					  gl_FragData[0] = tmpvar_1;
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
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp mat4 unity_MatrixVP;
					uniform highp float _Width;
					uniform highp float _Height;
					uniform highp float _AmbientLight;
					uniform highp vec3 _LightDirection;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec3 xlv_TEXCOORD1;
					varying highp vec3 xlv_TEXCOORD2;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.zw = _glesVertex.zw;
					  tmpvar_1.x = (((_Width / 2.0) * sign(_glesVertex.x)) + _glesVertex.x);
					  tmpvar_1.y = (((_Height / 2.0) * sign(_glesVertex.y)) + _glesVertex.y);
					  highp vec4 tmpvar_2;
					  tmpvar_2.w = 1.0;
					  tmpvar_2.xyz = tmpvar_1.xyz;
					  highp mat3 tmpvar_3;
					  tmpvar_3[0] = unity_ObjectToWorld[0].xyz;
					  tmpvar_3[1] = unity_ObjectToWorld[1].xyz;
					  tmpvar_3[2] = unity_ObjectToWorld[2].xyz;
					  highp mat3 tmpvar_4;
					  tmpvar_4[0] = unity_ObjectToWorld[0].xyz;
					  tmpvar_4[1] = unity_ObjectToWorld[1].xyz;
					  tmpvar_4[2] = unity_ObjectToWorld[2].xyz;
					  highp mat3 tmpvar_5;
					  tmpvar_5[0] = unity_WorldToObject[0].xyz;
					  tmpvar_5[1] = unity_WorldToObject[1].xyz;
					  tmpvar_5[2] = unity_WorldToObject[2].xyz;
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
					  xlv_TEXCOORD1 = _glesNormal;
					  xlv_TEXCOORD2 = (tmpvar_3 * tmpvar_1.xyz);
					  xlv_TEXCOORD3 = max (dot (normalize(
					    (_glesNormal * tmpvar_5)
					  ), normalize(
					    (tmpvar_4 * _LightDirection)
					  )), _AmbientLight);
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform highp vec4 _Color;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp vec4 shadedColor_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
					  shadedColor_2.xyz = ((tmpvar_3 * _Color) * xlv_TEXCOORD3).xyz;
					  shadedColor_2.w = 1.0;
					  tmpvar_1 = shadedColor_2;
					  gl_FragData[0] = tmpvar_1;
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
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp mat4 unity_MatrixVP;
					uniform highp float _Width;
					uniform highp float _Height;
					uniform highp float _AmbientLight;
					uniform highp vec3 _LightDirection;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp vec3 xlv_TEXCOORD1;
					varying highp vec3 xlv_TEXCOORD2;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.zw = _glesVertex.zw;
					  tmpvar_1.x = (((_Width / 2.0) * sign(_glesVertex.x)) + _glesVertex.x);
					  tmpvar_1.y = (((_Height / 2.0) * sign(_glesVertex.y)) + _glesVertex.y);
					  highp vec4 tmpvar_2;
					  tmpvar_2.w = 1.0;
					  tmpvar_2.xyz = tmpvar_1.xyz;
					  highp mat3 tmpvar_3;
					  tmpvar_3[0] = unity_ObjectToWorld[0].xyz;
					  tmpvar_3[1] = unity_ObjectToWorld[1].xyz;
					  tmpvar_3[2] = unity_ObjectToWorld[2].xyz;
					  highp mat3 tmpvar_4;
					  tmpvar_4[0] = unity_ObjectToWorld[0].xyz;
					  tmpvar_4[1] = unity_ObjectToWorld[1].xyz;
					  tmpvar_4[2] = unity_ObjectToWorld[2].xyz;
					  highp mat3 tmpvar_5;
					  tmpvar_5[0] = unity_WorldToObject[0].xyz;
					  tmpvar_5[1] = unity_WorldToObject[1].xyz;
					  tmpvar_5[2] = unity_WorldToObject[2].xyz;
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
					  xlv_TEXCOORD1 = _glesNormal;
					  xlv_TEXCOORD2 = (tmpvar_3 * tmpvar_1.xyz);
					  xlv_TEXCOORD3 = max (dot (normalize(
					    (_glesNormal * tmpvar_5)
					  ), normalize(
					    (tmpvar_4 * _LightDirection)
					  )), _AmbientLight);
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform sampler2D _MainTex;
					uniform highp vec4 _Color;
					varying highp vec2 xlv_TEXCOORD0;
					varying highp float xlv_TEXCOORD3;
					void main ()
					{
					  lowp vec4 tmpvar_1;
					  highp vec4 shadedColor_2;
					  lowp vec4 tmpvar_3;
					  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
					  shadedColor_2.xyz = ((tmpvar_3 * _Color) * xlv_TEXCOORD3).xyz;
					  shadedColor_2.w = 1.0;
					  tmpvar_1 = shadedColor_2;
					  gl_FragData[0] = tmpvar_1;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	float _Width;
					uniform 	float _Height;
					uniform 	float _AmbientLight;
					uniform 	vec3 _LightDirection;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec3 in_NORMAL0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD3;
					out highp vec3 vs_TEXCOORD1;
					out highp vec3 vs_TEXCOORD2;
					vec4 u_xlat0;
					ivec2 u_xlati0;
					vec4 u_xlat1;
					vec2 u_xlat4;
					ivec2 u_xlati4;
					float u_xlat6;
					void main()
					{
					    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[1].xyz * _LightDirection.yyy;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * _LightDirection.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * _LightDirection.zzz + u_xlat0.xyz;
					    u_xlat6 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat6 = inversesqrt(u_xlat6);
					    u_xlat0.xyz = vec3(u_xlat6) * u_xlat0.xyz;
					    u_xlat1.x = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
					    u_xlat6 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat6 = inversesqrt(u_xlat6);
					    u_xlat1.xyz = vec3(u_xlat6) * u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat1.xyz, u_xlat0.xyz);
					    vs_TEXCOORD3 = max(u_xlat0.x, _AmbientLight);
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlati0.xy = ivec2(uvec2(lessThan(vec4(0.0, 0.0, 0.0, 0.0), in_POSITION0.xyxx).xy) * 0xFFFFFFFFu);
					    u_xlati4.xy = ivec2(uvec2(lessThan(in_POSITION0.xyxy, vec4(0.0, 0.0, 0.0, 0.0)).xy) * 0xFFFFFFFFu);
					    u_xlati0.xy = (-u_xlati0.xy) + u_xlati4.xy;
					    u_xlat0.xy = vec2(u_xlati0.xy);
					    u_xlat4.xy = vec2(_Width, _Height) * vec2(0.5, 0.5);
					    u_xlat0.xy = u_xlat4.xy * u_xlat0.xy + in_POSITION0.xy;
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    vs_TEXCOORD2.xyz = u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD1.xyz = in_NORMAL0.xyz;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Color;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD3;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					void main()
					{
					    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vs_TEXCOORD3);
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
					uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	float _Width;
					uniform 	float _Height;
					uniform 	float _AmbientLight;
					uniform 	vec3 _LightDirection;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec3 in_NORMAL0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD3;
					out highp vec3 vs_TEXCOORD1;
					out highp vec3 vs_TEXCOORD2;
					vec4 u_xlat0;
					ivec2 u_xlati0;
					vec4 u_xlat1;
					vec2 u_xlat4;
					ivec2 u_xlati4;
					float u_xlat6;
					void main()
					{
					    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[1].xyz * _LightDirection.yyy;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * _LightDirection.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * _LightDirection.zzz + u_xlat0.xyz;
					    u_xlat6 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat6 = inversesqrt(u_xlat6);
					    u_xlat0.xyz = vec3(u_xlat6) * u_xlat0.xyz;
					    u_xlat1.x = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
					    u_xlat6 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat6 = inversesqrt(u_xlat6);
					    u_xlat1.xyz = vec3(u_xlat6) * u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat1.xyz, u_xlat0.xyz);
					    vs_TEXCOORD3 = max(u_xlat0.x, _AmbientLight);
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlati0.xy = ivec2(uvec2(lessThan(vec4(0.0, 0.0, 0.0, 0.0), in_POSITION0.xyxx).xy) * 0xFFFFFFFFu);
					    u_xlati4.xy = ivec2(uvec2(lessThan(in_POSITION0.xyxy, vec4(0.0, 0.0, 0.0, 0.0)).xy) * 0xFFFFFFFFu);
					    u_xlati0.xy = (-u_xlati0.xy) + u_xlati4.xy;
					    u_xlat0.xy = vec2(u_xlati0.xy);
					    u_xlat4.xy = vec2(_Width, _Height) * vec2(0.5, 0.5);
					    u_xlat0.xy = u_xlat4.xy * u_xlat0.xy + in_POSITION0.xy;
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    vs_TEXCOORD2.xyz = u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD1.xyz = in_NORMAL0.xyz;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Color;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD3;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					void main()
					{
					    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vs_TEXCOORD3);
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
					uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	float _Width;
					uniform 	float _Height;
					uniform 	float _AmbientLight;
					uniform 	vec3 _LightDirection;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec3 in_NORMAL0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD3;
					out highp vec3 vs_TEXCOORD1;
					out highp vec3 vs_TEXCOORD2;
					vec4 u_xlat0;
					ivec2 u_xlati0;
					vec4 u_xlat1;
					vec2 u_xlat4;
					ivec2 u_xlati4;
					float u_xlat6;
					void main()
					{
					    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[1].xyz * _LightDirection.yyy;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * _LightDirection.xxx + u_xlat0.xyz;
					    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * _LightDirection.zzz + u_xlat0.xyz;
					    u_xlat6 = dot(u_xlat0.xyz, u_xlat0.xyz);
					    u_xlat6 = inversesqrt(u_xlat6);
					    u_xlat0.xyz = vec3(u_xlat6) * u_xlat0.xyz;
					    u_xlat1.x = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
					    u_xlat1.y = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
					    u_xlat1.z = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
					    u_xlat6 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat6 = inversesqrt(u_xlat6);
					    u_xlat1.xyz = vec3(u_xlat6) * u_xlat1.xyz;
					    u_xlat0.x = dot(u_xlat1.xyz, u_xlat0.xyz);
					    vs_TEXCOORD3 = max(u_xlat0.x, _AmbientLight);
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlati0.xy = ivec2(uvec2(lessThan(vec4(0.0, 0.0, 0.0, 0.0), in_POSITION0.xyxx).xy) * 0xFFFFFFFFu);
					    u_xlati4.xy = ivec2(uvec2(lessThan(in_POSITION0.xyxy, vec4(0.0, 0.0, 0.0, 0.0)).xy) * 0xFFFFFFFFu);
					    u_xlati0.xy = (-u_xlati0.xy) + u_xlati4.xy;
					    u_xlat0.xy = vec2(u_xlati0.xy);
					    u_xlat4.xy = vec2(_Width, _Height) * vec2(0.5, 0.5);
					    u_xlat0.xy = u_xlat4.xy * u_xlat0.xy + in_POSITION0.xy;
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    vs_TEXCOORD2.xyz = u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat1.zzzz + u_xlat0;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat1.wwww + u_xlat0;
					    vs_TEXCOORD1.xyz = in_NORMAL0.xyz;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	vec4 _Color;
					uniform lowp sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD3;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					void main()
					{
					    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vs_TEXCOORD3);
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