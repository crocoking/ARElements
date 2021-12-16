Shader "ARElements/Shadows/ShadowDepth" {
	Properties {
	}
	SubShader {
		LOD 100
		Tags { "DisableBatching" = "true" "RenderType" = "Opaque" }
		Pass {
			LOD 100
			Tags { "DisableBatching" = "true" "RenderType" = "Opaque" }
			GpuProgramID 50863
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform highp float _CustomShadowScale;
					uniform highp mat4 _CustomShadowWorldToCamera;
					uniform highp float _CustomShadowFarClipPlane;
					varying highp float xlv_TEXCOORD1;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = (_glesVertex.xyz * _CustomShadowScale);
					  highp vec4 tmpvar_2;
					  tmpvar_2.w = 1.0;
					  tmpvar_2.xyz = tmpvar_1.xyz;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
					  xlv_TEXCOORD1 = (clamp (-(
					    (_CustomShadowWorldToCamera * (unity_ObjectToWorld * tmpvar_1))
					  .z), 0.0, _CustomShadowFarClipPlane) / _CustomShadowFarClipPlane);
					}
					
					
					#endif
					#ifdef FRAGMENT
					varying highp float xlv_TEXCOORD1;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.yzw = vec3(1.0, 0.0, 1.0);
					  tmpvar_1.x = xlv_TEXCOORD1;
					  gl_FragData[0] = tmpvar_1;
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
					uniform highp float _CustomShadowScale;
					uniform highp mat4 _CustomShadowWorldToCamera;
					uniform highp float _CustomShadowFarClipPlane;
					varying highp float xlv_TEXCOORD1;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = (_glesVertex.xyz * _CustomShadowScale);
					  highp vec4 tmpvar_2;
					  tmpvar_2.w = 1.0;
					  tmpvar_2.xyz = tmpvar_1.xyz;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
					  xlv_TEXCOORD1 = (clamp (-(
					    (_CustomShadowWorldToCamera * (unity_ObjectToWorld * tmpvar_1))
					  .z), 0.0, _CustomShadowFarClipPlane) / _CustomShadowFarClipPlane);
					}
					
					
					#endif
					#ifdef FRAGMENT
					varying highp float xlv_TEXCOORD1;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.yzw = vec3(1.0, 0.0, 1.0);
					  tmpvar_1.x = xlv_TEXCOORD1;
					  gl_FragData[0] = tmpvar_1;
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
					uniform highp float _CustomShadowScale;
					uniform highp mat4 _CustomShadowWorldToCamera;
					uniform highp float _CustomShadowFarClipPlane;
					varying highp float xlv_TEXCOORD1;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.w = 1.0;
					  tmpvar_1.xyz = (_glesVertex.xyz * _CustomShadowScale);
					  highp vec4 tmpvar_2;
					  tmpvar_2.w = 1.0;
					  tmpvar_2.xyz = tmpvar_1.xyz;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
					  xlv_TEXCOORD1 = (clamp (-(
					    (_CustomShadowWorldToCamera * (unity_ObjectToWorld * tmpvar_1))
					  .z), 0.0, _CustomShadowFarClipPlane) / _CustomShadowFarClipPlane);
					}
					
					
					#endif
					#ifdef FRAGMENT
					varying highp float xlv_TEXCOORD1;
					void main ()
					{
					  highp vec4 tmpvar_1;
					  tmpvar_1.yzw = vec3(1.0, 0.0, 1.0);
					  tmpvar_1.x = xlv_TEXCOORD1;
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
					uniform 	float _CustomShadowScale;
					uniform 	vec4 hlslcc_mtx4x4_CustomShadowWorldToCamera[4];
					uniform 	float _CustomShadowFarClipPlane;
					in highp vec4 in_POSITION0;
					out highp float vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
					float u_xlat2;
					void main()
					{
					    u_xlat0.xyz = in_POSITION0.xyz * vec3(_CustomShadowScale);
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat2 = u_xlat0.y * hlslcc_mtx4x4_CustomShadowWorldToCamera[1].z;
					    u_xlat0.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[0].z * u_xlat0.x + u_xlat2;
					    u_xlat0.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[2].z * u_xlat0.z + u_xlat0.x;
					    u_xlat0.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[3].z * u_xlat0.w + u_xlat0.x;
					    u_xlat0.x = max((-u_xlat0.x), 0.0);
					    u_xlat0.x = min(u_xlat0.x, _CustomShadowFarClipPlane);
					    vs_TEXCOORD1 = u_xlat0.x / _CustomShadowFarClipPlane;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					in highp float vs_TEXCOORD1;
					layout(location = 0) out highp vec4 SV_Target0;
					void main()
					{
					    SV_Target0.x = vs_TEXCOORD1;
					    SV_Target0.yzw = vec3(1.0, 0.0, 1.0);
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
					uniform 	float _CustomShadowScale;
					uniform 	vec4 hlslcc_mtx4x4_CustomShadowWorldToCamera[4];
					uniform 	float _CustomShadowFarClipPlane;
					in highp vec4 in_POSITION0;
					out highp float vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
					float u_xlat2;
					void main()
					{
					    u_xlat0.xyz = in_POSITION0.xyz * vec3(_CustomShadowScale);
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat2 = u_xlat0.y * hlslcc_mtx4x4_CustomShadowWorldToCamera[1].z;
					    u_xlat0.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[0].z * u_xlat0.x + u_xlat2;
					    u_xlat0.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[2].z * u_xlat0.z + u_xlat0.x;
					    u_xlat0.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[3].z * u_xlat0.w + u_xlat0.x;
					    u_xlat0.x = max((-u_xlat0.x), 0.0);
					    u_xlat0.x = min(u_xlat0.x, _CustomShadowFarClipPlane);
					    vs_TEXCOORD1 = u_xlat0.x / _CustomShadowFarClipPlane;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					in highp float vs_TEXCOORD1;
					layout(location = 0) out highp vec4 SV_Target0;
					void main()
					{
					    SV_Target0.x = vs_TEXCOORD1;
					    SV_Target0.yzw = vec3(1.0, 0.0, 1.0);
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
					uniform 	float _CustomShadowScale;
					uniform 	vec4 hlslcc_mtx4x4_CustomShadowWorldToCamera[4];
					uniform 	float _CustomShadowFarClipPlane;
					in highp vec4 in_POSITION0;
					out highp float vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
					float u_xlat2;
					void main()
					{
					    u_xlat0.xyz = in_POSITION0.xyz * vec3(_CustomShadowScale);
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat2 = u_xlat0.y * hlslcc_mtx4x4_CustomShadowWorldToCamera[1].z;
					    u_xlat0.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[0].z * u_xlat0.x + u_xlat2;
					    u_xlat0.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[2].z * u_xlat0.z + u_xlat0.x;
					    u_xlat0.x = hlslcc_mtx4x4_CustomShadowWorldToCamera[3].z * u_xlat0.w + u_xlat0.x;
					    u_xlat0.x = max((-u_xlat0.x), 0.0);
					    u_xlat0.x = min(u_xlat0.x, _CustomShadowFarClipPlane);
					    vs_TEXCOORD1 = u_xlat0.x / _CustomShadowFarClipPlane;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					in highp float vs_TEXCOORD1;
					layout(location = 0) out highp vec4 SV_Target0;
					void main()
					{
					    SV_Target0.x = vs_TEXCOORD1;
					    SV_Target0.yzw = vec3(1.0, 0.0, 1.0);
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