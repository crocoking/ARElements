Shader "ARElements/DynamicGrid Square" {
	Properties {
		_Visibility ("Visibility", Range(0, 1)) = 1
		_GridScale ("Grid Scale", Range(0.01, 0.5)) = 0.15
		_GeometryEdgeFadeWidth ("Edge Perimeter Distance", Float) = 0.3
		_FocalPointPosition ("-- Focal Point Position", Vector) = (0,0,0,1)
		_FocalPointRadius ("Focal Point Radius", Float) = 0
		_FocalPointRange ("Focal Point Range", Float) = 0.25
		_FocalPointFadePower ("Focal Point Fade Power", Float) = 1
		_GridColorBase ("-- Grid Color", Vector) = (1,1,1,0)
		_GridColorFocalPoint ("Focal Point Color --", Vector) = (1,1,1,0.2)
		_ColorMixFocalPoint ("Focal Point Color Mix", Range(0, 1)) = 1
		_GridColorEdge ("Edge Grid Color --", Vector) = (1,1,1,0)
		_ColorMixEdge ("Edge Color Mix", Range(0, 1)) = 1
		_CellScale ("-- Cell Scale", Range(0, 2)) = 1.27
		_ScaleFocalPoint ("Focal Point Scale --", Range(0, 2)) = 1.27
		_ScaleFocalPointMix ("Focal Point Scale Mix", Range(0, 1)) = 0
		_ScaleEdge ("Edge Scale --", Range(0, 2)) = 1.27
		_ScaleEdgeMix ("Edge Scale Mix", Range(0, 1)) = 0
		_CellFill ("-- Cell Fill", Range(0, 1)) = 1
		_CellFillFocalPoint ("Focal Point Fill --", Range(-0.25, 2)) = 1
		_CellFillMixFocalPoint ("Focal Point Fill Mix", Range(0, 1)) = 0
		_CellFillEdge ("Edge Fill --", Range(-0.25, 2)) = 1
		_CellFillMixEdge ("Edge Fill Mix", Range(0, 1)) = 0
		_OccludeCornerBase ("-- Occlude Corner Base", Range(0, 1)) = 0
		_CellCornerOccludeFocalPoint ("Focal Point Corner Occlude --", Range(-0.25, 2)) = 1
		_CellCornerOccludeMixFocalPoint ("Focal Point Corner Occlude Mix", Range(0, 1)) = 0
		_CellCornerOccludeEdge ("Edge Corner Occlude --", Range(-0.25, 2)) = 1
		_CellCornerOccludeMixEdge ("Edge Corner Occlude Mix", Range(0, 1)) = 0
		_OccludeEdgeBase ("-- Occlude Side Base", Range(0, 1)) = 0
		_CellEdgeOccludeFocalPoint ("Focal Point Side Occlude --", Range(-0.25, 2)) = 1
		_CellEdgeOccludeMixFocalPoint ("Focal Point Side Occlude Mix", Range(0, 1)) = 0
		_CellEdgeOccludeEdge ("Edge Side Occlude --", Range(-0.25, 2)) = 1
		_CellEdgeOccludeMixEdge ("Edge Side Occlude Mix", Range(0, 1)) = 0
		_PerimeterDist ("PerimeterDistanceMap", 2D) = "white" {}
		_Bounds ("Perimeter Bounds (World Space)", Vector) = (0,0,1,1)
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha One, SrcAlpha One
			ZWrite Off
			GpuProgramID 62989
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					#ifndef SHADER_TARGET
					    #define SHADER_TARGET 25
					#endif
					#ifndef SHADER_REQUIRE_DERIVATIVES
					    #define SHADER_REQUIRE_DERIVATIVES 1
					#endif
					#ifndef UNITY_NO_DXT5nm
					    #define UNITY_NO_DXT5nm 1
					#endif
					#ifndef UNITY_NO_RGBM
					    #define UNITY_NO_RGBM 1
					#endif
					#ifndef UNITY_ENABLE_REFLECTION_BUFFERS
					    #define UNITY_ENABLE_REFLECTION_BUFFERS 1
					#endif
					#ifndef UNITY_FRAMEBUFFER_FETCH_AVAILABLE
					    #define UNITY_FRAMEBUFFER_FETCH_AVAILABLE 1
					#endif
					#ifndef UNITY_NO_CUBEMAP_ARRAY
					    #define UNITY_NO_CUBEMAP_ARRAY 1
					#endif
					#ifndef UNITY_NO_SCREENSPACE_SHADOWS
					    #define UNITY_NO_SCREENSPACE_SHADOWS 1
					#endif
					#ifndef UNITY_PBS_USE_BRDF3
					    #define UNITY_PBS_USE_BRDF3 1
					#endif
					#ifndef UNITY_NO_FULL_STANDARD_SHADER
					    #define UNITY_NO_FULL_STANDARD_SHADER 1
					#endif
					#ifndef SHADER_API_MOBILE
					    #define SHADER_API_MOBILE 1
					#endif
					#ifndef UNITY_HARDWARE_TIER1
					    #define UNITY_HARDWARE_TIER1 1
					#endif
					#ifndef UNITY_COLORSPACE_GAMMA
					    #define UNITY_COLORSPACE_GAMMA 1
					#endif
					#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					    #define UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS 1
					#endif
					#ifndef UNITY_LIGHTMAP_DLDR_ENCODING
					    #define UNITY_LIGHTMAP_DLDR_ENCODING 1
					#endif
					#ifndef UNITY_VERSION
					    #define UNITY_VERSION 201841
					#endif
					#ifndef SHADER_STAGE_VERTEX
					    #define SHADER_STAGE_VERTEX 1
					#endif
					#ifndef SHADER_TARGET_AVAILABLE
					    #define SHADER_TARGET_AVAILABLE 25
					#endif
					#ifndef SHADER_AVAILABLE_DERIVATIVES
					    #define SHADER_AVAILABLE_DERIVATIVES 1
					#endif
					#ifndef SHADER_AVAILABLE_FRAGCOORD
					    #define SHADER_AVAILABLE_FRAGCOORD 1
					#endif
					#ifndef SHADER_API_GLES
					    #define SHADER_API_GLES 1
					#endif
					#define gl_Vertex _glesVertex
					attribute vec4 _glesVertex;
					#define gl_MultiTexCoord0 _glesMultiTexCoord0
					attribute vec4 _glesMultiTexCoord0;
					mat2 xll_transpose_mf2x2(mat2 m) {
					  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
					}
					mat3 xll_transpose_mf3x3(mat3 m) {
					  return mat3( m[0][0], m[1][0], m[2][0],
					               m[0][1], m[1][1], m[2][1],
					               m[0][2], m[1][2], m[2][2]);
					}
					mat4 xll_transpose_mf4x4(mat4 m) {
					  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
					               m[0][1], m[1][1], m[2][1], m[3][1],
					               m[0][2], m[1][2], m[2][2], m[3][2],
					               m[0][3], m[1][3], m[2][3], m[3][3]);
					}
					#line 447
					struct v2f_vertex_lit {
					    highp vec2 uv;
					    lowp vec4 diff;
					    lowp vec4 spec;
					};
					#line 756
					struct v2f_img {
					    highp vec4 pos;
					    mediump vec2 uv;
					};
					#line 749
					struct appdata_img {
					    highp vec4 vertex;
					    mediump vec2 texcoord;
					};
					#line 193
					struct PointRelationship {
					    highp float dist;
					    highp float angle;
					};
					#line 88
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 83
					struct appdata {
					    highp vec4 vertex;
					    highp vec2 uv;
					};
					#line 40
					uniform highp vec4 _Time;
					uniform highp vec4 _SinTime;
					uniform highp vec4 _CosTime;
					uniform highp vec4 unity_DeltaTime;
					#line 46
					uniform highp vec3 _WorldSpaceCameraPos;
					#line 53
					uniform highp vec4 _ProjectionParams;
					#line 59
					uniform highp vec4 _ScreenParams;
					#line 71
					uniform highp vec4 _ZBufferParams;
					#line 77
					uniform highp vec4 unity_OrthoParams;
					#line 86
					uniform highp vec4 unity_CameraWorldClipPlanes[6];
					#line 92
					uniform highp mat4 unity_CameraProjection;
					uniform highp mat4 unity_CameraInvProjection;
					uniform highp mat4 unity_WorldToCamera;
					uniform highp mat4 unity_CameraToWorld;
					#line 108
					uniform highp vec4 _WorldSpaceLightPos0;
					uniform highp vec4 _LightPositionRange;
					#line 112
					uniform highp vec4 _LightProjectionParams;
					uniform highp vec4 unity_4LightPosX0;
					uniform highp vec4 unity_4LightPosY0;
					#line 116
					uniform highp vec4 unity_4LightPosZ0;
					uniform mediump vec4 unity_4LightAtten0;
					uniform mediump vec4 unity_LightColor[8];
					#line 122
					uniform highp vec4 unity_LightPosition[8];
					#line 127
					uniform mediump vec4 unity_LightAtten[8];
					uniform highp vec4 unity_SpotDirection[8];
					#line 131
					uniform mediump vec4 unity_SHAr;
					uniform mediump vec4 unity_SHAg;
					uniform mediump vec4 unity_SHAb;
					uniform mediump vec4 unity_SHBr;
					#line 135
					uniform mediump vec4 unity_SHBg;
					uniform mediump vec4 unity_SHBb;
					uniform mediump vec4 unity_SHC;
					#line 140
					uniform lowp vec4 unity_OcclusionMaskSelector;
					uniform lowp vec4 unity_ProbesOcclusion;
					#line 145
					uniform mediump vec3 unity_LightColor0;
					uniform mediump vec3 unity_LightColor1;
					uniform mediump vec3 unity_LightColor2;
					uniform mediump vec3 unity_LightColor3;
					#line 152
					uniform highp vec4 unity_ShadowSplitSpheres[4];
					uniform highp vec4 unity_ShadowSplitSqRadii;
					uniform highp vec4 unity_LightShadowBias;
					uniform highp vec4 _LightSplitsNear;
					#line 156
					uniform highp vec4 _LightSplitsFar;
					uniform highp mat4 unity_WorldToShadow[4];
					uniform mediump vec4 _LightShadowData;
					uniform highp vec4 unity_ShadowFadeCenterAndType;
					#line 165
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp vec4 unity_LODFade;
					uniform highp vec4 unity_WorldTransformParams;
					#line 206
					uniform highp mat4 glstate_matrix_transpose_modelview0;
					#line 214
					uniform lowp vec4 glstate_lightmodel_ambient;
					uniform lowp vec4 unity_AmbientSky;
					uniform lowp vec4 unity_AmbientEquator;
					uniform lowp vec4 unity_AmbientGround;
					#line 218
					uniform lowp vec4 unity_IndirectSpecColor;
					uniform highp mat4 glstate_matrix_projection;
					#line 222
					uniform highp mat4 unity_MatrixV;
					uniform highp mat4 unity_MatrixInvV;
					uniform highp mat4 unity_MatrixVP;
					uniform highp int unity_StereoEyeIndex;
					#line 228
					uniform lowp vec4 unity_ShadowColor;
					#line 235
					uniform lowp vec4 unity_FogColor;
					#line 240
					uniform highp vec4 unity_FogParams;
					#line 248
					uniform mediump sampler2D unity_Lightmap;
					uniform mediump sampler2D unity_LightmapInd;
					#line 252
					uniform sampler2D unity_ShadowMask;
					uniform sampler2D unity_DynamicLightmap;
					#line 256
					uniform sampler2D unity_DynamicDirectionality;
					uniform sampler2D unity_DynamicNormal;
					#line 260
					uniform highp vec4 unity_LightmapST;
					uniform highp vec4 unity_DynamicLightmapST;
					#line 268
					uniform samplerCube unity_SpecCube0;
					uniform samplerCube unity_SpecCube1;
					#line 272
					uniform highp vec4 unity_SpecCube0_BoxMax;
					uniform highp vec4 unity_SpecCube0_BoxMin;
					uniform highp vec4 unity_SpecCube0_ProbePosition;
					uniform mediump vec4 unity_SpecCube0_HDR;
					#line 277
					uniform highp vec4 unity_SpecCube1_BoxMax;
					uniform highp vec4 unity_SpecCube1_BoxMin;
					uniform highp vec4 unity_SpecCube1_ProbePosition;
					uniform mediump vec4 unity_SpecCube1_HDR;
					#line 317
					highp mat4 unity_MatrixMVP;
					highp mat4 unity_MatrixMV;
					highp mat4 unity_MatrixTMV;
					highp mat4 unity_MatrixITMV;
					#line 8
					#line 30
					#line 44
					#line 84
					#line 93
					#line 103
					#line 112
					#line 124
					#line 135
					#line 141
					#line 147
					#line 151
					#line 157
					#line 163
					#line 169
					#line 175
					#line 186
					#line 201
					#line 208
					#line 223
					#line 230
					#line 237
					#line 255
					#line 291
					#line 320
					#line 326
					#line 339
					#line 357
					#line 373
					#line 427
					#line 453
					#line 464
					#line 473
					#line 480
					#line 485
					#line 502
					#line 522
					#line 537
					#line 543
					#line 554
					uniform mediump vec4 unity_Lightmap_HDR;
					uniform mediump vec4 unity_DynamicLightmap_HDR;
					#line 568
					#line 578
					#line 593
					#line 602
					#line 609
					#line 618
					#line 626
					#line 635
					#line 654
					#line 660
					#line 670
					#line 680
					#line 691
					#line 696
					#line 702
					#line 707
					#line 764
					#line 770
					#line 785
					#line 816
					#line 830
					#line 834
					#line 840
					#line 849
					#line 859
					#line 885
					#line 891
					#line 18
					uniform highp float _Visibility;
					uniform highp vec3 _FocalPointPosition;
					#line 22
					uniform highp float _FocalPointRange;
					uniform highp float _FocalPointRadius;
					uniform highp float _FocalPointFadePower;
					#line 27
					uniform highp float _GridScale;
					uniform highp float _GeometryEdgeFadeWidth;
					#line 31
					uniform highp vec4 _GridColorBase;
					uniform highp vec4 _GridColorFocalPoint;
					uniform highp float _ColorMixFocalPoint;
					uniform highp vec4 _GridColorEdge;
					#line 35
					uniform highp float _ColorMixEdge;
					uniform highp float _CellScale;
					#line 39
					uniform highp float _ScaleFocalPoint;
					uniform highp float _ScaleFocalPointMix;
					uniform highp float _ScaleEdge;
					uniform highp float _ScaleEdgeMix;
					#line 45
					uniform highp float _CellFill;
					uniform highp float _CellFillFocalPoint;
					uniform highp float _CellFillMixFocalPoint;
					uniform highp float _CellFillEdge;
					#line 49
					uniform highp float _CellFillMixEdge;
					uniform highp float _OccludeCornerBase;
					#line 53
					uniform highp float _CellCornerOccludeFocalPoint;
					uniform highp float _CellCornerOccludeMixFocalPoint;
					uniform highp float _CellCornerOccludeEdge;
					uniform highp float _CellCornerOccludeMixEdge;
					#line 59
					uniform highp float _OccludeEdgeBase;
					uniform highp float _CellEdgeOccludeFocalPoint;
					uniform highp float _CellEdgeOccludeMixFocalPoint;
					uniform highp float _CellEdgeOccludeEdge;
					#line 63
					uniform highp float _CellEdgeOccludeMixEdge;
					uniform sampler2D _PerimeterDist;
					uniform highp vec4 _Bounds;
					#line 70
					uniform highp vec4 _Extents;
					uniform highp float _NumVerts;
					#line 74
					uniform highp vec4 _PerimeterVerts[128];
					#line 79
					const highp float HALF_SQRT3 = 0.8660254;
					const highp float SQRT2 = 1.414214;
					const highp float INV_SQRT2 = 0.7071068;
					const highp float SQRT3 = 1.732051;
					#line 83
					const highp float THIRD_PI = 1.047198;
					const highp float HALF_PI = 1.570796;
					const highp float PI = 3.141593;
					const highp float TAU = 6.283185;
					#line 87
					const highp float COS_PI_OVER_8 = 0.9238795;
					const highp float SIN_PI_OVER_8 = 0.3826834;
					highp float TAU_3[3];
					#line 96
					highp float TAU_4[4];
					#line 103
					highp float TAU_6[6];
					#line 112
					highp float TAU_8[8];
					#line 125
					highp vec2 CIRC_VERTS_3[4];
					#line 132
					highp vec2 CIRC_VERTS_4_45[5];
					#line 140
					highp vec2 CIRC_VERTS_4[5];
					#line 148
					highp vec2 CIRC_VERTS_6[7];
					#line 158
					highp vec2 CIRC_VERTS_8[9];
					#line 170
					highp vec2 CIRC_VERTS_16[17];
					#line 201
					#line 215
					#line 224
					#line 285
					#line 292
					#line 298
					#line 307
					#line 93
					#line 101
					#line 44
					highp vec4 UnityObjectToClipPos( in highp vec3 pos ) {
					    #line 50
					    return (unity_MatrixVP * (unity_ObjectToWorld * vec4( pos, 1.0)));
					}
					#line 53
					highp vec4 UnityObjectToClipPos( in highp vec4 pos ) {
					    #line 55
					    return UnityObjectToClipPos( pos.xyz);
					}
					#line 93
					v2f vert( in appdata v ) {
					    v2f o;
					    o.vertex = UnityObjectToClipPos( v.vertex);
					    highp vec2 uv = (unity_ObjectToWorld * v.vertex).xz;
					    #line 97
					    o.uv = uv;
					    return o;
					}
					varying highp vec2 xlv_TEXCOORD0;
					void main() {
					TAU_3[0] = 2.094395;
					TAU_3[1] = 4.18879;
					TAU_3[2] = 6.283185;
					TAU_4[0] = 1.570796;
					TAU_4[1] = 3.141593;
					TAU_4[2] = 4.712389;
					TAU_4[3] = 6.283185;
					TAU_6[0] = 1.047198;
					TAU_6[1] = 2.094395;
					TAU_6[2] = 3.141593;
					TAU_6[3] = 4.18879;
					TAU_6[4] = 5.235988;
					TAU_6[5] = 6.283185;
					TAU_8[0] = 0.7853982;
					TAU_8[1] = 1.570796;
					TAU_8[2] = 2.356194;
					TAU_8[3] = 3.141593;
					TAU_8[4] = 3.926991;
					TAU_8[5] = 4.712389;
					TAU_8[6] = 5.497787;
					TAU_8[7] = 6.283185;
					CIRC_VERTS_3[0] = vec2(0);
					CIRC_VERTS_3[1] = vec2(-0.8660254);
					CIRC_VERTS_3[2] = vec2(1);
					CIRC_VERTS_3[3] = vec2(0.8660254);
					CIRC_VERTS_3[4] = vec2(-1);
					CIRC_VERTS_3[5] = vec2(0.8660254);
					CIRC_VERTS_3[6] = vec2(0);
					CIRC_VERTS_3[7] = vec2(-0.8660254);
					CIRC_VERTS_4_45[0] = vec2(1);
					CIRC_VERTS_4_45[1] = vec2(0);
					CIRC_VERTS_4_45[2] = vec2(-1);
					CIRC_VERTS_4_45[3] = vec2(0);
					CIRC_VERTS_4_45[4] = vec2(-1);
					CIRC_VERTS_4_45[5] = vec2(-1);
					CIRC_VERTS_4_45[6] = vec2(-1);
					CIRC_VERTS_4_45[7] = vec2(0);
					CIRC_VERTS_4_45[8] = vec2(1);
					CIRC_VERTS_4_45[9] = vec2(0);
					CIRC_VERTS_4[0] = vec2(0.7071068);
					CIRC_VERTS_4[1] = vec2(0.7071068);
					CIRC_VERTS_4[2] = vec2(-0.7071068);
					CIRC_VERTS_4[3] = vec2(0.7071068);
					CIRC_VERTS_4[4] = vec2(-0.7071068);
					CIRC_VERTS_4[5] = vec2(-0.7071068);
					CIRC_VERTS_4[6] = vec2(0.7071068);
					CIRC_VERTS_4[7] = vec2(-0.7071068);
					CIRC_VERTS_4[8] = vec2(0.7071068);
					CIRC_VERTS_4[9] = vec2(0.7071068);
					CIRC_VERTS_6[0] = vec2(0.8660254);
					CIRC_VERTS_6[1] = vec2(0.5);
					CIRC_VERTS_6[2] = vec2(0);
					CIRC_VERTS_6[3] = vec2(1);
					CIRC_VERTS_6[4] = vec2(-0.8660254);
					CIRC_VERTS_6[5] = vec2(0.5);
					CIRC_VERTS_6[6] = vec2(-0.8660254);
					CIRC_VERTS_6[7] = vec2(-0.5);
					CIRC_VERTS_6[8] = vec2(0);
					CIRC_VERTS_6[9] = vec2(-1);
					CIRC_VERTS_6[10] = vec2(0.8660254);
					CIRC_VERTS_6[11] = vec2(-0.5);
					CIRC_VERTS_6[12] = vec2(0.8660254);
					CIRC_VERTS_6[13] = vec2(0.5);
					CIRC_VERTS_8[0] = vec2(1);
					CIRC_VERTS_8[1] = vec2(0);
					CIRC_VERTS_8[2] = vec2(0.7071068);
					CIRC_VERTS_8[3] = vec2(0.7071068);
					CIRC_VERTS_8[4] = vec2(0);
					CIRC_VERTS_8[5] = vec2(1);
					CIRC_VERTS_8[6] = vec2(-0.7071068);
					CIRC_VERTS_8[7] = vec2(0.7071068);
					CIRC_VERTS_8[8] = vec2(-1);
					CIRC_VERTS_8[9] = vec2(0);
					CIRC_VERTS_8[10] = vec2(-0.7071068);
					CIRC_VERTS_8[11] = vec2(-0.7071068);
					CIRC_VERTS_8[12] = vec2(0);
					CIRC_VERTS_8[13] = vec2(-1);
					CIRC_VERTS_8[14] = vec2(0.7071068);
					CIRC_VERTS_8[15] = vec2(-0.7071068);
					CIRC_VERTS_8[16] = vec2(1);
					CIRC_VERTS_8[17] = vec2(0);
					CIRC_VERTS_16[0] = vec2(1);
					CIRC_VERTS_16[1] = vec2(0);
					CIRC_VERTS_16[2] = vec2(0.9238795);
					CIRC_VERTS_16[3] = vec2(0.3826834);
					CIRC_VERTS_16[4] = vec2(0.7071068);
					CIRC_VERTS_16[5] = vec2(0.7071068);
					CIRC_VERTS_16[6] = vec2(0.3826834);
					CIRC_VERTS_16[7] = vec2(0.9238795);
					CIRC_VERTS_16[8] = vec2(0);
					CIRC_VERTS_16[9] = vec2(1);
					CIRC_VERTS_16[10] = vec2(-0.3826834);
					CIRC_VERTS_16[11] = vec2(0.9238795);
					CIRC_VERTS_16[12] = vec2(-0.7071068);
					CIRC_VERTS_16[13] = vec2(0.7071068);
					CIRC_VERTS_16[14] = vec2(-0.9238795);
					CIRC_VERTS_16[15] = vec2(0.3826834);
					CIRC_VERTS_16[16] = vec2(-1);
					CIRC_VERTS_16[17] = vec2(0);
					CIRC_VERTS_16[18] = vec2(-0.9238795);
					CIRC_VERTS_16[19] = vec2(-0.3826834);
					CIRC_VERTS_16[20] = vec2(-0.7071068);
					CIRC_VERTS_16[21] = vec2(-0.7071068);
					CIRC_VERTS_16[22] = vec2(-0.3826834);
					CIRC_VERTS_16[23] = vec2(-0.9238795);
					CIRC_VERTS_16[24] = vec2(0);
					CIRC_VERTS_16[25] = vec2(-1);
					CIRC_VERTS_16[26] = vec2(0.3826834);
					CIRC_VERTS_16[27] = vec2(-0.9238795);
					CIRC_VERTS_16[28] = vec2(0.7071068);
					CIRC_VERTS_16[29] = vec2(-0.7071068);
					CIRC_VERTS_16[30] = vec2(0.9238795);
					CIRC_VERTS_16[31] = vec2(-0.3826834);
					CIRC_VERTS_16[32] = vec2(1);
					CIRC_VERTS_16[33] = vec2(0);
					unity_MatrixMVP = (unity_MatrixVP * unity_ObjectToWorld);
					unity_MatrixMV = (unity_MatrixV * unity_ObjectToWorld);
					unity_MatrixTMV = xll_transpose_mf4x4(unity_MatrixMV);
					unity_MatrixITMV = xll_transpose_mf4x4((unity_WorldToObject * unity_MatrixInvV));
					    v2f xl_retval;
					    appdata xlt_v;
					    xlt_v.vertex = vec4(gl_Vertex);
					    xlt_v.uv = vec2(gl_MultiTexCoord0);
					    xl_retval = vert( xlt_v);
					    xlv_TEXCOORD0 = vec2(xl_retval.uv);
					    gl_Position = vec4(xl_retval.vertex);
					}
					/* HLSL2GLSL - NOTE: GLSL optimization failed
					(128,1): error: array index must be < 4
					(129,1): error: array index must be < 4
					(130,1): error: array index must be < 4
					(131,1): error: array index must be < 4
					(137,1): error: array index must be < 5
					(138,1): error: array index must be < 5
					(139,1): error: array index must be < 5
					(140,1): error: array index must be < 5
					(141,1): error: array index must be < 5
					(147,1): error: array index must be < 5
					(148,1): error: array index must be < 5
					(149,1): error: array index must be < 5
					(150,1): error: array index must be < 5
					(151,1): error: array index must be < 5
					(159,1): error: array index must be < 7
					(160,1): error: array index must be < 7
					(161,1): error: array index must be < 7
					(162,1): error: array index must be < 7
					(163,1): error: array index must be < 7
					(164,1): error: array index must be < 7
					(165,1): error: array index must be < 7
					(175,1): error: array index must be < 9
					(176,1): error: array index must be < 9
					(177,1): error: array index must be < 9
					(178,1): error: array index must be < 9
					(179,1): error: array index must be < 9
					(180,1): error: array index must be < 9
					(181,1): error: array index must be < 9
					(182,1): error: array index must be < 9
					(183,1): error: array index must be < 9
					(201,1): error: array index must be < 17
					(202,1): error: array index must be < 17
					(203,1): error: array index must be < 17
					(204,1): error: array index must be < 17
					(205,1): error: array index must be < 17
					(206,1): error: array index must be < 17
					(207,1): error: array index must be < 17
					(208,1): error: array index must be < 17
					(209,1): error: array index must be < 17
					(210,1): error: array index must be < 17
					(211,1): error: array index must be < 17
					(212,1): error: array index must be < 17
					(213,1): error: array index must be < 17
					(214,1): error: array index must be < 17
					(215,1): error: array index must be < 17
					(216,1): error: array index must be < 17
					(217,1): error: array index must be < 17
					*/
					
					#endif
					#ifdef FRAGMENT
					#ifndef SHADER_TARGET
					    #define SHADER_TARGET 25
					#endif
					#ifndef SHADER_REQUIRE_DERIVATIVES
					    #define SHADER_REQUIRE_DERIVATIVES 1
					#endif
					#ifndef UNITY_NO_DXT5nm
					    #define UNITY_NO_DXT5nm 1
					#endif
					#ifndef UNITY_NO_RGBM
					    #define UNITY_NO_RGBM 1
					#endif
					#ifndef UNITY_ENABLE_REFLECTION_BUFFERS
					    #define UNITY_ENABLE_REFLECTION_BUFFERS 1
					#endif
					#ifndef UNITY_FRAMEBUFFER_FETCH_AVAILABLE
					    #define UNITY_FRAMEBUFFER_FETCH_AVAILABLE 1
					#endif
					#ifndef UNITY_NO_CUBEMAP_ARRAY
					    #define UNITY_NO_CUBEMAP_ARRAY 1
					#endif
					#ifndef UNITY_NO_SCREENSPACE_SHADOWS
					    #define UNITY_NO_SCREENSPACE_SHADOWS 1
					#endif
					#ifndef UNITY_PBS_USE_BRDF3
					    #define UNITY_PBS_USE_BRDF3 1
					#endif
					#ifndef UNITY_NO_FULL_STANDARD_SHADER
					    #define UNITY_NO_FULL_STANDARD_SHADER 1
					#endif
					#ifndef SHADER_API_MOBILE
					    #define SHADER_API_MOBILE 1
					#endif
					#ifndef UNITY_HARDWARE_TIER1
					    #define UNITY_HARDWARE_TIER1 1
					#endif
					#ifndef UNITY_COLORSPACE_GAMMA
					    #define UNITY_COLORSPACE_GAMMA 1
					#endif
					#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					    #define UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS 1
					#endif
					#ifndef UNITY_LIGHTMAP_DLDR_ENCODING
					    #define UNITY_LIGHTMAP_DLDR_ENCODING 1
					#endif
					#ifndef UNITY_VERSION
					    #define UNITY_VERSION 201841
					#endif
					#ifndef SHADER_STAGE_VERTEX
					    #define SHADER_STAGE_VERTEX 1
					#endif
					#ifndef SHADER_TARGET_AVAILABLE
					    #define SHADER_TARGET_AVAILABLE 25
					#endif
					#ifndef SHADER_AVAILABLE_DERIVATIVES
					    #define SHADER_AVAILABLE_DERIVATIVES 1
					#endif
					#ifndef SHADER_AVAILABLE_FRAGCOORD
					    #define SHADER_AVAILABLE_FRAGCOORD 1
					#endif
					#ifndef SHADER_API_GLES
					    #define SHADER_API_GLES 1
					#endif
					float xll_mod_f_f( float x, float y ) {
					  float d = x / y;
					  float f = fract (abs(d)) * y;
					  return d >= 0.0 ? f : -f;
					}
					vec2 xll_mod_vf2_vf2( vec2 x, vec2 y ) {
					  vec2 d = x / y;
					  vec2 f = fract (abs(d)) * y;
					  return vec2 (d.x >= 0.0 ? f.x : -f.x, d.y >= 0.0 ? f.y : -f.y);
					}
					vec3 xll_mod_vf3_vf3( vec3 x, vec3 y ) {
					  vec3 d = x / y;
					  vec3 f = fract (abs(d)) * y;
					  return vec3 (d.x >= 0.0 ? f.x : -f.x, d.y >= 0.0 ? f.y : -f.y, d.z >= 0.0 ? f.z : -f.z);
					}
					vec4 xll_mod_vf4_vf4( vec4 x, vec4 y ) {
					  vec4 d = x / y;
					  vec4 f = fract (abs(d)) * y;
					  return vec4 (d.x >= 0.0 ? f.x : -f.x, d.y >= 0.0 ? f.y : -f.y, d.z >= 0.0 ? f.z : -f.z, d.w >= 0.0 ? f.w : -f.w);
					}
					mat2 xll_transpose_mf2x2(mat2 m) {
					  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
					}
					mat3 xll_transpose_mf3x3(mat3 m) {
					  return mat3( m[0][0], m[1][0], m[2][0],
					               m[0][1], m[1][1], m[2][1],
					               m[0][2], m[1][2], m[2][2]);
					}
					mat4 xll_transpose_mf4x4(mat4 m) {
					  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
					               m[0][1], m[1][1], m[2][1], m[3][1],
					               m[0][2], m[1][2], m[2][2], m[3][2],
					               m[0][3], m[1][3], m[2][3], m[3][3]);
					}
					float xll_saturate_f( float x) {
					  return clamp( x, 0.0, 1.0);
					}
					vec2 xll_saturate_vf2( vec2 x) {
					  return clamp( x, 0.0, 1.0);
					}
					vec3 xll_saturate_vf3( vec3 x) {
					  return clamp( x, 0.0, 1.0);
					}
					vec4 xll_saturate_vf4( vec4 x) {
					  return clamp( x, 0.0, 1.0);
					}
					mat2 xll_saturate_mf2x2(mat2 m) {
					  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
					}
					mat3 xll_saturate_mf3x3(mat3 m) {
					  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
					}
					mat4 xll_saturate_mf4x4(mat4 m) {
					  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
					}
					float xll_round_f (float x) { return floor (x+0.5); }
					vec2 xll_round_vf2 (vec2 x) { return floor (x+vec2(0.5)); }
					vec3 xll_round_vf3 (vec3 x) { return floor (x+vec3(0.5)); }
					vec4 xll_round_vf4 (vec4 x) { return floor (x+vec4(0.5)); }
					#line 447
					struct v2f_vertex_lit {
					    highp vec2 uv;
					    lowp vec4 diff;
					    lowp vec4 spec;
					};
					#line 756
					struct v2f_img {
					    highp vec4 pos;
					    mediump vec2 uv;
					};
					#line 749
					struct appdata_img {
					    highp vec4 vertex;
					    mediump vec2 texcoord;
					};
					#line 193
					struct PointRelationship {
					    highp float dist;
					    highp float angle;
					};
					#line 88
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 83
					struct appdata {
					    highp vec4 vertex;
					    highp vec2 uv;
					};
					#line 40
					uniform highp vec4 _Time;
					uniform highp vec4 _SinTime;
					uniform highp vec4 _CosTime;
					uniform highp vec4 unity_DeltaTime;
					#line 46
					uniform highp vec3 _WorldSpaceCameraPos;
					#line 53
					uniform highp vec4 _ProjectionParams;
					#line 59
					uniform highp vec4 _ScreenParams;
					#line 71
					uniform highp vec4 _ZBufferParams;
					#line 77
					uniform highp vec4 unity_OrthoParams;
					#line 86
					uniform highp vec4 unity_CameraWorldClipPlanes[6];
					#line 92
					uniform highp mat4 unity_CameraProjection;
					uniform highp mat4 unity_CameraInvProjection;
					uniform highp mat4 unity_WorldToCamera;
					uniform highp mat4 unity_CameraToWorld;
					#line 108
					uniform highp vec4 _WorldSpaceLightPos0;
					uniform highp vec4 _LightPositionRange;
					#line 112
					uniform highp vec4 _LightProjectionParams;
					uniform highp vec4 unity_4LightPosX0;
					uniform highp vec4 unity_4LightPosY0;
					#line 116
					uniform highp vec4 unity_4LightPosZ0;
					uniform mediump vec4 unity_4LightAtten0;
					uniform mediump vec4 unity_LightColor[8];
					#line 122
					uniform highp vec4 unity_LightPosition[8];
					#line 127
					uniform mediump vec4 unity_LightAtten[8];
					uniform highp vec4 unity_SpotDirection[8];
					#line 131
					uniform mediump vec4 unity_SHAr;
					uniform mediump vec4 unity_SHAg;
					uniform mediump vec4 unity_SHAb;
					uniform mediump vec4 unity_SHBr;
					#line 135
					uniform mediump vec4 unity_SHBg;
					uniform mediump vec4 unity_SHBb;
					uniform mediump vec4 unity_SHC;
					#line 140
					uniform lowp vec4 unity_OcclusionMaskSelector;
					uniform lowp vec4 unity_ProbesOcclusion;
					#line 145
					uniform mediump vec3 unity_LightColor0;
					uniform mediump vec3 unity_LightColor1;
					uniform mediump vec3 unity_LightColor2;
					uniform mediump vec3 unity_LightColor3;
					#line 152
					uniform highp vec4 unity_ShadowSplitSpheres[4];
					uniform highp vec4 unity_ShadowSplitSqRadii;
					uniform highp vec4 unity_LightShadowBias;
					uniform highp vec4 _LightSplitsNear;
					#line 156
					uniform highp vec4 _LightSplitsFar;
					uniform highp mat4 unity_WorldToShadow[4];
					uniform mediump vec4 _LightShadowData;
					uniform highp vec4 unity_ShadowFadeCenterAndType;
					#line 165
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp vec4 unity_LODFade;
					uniform highp vec4 unity_WorldTransformParams;
					#line 206
					uniform highp mat4 glstate_matrix_transpose_modelview0;
					#line 214
					uniform lowp vec4 glstate_lightmodel_ambient;
					uniform lowp vec4 unity_AmbientSky;
					uniform lowp vec4 unity_AmbientEquator;
					uniform lowp vec4 unity_AmbientGround;
					#line 218
					uniform lowp vec4 unity_IndirectSpecColor;
					uniform highp mat4 glstate_matrix_projection;
					#line 222
					uniform highp mat4 unity_MatrixV;
					uniform highp mat4 unity_MatrixInvV;
					uniform highp mat4 unity_MatrixVP;
					uniform highp int unity_StereoEyeIndex;
					#line 228
					uniform lowp vec4 unity_ShadowColor;
					#line 235
					uniform lowp vec4 unity_FogColor;
					#line 240
					uniform highp vec4 unity_FogParams;
					#line 248
					uniform mediump sampler2D unity_Lightmap;
					uniform mediump sampler2D unity_LightmapInd;
					#line 252
					uniform sampler2D unity_ShadowMask;
					uniform sampler2D unity_DynamicLightmap;
					#line 256
					uniform sampler2D unity_DynamicDirectionality;
					uniform sampler2D unity_DynamicNormal;
					#line 260
					uniform highp vec4 unity_LightmapST;
					uniform highp vec4 unity_DynamicLightmapST;
					#line 268
					uniform samplerCube unity_SpecCube0;
					uniform samplerCube unity_SpecCube1;
					#line 272
					uniform highp vec4 unity_SpecCube0_BoxMax;
					uniform highp vec4 unity_SpecCube0_BoxMin;
					uniform highp vec4 unity_SpecCube0_ProbePosition;
					uniform mediump vec4 unity_SpecCube0_HDR;
					#line 277
					uniform highp vec4 unity_SpecCube1_BoxMax;
					uniform highp vec4 unity_SpecCube1_BoxMin;
					uniform highp vec4 unity_SpecCube1_ProbePosition;
					uniform mediump vec4 unity_SpecCube1_HDR;
					#line 317
					highp mat4 unity_MatrixMVP;
					highp mat4 unity_MatrixMV;
					highp mat4 unity_MatrixTMV;
					highp mat4 unity_MatrixITMV;
					#line 8
					#line 30
					#line 44
					#line 84
					#line 93
					#line 103
					#line 112
					#line 124
					#line 135
					#line 141
					#line 147
					#line 151
					#line 157
					#line 163
					#line 169
					#line 175
					#line 186
					#line 201
					#line 208
					#line 223
					#line 230
					#line 237
					#line 255
					#line 291
					#line 320
					#line 326
					#line 339
					#line 357
					#line 373
					#line 427
					#line 453
					#line 464
					#line 473
					#line 480
					#line 485
					#line 502
					#line 522
					#line 537
					#line 543
					#line 554
					uniform mediump vec4 unity_Lightmap_HDR;
					uniform mediump vec4 unity_DynamicLightmap_HDR;
					#line 568
					#line 578
					#line 593
					#line 602
					#line 609
					#line 618
					#line 626
					#line 635
					#line 654
					#line 660
					#line 670
					#line 680
					#line 691
					#line 696
					#line 702
					#line 707
					#line 764
					#line 770
					#line 785
					#line 816
					#line 830
					#line 834
					#line 840
					#line 849
					#line 859
					#line 885
					#line 891
					#line 18
					uniform highp float _Visibility;
					uniform highp vec3 _FocalPointPosition;
					#line 22
					uniform highp float _FocalPointRange;
					uniform highp float _FocalPointRadius;
					uniform highp float _FocalPointFadePower;
					#line 27
					uniform highp float _GridScale;
					uniform highp float _GeometryEdgeFadeWidth;
					#line 31
					uniform highp vec4 _GridColorBase;
					uniform highp vec4 _GridColorFocalPoint;
					uniform highp float _ColorMixFocalPoint;
					uniform highp vec4 _GridColorEdge;
					#line 35
					uniform highp float _ColorMixEdge;
					uniform highp float _CellScale;
					#line 39
					uniform highp float _ScaleFocalPoint;
					uniform highp float _ScaleFocalPointMix;
					uniform highp float _ScaleEdge;
					uniform highp float _ScaleEdgeMix;
					#line 45
					uniform highp float _CellFill;
					uniform highp float _CellFillFocalPoint;
					uniform highp float _CellFillMixFocalPoint;
					uniform highp float _CellFillEdge;
					#line 49
					uniform highp float _CellFillMixEdge;
					uniform highp float _OccludeCornerBase;
					#line 53
					uniform highp float _CellCornerOccludeFocalPoint;
					uniform highp float _CellCornerOccludeMixFocalPoint;
					uniform highp float _CellCornerOccludeEdge;
					uniform highp float _CellCornerOccludeMixEdge;
					#line 59
					uniform highp float _OccludeEdgeBase;
					uniform highp float _CellEdgeOccludeFocalPoint;
					uniform highp float _CellEdgeOccludeMixFocalPoint;
					uniform highp float _CellEdgeOccludeEdge;
					#line 63
					uniform highp float _CellEdgeOccludeMixEdge;
					uniform sampler2D _PerimeterDist;
					uniform highp vec4 _Bounds;
					#line 70
					uniform highp vec4 _Extents;
					uniform highp float _NumVerts;
					#line 74
					uniform highp vec4 _PerimeterVerts[128];
					#line 79
					const highp float HALF_SQRT3 = 0.8660254;
					const highp float SQRT2 = 1.414214;
					const highp float INV_SQRT2 = 0.7071068;
					const highp float SQRT3 = 1.732051;
					#line 83
					const highp float THIRD_PI = 1.047198;
					const highp float HALF_PI = 1.570796;
					const highp float PI = 3.141593;
					const highp float TAU = 6.283185;
					#line 87
					const highp float COS_PI_OVER_8 = 0.9238795;
					const highp float SIN_PI_OVER_8 = 0.3826834;
					highp float TAU_3[3];
					#line 96
					highp float TAU_4[4];
					#line 103
					highp float TAU_6[6];
					#line 112
					highp float TAU_8[8];
					#line 125
					highp vec2 CIRC_VERTS_3[4];
					#line 132
					highp vec2 CIRC_VERTS_4_45[5];
					#line 140
					highp vec2 CIRC_VERTS_4[5];
					#line 148
					highp vec2 CIRC_VERTS_6[7];
					#line 158
					highp vec2 CIRC_VERTS_8[9];
					#line 170
					highp vec2 CIRC_VERTS_16[17];
					#line 201
					#line 215
					#line 224
					#line 285
					#line 292
					#line 298
					#line 307
					#line 93
					#line 101
					#line 224
					highp vec3 Barycentric( in highp vec3 P, in highp vec3 A, in highp vec3 B, in highp vec3 C ) {
					    highp vec3 v0 = (C - A);
					    #line 228
					    highp vec3 v1 = (B - A);
					    highp vec3 v2 = (P - A);
					    #line 232
					    highp float dot00 = dot( v0, v0);
					    highp float dot01 = dot( v0, v1);
					    highp float dot02 = dot( v0, v2);
					    highp float dot11 = dot( v1, v1);
					    #line 236
					    highp float dot12 = dot( v1, v2);
					    highp float invDenom = (1.0 / ((dot00 * dot11) - (dot01 * dot01)));
					    #line 240
					    highp vec3 bary;
					    bary.x = (((dot11 * dot02) - (dot01 * dot12)) * invDenom);
					    bary.y = (((dot00 * dot12) - (dot01 * dot02)) * invDenom);
					    bary.z = ((1.0 - bary.x) - bary.y);
					    #line 244
					    return bary;
					}
					#line 247
					highp float IsInside( in highp vec3 baryCoords ) {
					    #line 248
					    return ((xll_saturate_f((10000.0 * baryCoords.x)) * xll_saturate_f((10000.0 * baryCoords.y))) * xll_saturate_f((10000.0 * (1.0 - (baryCoords.x + baryCoords.y)))));
					}
					#line 101
					lowp vec4 frag( in v2f i ) {
					    lowp vec4 col = _GridColorBase;
					    highp vec3 uv = vec3( i.uv.x, _FocalPointPosition.y, i.uv.y);
					    #line 110
					    lowp vec2 cellXY = (xll_round_vf2((i.uv / _GridScale)) * _GridScale);
					    lowp vec3 cellCP = vec3( cellXY.x, _FocalPointPosition.y, cellXY.y);
					    lowp float distFromCP = distance( uv, cellCP);
					    #line 118
					    PointRelationship perimeterRelationship;
					    highp vec2 localUV = vec2( ((cellCP.x - _Bounds.x) / _Bounds.z), ((cellCP.z - _Bounds.y) / _Bounds.w));
					    #line 124
					    perimeterRelationship.dist = float( ((texture2D( _PerimeterDist, localUV) * _Bounds.z) * 0.5));
					    #line 129
					    lowp float edgeEffect = (1.0 - xll_saturate_f((perimeterRelationship.dist / _GeometryEdgeFadeWidth)));
					    if ((perimeterRelationship.dist < (_GridScale / 2.0))){
					        #line 133
					        col.w = 0.0;
					        return col;
					    }
					    #line 138
					    PointRelationship focalPointRel;
					    focalPointRel.dist = distance( _FocalPointPosition, cellCP);
					    focalPointRel.angle = atan( (_FocalPointPosition.z - cellCP.z), (_FocalPointPosition.x - cellCP.x));
					    #line 142
					    lowp float focalPointEffect = xll_saturate_f((1.0 - (focalPointRel.dist / _FocalPointRadius)));
					    focalPointEffect = xll_saturate_f((1.0 - (abs((_FocalPointRadius - focalPointRel.dist)) / _FocalPointRange)));
					    focalPointEffect = pow( focalPointEffect, (1.0 / _FocalPointFadePower));
					    #line 150
					    lowp float cellScaleEdgeEffect = mix( _CellScale, _ScaleEdge, (_ScaleEdgeMix * edgeEffect));
					    lowp float cellScaleFPEffect = mix( _CellScale, _ScaleFocalPoint, (_ScaleFocalPointMix * focalPointEffect));
					    lowp float cellOuterRadius = ((((_GridScale * 0.5) * _CellScale) * cellScaleEdgeEffect) * cellScaleFPEffect);
					    #line 155
					    lowp float cellFillEdgeEffect = mix( _CellFill, _CellFillEdge, (_CellFillMixEdge * edgeEffect));
					    lowp float cellFillFPEffect = mix( _CellFill, _CellFillFocalPoint, (_CellFillMixFocalPoint * focalPointEffect));
					    lowp float cellInnerRadius = (cellOuterRadius * (1.0 - ((_CellFill / cellFillEdgeEffect) * cellFillFPEffect)));
					    #line 160
					    col = mix( _GridColorBase, _GridColorFocalPoint, vec4( (_ColorMixFocalPoint * focalPointEffect)));
					    col = mix( col, _GridColorEdge, vec4( (_ColorMixEdge * edgeEffect)));
					    #line 164
					    lowp float occludeEdgeThreshold = mix( _OccludeEdgeBase, _CellEdgeOccludeFocalPoint, (_CellEdgeOccludeMixFocalPoint * focalPointEffect));
					    occludeEdgeThreshold = mix( occludeEdgeThreshold, _CellEdgeOccludeEdge, (_CellEdgeOccludeMixEdge * edgeEffect));
					    #line 168
					    lowp float occludeCornerThreshold = mix( _OccludeCornerBase, _CellCornerOccludeFocalPoint, (_CellCornerOccludeMixFocalPoint * focalPointEffect));
					    occludeCornerThreshold = mix( occludeCornerThreshold, _CellCornerOccludeEdge, (_CellCornerOccludeMixEdge * edgeEffect));
					    #line 175
					    lowp vec3 cellOuterVerts[5];
					    lowp vec3 wedgeOuterVerts[3];
					    highp int cvi = 0;
					    for ( ; (cvi < 5); (cvi++)) {
					        cellOuterVerts[cvi].x = (cellCP.x + (cellOuterRadius * CIRC_VERTS_4[cvi].x));
					        #line 179
					        cellOuterVerts[cvi].y = cellCP.y;
					        cellOuterVerts[cvi].z = (cellCP.z + (cellOuterRadius * CIRC_VERTS_4[cvi].y));
					    }
					    #line 183
					    lowp vec3 baryCoords = vec3( 0.0, 0.0, 0.0);
					    lowp float wedgeVal = -1.0;
					    #line 187
					    lowp float value = 0.0;
					    highp int wi = 0;
					    for ( ; (wi < 4); (wi++)) {
					        lowp vec3 checkBaryCoords = Barycentric( uv, cellOuterVerts[wi], cellCP, cellOuterVerts[(wi + 1)]);
					        lowp float val = IsInside( checkBaryCoords);
					        #line 191
					        baryCoords += (val * checkBaryCoords);
					        wedgeVal += (val * (xll_mod_f_f( value, 4.0) + 1.0));
					        value += 1.0;
					    }
					    #line 197
					    lowp float bary0 = xll_saturate_f((10000.0 * (baryCoords.x - occludeCornerThreshold)));
					    lowp float bary1 = xll_saturate_f((10000.0 * (baryCoords.z - occludeCornerThreshold)));
					    lowp float bary2 = xll_saturate_f((10000.0 * ((baryCoords.x - baryCoords.z) - occludeEdgeThreshold)));
					    #line 201
					    lowp float bary3 = xll_saturate_f((10000.0 * ((baryCoords.z - baryCoords.x) - occludeEdgeThreshold)));
					    bary2 = xll_saturate_f((bary2 + bary3));
					    #line 205
					    bary3 = xll_saturate_f((10000.0 * ((cellFillFPEffect * cellFillEdgeEffect) - baryCoords.y)));
					    lowp float val0 = xll_saturate_f((10000.0 * abs((wedgeVal - 4.0))));
					    lowp float val1 = xll_saturate_f((10000.0 * abs((wedgeVal - -1.0))));
					    #line 210
					    col.w = (((((((col.w * val0) * val1) * bary0) * bary1) * bary2) * bary3) * _Visibility);
					    return col;
					}
					varying highp vec2 xlv_TEXCOORD0;
					void main() {
					TAU_3[0] = 2.094395;
					TAU_3[1] = 4.18879;
					TAU_3[2] = 6.283185;
					TAU_4[0] = 1.570796;
					TAU_4[1] = 3.141593;
					TAU_4[2] = 4.712389;
					TAU_4[3] = 6.283185;
					TAU_6[0] = 1.047198;
					TAU_6[1] = 2.094395;
					TAU_6[2] = 3.141593;
					TAU_6[3] = 4.18879;
					TAU_6[4] = 5.235988;
					TAU_6[5] = 6.283185;
					TAU_8[0] = 0.7853982;
					TAU_8[1] = 1.570796;
					TAU_8[2] = 2.356194;
					TAU_8[3] = 3.141593;
					TAU_8[4] = 3.926991;
					TAU_8[5] = 4.712389;
					TAU_8[6] = 5.497787;
					TAU_8[7] = 6.283185;
					CIRC_VERTS_3[0] = vec2(0);
					CIRC_VERTS_3[1] = vec2(-0.8660254);
					CIRC_VERTS_3[2] = vec2(1);
					CIRC_VERTS_3[3] = vec2(0.8660254);
					CIRC_VERTS_3[4] = vec2(-1);
					CIRC_VERTS_3[5] = vec2(0.8660254);
					CIRC_VERTS_3[6] = vec2(0);
					CIRC_VERTS_3[7] = vec2(-0.8660254);
					CIRC_VERTS_4_45[0] = vec2(1);
					CIRC_VERTS_4_45[1] = vec2(0);
					CIRC_VERTS_4_45[2] = vec2(-1);
					CIRC_VERTS_4_45[3] = vec2(0);
					CIRC_VERTS_4_45[4] = vec2(-1);
					CIRC_VERTS_4_45[5] = vec2(-1);
					CIRC_VERTS_4_45[6] = vec2(-1);
					CIRC_VERTS_4_45[7] = vec2(0);
					CIRC_VERTS_4_45[8] = vec2(1);
					CIRC_VERTS_4_45[9] = vec2(0);
					CIRC_VERTS_4[0] = vec2(0.7071068);
					CIRC_VERTS_4[1] = vec2(0.7071068);
					CIRC_VERTS_4[2] = vec2(-0.7071068);
					CIRC_VERTS_4[3] = vec2(0.7071068);
					CIRC_VERTS_4[4] = vec2(-0.7071068);
					CIRC_VERTS_4[5] = vec2(-0.7071068);
					CIRC_VERTS_4[6] = vec2(0.7071068);
					CIRC_VERTS_4[7] = vec2(-0.7071068);
					CIRC_VERTS_4[8] = vec2(0.7071068);
					CIRC_VERTS_4[9] = vec2(0.7071068);
					CIRC_VERTS_6[0] = vec2(0.8660254);
					CIRC_VERTS_6[1] = vec2(0.5);
					CIRC_VERTS_6[2] = vec2(0);
					CIRC_VERTS_6[3] = vec2(1);
					CIRC_VERTS_6[4] = vec2(-0.8660254);
					CIRC_VERTS_6[5] = vec2(0.5);
					CIRC_VERTS_6[6] = vec2(-0.8660254);
					CIRC_VERTS_6[7] = vec2(-0.5);
					CIRC_VERTS_6[8] = vec2(0);
					CIRC_VERTS_6[9] = vec2(-1);
					CIRC_VERTS_6[10] = vec2(0.8660254);
					CIRC_VERTS_6[11] = vec2(-0.5);
					CIRC_VERTS_6[12] = vec2(0.8660254);
					CIRC_VERTS_6[13] = vec2(0.5);
					CIRC_VERTS_8[0] = vec2(1);
					CIRC_VERTS_8[1] = vec2(0);
					CIRC_VERTS_8[2] = vec2(0.7071068);
					CIRC_VERTS_8[3] = vec2(0.7071068);
					CIRC_VERTS_8[4] = vec2(0);
					CIRC_VERTS_8[5] = vec2(1);
					CIRC_VERTS_8[6] = vec2(-0.7071068);
					CIRC_VERTS_8[7] = vec2(0.7071068);
					CIRC_VERTS_8[8] = vec2(-1);
					CIRC_VERTS_8[9] = vec2(0);
					CIRC_VERTS_8[10] = vec2(-0.7071068);
					CIRC_VERTS_8[11] = vec2(-0.7071068);
					CIRC_VERTS_8[12] = vec2(0);
					CIRC_VERTS_8[13] = vec2(-1);
					CIRC_VERTS_8[14] = vec2(0.7071068);
					CIRC_VERTS_8[15] = vec2(-0.7071068);
					CIRC_VERTS_8[16] = vec2(1);
					CIRC_VERTS_8[17] = vec2(0);
					CIRC_VERTS_16[0] = vec2(1);
					CIRC_VERTS_16[1] = vec2(0);
					CIRC_VERTS_16[2] = vec2(0.9238795);
					CIRC_VERTS_16[3] = vec2(0.3826834);
					CIRC_VERTS_16[4] = vec2(0.7071068);
					CIRC_VERTS_16[5] = vec2(0.7071068);
					CIRC_VERTS_16[6] = vec2(0.3826834);
					CIRC_VERTS_16[7] = vec2(0.9238795);
					CIRC_VERTS_16[8] = vec2(0);
					CIRC_VERTS_16[9] = vec2(1);
					CIRC_VERTS_16[10] = vec2(-0.3826834);
					CIRC_VERTS_16[11] = vec2(0.9238795);
					CIRC_VERTS_16[12] = vec2(-0.7071068);
					CIRC_VERTS_16[13] = vec2(0.7071068);
					CIRC_VERTS_16[14] = vec2(-0.9238795);
					CIRC_VERTS_16[15] = vec2(0.3826834);
					CIRC_VERTS_16[16] = vec2(-1);
					CIRC_VERTS_16[17] = vec2(0);
					CIRC_VERTS_16[18] = vec2(-0.9238795);
					CIRC_VERTS_16[19] = vec2(-0.3826834);
					CIRC_VERTS_16[20] = vec2(-0.7071068);
					CIRC_VERTS_16[21] = vec2(-0.7071068);
					CIRC_VERTS_16[22] = vec2(-0.3826834);
					CIRC_VERTS_16[23] = vec2(-0.9238795);
					CIRC_VERTS_16[24] = vec2(0);
					CIRC_VERTS_16[25] = vec2(-1);
					CIRC_VERTS_16[26] = vec2(0.3826834);
					CIRC_VERTS_16[27] = vec2(-0.9238795);
					CIRC_VERTS_16[28] = vec2(0.7071068);
					CIRC_VERTS_16[29] = vec2(-0.7071068);
					CIRC_VERTS_16[30] = vec2(0.9238795);
					CIRC_VERTS_16[31] = vec2(-0.3826834);
					CIRC_VERTS_16[32] = vec2(1);
					CIRC_VERTS_16[33] = vec2(0);
					unity_MatrixMVP = (unity_MatrixVP * unity_ObjectToWorld);
					unity_MatrixMV = (unity_MatrixV * unity_ObjectToWorld);
					unity_MatrixTMV = xll_transpose_mf4x4(unity_MatrixMV);
					unity_MatrixITMV = xll_transpose_mf4x4((unity_WorldToObject * unity_MatrixInvV));
					    lowp vec4 xl_retval;
					    v2f xlt_i;
					    xlt_i.uv = vec2(xlv_TEXCOORD0);
					    xlt_i.vertex = vec4(0.0);
					    xl_retval = frag( xlt_i);
					    gl_FragData[0] = vec4(xl_retval);
					}
					/* HLSL2GLSL - NOTE: GLSL optimization failed
					(241,1): error: array index must be < 4
					(242,1): error: array index must be < 4
					(243,1): error: array index must be < 4
					(244,1): error: array index must be < 4
					(250,1): error: array index must be < 5
					(251,1): error: array index must be < 5
					(252,1): error: array index must be < 5
					(253,1): error: array index must be < 5
					(254,1): error: array index must be < 5
					(260,1): error: array index must be < 5
					(261,1): error: array index must be < 5
					(262,1): error: array index must be < 5
					(263,1): error: array index must be < 5
					(264,1): error: array index must be < 5
					(272,1): error: array index must be < 7
					(273,1): error: array index must be < 7
					(274,1): error: array index must be < 7
					(275,1): error: array index must be < 7
					(276,1): error: array index must be < 7
					(277,1): error: array index must be < 7
					(278,1): error: array index must be < 7
					(288,1): error: array index must be < 9
					(289,1): error: array index must be < 9
					(290,1): error: array index must be < 9
					(291,1): error: array index must be < 9
					(292,1): error: array index must be < 9
					(293,1): error: array index must be < 9
					(294,1): error: array index must be < 9
					(295,1): error: array index must be < 9
					(296,1): error: array index must be < 9
					(314,1): error: array index must be < 17
					(315,1): error: array index must be < 17
					(316,1): error: array index must be < 17
					(317,1): error: array index must be < 17
					(318,1): error: array index must be < 17
					(319,1): error: array index must be < 17
					(320,1): error: array index must be < 17
					(321,1): error: array index must be < 17
					(322,1): error: array index must be < 17
					(323,1): error: array index must be < 17
					(324,1): error: array index must be < 17
					(325,1): error: array index must be < 17
					(326,1): error: array index must be < 17
					(327,1): error: array index must be < 17
					(328,1): error: array index must be < 17
					(329,1): error: array index must be < 17
					(330,1): error: array index must be < 17
					*/
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					#ifndef SHADER_TARGET
					    #define SHADER_TARGET 25
					#endif
					#ifndef SHADER_REQUIRE_DERIVATIVES
					    #define SHADER_REQUIRE_DERIVATIVES 1
					#endif
					#ifndef UNITY_NO_DXT5nm
					    #define UNITY_NO_DXT5nm 1
					#endif
					#ifndef UNITY_NO_RGBM
					    #define UNITY_NO_RGBM 1
					#endif
					#ifndef UNITY_ENABLE_REFLECTION_BUFFERS
					    #define UNITY_ENABLE_REFLECTION_BUFFERS 1
					#endif
					#ifndef UNITY_FRAMEBUFFER_FETCH_AVAILABLE
					    #define UNITY_FRAMEBUFFER_FETCH_AVAILABLE 1
					#endif
					#ifndef UNITY_NO_CUBEMAP_ARRAY
					    #define UNITY_NO_CUBEMAP_ARRAY 1
					#endif
					#ifndef UNITY_NO_SCREENSPACE_SHADOWS
					    #define UNITY_NO_SCREENSPACE_SHADOWS 1
					#endif
					#ifndef UNITY_PBS_USE_BRDF2
					    #define UNITY_PBS_USE_BRDF2 1
					#endif
					#ifndef SHADER_API_MOBILE
					    #define SHADER_API_MOBILE 1
					#endif
					#ifndef UNITY_HARDWARE_TIER2
					    #define UNITY_HARDWARE_TIER2 1
					#endif
					#ifndef UNITY_COLORSPACE_GAMMA
					    #define UNITY_COLORSPACE_GAMMA 1
					#endif
					#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					    #define UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS 1
					#endif
					#ifndef UNITY_LIGHTMAP_DLDR_ENCODING
					    #define UNITY_LIGHTMAP_DLDR_ENCODING 1
					#endif
					#ifndef UNITY_VERSION
					    #define UNITY_VERSION 201841
					#endif
					#ifndef SHADER_STAGE_VERTEX
					    #define SHADER_STAGE_VERTEX 1
					#endif
					#ifndef SHADER_TARGET_AVAILABLE
					    #define SHADER_TARGET_AVAILABLE 25
					#endif
					#ifndef SHADER_AVAILABLE_DERIVATIVES
					    #define SHADER_AVAILABLE_DERIVATIVES 1
					#endif
					#ifndef SHADER_AVAILABLE_FRAGCOORD
					    #define SHADER_AVAILABLE_FRAGCOORD 1
					#endif
					#ifndef SHADER_API_GLES
					    #define SHADER_API_GLES 1
					#endif
					#define gl_Vertex _glesVertex
					attribute vec4 _glesVertex;
					#define gl_MultiTexCoord0 _glesMultiTexCoord0
					attribute vec4 _glesMultiTexCoord0;
					mat2 xll_transpose_mf2x2(mat2 m) {
					  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
					}
					mat3 xll_transpose_mf3x3(mat3 m) {
					  return mat3( m[0][0], m[1][0], m[2][0],
					               m[0][1], m[1][1], m[2][1],
					               m[0][2], m[1][2], m[2][2]);
					}
					mat4 xll_transpose_mf4x4(mat4 m) {
					  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
					               m[0][1], m[1][1], m[2][1], m[3][1],
					               m[0][2], m[1][2], m[2][2], m[3][2],
					               m[0][3], m[1][3], m[2][3], m[3][3]);
					}
					#line 447
					struct v2f_vertex_lit {
					    highp vec2 uv;
					    lowp vec4 diff;
					    lowp vec4 spec;
					};
					#line 756
					struct v2f_img {
					    highp vec4 pos;
					    mediump vec2 uv;
					};
					#line 749
					struct appdata_img {
					    highp vec4 vertex;
					    mediump vec2 texcoord;
					};
					#line 193
					struct PointRelationship {
					    highp float dist;
					    highp float angle;
					};
					#line 88
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 83
					struct appdata {
					    highp vec4 vertex;
					    highp vec2 uv;
					};
					#line 40
					uniform highp vec4 _Time;
					uniform highp vec4 _SinTime;
					uniform highp vec4 _CosTime;
					uniform highp vec4 unity_DeltaTime;
					#line 46
					uniform highp vec3 _WorldSpaceCameraPos;
					#line 53
					uniform highp vec4 _ProjectionParams;
					#line 59
					uniform highp vec4 _ScreenParams;
					#line 71
					uniform highp vec4 _ZBufferParams;
					#line 77
					uniform highp vec4 unity_OrthoParams;
					#line 86
					uniform highp vec4 unity_CameraWorldClipPlanes[6];
					#line 92
					uniform highp mat4 unity_CameraProjection;
					uniform highp mat4 unity_CameraInvProjection;
					uniform highp mat4 unity_WorldToCamera;
					uniform highp mat4 unity_CameraToWorld;
					#line 108
					uniform highp vec4 _WorldSpaceLightPos0;
					uniform highp vec4 _LightPositionRange;
					#line 112
					uniform highp vec4 _LightProjectionParams;
					uniform highp vec4 unity_4LightPosX0;
					uniform highp vec4 unity_4LightPosY0;
					#line 116
					uniform highp vec4 unity_4LightPosZ0;
					uniform mediump vec4 unity_4LightAtten0;
					uniform mediump vec4 unity_LightColor[8];
					#line 122
					uniform highp vec4 unity_LightPosition[8];
					#line 127
					uniform mediump vec4 unity_LightAtten[8];
					uniform highp vec4 unity_SpotDirection[8];
					#line 131
					uniform mediump vec4 unity_SHAr;
					uniform mediump vec4 unity_SHAg;
					uniform mediump vec4 unity_SHAb;
					uniform mediump vec4 unity_SHBr;
					#line 135
					uniform mediump vec4 unity_SHBg;
					uniform mediump vec4 unity_SHBb;
					uniform mediump vec4 unity_SHC;
					#line 140
					uniform lowp vec4 unity_OcclusionMaskSelector;
					uniform lowp vec4 unity_ProbesOcclusion;
					#line 145
					uniform mediump vec3 unity_LightColor0;
					uniform mediump vec3 unity_LightColor1;
					uniform mediump vec3 unity_LightColor2;
					uniform mediump vec3 unity_LightColor3;
					#line 152
					uniform highp vec4 unity_ShadowSplitSpheres[4];
					uniform highp vec4 unity_ShadowSplitSqRadii;
					uniform highp vec4 unity_LightShadowBias;
					uniform highp vec4 _LightSplitsNear;
					#line 156
					uniform highp vec4 _LightSplitsFar;
					uniform highp mat4 unity_WorldToShadow[4];
					uniform mediump vec4 _LightShadowData;
					uniform highp vec4 unity_ShadowFadeCenterAndType;
					#line 165
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp vec4 unity_LODFade;
					uniform highp vec4 unity_WorldTransformParams;
					#line 206
					uniform highp mat4 glstate_matrix_transpose_modelview0;
					#line 214
					uniform lowp vec4 glstate_lightmodel_ambient;
					uniform lowp vec4 unity_AmbientSky;
					uniform lowp vec4 unity_AmbientEquator;
					uniform lowp vec4 unity_AmbientGround;
					#line 218
					uniform lowp vec4 unity_IndirectSpecColor;
					uniform highp mat4 glstate_matrix_projection;
					#line 222
					uniform highp mat4 unity_MatrixV;
					uniform highp mat4 unity_MatrixInvV;
					uniform highp mat4 unity_MatrixVP;
					uniform highp int unity_StereoEyeIndex;
					#line 228
					uniform lowp vec4 unity_ShadowColor;
					#line 235
					uniform lowp vec4 unity_FogColor;
					#line 240
					uniform highp vec4 unity_FogParams;
					#line 248
					uniform mediump sampler2D unity_Lightmap;
					uniform mediump sampler2D unity_LightmapInd;
					#line 252
					uniform sampler2D unity_ShadowMask;
					uniform sampler2D unity_DynamicLightmap;
					#line 256
					uniform sampler2D unity_DynamicDirectionality;
					uniform sampler2D unity_DynamicNormal;
					#line 260
					uniform highp vec4 unity_LightmapST;
					uniform highp vec4 unity_DynamicLightmapST;
					#line 268
					uniform samplerCube unity_SpecCube0;
					uniform samplerCube unity_SpecCube1;
					#line 272
					uniform highp vec4 unity_SpecCube0_BoxMax;
					uniform highp vec4 unity_SpecCube0_BoxMin;
					uniform highp vec4 unity_SpecCube0_ProbePosition;
					uniform mediump vec4 unity_SpecCube0_HDR;
					#line 277
					uniform highp vec4 unity_SpecCube1_BoxMax;
					uniform highp vec4 unity_SpecCube1_BoxMin;
					uniform highp vec4 unity_SpecCube1_ProbePosition;
					uniform mediump vec4 unity_SpecCube1_HDR;
					#line 317
					highp mat4 unity_MatrixMVP;
					highp mat4 unity_MatrixMV;
					highp mat4 unity_MatrixTMV;
					highp mat4 unity_MatrixITMV;
					#line 8
					#line 30
					#line 44
					#line 84
					#line 93
					#line 103
					#line 112
					#line 124
					#line 135
					#line 141
					#line 147
					#line 151
					#line 157
					#line 163
					#line 169
					#line 175
					#line 186
					#line 201
					#line 208
					#line 223
					#line 230
					#line 237
					#line 255
					#line 291
					#line 320
					#line 326
					#line 339
					#line 357
					#line 373
					#line 427
					#line 453
					#line 464
					#line 473
					#line 480
					#line 485
					#line 502
					#line 522
					#line 537
					#line 543
					#line 554
					uniform mediump vec4 unity_Lightmap_HDR;
					uniform mediump vec4 unity_DynamicLightmap_HDR;
					#line 568
					#line 578
					#line 593
					#line 602
					#line 609
					#line 618
					#line 626
					#line 635
					#line 654
					#line 660
					#line 670
					#line 680
					#line 691
					#line 696
					#line 702
					#line 707
					#line 764
					#line 770
					#line 785
					#line 816
					#line 830
					#line 834
					#line 840
					#line 849
					#line 859
					#line 885
					#line 891
					#line 18
					uniform highp float _Visibility;
					uniform highp vec3 _FocalPointPosition;
					#line 22
					uniform highp float _FocalPointRange;
					uniform highp float _FocalPointRadius;
					uniform highp float _FocalPointFadePower;
					#line 27
					uniform highp float _GridScale;
					uniform highp float _GeometryEdgeFadeWidth;
					#line 31
					uniform highp vec4 _GridColorBase;
					uniform highp vec4 _GridColorFocalPoint;
					uniform highp float _ColorMixFocalPoint;
					uniform highp vec4 _GridColorEdge;
					#line 35
					uniform highp float _ColorMixEdge;
					uniform highp float _CellScale;
					#line 39
					uniform highp float _ScaleFocalPoint;
					uniform highp float _ScaleFocalPointMix;
					uniform highp float _ScaleEdge;
					uniform highp float _ScaleEdgeMix;
					#line 45
					uniform highp float _CellFill;
					uniform highp float _CellFillFocalPoint;
					uniform highp float _CellFillMixFocalPoint;
					uniform highp float _CellFillEdge;
					#line 49
					uniform highp float _CellFillMixEdge;
					uniform highp float _OccludeCornerBase;
					#line 53
					uniform highp float _CellCornerOccludeFocalPoint;
					uniform highp float _CellCornerOccludeMixFocalPoint;
					uniform highp float _CellCornerOccludeEdge;
					uniform highp float _CellCornerOccludeMixEdge;
					#line 59
					uniform highp float _OccludeEdgeBase;
					uniform highp float _CellEdgeOccludeFocalPoint;
					uniform highp float _CellEdgeOccludeMixFocalPoint;
					uniform highp float _CellEdgeOccludeEdge;
					#line 63
					uniform highp float _CellEdgeOccludeMixEdge;
					uniform sampler2D _PerimeterDist;
					uniform highp vec4 _Bounds;
					#line 70
					uniform highp vec4 _Extents;
					uniform highp float _NumVerts;
					#line 74
					uniform highp vec4 _PerimeterVerts[128];
					#line 79
					const highp float HALF_SQRT3 = 0.8660254;
					const highp float SQRT2 = 1.414214;
					const highp float INV_SQRT2 = 0.7071068;
					const highp float SQRT3 = 1.732051;
					#line 83
					const highp float THIRD_PI = 1.047198;
					const highp float HALF_PI = 1.570796;
					const highp float PI = 3.141593;
					const highp float TAU = 6.283185;
					#line 87
					const highp float COS_PI_OVER_8 = 0.9238795;
					const highp float SIN_PI_OVER_8 = 0.3826834;
					highp float TAU_3[3];
					#line 96
					highp float TAU_4[4];
					#line 103
					highp float TAU_6[6];
					#line 112
					highp float TAU_8[8];
					#line 125
					highp vec2 CIRC_VERTS_3[4];
					#line 132
					highp vec2 CIRC_VERTS_4_45[5];
					#line 140
					highp vec2 CIRC_VERTS_4[5];
					#line 148
					highp vec2 CIRC_VERTS_6[7];
					#line 158
					highp vec2 CIRC_VERTS_8[9];
					#line 170
					highp vec2 CIRC_VERTS_16[17];
					#line 201
					#line 215
					#line 224
					#line 285
					#line 292
					#line 298
					#line 307
					#line 93
					#line 101
					#line 44
					highp vec4 UnityObjectToClipPos( in highp vec3 pos ) {
					    #line 50
					    return (unity_MatrixVP * (unity_ObjectToWorld * vec4( pos, 1.0)));
					}
					#line 53
					highp vec4 UnityObjectToClipPos( in highp vec4 pos ) {
					    #line 55
					    return UnityObjectToClipPos( pos.xyz);
					}
					#line 93
					v2f vert( in appdata v ) {
					    v2f o;
					    o.vertex = UnityObjectToClipPos( v.vertex);
					    highp vec2 uv = (unity_ObjectToWorld * v.vertex).xz;
					    #line 97
					    o.uv = uv;
					    return o;
					}
					varying highp vec2 xlv_TEXCOORD0;
					void main() {
					TAU_3[0] = 2.094395;
					TAU_3[1] = 4.18879;
					TAU_3[2] = 6.283185;
					TAU_4[0] = 1.570796;
					TAU_4[1] = 3.141593;
					TAU_4[2] = 4.712389;
					TAU_4[3] = 6.283185;
					TAU_6[0] = 1.047198;
					TAU_6[1] = 2.094395;
					TAU_6[2] = 3.141593;
					TAU_6[3] = 4.18879;
					TAU_6[4] = 5.235988;
					TAU_6[5] = 6.283185;
					TAU_8[0] = 0.7853982;
					TAU_8[1] = 1.570796;
					TAU_8[2] = 2.356194;
					TAU_8[3] = 3.141593;
					TAU_8[4] = 3.926991;
					TAU_8[5] = 4.712389;
					TAU_8[6] = 5.497787;
					TAU_8[7] = 6.283185;
					CIRC_VERTS_3[0] = vec2(0);
					CIRC_VERTS_3[1] = vec2(-0.8660254);
					CIRC_VERTS_3[2] = vec2(1);
					CIRC_VERTS_3[3] = vec2(0.8660254);
					CIRC_VERTS_3[4] = vec2(-1);
					CIRC_VERTS_3[5] = vec2(0.8660254);
					CIRC_VERTS_3[6] = vec2(0);
					CIRC_VERTS_3[7] = vec2(-0.8660254);
					CIRC_VERTS_4_45[0] = vec2(1);
					CIRC_VERTS_4_45[1] = vec2(0);
					CIRC_VERTS_4_45[2] = vec2(-1);
					CIRC_VERTS_4_45[3] = vec2(0);
					CIRC_VERTS_4_45[4] = vec2(-1);
					CIRC_VERTS_4_45[5] = vec2(-1);
					CIRC_VERTS_4_45[6] = vec2(-1);
					CIRC_VERTS_4_45[7] = vec2(0);
					CIRC_VERTS_4_45[8] = vec2(1);
					CIRC_VERTS_4_45[9] = vec2(0);
					CIRC_VERTS_4[0] = vec2(0.7071068);
					CIRC_VERTS_4[1] = vec2(0.7071068);
					CIRC_VERTS_4[2] = vec2(-0.7071068);
					CIRC_VERTS_4[3] = vec2(0.7071068);
					CIRC_VERTS_4[4] = vec2(-0.7071068);
					CIRC_VERTS_4[5] = vec2(-0.7071068);
					CIRC_VERTS_4[6] = vec2(0.7071068);
					CIRC_VERTS_4[7] = vec2(-0.7071068);
					CIRC_VERTS_4[8] = vec2(0.7071068);
					CIRC_VERTS_4[9] = vec2(0.7071068);
					CIRC_VERTS_6[0] = vec2(0.8660254);
					CIRC_VERTS_6[1] = vec2(0.5);
					CIRC_VERTS_6[2] = vec2(0);
					CIRC_VERTS_6[3] = vec2(1);
					CIRC_VERTS_6[4] = vec2(-0.8660254);
					CIRC_VERTS_6[5] = vec2(0.5);
					CIRC_VERTS_6[6] = vec2(-0.8660254);
					CIRC_VERTS_6[7] = vec2(-0.5);
					CIRC_VERTS_6[8] = vec2(0);
					CIRC_VERTS_6[9] = vec2(-1);
					CIRC_VERTS_6[10] = vec2(0.8660254);
					CIRC_VERTS_6[11] = vec2(-0.5);
					CIRC_VERTS_6[12] = vec2(0.8660254);
					CIRC_VERTS_6[13] = vec2(0.5);
					CIRC_VERTS_8[0] = vec2(1);
					CIRC_VERTS_8[1] = vec2(0);
					CIRC_VERTS_8[2] = vec2(0.7071068);
					CIRC_VERTS_8[3] = vec2(0.7071068);
					CIRC_VERTS_8[4] = vec2(0);
					CIRC_VERTS_8[5] = vec2(1);
					CIRC_VERTS_8[6] = vec2(-0.7071068);
					CIRC_VERTS_8[7] = vec2(0.7071068);
					CIRC_VERTS_8[8] = vec2(-1);
					CIRC_VERTS_8[9] = vec2(0);
					CIRC_VERTS_8[10] = vec2(-0.7071068);
					CIRC_VERTS_8[11] = vec2(-0.7071068);
					CIRC_VERTS_8[12] = vec2(0);
					CIRC_VERTS_8[13] = vec2(-1);
					CIRC_VERTS_8[14] = vec2(0.7071068);
					CIRC_VERTS_8[15] = vec2(-0.7071068);
					CIRC_VERTS_8[16] = vec2(1);
					CIRC_VERTS_8[17] = vec2(0);
					CIRC_VERTS_16[0] = vec2(1);
					CIRC_VERTS_16[1] = vec2(0);
					CIRC_VERTS_16[2] = vec2(0.9238795);
					CIRC_VERTS_16[3] = vec2(0.3826834);
					CIRC_VERTS_16[4] = vec2(0.7071068);
					CIRC_VERTS_16[5] = vec2(0.7071068);
					CIRC_VERTS_16[6] = vec2(0.3826834);
					CIRC_VERTS_16[7] = vec2(0.9238795);
					CIRC_VERTS_16[8] = vec2(0);
					CIRC_VERTS_16[9] = vec2(1);
					CIRC_VERTS_16[10] = vec2(-0.3826834);
					CIRC_VERTS_16[11] = vec2(0.9238795);
					CIRC_VERTS_16[12] = vec2(-0.7071068);
					CIRC_VERTS_16[13] = vec2(0.7071068);
					CIRC_VERTS_16[14] = vec2(-0.9238795);
					CIRC_VERTS_16[15] = vec2(0.3826834);
					CIRC_VERTS_16[16] = vec2(-1);
					CIRC_VERTS_16[17] = vec2(0);
					CIRC_VERTS_16[18] = vec2(-0.9238795);
					CIRC_VERTS_16[19] = vec2(-0.3826834);
					CIRC_VERTS_16[20] = vec2(-0.7071068);
					CIRC_VERTS_16[21] = vec2(-0.7071068);
					CIRC_VERTS_16[22] = vec2(-0.3826834);
					CIRC_VERTS_16[23] = vec2(-0.9238795);
					CIRC_VERTS_16[24] = vec2(0);
					CIRC_VERTS_16[25] = vec2(-1);
					CIRC_VERTS_16[26] = vec2(0.3826834);
					CIRC_VERTS_16[27] = vec2(-0.9238795);
					CIRC_VERTS_16[28] = vec2(0.7071068);
					CIRC_VERTS_16[29] = vec2(-0.7071068);
					CIRC_VERTS_16[30] = vec2(0.9238795);
					CIRC_VERTS_16[31] = vec2(-0.3826834);
					CIRC_VERTS_16[32] = vec2(1);
					CIRC_VERTS_16[33] = vec2(0);
					unity_MatrixMVP = (unity_MatrixVP * unity_ObjectToWorld);
					unity_MatrixMV = (unity_MatrixV * unity_ObjectToWorld);
					unity_MatrixTMV = xll_transpose_mf4x4(unity_MatrixMV);
					unity_MatrixITMV = xll_transpose_mf4x4((unity_WorldToObject * unity_MatrixInvV));
					    v2f xl_retval;
					    appdata xlt_v;
					    xlt_v.vertex = vec4(gl_Vertex);
					    xlt_v.uv = vec2(gl_MultiTexCoord0);
					    xl_retval = vert( xlt_v);
					    xlv_TEXCOORD0 = vec2(xl_retval.uv);
					    gl_Position = vec4(xl_retval.vertex);
					}
					/* HLSL2GLSL - NOTE: GLSL optimization failed
					(128,1): error: array index must be < 4
					(129,1): error: array index must be < 4
					(130,1): error: array index must be < 4
					(131,1): error: array index must be < 4
					(137,1): error: array index must be < 5
					(138,1): error: array index must be < 5
					(139,1): error: array index must be < 5
					(140,1): error: array index must be < 5
					(141,1): error: array index must be < 5
					(147,1): error: array index must be < 5
					(148,1): error: array index must be < 5
					(149,1): error: array index must be < 5
					(150,1): error: array index must be < 5
					(151,1): error: array index must be < 5
					(159,1): error: array index must be < 7
					(160,1): error: array index must be < 7
					(161,1): error: array index must be < 7
					(162,1): error: array index must be < 7
					(163,1): error: array index must be < 7
					(164,1): error: array index must be < 7
					(165,1): error: array index must be < 7
					(175,1): error: array index must be < 9
					(176,1): error: array index must be < 9
					(177,1): error: array index must be < 9
					(178,1): error: array index must be < 9
					(179,1): error: array index must be < 9
					(180,1): error: array index must be < 9
					(181,1): error: array index must be < 9
					(182,1): error: array index must be < 9
					(183,1): error: array index must be < 9
					(201,1): error: array index must be < 17
					(202,1): error: array index must be < 17
					(203,1): error: array index must be < 17
					(204,1): error: array index must be < 17
					(205,1): error: array index must be < 17
					(206,1): error: array index must be < 17
					(207,1): error: array index must be < 17
					(208,1): error: array index must be < 17
					(209,1): error: array index must be < 17
					(210,1): error: array index must be < 17
					(211,1): error: array index must be < 17
					(212,1): error: array index must be < 17
					(213,1): error: array index must be < 17
					(214,1): error: array index must be < 17
					(215,1): error: array index must be < 17
					(216,1): error: array index must be < 17
					(217,1): error: array index must be < 17
					*/
					
					#endif
					#ifdef FRAGMENT
					#ifndef SHADER_TARGET
					    #define SHADER_TARGET 25
					#endif
					#ifndef SHADER_REQUIRE_DERIVATIVES
					    #define SHADER_REQUIRE_DERIVATIVES 1
					#endif
					#ifndef UNITY_NO_DXT5nm
					    #define UNITY_NO_DXT5nm 1
					#endif
					#ifndef UNITY_NO_RGBM
					    #define UNITY_NO_RGBM 1
					#endif
					#ifndef UNITY_ENABLE_REFLECTION_BUFFERS
					    #define UNITY_ENABLE_REFLECTION_BUFFERS 1
					#endif
					#ifndef UNITY_FRAMEBUFFER_FETCH_AVAILABLE
					    #define UNITY_FRAMEBUFFER_FETCH_AVAILABLE 1
					#endif
					#ifndef UNITY_NO_CUBEMAP_ARRAY
					    #define UNITY_NO_CUBEMAP_ARRAY 1
					#endif
					#ifndef UNITY_NO_SCREENSPACE_SHADOWS
					    #define UNITY_NO_SCREENSPACE_SHADOWS 1
					#endif
					#ifndef UNITY_PBS_USE_BRDF2
					    #define UNITY_PBS_USE_BRDF2 1
					#endif
					#ifndef SHADER_API_MOBILE
					    #define SHADER_API_MOBILE 1
					#endif
					#ifndef UNITY_HARDWARE_TIER2
					    #define UNITY_HARDWARE_TIER2 1
					#endif
					#ifndef UNITY_COLORSPACE_GAMMA
					    #define UNITY_COLORSPACE_GAMMA 1
					#endif
					#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					    #define UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS 1
					#endif
					#ifndef UNITY_LIGHTMAP_DLDR_ENCODING
					    #define UNITY_LIGHTMAP_DLDR_ENCODING 1
					#endif
					#ifndef UNITY_VERSION
					    #define UNITY_VERSION 201841
					#endif
					#ifndef SHADER_STAGE_VERTEX
					    #define SHADER_STAGE_VERTEX 1
					#endif
					#ifndef SHADER_TARGET_AVAILABLE
					    #define SHADER_TARGET_AVAILABLE 25
					#endif
					#ifndef SHADER_AVAILABLE_DERIVATIVES
					    #define SHADER_AVAILABLE_DERIVATIVES 1
					#endif
					#ifndef SHADER_AVAILABLE_FRAGCOORD
					    #define SHADER_AVAILABLE_FRAGCOORD 1
					#endif
					#ifndef SHADER_API_GLES
					    #define SHADER_API_GLES 1
					#endif
					float xll_mod_f_f( float x, float y ) {
					  float d = x / y;
					  float f = fract (abs(d)) * y;
					  return d >= 0.0 ? f : -f;
					}
					vec2 xll_mod_vf2_vf2( vec2 x, vec2 y ) {
					  vec2 d = x / y;
					  vec2 f = fract (abs(d)) * y;
					  return vec2 (d.x >= 0.0 ? f.x : -f.x, d.y >= 0.0 ? f.y : -f.y);
					}
					vec3 xll_mod_vf3_vf3( vec3 x, vec3 y ) {
					  vec3 d = x / y;
					  vec3 f = fract (abs(d)) * y;
					  return vec3 (d.x >= 0.0 ? f.x : -f.x, d.y >= 0.0 ? f.y : -f.y, d.z >= 0.0 ? f.z : -f.z);
					}
					vec4 xll_mod_vf4_vf4( vec4 x, vec4 y ) {
					  vec4 d = x / y;
					  vec4 f = fract (abs(d)) * y;
					  return vec4 (d.x >= 0.0 ? f.x : -f.x, d.y >= 0.0 ? f.y : -f.y, d.z >= 0.0 ? f.z : -f.z, d.w >= 0.0 ? f.w : -f.w);
					}
					mat2 xll_transpose_mf2x2(mat2 m) {
					  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
					}
					mat3 xll_transpose_mf3x3(mat3 m) {
					  return mat3( m[0][0], m[1][0], m[2][0],
					               m[0][1], m[1][1], m[2][1],
					               m[0][2], m[1][2], m[2][2]);
					}
					mat4 xll_transpose_mf4x4(mat4 m) {
					  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
					               m[0][1], m[1][1], m[2][1], m[3][1],
					               m[0][2], m[1][2], m[2][2], m[3][2],
					               m[0][3], m[1][3], m[2][3], m[3][3]);
					}
					float xll_saturate_f( float x) {
					  return clamp( x, 0.0, 1.0);
					}
					vec2 xll_saturate_vf2( vec2 x) {
					  return clamp( x, 0.0, 1.0);
					}
					vec3 xll_saturate_vf3( vec3 x) {
					  return clamp( x, 0.0, 1.0);
					}
					vec4 xll_saturate_vf4( vec4 x) {
					  return clamp( x, 0.0, 1.0);
					}
					mat2 xll_saturate_mf2x2(mat2 m) {
					  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
					}
					mat3 xll_saturate_mf3x3(mat3 m) {
					  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
					}
					mat4 xll_saturate_mf4x4(mat4 m) {
					  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
					}
					float xll_round_f (float x) { return floor (x+0.5); }
					vec2 xll_round_vf2 (vec2 x) { return floor (x+vec2(0.5)); }
					vec3 xll_round_vf3 (vec3 x) { return floor (x+vec3(0.5)); }
					vec4 xll_round_vf4 (vec4 x) { return floor (x+vec4(0.5)); }
					#line 447
					struct v2f_vertex_lit {
					    highp vec2 uv;
					    lowp vec4 diff;
					    lowp vec4 spec;
					};
					#line 756
					struct v2f_img {
					    highp vec4 pos;
					    mediump vec2 uv;
					};
					#line 749
					struct appdata_img {
					    highp vec4 vertex;
					    mediump vec2 texcoord;
					};
					#line 193
					struct PointRelationship {
					    highp float dist;
					    highp float angle;
					};
					#line 88
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 83
					struct appdata {
					    highp vec4 vertex;
					    highp vec2 uv;
					};
					#line 40
					uniform highp vec4 _Time;
					uniform highp vec4 _SinTime;
					uniform highp vec4 _CosTime;
					uniform highp vec4 unity_DeltaTime;
					#line 46
					uniform highp vec3 _WorldSpaceCameraPos;
					#line 53
					uniform highp vec4 _ProjectionParams;
					#line 59
					uniform highp vec4 _ScreenParams;
					#line 71
					uniform highp vec4 _ZBufferParams;
					#line 77
					uniform highp vec4 unity_OrthoParams;
					#line 86
					uniform highp vec4 unity_CameraWorldClipPlanes[6];
					#line 92
					uniform highp mat4 unity_CameraProjection;
					uniform highp mat4 unity_CameraInvProjection;
					uniform highp mat4 unity_WorldToCamera;
					uniform highp mat4 unity_CameraToWorld;
					#line 108
					uniform highp vec4 _WorldSpaceLightPos0;
					uniform highp vec4 _LightPositionRange;
					#line 112
					uniform highp vec4 _LightProjectionParams;
					uniform highp vec4 unity_4LightPosX0;
					uniform highp vec4 unity_4LightPosY0;
					#line 116
					uniform highp vec4 unity_4LightPosZ0;
					uniform mediump vec4 unity_4LightAtten0;
					uniform mediump vec4 unity_LightColor[8];
					#line 122
					uniform highp vec4 unity_LightPosition[8];
					#line 127
					uniform mediump vec4 unity_LightAtten[8];
					uniform highp vec4 unity_SpotDirection[8];
					#line 131
					uniform mediump vec4 unity_SHAr;
					uniform mediump vec4 unity_SHAg;
					uniform mediump vec4 unity_SHAb;
					uniform mediump vec4 unity_SHBr;
					#line 135
					uniform mediump vec4 unity_SHBg;
					uniform mediump vec4 unity_SHBb;
					uniform mediump vec4 unity_SHC;
					#line 140
					uniform lowp vec4 unity_OcclusionMaskSelector;
					uniform lowp vec4 unity_ProbesOcclusion;
					#line 145
					uniform mediump vec3 unity_LightColor0;
					uniform mediump vec3 unity_LightColor1;
					uniform mediump vec3 unity_LightColor2;
					uniform mediump vec3 unity_LightColor3;
					#line 152
					uniform highp vec4 unity_ShadowSplitSpheres[4];
					uniform highp vec4 unity_ShadowSplitSqRadii;
					uniform highp vec4 unity_LightShadowBias;
					uniform highp vec4 _LightSplitsNear;
					#line 156
					uniform highp vec4 _LightSplitsFar;
					uniform highp mat4 unity_WorldToShadow[4];
					uniform mediump vec4 _LightShadowData;
					uniform highp vec4 unity_ShadowFadeCenterAndType;
					#line 165
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp vec4 unity_LODFade;
					uniform highp vec4 unity_WorldTransformParams;
					#line 206
					uniform highp mat4 glstate_matrix_transpose_modelview0;
					#line 214
					uniform lowp vec4 glstate_lightmodel_ambient;
					uniform lowp vec4 unity_AmbientSky;
					uniform lowp vec4 unity_AmbientEquator;
					uniform lowp vec4 unity_AmbientGround;
					#line 218
					uniform lowp vec4 unity_IndirectSpecColor;
					uniform highp mat4 glstate_matrix_projection;
					#line 222
					uniform highp mat4 unity_MatrixV;
					uniform highp mat4 unity_MatrixInvV;
					uniform highp mat4 unity_MatrixVP;
					uniform highp int unity_StereoEyeIndex;
					#line 228
					uniform lowp vec4 unity_ShadowColor;
					#line 235
					uniform lowp vec4 unity_FogColor;
					#line 240
					uniform highp vec4 unity_FogParams;
					#line 248
					uniform mediump sampler2D unity_Lightmap;
					uniform mediump sampler2D unity_LightmapInd;
					#line 252
					uniform sampler2D unity_ShadowMask;
					uniform sampler2D unity_DynamicLightmap;
					#line 256
					uniform sampler2D unity_DynamicDirectionality;
					uniform sampler2D unity_DynamicNormal;
					#line 260
					uniform highp vec4 unity_LightmapST;
					uniform highp vec4 unity_DynamicLightmapST;
					#line 268
					uniform samplerCube unity_SpecCube0;
					uniform samplerCube unity_SpecCube1;
					#line 272
					uniform highp vec4 unity_SpecCube0_BoxMax;
					uniform highp vec4 unity_SpecCube0_BoxMin;
					uniform highp vec4 unity_SpecCube0_ProbePosition;
					uniform mediump vec4 unity_SpecCube0_HDR;
					#line 277
					uniform highp vec4 unity_SpecCube1_BoxMax;
					uniform highp vec4 unity_SpecCube1_BoxMin;
					uniform highp vec4 unity_SpecCube1_ProbePosition;
					uniform mediump vec4 unity_SpecCube1_HDR;
					#line 317
					highp mat4 unity_MatrixMVP;
					highp mat4 unity_MatrixMV;
					highp mat4 unity_MatrixTMV;
					highp mat4 unity_MatrixITMV;
					#line 8
					#line 30
					#line 44
					#line 84
					#line 93
					#line 103
					#line 112
					#line 124
					#line 135
					#line 141
					#line 147
					#line 151
					#line 157
					#line 163
					#line 169
					#line 175
					#line 186
					#line 201
					#line 208
					#line 223
					#line 230
					#line 237
					#line 255
					#line 291
					#line 320
					#line 326
					#line 339
					#line 357
					#line 373
					#line 427
					#line 453
					#line 464
					#line 473
					#line 480
					#line 485
					#line 502
					#line 522
					#line 537
					#line 543
					#line 554
					uniform mediump vec4 unity_Lightmap_HDR;
					uniform mediump vec4 unity_DynamicLightmap_HDR;
					#line 568
					#line 578
					#line 593
					#line 602
					#line 609
					#line 618
					#line 626
					#line 635
					#line 654
					#line 660
					#line 670
					#line 680
					#line 691
					#line 696
					#line 702
					#line 707
					#line 764
					#line 770
					#line 785
					#line 816
					#line 830
					#line 834
					#line 840
					#line 849
					#line 859
					#line 885
					#line 891
					#line 18
					uniform highp float _Visibility;
					uniform highp vec3 _FocalPointPosition;
					#line 22
					uniform highp float _FocalPointRange;
					uniform highp float _FocalPointRadius;
					uniform highp float _FocalPointFadePower;
					#line 27
					uniform highp float _GridScale;
					uniform highp float _GeometryEdgeFadeWidth;
					#line 31
					uniform highp vec4 _GridColorBase;
					uniform highp vec4 _GridColorFocalPoint;
					uniform highp float _ColorMixFocalPoint;
					uniform highp vec4 _GridColorEdge;
					#line 35
					uniform highp float _ColorMixEdge;
					uniform highp float _CellScale;
					#line 39
					uniform highp float _ScaleFocalPoint;
					uniform highp float _ScaleFocalPointMix;
					uniform highp float _ScaleEdge;
					uniform highp float _ScaleEdgeMix;
					#line 45
					uniform highp float _CellFill;
					uniform highp float _CellFillFocalPoint;
					uniform highp float _CellFillMixFocalPoint;
					uniform highp float _CellFillEdge;
					#line 49
					uniform highp float _CellFillMixEdge;
					uniform highp float _OccludeCornerBase;
					#line 53
					uniform highp float _CellCornerOccludeFocalPoint;
					uniform highp float _CellCornerOccludeMixFocalPoint;
					uniform highp float _CellCornerOccludeEdge;
					uniform highp float _CellCornerOccludeMixEdge;
					#line 59
					uniform highp float _OccludeEdgeBase;
					uniform highp float _CellEdgeOccludeFocalPoint;
					uniform highp float _CellEdgeOccludeMixFocalPoint;
					uniform highp float _CellEdgeOccludeEdge;
					#line 63
					uniform highp float _CellEdgeOccludeMixEdge;
					uniform sampler2D _PerimeterDist;
					uniform highp vec4 _Bounds;
					#line 70
					uniform highp vec4 _Extents;
					uniform highp float _NumVerts;
					#line 74
					uniform highp vec4 _PerimeterVerts[128];
					#line 79
					const highp float HALF_SQRT3 = 0.8660254;
					const highp float SQRT2 = 1.414214;
					const highp float INV_SQRT2 = 0.7071068;
					const highp float SQRT3 = 1.732051;
					#line 83
					const highp float THIRD_PI = 1.047198;
					const highp float HALF_PI = 1.570796;
					const highp float PI = 3.141593;
					const highp float TAU = 6.283185;
					#line 87
					const highp float COS_PI_OVER_8 = 0.9238795;
					const highp float SIN_PI_OVER_8 = 0.3826834;
					highp float TAU_3[3];
					#line 96
					highp float TAU_4[4];
					#line 103
					highp float TAU_6[6];
					#line 112
					highp float TAU_8[8];
					#line 125
					highp vec2 CIRC_VERTS_3[4];
					#line 132
					highp vec2 CIRC_VERTS_4_45[5];
					#line 140
					highp vec2 CIRC_VERTS_4[5];
					#line 148
					highp vec2 CIRC_VERTS_6[7];
					#line 158
					highp vec2 CIRC_VERTS_8[9];
					#line 170
					highp vec2 CIRC_VERTS_16[17];
					#line 201
					#line 215
					#line 224
					#line 285
					#line 292
					#line 298
					#line 307
					#line 93
					#line 101
					#line 224
					highp vec3 Barycentric( in highp vec3 P, in highp vec3 A, in highp vec3 B, in highp vec3 C ) {
					    highp vec3 v0 = (C - A);
					    #line 228
					    highp vec3 v1 = (B - A);
					    highp vec3 v2 = (P - A);
					    #line 232
					    highp float dot00 = dot( v0, v0);
					    highp float dot01 = dot( v0, v1);
					    highp float dot02 = dot( v0, v2);
					    highp float dot11 = dot( v1, v1);
					    #line 236
					    highp float dot12 = dot( v1, v2);
					    highp float invDenom = (1.0 / ((dot00 * dot11) - (dot01 * dot01)));
					    #line 240
					    highp vec3 bary;
					    bary.x = (((dot11 * dot02) - (dot01 * dot12)) * invDenom);
					    bary.y = (((dot00 * dot12) - (dot01 * dot02)) * invDenom);
					    bary.z = ((1.0 - bary.x) - bary.y);
					    #line 244
					    return bary;
					}
					#line 247
					highp float IsInside( in highp vec3 baryCoords ) {
					    #line 248
					    return ((xll_saturate_f((10000.0 * baryCoords.x)) * xll_saturate_f((10000.0 * baryCoords.y))) * xll_saturate_f((10000.0 * (1.0 - (baryCoords.x + baryCoords.y)))));
					}
					#line 101
					lowp vec4 frag( in v2f i ) {
					    lowp vec4 col = _GridColorBase;
					    highp vec3 uv = vec3( i.uv.x, _FocalPointPosition.y, i.uv.y);
					    #line 110
					    lowp vec2 cellXY = (xll_round_vf2((i.uv / _GridScale)) * _GridScale);
					    lowp vec3 cellCP = vec3( cellXY.x, _FocalPointPosition.y, cellXY.y);
					    lowp float distFromCP = distance( uv, cellCP);
					    #line 118
					    PointRelationship perimeterRelationship;
					    highp vec2 localUV = vec2( ((cellCP.x - _Bounds.x) / _Bounds.z), ((cellCP.z - _Bounds.y) / _Bounds.w));
					    #line 124
					    perimeterRelationship.dist = float( ((texture2D( _PerimeterDist, localUV) * _Bounds.z) * 0.5));
					    #line 129
					    lowp float edgeEffect = (1.0 - xll_saturate_f((perimeterRelationship.dist / _GeometryEdgeFadeWidth)));
					    if ((perimeterRelationship.dist < (_GridScale / 2.0))){
					        #line 133
					        col.w = 0.0;
					        return col;
					    }
					    #line 138
					    PointRelationship focalPointRel;
					    focalPointRel.dist = distance( _FocalPointPosition, cellCP);
					    focalPointRel.angle = atan( (_FocalPointPosition.z - cellCP.z), (_FocalPointPosition.x - cellCP.x));
					    #line 142
					    lowp float focalPointEffect = xll_saturate_f((1.0 - (focalPointRel.dist / _FocalPointRadius)));
					    focalPointEffect = xll_saturate_f((1.0 - (abs((_FocalPointRadius - focalPointRel.dist)) / _FocalPointRange)));
					    focalPointEffect = pow( focalPointEffect, (1.0 / _FocalPointFadePower));
					    #line 150
					    lowp float cellScaleEdgeEffect = mix( _CellScale, _ScaleEdge, (_ScaleEdgeMix * edgeEffect));
					    lowp float cellScaleFPEffect = mix( _CellScale, _ScaleFocalPoint, (_ScaleFocalPointMix * focalPointEffect));
					    lowp float cellOuterRadius = ((((_GridScale * 0.5) * _CellScale) * cellScaleEdgeEffect) * cellScaleFPEffect);
					    #line 155
					    lowp float cellFillEdgeEffect = mix( _CellFill, _CellFillEdge, (_CellFillMixEdge * edgeEffect));
					    lowp float cellFillFPEffect = mix( _CellFill, _CellFillFocalPoint, (_CellFillMixFocalPoint * focalPointEffect));
					    lowp float cellInnerRadius = (cellOuterRadius * (1.0 - ((_CellFill / cellFillEdgeEffect) * cellFillFPEffect)));
					    #line 160
					    col = mix( _GridColorBase, _GridColorFocalPoint, vec4( (_ColorMixFocalPoint * focalPointEffect)));
					    col = mix( col, _GridColorEdge, vec4( (_ColorMixEdge * edgeEffect)));
					    #line 164
					    lowp float occludeEdgeThreshold = mix( _OccludeEdgeBase, _CellEdgeOccludeFocalPoint, (_CellEdgeOccludeMixFocalPoint * focalPointEffect));
					    occludeEdgeThreshold = mix( occludeEdgeThreshold, _CellEdgeOccludeEdge, (_CellEdgeOccludeMixEdge * edgeEffect));
					    #line 168
					    lowp float occludeCornerThreshold = mix( _OccludeCornerBase, _CellCornerOccludeFocalPoint, (_CellCornerOccludeMixFocalPoint * focalPointEffect));
					    occludeCornerThreshold = mix( occludeCornerThreshold, _CellCornerOccludeEdge, (_CellCornerOccludeMixEdge * edgeEffect));
					    #line 175
					    lowp vec3 cellOuterVerts[5];
					    lowp vec3 wedgeOuterVerts[3];
					    highp int cvi = 0;
					    for ( ; (cvi < 5); (cvi++)) {
					        cellOuterVerts[cvi].x = (cellCP.x + (cellOuterRadius * CIRC_VERTS_4[cvi].x));
					        #line 179
					        cellOuterVerts[cvi].y = cellCP.y;
					        cellOuterVerts[cvi].z = (cellCP.z + (cellOuterRadius * CIRC_VERTS_4[cvi].y));
					    }
					    #line 183
					    lowp vec3 baryCoords = vec3( 0.0, 0.0, 0.0);
					    lowp float wedgeVal = -1.0;
					    #line 187
					    lowp float value = 0.0;
					    highp int wi = 0;
					    for ( ; (wi < 4); (wi++)) {
					        lowp vec3 checkBaryCoords = Barycentric( uv, cellOuterVerts[wi], cellCP, cellOuterVerts[(wi + 1)]);
					        lowp float val = IsInside( checkBaryCoords);
					        #line 191
					        baryCoords += (val * checkBaryCoords);
					        wedgeVal += (val * (xll_mod_f_f( value, 4.0) + 1.0));
					        value += 1.0;
					    }
					    #line 197
					    lowp float bary0 = xll_saturate_f((10000.0 * (baryCoords.x - occludeCornerThreshold)));
					    lowp float bary1 = xll_saturate_f((10000.0 * (baryCoords.z - occludeCornerThreshold)));
					    lowp float bary2 = xll_saturate_f((10000.0 * ((baryCoords.x - baryCoords.z) - occludeEdgeThreshold)));
					    #line 201
					    lowp float bary3 = xll_saturate_f((10000.0 * ((baryCoords.z - baryCoords.x) - occludeEdgeThreshold)));
					    bary2 = xll_saturate_f((bary2 + bary3));
					    #line 205
					    bary3 = xll_saturate_f((10000.0 * ((cellFillFPEffect * cellFillEdgeEffect) - baryCoords.y)));
					    lowp float val0 = xll_saturate_f((10000.0 * abs((wedgeVal - 4.0))));
					    lowp float val1 = xll_saturate_f((10000.0 * abs((wedgeVal - -1.0))));
					    #line 210
					    col.w = (((((((col.w * val0) * val1) * bary0) * bary1) * bary2) * bary3) * _Visibility);
					    return col;
					}
					varying highp vec2 xlv_TEXCOORD0;
					void main() {
					TAU_3[0] = 2.094395;
					TAU_3[1] = 4.18879;
					TAU_3[2] = 6.283185;
					TAU_4[0] = 1.570796;
					TAU_4[1] = 3.141593;
					TAU_4[2] = 4.712389;
					TAU_4[3] = 6.283185;
					TAU_6[0] = 1.047198;
					TAU_6[1] = 2.094395;
					TAU_6[2] = 3.141593;
					TAU_6[3] = 4.18879;
					TAU_6[4] = 5.235988;
					TAU_6[5] = 6.283185;
					TAU_8[0] = 0.7853982;
					TAU_8[1] = 1.570796;
					TAU_8[2] = 2.356194;
					TAU_8[3] = 3.141593;
					TAU_8[4] = 3.926991;
					TAU_8[5] = 4.712389;
					TAU_8[6] = 5.497787;
					TAU_8[7] = 6.283185;
					CIRC_VERTS_3[0] = vec2(0);
					CIRC_VERTS_3[1] = vec2(-0.8660254);
					CIRC_VERTS_3[2] = vec2(1);
					CIRC_VERTS_3[3] = vec2(0.8660254);
					CIRC_VERTS_3[4] = vec2(-1);
					CIRC_VERTS_3[5] = vec2(0.8660254);
					CIRC_VERTS_3[6] = vec2(0);
					CIRC_VERTS_3[7] = vec2(-0.8660254);
					CIRC_VERTS_4_45[0] = vec2(1);
					CIRC_VERTS_4_45[1] = vec2(0);
					CIRC_VERTS_4_45[2] = vec2(-1);
					CIRC_VERTS_4_45[3] = vec2(0);
					CIRC_VERTS_4_45[4] = vec2(-1);
					CIRC_VERTS_4_45[5] = vec2(-1);
					CIRC_VERTS_4_45[6] = vec2(-1);
					CIRC_VERTS_4_45[7] = vec2(0);
					CIRC_VERTS_4_45[8] = vec2(1);
					CIRC_VERTS_4_45[9] = vec2(0);
					CIRC_VERTS_4[0] = vec2(0.7071068);
					CIRC_VERTS_4[1] = vec2(0.7071068);
					CIRC_VERTS_4[2] = vec2(-0.7071068);
					CIRC_VERTS_4[3] = vec2(0.7071068);
					CIRC_VERTS_4[4] = vec2(-0.7071068);
					CIRC_VERTS_4[5] = vec2(-0.7071068);
					CIRC_VERTS_4[6] = vec2(0.7071068);
					CIRC_VERTS_4[7] = vec2(-0.7071068);
					CIRC_VERTS_4[8] = vec2(0.7071068);
					CIRC_VERTS_4[9] = vec2(0.7071068);
					CIRC_VERTS_6[0] = vec2(0.8660254);
					CIRC_VERTS_6[1] = vec2(0.5);
					CIRC_VERTS_6[2] = vec2(0);
					CIRC_VERTS_6[3] = vec2(1);
					CIRC_VERTS_6[4] = vec2(-0.8660254);
					CIRC_VERTS_6[5] = vec2(0.5);
					CIRC_VERTS_6[6] = vec2(-0.8660254);
					CIRC_VERTS_6[7] = vec2(-0.5);
					CIRC_VERTS_6[8] = vec2(0);
					CIRC_VERTS_6[9] = vec2(-1);
					CIRC_VERTS_6[10] = vec2(0.8660254);
					CIRC_VERTS_6[11] = vec2(-0.5);
					CIRC_VERTS_6[12] = vec2(0.8660254);
					CIRC_VERTS_6[13] = vec2(0.5);
					CIRC_VERTS_8[0] = vec2(1);
					CIRC_VERTS_8[1] = vec2(0);
					CIRC_VERTS_8[2] = vec2(0.7071068);
					CIRC_VERTS_8[3] = vec2(0.7071068);
					CIRC_VERTS_8[4] = vec2(0);
					CIRC_VERTS_8[5] = vec2(1);
					CIRC_VERTS_8[6] = vec2(-0.7071068);
					CIRC_VERTS_8[7] = vec2(0.7071068);
					CIRC_VERTS_8[8] = vec2(-1);
					CIRC_VERTS_8[9] = vec2(0);
					CIRC_VERTS_8[10] = vec2(-0.7071068);
					CIRC_VERTS_8[11] = vec2(-0.7071068);
					CIRC_VERTS_8[12] = vec2(0);
					CIRC_VERTS_8[13] = vec2(-1);
					CIRC_VERTS_8[14] = vec2(0.7071068);
					CIRC_VERTS_8[15] = vec2(-0.7071068);
					CIRC_VERTS_8[16] = vec2(1);
					CIRC_VERTS_8[17] = vec2(0);
					CIRC_VERTS_16[0] = vec2(1);
					CIRC_VERTS_16[1] = vec2(0);
					CIRC_VERTS_16[2] = vec2(0.9238795);
					CIRC_VERTS_16[3] = vec2(0.3826834);
					CIRC_VERTS_16[4] = vec2(0.7071068);
					CIRC_VERTS_16[5] = vec2(0.7071068);
					CIRC_VERTS_16[6] = vec2(0.3826834);
					CIRC_VERTS_16[7] = vec2(0.9238795);
					CIRC_VERTS_16[8] = vec2(0);
					CIRC_VERTS_16[9] = vec2(1);
					CIRC_VERTS_16[10] = vec2(-0.3826834);
					CIRC_VERTS_16[11] = vec2(0.9238795);
					CIRC_VERTS_16[12] = vec2(-0.7071068);
					CIRC_VERTS_16[13] = vec2(0.7071068);
					CIRC_VERTS_16[14] = vec2(-0.9238795);
					CIRC_VERTS_16[15] = vec2(0.3826834);
					CIRC_VERTS_16[16] = vec2(-1);
					CIRC_VERTS_16[17] = vec2(0);
					CIRC_VERTS_16[18] = vec2(-0.9238795);
					CIRC_VERTS_16[19] = vec2(-0.3826834);
					CIRC_VERTS_16[20] = vec2(-0.7071068);
					CIRC_VERTS_16[21] = vec2(-0.7071068);
					CIRC_VERTS_16[22] = vec2(-0.3826834);
					CIRC_VERTS_16[23] = vec2(-0.9238795);
					CIRC_VERTS_16[24] = vec2(0);
					CIRC_VERTS_16[25] = vec2(-1);
					CIRC_VERTS_16[26] = vec2(0.3826834);
					CIRC_VERTS_16[27] = vec2(-0.9238795);
					CIRC_VERTS_16[28] = vec2(0.7071068);
					CIRC_VERTS_16[29] = vec2(-0.7071068);
					CIRC_VERTS_16[30] = vec2(0.9238795);
					CIRC_VERTS_16[31] = vec2(-0.3826834);
					CIRC_VERTS_16[32] = vec2(1);
					CIRC_VERTS_16[33] = vec2(0);
					unity_MatrixMVP = (unity_MatrixVP * unity_ObjectToWorld);
					unity_MatrixMV = (unity_MatrixV * unity_ObjectToWorld);
					unity_MatrixTMV = xll_transpose_mf4x4(unity_MatrixMV);
					unity_MatrixITMV = xll_transpose_mf4x4((unity_WorldToObject * unity_MatrixInvV));
					    lowp vec4 xl_retval;
					    v2f xlt_i;
					    xlt_i.uv = vec2(xlv_TEXCOORD0);
					    xlt_i.vertex = vec4(0.0);
					    xl_retval = frag( xlt_i);
					    gl_FragData[0] = vec4(xl_retval);
					}
					/* HLSL2GLSL - NOTE: GLSL optimization failed
					(241,1): error: array index must be < 4
					(242,1): error: array index must be < 4
					(243,1): error: array index must be < 4
					(244,1): error: array index must be < 4
					(250,1): error: array index must be < 5
					(251,1): error: array index must be < 5
					(252,1): error: array index must be < 5
					(253,1): error: array index must be < 5
					(254,1): error: array index must be < 5
					(260,1): error: array index must be < 5
					(261,1): error: array index must be < 5
					(262,1): error: array index must be < 5
					(263,1): error: array index must be < 5
					(264,1): error: array index must be < 5
					(272,1): error: array index must be < 7
					(273,1): error: array index must be < 7
					(274,1): error: array index must be < 7
					(275,1): error: array index must be < 7
					(276,1): error: array index must be < 7
					(277,1): error: array index must be < 7
					(278,1): error: array index must be < 7
					(288,1): error: array index must be < 9
					(289,1): error: array index must be < 9
					(290,1): error: array index must be < 9
					(291,1): error: array index must be < 9
					(292,1): error: array index must be < 9
					(293,1): error: array index must be < 9
					(294,1): error: array index must be < 9
					(295,1): error: array index must be < 9
					(296,1): error: array index must be < 9
					(314,1): error: array index must be < 17
					(315,1): error: array index must be < 17
					(316,1): error: array index must be < 17
					(317,1): error: array index must be < 17
					(318,1): error: array index must be < 17
					(319,1): error: array index must be < 17
					(320,1): error: array index must be < 17
					(321,1): error: array index must be < 17
					(322,1): error: array index must be < 17
					(323,1): error: array index must be < 17
					(324,1): error: array index must be < 17
					(325,1): error: array index must be < 17
					(326,1): error: array index must be < 17
					(327,1): error: array index must be < 17
					(328,1): error: array index must be < 17
					(329,1): error: array index must be < 17
					(330,1): error: array index must be < 17
					*/
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					#ifndef SHADER_TARGET
					    #define SHADER_TARGET 25
					#endif
					#ifndef SHADER_REQUIRE_DERIVATIVES
					    #define SHADER_REQUIRE_DERIVATIVES 1
					#endif
					#ifndef UNITY_NO_DXT5nm
					    #define UNITY_NO_DXT5nm 1
					#endif
					#ifndef UNITY_NO_RGBM
					    #define UNITY_NO_RGBM 1
					#endif
					#ifndef UNITY_ENABLE_REFLECTION_BUFFERS
					    #define UNITY_ENABLE_REFLECTION_BUFFERS 1
					#endif
					#ifndef UNITY_FRAMEBUFFER_FETCH_AVAILABLE
					    #define UNITY_FRAMEBUFFER_FETCH_AVAILABLE 1
					#endif
					#ifndef UNITY_NO_CUBEMAP_ARRAY
					    #define UNITY_NO_CUBEMAP_ARRAY 1
					#endif
					#ifndef UNITY_NO_SCREENSPACE_SHADOWS
					    #define UNITY_NO_SCREENSPACE_SHADOWS 1
					#endif
					#ifndef UNITY_PBS_USE_BRDF2
					    #define UNITY_PBS_USE_BRDF2 1
					#endif
					#ifndef SHADER_API_MOBILE
					    #define SHADER_API_MOBILE 1
					#endif
					#ifndef UNITY_HARDWARE_TIER3
					    #define UNITY_HARDWARE_TIER3 1
					#endif
					#ifndef UNITY_COLORSPACE_GAMMA
					    #define UNITY_COLORSPACE_GAMMA 1
					#endif
					#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					    #define UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS 1
					#endif
					#ifndef UNITY_LIGHTMAP_DLDR_ENCODING
					    #define UNITY_LIGHTMAP_DLDR_ENCODING 1
					#endif
					#ifndef UNITY_VERSION
					    #define UNITY_VERSION 201841
					#endif
					#ifndef SHADER_STAGE_VERTEX
					    #define SHADER_STAGE_VERTEX 1
					#endif
					#ifndef SHADER_TARGET_AVAILABLE
					    #define SHADER_TARGET_AVAILABLE 25
					#endif
					#ifndef SHADER_AVAILABLE_DERIVATIVES
					    #define SHADER_AVAILABLE_DERIVATIVES 1
					#endif
					#ifndef SHADER_AVAILABLE_FRAGCOORD
					    #define SHADER_AVAILABLE_FRAGCOORD 1
					#endif
					#ifndef SHADER_API_GLES
					    #define SHADER_API_GLES 1
					#endif
					#define gl_Vertex _glesVertex
					attribute vec4 _glesVertex;
					#define gl_MultiTexCoord0 _glesMultiTexCoord0
					attribute vec4 _glesMultiTexCoord0;
					mat2 xll_transpose_mf2x2(mat2 m) {
					  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
					}
					mat3 xll_transpose_mf3x3(mat3 m) {
					  return mat3( m[0][0], m[1][0], m[2][0],
					               m[0][1], m[1][1], m[2][1],
					               m[0][2], m[1][2], m[2][2]);
					}
					mat4 xll_transpose_mf4x4(mat4 m) {
					  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
					               m[0][1], m[1][1], m[2][1], m[3][1],
					               m[0][2], m[1][2], m[2][2], m[3][2],
					               m[0][3], m[1][3], m[2][3], m[3][3]);
					}
					#line 447
					struct v2f_vertex_lit {
					    highp vec2 uv;
					    lowp vec4 diff;
					    lowp vec4 spec;
					};
					#line 756
					struct v2f_img {
					    highp vec4 pos;
					    mediump vec2 uv;
					};
					#line 749
					struct appdata_img {
					    highp vec4 vertex;
					    mediump vec2 texcoord;
					};
					#line 193
					struct PointRelationship {
					    highp float dist;
					    highp float angle;
					};
					#line 88
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 83
					struct appdata {
					    highp vec4 vertex;
					    highp vec2 uv;
					};
					#line 40
					uniform highp vec4 _Time;
					uniform highp vec4 _SinTime;
					uniform highp vec4 _CosTime;
					uniform highp vec4 unity_DeltaTime;
					#line 46
					uniform highp vec3 _WorldSpaceCameraPos;
					#line 53
					uniform highp vec4 _ProjectionParams;
					#line 59
					uniform highp vec4 _ScreenParams;
					#line 71
					uniform highp vec4 _ZBufferParams;
					#line 77
					uniform highp vec4 unity_OrthoParams;
					#line 86
					uniform highp vec4 unity_CameraWorldClipPlanes[6];
					#line 92
					uniform highp mat4 unity_CameraProjection;
					uniform highp mat4 unity_CameraInvProjection;
					uniform highp mat4 unity_WorldToCamera;
					uniform highp mat4 unity_CameraToWorld;
					#line 108
					uniform highp vec4 _WorldSpaceLightPos0;
					uniform highp vec4 _LightPositionRange;
					#line 112
					uniform highp vec4 _LightProjectionParams;
					uniform highp vec4 unity_4LightPosX0;
					uniform highp vec4 unity_4LightPosY0;
					#line 116
					uniform highp vec4 unity_4LightPosZ0;
					uniform mediump vec4 unity_4LightAtten0;
					uniform mediump vec4 unity_LightColor[8];
					#line 122
					uniform highp vec4 unity_LightPosition[8];
					#line 127
					uniform mediump vec4 unity_LightAtten[8];
					uniform highp vec4 unity_SpotDirection[8];
					#line 131
					uniform mediump vec4 unity_SHAr;
					uniform mediump vec4 unity_SHAg;
					uniform mediump vec4 unity_SHAb;
					uniform mediump vec4 unity_SHBr;
					#line 135
					uniform mediump vec4 unity_SHBg;
					uniform mediump vec4 unity_SHBb;
					uniform mediump vec4 unity_SHC;
					#line 140
					uniform lowp vec4 unity_OcclusionMaskSelector;
					uniform lowp vec4 unity_ProbesOcclusion;
					#line 145
					uniform mediump vec3 unity_LightColor0;
					uniform mediump vec3 unity_LightColor1;
					uniform mediump vec3 unity_LightColor2;
					uniform mediump vec3 unity_LightColor3;
					#line 152
					uniform highp vec4 unity_ShadowSplitSpheres[4];
					uniform highp vec4 unity_ShadowSplitSqRadii;
					uniform highp vec4 unity_LightShadowBias;
					uniform highp vec4 _LightSplitsNear;
					#line 156
					uniform highp vec4 _LightSplitsFar;
					uniform highp mat4 unity_WorldToShadow[4];
					uniform mediump vec4 _LightShadowData;
					uniform highp vec4 unity_ShadowFadeCenterAndType;
					#line 165
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp vec4 unity_LODFade;
					uniform highp vec4 unity_WorldTransformParams;
					#line 206
					uniform highp mat4 glstate_matrix_transpose_modelview0;
					#line 214
					uniform lowp vec4 glstate_lightmodel_ambient;
					uniform lowp vec4 unity_AmbientSky;
					uniform lowp vec4 unity_AmbientEquator;
					uniform lowp vec4 unity_AmbientGround;
					#line 218
					uniform lowp vec4 unity_IndirectSpecColor;
					uniform highp mat4 glstate_matrix_projection;
					#line 222
					uniform highp mat4 unity_MatrixV;
					uniform highp mat4 unity_MatrixInvV;
					uniform highp mat4 unity_MatrixVP;
					uniform highp int unity_StereoEyeIndex;
					#line 228
					uniform lowp vec4 unity_ShadowColor;
					#line 235
					uniform lowp vec4 unity_FogColor;
					#line 240
					uniform highp vec4 unity_FogParams;
					#line 248
					uniform mediump sampler2D unity_Lightmap;
					uniform mediump sampler2D unity_LightmapInd;
					#line 252
					uniform sampler2D unity_ShadowMask;
					uniform sampler2D unity_DynamicLightmap;
					#line 256
					uniform sampler2D unity_DynamicDirectionality;
					uniform sampler2D unity_DynamicNormal;
					#line 260
					uniform highp vec4 unity_LightmapST;
					uniform highp vec4 unity_DynamicLightmapST;
					#line 268
					uniform samplerCube unity_SpecCube0;
					uniform samplerCube unity_SpecCube1;
					#line 272
					uniform highp vec4 unity_SpecCube0_BoxMax;
					uniform highp vec4 unity_SpecCube0_BoxMin;
					uniform highp vec4 unity_SpecCube0_ProbePosition;
					uniform mediump vec4 unity_SpecCube0_HDR;
					#line 277
					uniform highp vec4 unity_SpecCube1_BoxMax;
					uniform highp vec4 unity_SpecCube1_BoxMin;
					uniform highp vec4 unity_SpecCube1_ProbePosition;
					uniform mediump vec4 unity_SpecCube1_HDR;
					#line 317
					highp mat4 unity_MatrixMVP;
					highp mat4 unity_MatrixMV;
					highp mat4 unity_MatrixTMV;
					highp mat4 unity_MatrixITMV;
					#line 8
					#line 30
					#line 44
					#line 84
					#line 93
					#line 103
					#line 112
					#line 124
					#line 135
					#line 141
					#line 147
					#line 151
					#line 157
					#line 163
					#line 169
					#line 175
					#line 186
					#line 201
					#line 208
					#line 223
					#line 230
					#line 237
					#line 255
					#line 291
					#line 320
					#line 326
					#line 339
					#line 357
					#line 373
					#line 427
					#line 453
					#line 464
					#line 473
					#line 480
					#line 485
					#line 502
					#line 522
					#line 537
					#line 543
					#line 554
					uniform mediump vec4 unity_Lightmap_HDR;
					uniform mediump vec4 unity_DynamicLightmap_HDR;
					#line 568
					#line 578
					#line 593
					#line 602
					#line 609
					#line 618
					#line 626
					#line 635
					#line 654
					#line 660
					#line 670
					#line 680
					#line 691
					#line 696
					#line 702
					#line 707
					#line 764
					#line 770
					#line 785
					#line 816
					#line 830
					#line 834
					#line 840
					#line 849
					#line 859
					#line 885
					#line 891
					#line 18
					uniform highp float _Visibility;
					uniform highp vec3 _FocalPointPosition;
					#line 22
					uniform highp float _FocalPointRange;
					uniform highp float _FocalPointRadius;
					uniform highp float _FocalPointFadePower;
					#line 27
					uniform highp float _GridScale;
					uniform highp float _GeometryEdgeFadeWidth;
					#line 31
					uniform highp vec4 _GridColorBase;
					uniform highp vec4 _GridColorFocalPoint;
					uniform highp float _ColorMixFocalPoint;
					uniform highp vec4 _GridColorEdge;
					#line 35
					uniform highp float _ColorMixEdge;
					uniform highp float _CellScale;
					#line 39
					uniform highp float _ScaleFocalPoint;
					uniform highp float _ScaleFocalPointMix;
					uniform highp float _ScaleEdge;
					uniform highp float _ScaleEdgeMix;
					#line 45
					uniform highp float _CellFill;
					uniform highp float _CellFillFocalPoint;
					uniform highp float _CellFillMixFocalPoint;
					uniform highp float _CellFillEdge;
					#line 49
					uniform highp float _CellFillMixEdge;
					uniform highp float _OccludeCornerBase;
					#line 53
					uniform highp float _CellCornerOccludeFocalPoint;
					uniform highp float _CellCornerOccludeMixFocalPoint;
					uniform highp float _CellCornerOccludeEdge;
					uniform highp float _CellCornerOccludeMixEdge;
					#line 59
					uniform highp float _OccludeEdgeBase;
					uniform highp float _CellEdgeOccludeFocalPoint;
					uniform highp float _CellEdgeOccludeMixFocalPoint;
					uniform highp float _CellEdgeOccludeEdge;
					#line 63
					uniform highp float _CellEdgeOccludeMixEdge;
					uniform sampler2D _PerimeterDist;
					uniform highp vec4 _Bounds;
					#line 70
					uniform highp vec4 _Extents;
					uniform highp float _NumVerts;
					#line 74
					uniform highp vec4 _PerimeterVerts[128];
					#line 79
					const highp float HALF_SQRT3 = 0.8660254;
					const highp float SQRT2 = 1.414214;
					const highp float INV_SQRT2 = 0.7071068;
					const highp float SQRT3 = 1.732051;
					#line 83
					const highp float THIRD_PI = 1.047198;
					const highp float HALF_PI = 1.570796;
					const highp float PI = 3.141593;
					const highp float TAU = 6.283185;
					#line 87
					const highp float COS_PI_OVER_8 = 0.9238795;
					const highp float SIN_PI_OVER_8 = 0.3826834;
					highp float TAU_3[3];
					#line 96
					highp float TAU_4[4];
					#line 103
					highp float TAU_6[6];
					#line 112
					highp float TAU_8[8];
					#line 125
					highp vec2 CIRC_VERTS_3[4];
					#line 132
					highp vec2 CIRC_VERTS_4_45[5];
					#line 140
					highp vec2 CIRC_VERTS_4[5];
					#line 148
					highp vec2 CIRC_VERTS_6[7];
					#line 158
					highp vec2 CIRC_VERTS_8[9];
					#line 170
					highp vec2 CIRC_VERTS_16[17];
					#line 201
					#line 215
					#line 224
					#line 285
					#line 292
					#line 298
					#line 307
					#line 93
					#line 101
					#line 44
					highp vec4 UnityObjectToClipPos( in highp vec3 pos ) {
					    #line 50
					    return (unity_MatrixVP * (unity_ObjectToWorld * vec4( pos, 1.0)));
					}
					#line 53
					highp vec4 UnityObjectToClipPos( in highp vec4 pos ) {
					    #line 55
					    return UnityObjectToClipPos( pos.xyz);
					}
					#line 93
					v2f vert( in appdata v ) {
					    v2f o;
					    o.vertex = UnityObjectToClipPos( v.vertex);
					    highp vec2 uv = (unity_ObjectToWorld * v.vertex).xz;
					    #line 97
					    o.uv = uv;
					    return o;
					}
					varying highp vec2 xlv_TEXCOORD0;
					void main() {
					TAU_3[0] = 2.094395;
					TAU_3[1] = 4.18879;
					TAU_3[2] = 6.283185;
					TAU_4[0] = 1.570796;
					TAU_4[1] = 3.141593;
					TAU_4[2] = 4.712389;
					TAU_4[3] = 6.283185;
					TAU_6[0] = 1.047198;
					TAU_6[1] = 2.094395;
					TAU_6[2] = 3.141593;
					TAU_6[3] = 4.18879;
					TAU_6[4] = 5.235988;
					TAU_6[5] = 6.283185;
					TAU_8[0] = 0.7853982;
					TAU_8[1] = 1.570796;
					TAU_8[2] = 2.356194;
					TAU_8[3] = 3.141593;
					TAU_8[4] = 3.926991;
					TAU_8[5] = 4.712389;
					TAU_8[6] = 5.497787;
					TAU_8[7] = 6.283185;
					CIRC_VERTS_3[0] = vec2(0);
					CIRC_VERTS_3[1] = vec2(-0.8660254);
					CIRC_VERTS_3[2] = vec2(1);
					CIRC_VERTS_3[3] = vec2(0.8660254);
					CIRC_VERTS_3[4] = vec2(-1);
					CIRC_VERTS_3[5] = vec2(0.8660254);
					CIRC_VERTS_3[6] = vec2(0);
					CIRC_VERTS_3[7] = vec2(-0.8660254);
					CIRC_VERTS_4_45[0] = vec2(1);
					CIRC_VERTS_4_45[1] = vec2(0);
					CIRC_VERTS_4_45[2] = vec2(-1);
					CIRC_VERTS_4_45[3] = vec2(0);
					CIRC_VERTS_4_45[4] = vec2(-1);
					CIRC_VERTS_4_45[5] = vec2(-1);
					CIRC_VERTS_4_45[6] = vec2(-1);
					CIRC_VERTS_4_45[7] = vec2(0);
					CIRC_VERTS_4_45[8] = vec2(1);
					CIRC_VERTS_4_45[9] = vec2(0);
					CIRC_VERTS_4[0] = vec2(0.7071068);
					CIRC_VERTS_4[1] = vec2(0.7071068);
					CIRC_VERTS_4[2] = vec2(-0.7071068);
					CIRC_VERTS_4[3] = vec2(0.7071068);
					CIRC_VERTS_4[4] = vec2(-0.7071068);
					CIRC_VERTS_4[5] = vec2(-0.7071068);
					CIRC_VERTS_4[6] = vec2(0.7071068);
					CIRC_VERTS_4[7] = vec2(-0.7071068);
					CIRC_VERTS_4[8] = vec2(0.7071068);
					CIRC_VERTS_4[9] = vec2(0.7071068);
					CIRC_VERTS_6[0] = vec2(0.8660254);
					CIRC_VERTS_6[1] = vec2(0.5);
					CIRC_VERTS_6[2] = vec2(0);
					CIRC_VERTS_6[3] = vec2(1);
					CIRC_VERTS_6[4] = vec2(-0.8660254);
					CIRC_VERTS_6[5] = vec2(0.5);
					CIRC_VERTS_6[6] = vec2(-0.8660254);
					CIRC_VERTS_6[7] = vec2(-0.5);
					CIRC_VERTS_6[8] = vec2(0);
					CIRC_VERTS_6[9] = vec2(-1);
					CIRC_VERTS_6[10] = vec2(0.8660254);
					CIRC_VERTS_6[11] = vec2(-0.5);
					CIRC_VERTS_6[12] = vec2(0.8660254);
					CIRC_VERTS_6[13] = vec2(0.5);
					CIRC_VERTS_8[0] = vec2(1);
					CIRC_VERTS_8[1] = vec2(0);
					CIRC_VERTS_8[2] = vec2(0.7071068);
					CIRC_VERTS_8[3] = vec2(0.7071068);
					CIRC_VERTS_8[4] = vec2(0);
					CIRC_VERTS_8[5] = vec2(1);
					CIRC_VERTS_8[6] = vec2(-0.7071068);
					CIRC_VERTS_8[7] = vec2(0.7071068);
					CIRC_VERTS_8[8] = vec2(-1);
					CIRC_VERTS_8[9] = vec2(0);
					CIRC_VERTS_8[10] = vec2(-0.7071068);
					CIRC_VERTS_8[11] = vec2(-0.7071068);
					CIRC_VERTS_8[12] = vec2(0);
					CIRC_VERTS_8[13] = vec2(-1);
					CIRC_VERTS_8[14] = vec2(0.7071068);
					CIRC_VERTS_8[15] = vec2(-0.7071068);
					CIRC_VERTS_8[16] = vec2(1);
					CIRC_VERTS_8[17] = vec2(0);
					CIRC_VERTS_16[0] = vec2(1);
					CIRC_VERTS_16[1] = vec2(0);
					CIRC_VERTS_16[2] = vec2(0.9238795);
					CIRC_VERTS_16[3] = vec2(0.3826834);
					CIRC_VERTS_16[4] = vec2(0.7071068);
					CIRC_VERTS_16[5] = vec2(0.7071068);
					CIRC_VERTS_16[6] = vec2(0.3826834);
					CIRC_VERTS_16[7] = vec2(0.9238795);
					CIRC_VERTS_16[8] = vec2(0);
					CIRC_VERTS_16[9] = vec2(1);
					CIRC_VERTS_16[10] = vec2(-0.3826834);
					CIRC_VERTS_16[11] = vec2(0.9238795);
					CIRC_VERTS_16[12] = vec2(-0.7071068);
					CIRC_VERTS_16[13] = vec2(0.7071068);
					CIRC_VERTS_16[14] = vec2(-0.9238795);
					CIRC_VERTS_16[15] = vec2(0.3826834);
					CIRC_VERTS_16[16] = vec2(-1);
					CIRC_VERTS_16[17] = vec2(0);
					CIRC_VERTS_16[18] = vec2(-0.9238795);
					CIRC_VERTS_16[19] = vec2(-0.3826834);
					CIRC_VERTS_16[20] = vec2(-0.7071068);
					CIRC_VERTS_16[21] = vec2(-0.7071068);
					CIRC_VERTS_16[22] = vec2(-0.3826834);
					CIRC_VERTS_16[23] = vec2(-0.9238795);
					CIRC_VERTS_16[24] = vec2(0);
					CIRC_VERTS_16[25] = vec2(-1);
					CIRC_VERTS_16[26] = vec2(0.3826834);
					CIRC_VERTS_16[27] = vec2(-0.9238795);
					CIRC_VERTS_16[28] = vec2(0.7071068);
					CIRC_VERTS_16[29] = vec2(-0.7071068);
					CIRC_VERTS_16[30] = vec2(0.9238795);
					CIRC_VERTS_16[31] = vec2(-0.3826834);
					CIRC_VERTS_16[32] = vec2(1);
					CIRC_VERTS_16[33] = vec2(0);
					unity_MatrixMVP = (unity_MatrixVP * unity_ObjectToWorld);
					unity_MatrixMV = (unity_MatrixV * unity_ObjectToWorld);
					unity_MatrixTMV = xll_transpose_mf4x4(unity_MatrixMV);
					unity_MatrixITMV = xll_transpose_mf4x4((unity_WorldToObject * unity_MatrixInvV));
					    v2f xl_retval;
					    appdata xlt_v;
					    xlt_v.vertex = vec4(gl_Vertex);
					    xlt_v.uv = vec2(gl_MultiTexCoord0);
					    xl_retval = vert( xlt_v);
					    xlv_TEXCOORD0 = vec2(xl_retval.uv);
					    gl_Position = vec4(xl_retval.vertex);
					}
					/* HLSL2GLSL - NOTE: GLSL optimization failed
					(128,1): error: array index must be < 4
					(129,1): error: array index must be < 4
					(130,1): error: array index must be < 4
					(131,1): error: array index must be < 4
					(137,1): error: array index must be < 5
					(138,1): error: array index must be < 5
					(139,1): error: array index must be < 5
					(140,1): error: array index must be < 5
					(141,1): error: array index must be < 5
					(147,1): error: array index must be < 5
					(148,1): error: array index must be < 5
					(149,1): error: array index must be < 5
					(150,1): error: array index must be < 5
					(151,1): error: array index must be < 5
					(159,1): error: array index must be < 7
					(160,1): error: array index must be < 7
					(161,1): error: array index must be < 7
					(162,1): error: array index must be < 7
					(163,1): error: array index must be < 7
					(164,1): error: array index must be < 7
					(165,1): error: array index must be < 7
					(175,1): error: array index must be < 9
					(176,1): error: array index must be < 9
					(177,1): error: array index must be < 9
					(178,1): error: array index must be < 9
					(179,1): error: array index must be < 9
					(180,1): error: array index must be < 9
					(181,1): error: array index must be < 9
					(182,1): error: array index must be < 9
					(183,1): error: array index must be < 9
					(201,1): error: array index must be < 17
					(202,1): error: array index must be < 17
					(203,1): error: array index must be < 17
					(204,1): error: array index must be < 17
					(205,1): error: array index must be < 17
					(206,1): error: array index must be < 17
					(207,1): error: array index must be < 17
					(208,1): error: array index must be < 17
					(209,1): error: array index must be < 17
					(210,1): error: array index must be < 17
					(211,1): error: array index must be < 17
					(212,1): error: array index must be < 17
					(213,1): error: array index must be < 17
					(214,1): error: array index must be < 17
					(215,1): error: array index must be < 17
					(216,1): error: array index must be < 17
					(217,1): error: array index must be < 17
					*/
					
					#endif
					#ifdef FRAGMENT
					#ifndef SHADER_TARGET
					    #define SHADER_TARGET 25
					#endif
					#ifndef SHADER_REQUIRE_DERIVATIVES
					    #define SHADER_REQUIRE_DERIVATIVES 1
					#endif
					#ifndef UNITY_NO_DXT5nm
					    #define UNITY_NO_DXT5nm 1
					#endif
					#ifndef UNITY_NO_RGBM
					    #define UNITY_NO_RGBM 1
					#endif
					#ifndef UNITY_ENABLE_REFLECTION_BUFFERS
					    #define UNITY_ENABLE_REFLECTION_BUFFERS 1
					#endif
					#ifndef UNITY_FRAMEBUFFER_FETCH_AVAILABLE
					    #define UNITY_FRAMEBUFFER_FETCH_AVAILABLE 1
					#endif
					#ifndef UNITY_NO_CUBEMAP_ARRAY
					    #define UNITY_NO_CUBEMAP_ARRAY 1
					#endif
					#ifndef UNITY_NO_SCREENSPACE_SHADOWS
					    #define UNITY_NO_SCREENSPACE_SHADOWS 1
					#endif
					#ifndef UNITY_PBS_USE_BRDF2
					    #define UNITY_PBS_USE_BRDF2 1
					#endif
					#ifndef SHADER_API_MOBILE
					    #define SHADER_API_MOBILE 1
					#endif
					#ifndef UNITY_HARDWARE_TIER3
					    #define UNITY_HARDWARE_TIER3 1
					#endif
					#ifndef UNITY_COLORSPACE_GAMMA
					    #define UNITY_COLORSPACE_GAMMA 1
					#endif
					#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
					    #define UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS 1
					#endif
					#ifndef UNITY_LIGHTMAP_DLDR_ENCODING
					    #define UNITY_LIGHTMAP_DLDR_ENCODING 1
					#endif
					#ifndef UNITY_VERSION
					    #define UNITY_VERSION 201841
					#endif
					#ifndef SHADER_STAGE_VERTEX
					    #define SHADER_STAGE_VERTEX 1
					#endif
					#ifndef SHADER_TARGET_AVAILABLE
					    #define SHADER_TARGET_AVAILABLE 25
					#endif
					#ifndef SHADER_AVAILABLE_DERIVATIVES
					    #define SHADER_AVAILABLE_DERIVATIVES 1
					#endif
					#ifndef SHADER_AVAILABLE_FRAGCOORD
					    #define SHADER_AVAILABLE_FRAGCOORD 1
					#endif
					#ifndef SHADER_API_GLES
					    #define SHADER_API_GLES 1
					#endif
					float xll_mod_f_f( float x, float y ) {
					  float d = x / y;
					  float f = fract (abs(d)) * y;
					  return d >= 0.0 ? f : -f;
					}
					vec2 xll_mod_vf2_vf2( vec2 x, vec2 y ) {
					  vec2 d = x / y;
					  vec2 f = fract (abs(d)) * y;
					  return vec2 (d.x >= 0.0 ? f.x : -f.x, d.y >= 0.0 ? f.y : -f.y);
					}
					vec3 xll_mod_vf3_vf3( vec3 x, vec3 y ) {
					  vec3 d = x / y;
					  vec3 f = fract (abs(d)) * y;
					  return vec3 (d.x >= 0.0 ? f.x : -f.x, d.y >= 0.0 ? f.y : -f.y, d.z >= 0.0 ? f.z : -f.z);
					}
					vec4 xll_mod_vf4_vf4( vec4 x, vec4 y ) {
					  vec4 d = x / y;
					  vec4 f = fract (abs(d)) * y;
					  return vec4 (d.x >= 0.0 ? f.x : -f.x, d.y >= 0.0 ? f.y : -f.y, d.z >= 0.0 ? f.z : -f.z, d.w >= 0.0 ? f.w : -f.w);
					}
					mat2 xll_transpose_mf2x2(mat2 m) {
					  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
					}
					mat3 xll_transpose_mf3x3(mat3 m) {
					  return mat3( m[0][0], m[1][0], m[2][0],
					               m[0][1], m[1][1], m[2][1],
					               m[0][2], m[1][2], m[2][2]);
					}
					mat4 xll_transpose_mf4x4(mat4 m) {
					  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
					               m[0][1], m[1][1], m[2][1], m[3][1],
					               m[0][2], m[1][2], m[2][2], m[3][2],
					               m[0][3], m[1][3], m[2][3], m[3][3]);
					}
					float xll_saturate_f( float x) {
					  return clamp( x, 0.0, 1.0);
					}
					vec2 xll_saturate_vf2( vec2 x) {
					  return clamp( x, 0.0, 1.0);
					}
					vec3 xll_saturate_vf3( vec3 x) {
					  return clamp( x, 0.0, 1.0);
					}
					vec4 xll_saturate_vf4( vec4 x) {
					  return clamp( x, 0.0, 1.0);
					}
					mat2 xll_saturate_mf2x2(mat2 m) {
					  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
					}
					mat3 xll_saturate_mf3x3(mat3 m) {
					  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
					}
					mat4 xll_saturate_mf4x4(mat4 m) {
					  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
					}
					float xll_round_f (float x) { return floor (x+0.5); }
					vec2 xll_round_vf2 (vec2 x) { return floor (x+vec2(0.5)); }
					vec3 xll_round_vf3 (vec3 x) { return floor (x+vec3(0.5)); }
					vec4 xll_round_vf4 (vec4 x) { return floor (x+vec4(0.5)); }
					#line 447
					struct v2f_vertex_lit {
					    highp vec2 uv;
					    lowp vec4 diff;
					    lowp vec4 spec;
					};
					#line 756
					struct v2f_img {
					    highp vec4 pos;
					    mediump vec2 uv;
					};
					#line 749
					struct appdata_img {
					    highp vec4 vertex;
					    mediump vec2 texcoord;
					};
					#line 193
					struct PointRelationship {
					    highp float dist;
					    highp float angle;
					};
					#line 88
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 83
					struct appdata {
					    highp vec4 vertex;
					    highp vec2 uv;
					};
					#line 40
					uniform highp vec4 _Time;
					uniform highp vec4 _SinTime;
					uniform highp vec4 _CosTime;
					uniform highp vec4 unity_DeltaTime;
					#line 46
					uniform highp vec3 _WorldSpaceCameraPos;
					#line 53
					uniform highp vec4 _ProjectionParams;
					#line 59
					uniform highp vec4 _ScreenParams;
					#line 71
					uniform highp vec4 _ZBufferParams;
					#line 77
					uniform highp vec4 unity_OrthoParams;
					#line 86
					uniform highp vec4 unity_CameraWorldClipPlanes[6];
					#line 92
					uniform highp mat4 unity_CameraProjection;
					uniform highp mat4 unity_CameraInvProjection;
					uniform highp mat4 unity_WorldToCamera;
					uniform highp mat4 unity_CameraToWorld;
					#line 108
					uniform highp vec4 _WorldSpaceLightPos0;
					uniform highp vec4 _LightPositionRange;
					#line 112
					uniform highp vec4 _LightProjectionParams;
					uniform highp vec4 unity_4LightPosX0;
					uniform highp vec4 unity_4LightPosY0;
					#line 116
					uniform highp vec4 unity_4LightPosZ0;
					uniform mediump vec4 unity_4LightAtten0;
					uniform mediump vec4 unity_LightColor[8];
					#line 122
					uniform highp vec4 unity_LightPosition[8];
					#line 127
					uniform mediump vec4 unity_LightAtten[8];
					uniform highp vec4 unity_SpotDirection[8];
					#line 131
					uniform mediump vec4 unity_SHAr;
					uniform mediump vec4 unity_SHAg;
					uniform mediump vec4 unity_SHAb;
					uniform mediump vec4 unity_SHBr;
					#line 135
					uniform mediump vec4 unity_SHBg;
					uniform mediump vec4 unity_SHBb;
					uniform mediump vec4 unity_SHC;
					#line 140
					uniform lowp vec4 unity_OcclusionMaskSelector;
					uniform lowp vec4 unity_ProbesOcclusion;
					#line 145
					uniform mediump vec3 unity_LightColor0;
					uniform mediump vec3 unity_LightColor1;
					uniform mediump vec3 unity_LightColor2;
					uniform mediump vec3 unity_LightColor3;
					#line 152
					uniform highp vec4 unity_ShadowSplitSpheres[4];
					uniform highp vec4 unity_ShadowSplitSqRadii;
					uniform highp vec4 unity_LightShadowBias;
					uniform highp vec4 _LightSplitsNear;
					#line 156
					uniform highp vec4 _LightSplitsFar;
					uniform highp mat4 unity_WorldToShadow[4];
					uniform mediump vec4 _LightShadowData;
					uniform highp vec4 unity_ShadowFadeCenterAndType;
					#line 165
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_WorldToObject;
					uniform highp vec4 unity_LODFade;
					uniform highp vec4 unity_WorldTransformParams;
					#line 206
					uniform highp mat4 glstate_matrix_transpose_modelview0;
					#line 214
					uniform lowp vec4 glstate_lightmodel_ambient;
					uniform lowp vec4 unity_AmbientSky;
					uniform lowp vec4 unity_AmbientEquator;
					uniform lowp vec4 unity_AmbientGround;
					#line 218
					uniform lowp vec4 unity_IndirectSpecColor;
					uniform highp mat4 glstate_matrix_projection;
					#line 222
					uniform highp mat4 unity_MatrixV;
					uniform highp mat4 unity_MatrixInvV;
					uniform highp mat4 unity_MatrixVP;
					uniform highp int unity_StereoEyeIndex;
					#line 228
					uniform lowp vec4 unity_ShadowColor;
					#line 235
					uniform lowp vec4 unity_FogColor;
					#line 240
					uniform highp vec4 unity_FogParams;
					#line 248
					uniform mediump sampler2D unity_Lightmap;
					uniform mediump sampler2D unity_LightmapInd;
					#line 252
					uniform sampler2D unity_ShadowMask;
					uniform sampler2D unity_DynamicLightmap;
					#line 256
					uniform sampler2D unity_DynamicDirectionality;
					uniform sampler2D unity_DynamicNormal;
					#line 260
					uniform highp vec4 unity_LightmapST;
					uniform highp vec4 unity_DynamicLightmapST;
					#line 268
					uniform samplerCube unity_SpecCube0;
					uniform samplerCube unity_SpecCube1;
					#line 272
					uniform highp vec4 unity_SpecCube0_BoxMax;
					uniform highp vec4 unity_SpecCube0_BoxMin;
					uniform highp vec4 unity_SpecCube0_ProbePosition;
					uniform mediump vec4 unity_SpecCube0_HDR;
					#line 277
					uniform highp vec4 unity_SpecCube1_BoxMax;
					uniform highp vec4 unity_SpecCube1_BoxMin;
					uniform highp vec4 unity_SpecCube1_ProbePosition;
					uniform mediump vec4 unity_SpecCube1_HDR;
					#line 317
					highp mat4 unity_MatrixMVP;
					highp mat4 unity_MatrixMV;
					highp mat4 unity_MatrixTMV;
					highp mat4 unity_MatrixITMV;
					#line 8
					#line 30
					#line 44
					#line 84
					#line 93
					#line 103
					#line 112
					#line 124
					#line 135
					#line 141
					#line 147
					#line 151
					#line 157
					#line 163
					#line 169
					#line 175
					#line 186
					#line 201
					#line 208
					#line 223
					#line 230
					#line 237
					#line 255
					#line 291
					#line 320
					#line 326
					#line 339
					#line 357
					#line 373
					#line 427
					#line 453
					#line 464
					#line 473
					#line 480
					#line 485
					#line 502
					#line 522
					#line 537
					#line 543
					#line 554
					uniform mediump vec4 unity_Lightmap_HDR;
					uniform mediump vec4 unity_DynamicLightmap_HDR;
					#line 568
					#line 578
					#line 593
					#line 602
					#line 609
					#line 618
					#line 626
					#line 635
					#line 654
					#line 660
					#line 670
					#line 680
					#line 691
					#line 696
					#line 702
					#line 707
					#line 764
					#line 770
					#line 785
					#line 816
					#line 830
					#line 834
					#line 840
					#line 849
					#line 859
					#line 885
					#line 891
					#line 18
					uniform highp float _Visibility;
					uniform highp vec3 _FocalPointPosition;
					#line 22
					uniform highp float _FocalPointRange;
					uniform highp float _FocalPointRadius;
					uniform highp float _FocalPointFadePower;
					#line 27
					uniform highp float _GridScale;
					uniform highp float _GeometryEdgeFadeWidth;
					#line 31
					uniform highp vec4 _GridColorBase;
					uniform highp vec4 _GridColorFocalPoint;
					uniform highp float _ColorMixFocalPoint;
					uniform highp vec4 _GridColorEdge;
					#line 35
					uniform highp float _ColorMixEdge;
					uniform highp float _CellScale;
					#line 39
					uniform highp float _ScaleFocalPoint;
					uniform highp float _ScaleFocalPointMix;
					uniform highp float _ScaleEdge;
					uniform highp float _ScaleEdgeMix;
					#line 45
					uniform highp float _CellFill;
					uniform highp float _CellFillFocalPoint;
					uniform highp float _CellFillMixFocalPoint;
					uniform highp float _CellFillEdge;
					#line 49
					uniform highp float _CellFillMixEdge;
					uniform highp float _OccludeCornerBase;
					#line 53
					uniform highp float _CellCornerOccludeFocalPoint;
					uniform highp float _CellCornerOccludeMixFocalPoint;
					uniform highp float _CellCornerOccludeEdge;
					uniform highp float _CellCornerOccludeMixEdge;
					#line 59
					uniform highp float _OccludeEdgeBase;
					uniform highp float _CellEdgeOccludeFocalPoint;
					uniform highp float _CellEdgeOccludeMixFocalPoint;
					uniform highp float _CellEdgeOccludeEdge;
					#line 63
					uniform highp float _CellEdgeOccludeMixEdge;
					uniform sampler2D _PerimeterDist;
					uniform highp vec4 _Bounds;
					#line 70
					uniform highp vec4 _Extents;
					uniform highp float _NumVerts;
					#line 74
					uniform highp vec4 _PerimeterVerts[128];
					#line 79
					const highp float HALF_SQRT3 = 0.8660254;
					const highp float SQRT2 = 1.414214;
					const highp float INV_SQRT2 = 0.7071068;
					const highp float SQRT3 = 1.732051;
					#line 83
					const highp float THIRD_PI = 1.047198;
					const highp float HALF_PI = 1.570796;
					const highp float PI = 3.141593;
					const highp float TAU = 6.283185;
					#line 87
					const highp float COS_PI_OVER_8 = 0.9238795;
					const highp float SIN_PI_OVER_8 = 0.3826834;
					highp float TAU_3[3];
					#line 96
					highp float TAU_4[4];
					#line 103
					highp float TAU_6[6];
					#line 112
					highp float TAU_8[8];
					#line 125
					highp vec2 CIRC_VERTS_3[4];
					#line 132
					highp vec2 CIRC_VERTS_4_45[5];
					#line 140
					highp vec2 CIRC_VERTS_4[5];
					#line 148
					highp vec2 CIRC_VERTS_6[7];
					#line 158
					highp vec2 CIRC_VERTS_8[9];
					#line 170
					highp vec2 CIRC_VERTS_16[17];
					#line 201
					#line 215
					#line 224
					#line 285
					#line 292
					#line 298
					#line 307
					#line 93
					#line 101
					#line 224
					highp vec3 Barycentric( in highp vec3 P, in highp vec3 A, in highp vec3 B, in highp vec3 C ) {
					    highp vec3 v0 = (C - A);
					    #line 228
					    highp vec3 v1 = (B - A);
					    highp vec3 v2 = (P - A);
					    #line 232
					    highp float dot00 = dot( v0, v0);
					    highp float dot01 = dot( v0, v1);
					    highp float dot02 = dot( v0, v2);
					    highp float dot11 = dot( v1, v1);
					    #line 236
					    highp float dot12 = dot( v1, v2);
					    highp float invDenom = (1.0 / ((dot00 * dot11) - (dot01 * dot01)));
					    #line 240
					    highp vec3 bary;
					    bary.x = (((dot11 * dot02) - (dot01 * dot12)) * invDenom);
					    bary.y = (((dot00 * dot12) - (dot01 * dot02)) * invDenom);
					    bary.z = ((1.0 - bary.x) - bary.y);
					    #line 244
					    return bary;
					}
					#line 247
					highp float IsInside( in highp vec3 baryCoords ) {
					    #line 248
					    return ((xll_saturate_f((10000.0 * baryCoords.x)) * xll_saturate_f((10000.0 * baryCoords.y))) * xll_saturate_f((10000.0 * (1.0 - (baryCoords.x + baryCoords.y)))));
					}
					#line 101
					lowp vec4 frag( in v2f i ) {
					    lowp vec4 col = _GridColorBase;
					    highp vec3 uv = vec3( i.uv.x, _FocalPointPosition.y, i.uv.y);
					    #line 110
					    lowp vec2 cellXY = (xll_round_vf2((i.uv / _GridScale)) * _GridScale);
					    lowp vec3 cellCP = vec3( cellXY.x, _FocalPointPosition.y, cellXY.y);
					    lowp float distFromCP = distance( uv, cellCP);
					    #line 118
					    PointRelationship perimeterRelationship;
					    highp vec2 localUV = vec2( ((cellCP.x - _Bounds.x) / _Bounds.z), ((cellCP.z - _Bounds.y) / _Bounds.w));
					    #line 124
					    perimeterRelationship.dist = float( ((texture2D( _PerimeterDist, localUV) * _Bounds.z) * 0.5));
					    #line 129
					    lowp float edgeEffect = (1.0 - xll_saturate_f((perimeterRelationship.dist / _GeometryEdgeFadeWidth)));
					    if ((perimeterRelationship.dist < (_GridScale / 2.0))){
					        #line 133
					        col.w = 0.0;
					        return col;
					    }
					    #line 138
					    PointRelationship focalPointRel;
					    focalPointRel.dist = distance( _FocalPointPosition, cellCP);
					    focalPointRel.angle = atan( (_FocalPointPosition.z - cellCP.z), (_FocalPointPosition.x - cellCP.x));
					    #line 142
					    lowp float focalPointEffect = xll_saturate_f((1.0 - (focalPointRel.dist / _FocalPointRadius)));
					    focalPointEffect = xll_saturate_f((1.0 - (abs((_FocalPointRadius - focalPointRel.dist)) / _FocalPointRange)));
					    focalPointEffect = pow( focalPointEffect, (1.0 / _FocalPointFadePower));
					    #line 150
					    lowp float cellScaleEdgeEffect = mix( _CellScale, _ScaleEdge, (_ScaleEdgeMix * edgeEffect));
					    lowp float cellScaleFPEffect = mix( _CellScale, _ScaleFocalPoint, (_ScaleFocalPointMix * focalPointEffect));
					    lowp float cellOuterRadius = ((((_GridScale * 0.5) * _CellScale) * cellScaleEdgeEffect) * cellScaleFPEffect);
					    #line 155
					    lowp float cellFillEdgeEffect = mix( _CellFill, _CellFillEdge, (_CellFillMixEdge * edgeEffect));
					    lowp float cellFillFPEffect = mix( _CellFill, _CellFillFocalPoint, (_CellFillMixFocalPoint * focalPointEffect));
					    lowp float cellInnerRadius = (cellOuterRadius * (1.0 - ((_CellFill / cellFillEdgeEffect) * cellFillFPEffect)));
					    #line 160
					    col = mix( _GridColorBase, _GridColorFocalPoint, vec4( (_ColorMixFocalPoint * focalPointEffect)));
					    col = mix( col, _GridColorEdge, vec4( (_ColorMixEdge * edgeEffect)));
					    #line 164
					    lowp float occludeEdgeThreshold = mix( _OccludeEdgeBase, _CellEdgeOccludeFocalPoint, (_CellEdgeOccludeMixFocalPoint * focalPointEffect));
					    occludeEdgeThreshold = mix( occludeEdgeThreshold, _CellEdgeOccludeEdge, (_CellEdgeOccludeMixEdge * edgeEffect));
					    #line 168
					    lowp float occludeCornerThreshold = mix( _OccludeCornerBase, _CellCornerOccludeFocalPoint, (_CellCornerOccludeMixFocalPoint * focalPointEffect));
					    occludeCornerThreshold = mix( occludeCornerThreshold, _CellCornerOccludeEdge, (_CellCornerOccludeMixEdge * edgeEffect));
					    #line 175
					    lowp vec3 cellOuterVerts[5];
					    lowp vec3 wedgeOuterVerts[3];
					    highp int cvi = 0;
					    for ( ; (cvi < 5); (cvi++)) {
					        cellOuterVerts[cvi].x = (cellCP.x + (cellOuterRadius * CIRC_VERTS_4[cvi].x));
					        #line 179
					        cellOuterVerts[cvi].y = cellCP.y;
					        cellOuterVerts[cvi].z = (cellCP.z + (cellOuterRadius * CIRC_VERTS_4[cvi].y));
					    }
					    #line 183
					    lowp vec3 baryCoords = vec3( 0.0, 0.0, 0.0);
					    lowp float wedgeVal = -1.0;
					    #line 187
					    lowp float value = 0.0;
					    highp int wi = 0;
					    for ( ; (wi < 4); (wi++)) {
					        lowp vec3 checkBaryCoords = Barycentric( uv, cellOuterVerts[wi], cellCP, cellOuterVerts[(wi + 1)]);
					        lowp float val = IsInside( checkBaryCoords);
					        #line 191
					        baryCoords += (val * checkBaryCoords);
					        wedgeVal += (val * (xll_mod_f_f( value, 4.0) + 1.0));
					        value += 1.0;
					    }
					    #line 197
					    lowp float bary0 = xll_saturate_f((10000.0 * (baryCoords.x - occludeCornerThreshold)));
					    lowp float bary1 = xll_saturate_f((10000.0 * (baryCoords.z - occludeCornerThreshold)));
					    lowp float bary2 = xll_saturate_f((10000.0 * ((baryCoords.x - baryCoords.z) - occludeEdgeThreshold)));
					    #line 201
					    lowp float bary3 = xll_saturate_f((10000.0 * ((baryCoords.z - baryCoords.x) - occludeEdgeThreshold)));
					    bary2 = xll_saturate_f((bary2 + bary3));
					    #line 205
					    bary3 = xll_saturate_f((10000.0 * ((cellFillFPEffect * cellFillEdgeEffect) - baryCoords.y)));
					    lowp float val0 = xll_saturate_f((10000.0 * abs((wedgeVal - 4.0))));
					    lowp float val1 = xll_saturate_f((10000.0 * abs((wedgeVal - -1.0))));
					    #line 210
					    col.w = (((((((col.w * val0) * val1) * bary0) * bary1) * bary2) * bary3) * _Visibility);
					    return col;
					}
					varying highp vec2 xlv_TEXCOORD0;
					void main() {
					TAU_3[0] = 2.094395;
					TAU_3[1] = 4.18879;
					TAU_3[2] = 6.283185;
					TAU_4[0] = 1.570796;
					TAU_4[1] = 3.141593;
					TAU_4[2] = 4.712389;
					TAU_4[3] = 6.283185;
					TAU_6[0] = 1.047198;
					TAU_6[1] = 2.094395;
					TAU_6[2] = 3.141593;
					TAU_6[3] = 4.18879;
					TAU_6[4] = 5.235988;
					TAU_6[5] = 6.283185;
					TAU_8[0] = 0.7853982;
					TAU_8[1] = 1.570796;
					TAU_8[2] = 2.356194;
					TAU_8[3] = 3.141593;
					TAU_8[4] = 3.926991;
					TAU_8[5] = 4.712389;
					TAU_8[6] = 5.497787;
					TAU_8[7] = 6.283185;
					CIRC_VERTS_3[0] = vec2(0);
					CIRC_VERTS_3[1] = vec2(-0.8660254);
					CIRC_VERTS_3[2] = vec2(1);
					CIRC_VERTS_3[3] = vec2(0.8660254);
					CIRC_VERTS_3[4] = vec2(-1);
					CIRC_VERTS_3[5] = vec2(0.8660254);
					CIRC_VERTS_3[6] = vec2(0);
					CIRC_VERTS_3[7] = vec2(-0.8660254);
					CIRC_VERTS_4_45[0] = vec2(1);
					CIRC_VERTS_4_45[1] = vec2(0);
					CIRC_VERTS_4_45[2] = vec2(-1);
					CIRC_VERTS_4_45[3] = vec2(0);
					CIRC_VERTS_4_45[4] = vec2(-1);
					CIRC_VERTS_4_45[5] = vec2(-1);
					CIRC_VERTS_4_45[6] = vec2(-1);
					CIRC_VERTS_4_45[7] = vec2(0);
					CIRC_VERTS_4_45[8] = vec2(1);
					CIRC_VERTS_4_45[9] = vec2(0);
					CIRC_VERTS_4[0] = vec2(0.7071068);
					CIRC_VERTS_4[1] = vec2(0.7071068);
					CIRC_VERTS_4[2] = vec2(-0.7071068);
					CIRC_VERTS_4[3] = vec2(0.7071068);
					CIRC_VERTS_4[4] = vec2(-0.7071068);
					CIRC_VERTS_4[5] = vec2(-0.7071068);
					CIRC_VERTS_4[6] = vec2(0.7071068);
					CIRC_VERTS_4[7] = vec2(-0.7071068);
					CIRC_VERTS_4[8] = vec2(0.7071068);
					CIRC_VERTS_4[9] = vec2(0.7071068);
					CIRC_VERTS_6[0] = vec2(0.8660254);
					CIRC_VERTS_6[1] = vec2(0.5);
					CIRC_VERTS_6[2] = vec2(0);
					CIRC_VERTS_6[3] = vec2(1);
					CIRC_VERTS_6[4] = vec2(-0.8660254);
					CIRC_VERTS_6[5] = vec2(0.5);
					CIRC_VERTS_6[6] = vec2(-0.8660254);
					CIRC_VERTS_6[7] = vec2(-0.5);
					CIRC_VERTS_6[8] = vec2(0);
					CIRC_VERTS_6[9] = vec2(-1);
					CIRC_VERTS_6[10] = vec2(0.8660254);
					CIRC_VERTS_6[11] = vec2(-0.5);
					CIRC_VERTS_6[12] = vec2(0.8660254);
					CIRC_VERTS_6[13] = vec2(0.5);
					CIRC_VERTS_8[0] = vec2(1);
					CIRC_VERTS_8[1] = vec2(0);
					CIRC_VERTS_8[2] = vec2(0.7071068);
					CIRC_VERTS_8[3] = vec2(0.7071068);
					CIRC_VERTS_8[4] = vec2(0);
					CIRC_VERTS_8[5] = vec2(1);
					CIRC_VERTS_8[6] = vec2(-0.7071068);
					CIRC_VERTS_8[7] = vec2(0.7071068);
					CIRC_VERTS_8[8] = vec2(-1);
					CIRC_VERTS_8[9] = vec2(0);
					CIRC_VERTS_8[10] = vec2(-0.7071068);
					CIRC_VERTS_8[11] = vec2(-0.7071068);
					CIRC_VERTS_8[12] = vec2(0);
					CIRC_VERTS_8[13] = vec2(-1);
					CIRC_VERTS_8[14] = vec2(0.7071068);
					CIRC_VERTS_8[15] = vec2(-0.7071068);
					CIRC_VERTS_8[16] = vec2(1);
					CIRC_VERTS_8[17] = vec2(0);
					CIRC_VERTS_16[0] = vec2(1);
					CIRC_VERTS_16[1] = vec2(0);
					CIRC_VERTS_16[2] = vec2(0.9238795);
					CIRC_VERTS_16[3] = vec2(0.3826834);
					CIRC_VERTS_16[4] = vec2(0.7071068);
					CIRC_VERTS_16[5] = vec2(0.7071068);
					CIRC_VERTS_16[6] = vec2(0.3826834);
					CIRC_VERTS_16[7] = vec2(0.9238795);
					CIRC_VERTS_16[8] = vec2(0);
					CIRC_VERTS_16[9] = vec2(1);
					CIRC_VERTS_16[10] = vec2(-0.3826834);
					CIRC_VERTS_16[11] = vec2(0.9238795);
					CIRC_VERTS_16[12] = vec2(-0.7071068);
					CIRC_VERTS_16[13] = vec2(0.7071068);
					CIRC_VERTS_16[14] = vec2(-0.9238795);
					CIRC_VERTS_16[15] = vec2(0.3826834);
					CIRC_VERTS_16[16] = vec2(-1);
					CIRC_VERTS_16[17] = vec2(0);
					CIRC_VERTS_16[18] = vec2(-0.9238795);
					CIRC_VERTS_16[19] = vec2(-0.3826834);
					CIRC_VERTS_16[20] = vec2(-0.7071068);
					CIRC_VERTS_16[21] = vec2(-0.7071068);
					CIRC_VERTS_16[22] = vec2(-0.3826834);
					CIRC_VERTS_16[23] = vec2(-0.9238795);
					CIRC_VERTS_16[24] = vec2(0);
					CIRC_VERTS_16[25] = vec2(-1);
					CIRC_VERTS_16[26] = vec2(0.3826834);
					CIRC_VERTS_16[27] = vec2(-0.9238795);
					CIRC_VERTS_16[28] = vec2(0.7071068);
					CIRC_VERTS_16[29] = vec2(-0.7071068);
					CIRC_VERTS_16[30] = vec2(0.9238795);
					CIRC_VERTS_16[31] = vec2(-0.3826834);
					CIRC_VERTS_16[32] = vec2(1);
					CIRC_VERTS_16[33] = vec2(0);
					unity_MatrixMVP = (unity_MatrixVP * unity_ObjectToWorld);
					unity_MatrixMV = (unity_MatrixV * unity_ObjectToWorld);
					unity_MatrixTMV = xll_transpose_mf4x4(unity_MatrixMV);
					unity_MatrixITMV = xll_transpose_mf4x4((unity_WorldToObject * unity_MatrixInvV));
					    lowp vec4 xl_retval;
					    v2f xlt_i;
					    xlt_i.uv = vec2(xlv_TEXCOORD0);
					    xlt_i.vertex = vec4(0.0);
					    xl_retval = frag( xlt_i);
					    gl_FragData[0] = vec4(xl_retval);
					}
					/* HLSL2GLSL - NOTE: GLSL optimization failed
					(241,1): error: array index must be < 4
					(242,1): error: array index must be < 4
					(243,1): error: array index must be < 4
					(244,1): error: array index must be < 4
					(250,1): error: array index must be < 5
					(251,1): error: array index must be < 5
					(252,1): error: array index must be < 5
					(253,1): error: array index must be < 5
					(254,1): error: array index must be < 5
					(260,1): error: array index must be < 5
					(261,1): error: array index must be < 5
					(262,1): error: array index must be < 5
					(263,1): error: array index must be < 5
					(264,1): error: array index must be < 5
					(272,1): error: array index must be < 7
					(273,1): error: array index must be < 7
					(274,1): error: array index must be < 7
					(275,1): error: array index must be < 7
					(276,1): error: array index must be < 7
					(277,1): error: array index must be < 7
					(278,1): error: array index must be < 7
					(288,1): error: array index must be < 9
					(289,1): error: array index must be < 9
					(290,1): error: array index must be < 9
					(291,1): error: array index must be < 9
					(292,1): error: array index must be < 9
					(293,1): error: array index must be < 9
					(294,1): error: array index must be < 9
					(295,1): error: array index must be < 9
					(296,1): error: array index must be < 9
					(314,1): error: array index must be < 17
					(315,1): error: array index must be < 17
					(316,1): error: array index must be < 17
					(317,1): error: array index must be < 17
					(318,1): error: array index must be < 17
					(319,1): error: array index must be < 17
					(320,1): error: array index must be < 17
					(321,1): error: array index must be < 17
					(322,1): error: array index must be < 17
					(323,1): error: array index must be < 17
					(324,1): error: array index must be < 17
					(325,1): error: array index must be < 17
					(326,1): error: array index must be < 17
					(327,1): error: array index must be < 17
					(328,1): error: array index must be < 17
					(329,1): error: array index must be < 17
					(330,1): error: array index must be < 17
					*/
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    vs_TEXCOORD0.xy = hlslcc_mtx4x4unity_ObjectToWorld[3].xz * in_POSITION0.ww + u_xlat0.xz;
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
					uniform 	float _Visibility;
					uniform 	vec3 _FocalPointPosition;
					uniform 	float _FocalPointRange;
					uniform 	float _FocalPointRadius;
					uniform 	float _FocalPointFadePower;
					uniform 	float _GridScale;
					uniform 	float _GeometryEdgeFadeWidth;
					uniform 	vec4 _GridColorBase;
					uniform 	vec4 _GridColorFocalPoint;
					uniform 	float _ColorMixFocalPoint;
					uniform 	vec4 _GridColorEdge;
					uniform 	float _ColorMixEdge;
					uniform 	float _CellScale;
					uniform 	float _ScaleFocalPoint;
					uniform 	float _ScaleFocalPointMix;
					uniform 	float _ScaleEdge;
					uniform 	float _ScaleEdgeMix;
					uniform 	float _CellFill;
					uniform 	float _CellFillFocalPoint;
					uniform 	float _CellFillMixFocalPoint;
					uniform 	float _CellFillEdge;
					uniform 	float _CellFillMixEdge;
					uniform 	float _OccludeCornerBase;
					uniform 	float _CellCornerOccludeFocalPoint;
					uniform 	float _CellCornerOccludeMixFocalPoint;
					uniform 	float _CellCornerOccludeEdge;
					uniform 	float _CellCornerOccludeMixEdge;
					uniform 	float _OccludeEdgeBase;
					uniform 	float _CellEdgeOccludeFocalPoint;
					uniform 	float _CellEdgeOccludeMixFocalPoint;
					uniform 	float _CellEdgeOccludeEdge;
					uniform 	float _CellEdgeOccludeMixEdge;
					uniform 	vec4 _Bounds;
					uniform lowp sampler2D _PerimeterDist;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec2 u_xlat2;
					bool u_xlatb2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec3 u_xlat7;
					vec3 u_xlat8;
					mediump vec4 u_xlat16_9;
					vec3 u_xlat10;
					mediump vec2 u_xlat16_11;
					vec3 u_xlat12;
					vec3 u_xlat13;
					float u_xlat14;
					float u_xlat16;
					float u_xlat17;
					mediump vec3 u_xlat16_21;
					float u_xlat24;
					vec2 u_xlat25;
					lowp float u_xlat10_25;
					float u_xlat26;
					vec2 u_xlat29;
					vec2 u_xlat31;
					mediump float u_xlat16_33;
					float u_xlat36;
					float u_xlat37;
					float u_xlat38;
					void main()
					{
					    u_xlat0 = vs_TEXCOORD0.xyxy / vec4(vec4(_GridScale, _GridScale, _GridScale, _GridScale));
					    u_xlat0 = roundEven(u_xlat0);
					    u_xlat1.xy = vec2(u_xlat0.z * float(_GridScale), u_xlat0.w * float(_GridScale));
					    u_xlat25.xy = u_xlat0.zw * vec2(vec2(_GridScale, _GridScale)) + (-_Bounds.xy);
					    u_xlat25.xy = vec2(u_xlat25.x / _Bounds.z, u_xlat25.y / _Bounds.w);
					    u_xlat10_25 = texture(_PerimeterDist, u_xlat25.xy).x;
					    u_xlat25.x = u_xlat10_25 * _Bounds.z;
					    u_xlat25.x = u_xlat25.x * 0.5;
					    u_xlat37 = _GridScale * 0.5;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb2 = !!(u_xlat25.x<u_xlat37);
					#else
					    u_xlatb2 = u_xlat25.x<u_xlat37;
					#endif
					    if(u_xlatb2){
					        SV_Target0.xyz = _GridColorBase.xyz;
					        SV_Target0.w = 0.0;
					        return;
					    //ENDIF
					    }
					    u_xlat25.x = u_xlat25.x / _GeometryEdgeFadeWidth;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat25.x = min(max(u_xlat25.x, 0.0), 1.0);
					#else
					    u_xlat25.x = clamp(u_xlat25.x, 0.0, 1.0);
					#endif
					    u_xlat25.x = (-u_xlat25.x) + 1.0;
					    u_xlat2.xy = (-u_xlat0.zw) * vec2(vec2(_GridScale, _GridScale)) + vec2(_FocalPointPosition.x, _FocalPointPosition.z);
					    u_xlat2.x = dot(u_xlat2.xy, u_xlat2.xy);
					    u_xlat2.x = sqrt(u_xlat2.x);
					    u_xlat2.x = (-u_xlat2.x) + _FocalPointRadius;
					    u_xlat2.x = abs(u_xlat2.x) / _FocalPointRange;
					    u_xlat2.x = (-u_xlat2.x) + 1.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.x = min(max(u_xlat2.x, 0.0), 1.0);
					#else
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					#endif
					    u_xlat14 = float(1.0) / _FocalPointFadePower;
					    u_xlat2.x = log2(u_xlat2.x);
					    u_xlat2.x = u_xlat2.x * u_xlat14;
					    u_xlat2.x = exp2(u_xlat2.x);
					    u_xlat14 = u_xlat25.x * _ScaleEdgeMix;
					    u_xlat26 = (-_CellScale) + _ScaleEdge;
					    u_xlat14 = u_xlat14 * u_xlat26 + _CellScale;
					    u_xlat26 = u_xlat2.x * _ScaleFocalPointMix;
					    u_xlat38 = (-_CellScale) + _ScaleFocalPoint;
					    u_xlat26 = u_xlat26 * u_xlat38 + _CellScale;
					    u_xlat37 = u_xlat37 * _CellScale;
					    u_xlat37 = u_xlat14 * u_xlat37;
					    u_xlat37 = u_xlat26 * u_xlat37;
					    u_xlat14 = u_xlat25.x * _CellFillMixEdge;
					    u_xlat26 = (-_CellFill) + _CellFillEdge;
					    u_xlat14 = u_xlat14 * u_xlat26 + _CellFill;
					    u_xlat26 = u_xlat2.x * _CellFillMixFocalPoint;
					    u_xlat38 = (-_CellFill) + _CellFillFocalPoint;
					    u_xlat26 = u_xlat26 * u_xlat38 + _CellFill;
					    u_xlat38 = u_xlat2.x * _ColorMixFocalPoint;
					    u_xlat3 = (-_GridColorBase) + _GridColorFocalPoint;
					    u_xlat3 = vec4(u_xlat38) * u_xlat3 + _GridColorBase;
					    u_xlat38 = u_xlat25.x * _ColorMixEdge;
					    u_xlat4 = (-u_xlat3) + _GridColorEdge;
					    u_xlat3 = vec4(u_xlat38) * u_xlat4 + u_xlat3;
					    u_xlat38 = u_xlat2.x * _CellEdgeOccludeMixFocalPoint;
					    u_xlat4.x = (-_OccludeEdgeBase) + _CellEdgeOccludeFocalPoint;
					    u_xlat38 = u_xlat38 * u_xlat4.x + _OccludeEdgeBase;
					    u_xlat4.x = u_xlat25.x * _CellEdgeOccludeMixEdge;
					    u_xlat16 = (-u_xlat38) + _CellEdgeOccludeEdge;
					    u_xlat38 = u_xlat4.x * u_xlat16 + u_xlat38;
					    u_xlat2.x = u_xlat2.x * _CellCornerOccludeMixFocalPoint;
					    u_xlat4.x = (-_OccludeCornerBase) + _CellCornerOccludeFocalPoint;
					    u_xlat2.x = u_xlat2.x * u_xlat4.x + _OccludeCornerBase;
					    u_xlat25.x = u_xlat25.x * _CellCornerOccludeMixEdge;
					    u_xlat4.x = (-u_xlat2.x) + _CellCornerOccludeEdge;
					    u_xlat25.x = u_xlat25.x * u_xlat4.x + u_xlat2.x;
					    u_xlat4 = vec4(u_xlat37) * vec4(0.707106769, 0.707106769, -0.707106769, -0.707106769) + u_xlat1.xyxy;
					    u_xlat1.xy = vec2((-u_xlat4.x) + u_xlat4.z, (-u_xlat4.y) + u_xlat4.w);
					    u_xlat5 = u_xlat0.zwzw * vec4(vec4(_GridScale, _GridScale, _GridScale, _GridScale)) + (-u_xlat4.xyzy);
					    u_xlat6 = (-u_xlat4.xyzy) + vs_TEXCOORD0.xyxy;
					    u_xlat7.xy = u_xlat1.xy * u_xlat1.xy;
					    u_xlat31.xy = u_xlat1.xy * u_xlat5.xw;
					    u_xlat1.xy = u_xlat1.xy * u_xlat6.xw;
					    u_xlat37 = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat2.x = dot(u_xlat5.xy, u_xlat6.xy);
					    u_xlat5.xy = u_xlat31.xy * u_xlat31.xy;
					    u_xlat5.x = u_xlat7.x * u_xlat37 + (-u_xlat5.x);
					    u_xlat5.x = float(1.0) / u_xlat5.x;
					    u_xlat6.x = u_xlat2.x * u_xlat31.x;
					    u_xlat1.w = u_xlat37 * u_xlat1.x + (-u_xlat6.x);
					    u_xlat6.xy = u_xlat1.xy * u_xlat31.xy;
					    u_xlat1.x = u_xlat7.x * u_xlat2.x + (-u_xlat6.x);
					    u_xlat8.yz = u_xlat5.xx * u_xlat1.wx;
					    u_xlat2.x = (-u_xlat1.w) * u_xlat5.x + 1.0;
					    u_xlat8.x = (-u_xlat1.x) * u_xlat5.x + u_xlat2.x;
					    u_xlat7.xz = vec2(u_xlat8.y * float(10000.0), u_xlat8.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat7.xz = min(max(u_xlat7.xz, 0.0), 1.0);
					#else
					    u_xlat7.xz = clamp(u_xlat7.xz, 0.0, 1.0);
					#endif
					    u_xlat1.x = u_xlat7.z * u_xlat7.x;
					    u_xlat37 = u_xlat1.w * u_xlat5.x + u_xlat8.z;
					    u_xlat37 = (-u_xlat37) + 1.0;
					    u_xlat37 = u_xlat37 * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat37 = min(max(u_xlat37, 0.0), 1.0);
					#else
					    u_xlat37 = clamp(u_xlat37, 0.0, 1.0);
					#endif
					    u_xlat2.x = u_xlat37 * u_xlat1.x;
					    u_xlat16_9.x = u_xlat1.x * u_xlat37 + -1.0;
					    u_xlat1.x = dot(u_xlat5.zw, u_xlat5.zw);
					    u_xlat37 = dot(u_xlat5.zw, u_xlat6.zw);
					    u_xlat5.x = u_xlat7.y * u_xlat1.x + (-u_xlat5.y);
					    u_xlat5.x = float(1.0) / u_xlat5.x;
					    u_xlat17 = u_xlat37 * u_xlat31.y;
					    u_xlat1.x = u_xlat1.x * u_xlat1.y + (-u_xlat17);
					    u_xlat1.y = u_xlat7.y * u_xlat37 + (-u_xlat6.y);
					    u_xlat10.yz = u_xlat5.xx * u_xlat1.xy;
					    u_xlat37 = (-u_xlat1.x) * u_xlat5.x + 1.0;
					    u_xlat10.x = (-u_xlat1.y) * u_xlat5.x + u_xlat37;
					    u_xlat13.xz = vec2(u_xlat10.y * float(10000.0), u_xlat10.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat13.xz = min(max(u_xlat13.xz, 0.0), 1.0);
					#else
					    u_xlat13.xz = clamp(u_xlat13.xz, 0.0, 1.0);
					#endif
					    u_xlat13.x = u_xlat13.z * u_xlat13.x;
					    u_xlat1.x = u_xlat1.x * u_xlat5.x + u_xlat10.z;
					    u_xlat1.x = (-u_xlat1.x) + 1.0;
					    u_xlat1.x = u_xlat1.x * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    u_xlat1.x = u_xlat1.x * u_xlat13.x;
					    u_xlat16_21.xyz = u_xlat10.xyz * u_xlat1.xxx;
					    u_xlat16_21.xyz = u_xlat2.xxx * u_xlat8.xyz + u_xlat16_21.xyz;
					    u_xlat16_9.x = u_xlat1.x * 2.0 + u_xlat16_9.x;
					    u_xlat1.xy = vec2((-u_xlat4.z) + u_xlat4.x, (-u_xlat4.w) + u_xlat4.y);
					    u_xlat0 = u_xlat0 * vec4(vec4(_GridScale, _GridScale, _GridScale, _GridScale)) + (-u_xlat4.zwxw);
					    u_xlat4 = (-u_xlat4.zwxw) + vs_TEXCOORD0.xyxy;
					    u_xlat5.xy = u_xlat1.xy * u_xlat1.xy;
					    u_xlat29.xy = u_xlat0.xw * u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * u_xlat4.xw;
					    u_xlat37 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat0.x = dot(u_xlat0.xy, u_xlat4.xy);
					    u_xlat4.xy = u_xlat29.xy * u_xlat29.xy;
					    u_xlat12.x = u_xlat5.x * u_xlat37 + (-u_xlat4.x);
					    u_xlat12.x = float(1.0) / u_xlat12.x;
					    u_xlat2.x = u_xlat0.x * u_xlat29.x;
					    u_xlat37 = u_xlat37 * u_xlat1.x + (-u_xlat2.x);
					    u_xlat6.y = u_xlat12.x * u_xlat37;
					    u_xlat7.xy = u_xlat1.xy * u_xlat29.xy;
					    u_xlat0.x = u_xlat5.x * u_xlat0.x + (-u_xlat7.x);
					    u_xlat6.z = u_xlat12.x * u_xlat0.x;
					    u_xlat1.x = (-u_xlat37) * u_xlat12.x + 1.0;
					    u_xlat6.x = (-u_xlat0.x) * u_xlat12.x + u_xlat1.x;
					    u_xlat5.xz = vec2(u_xlat6.y * float(10000.0), u_xlat6.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat5.xz = min(max(u_xlat5.xz, 0.0), 1.0);
					#else
					    u_xlat5.xz = clamp(u_xlat5.xz, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat5.z * u_xlat5.x;
					    u_xlat12.x = u_xlat37 * u_xlat12.x + u_xlat6.z;
					    u_xlat12.x = (-u_xlat12.x) + 1.0;
					    u_xlat12.x = u_xlat12.x * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat12.x = min(max(u_xlat12.x, 0.0), 1.0);
					#else
					    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat12.x * u_xlat0.x;
					    u_xlat16_21.xyz = u_xlat0.xxx * u_xlat6.xyz + u_xlat16_21.xyz;
					    u_xlat16_9.x = u_xlat0.x * 3.0 + u_xlat16_9.x;
					    u_xlat0.x = dot(u_xlat0.zw, u_xlat0.zw);
					    u_xlat12.x = dot(u_xlat0.zw, u_xlat4.zw);
					    u_xlat24 = u_xlat5.y * u_xlat0.x + (-u_xlat4.y);
					    u_xlat24 = float(1.0) / u_xlat24;
					    u_xlat36 = u_xlat12.x * u_xlat29.y;
					    u_xlat0.x = u_xlat0.x * u_xlat1.y + (-u_xlat36);
					    u_xlat0.y = u_xlat5.y * u_xlat12.x + (-u_xlat7.y);
					    u_xlat4.yz = vec2(u_xlat24) * u_xlat0.xy;
					    u_xlat36 = (-u_xlat0.x) * u_xlat24 + 1.0;
					    u_xlat4.x = (-u_xlat0.y) * u_xlat24 + u_xlat36;
					    u_xlat12.xz = vec2(u_xlat4.y * float(10000.0), u_xlat4.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat12.xz = min(max(u_xlat12.xz, 0.0), 1.0);
					#else
					    u_xlat12.xz = clamp(u_xlat12.xz, 0.0, 1.0);
					#endif
					    u_xlat12.x = u_xlat12.z * u_xlat12.x;
					    u_xlat0.x = u_xlat0.x * u_xlat24 + u_xlat4.z;
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = u_xlat0.x * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
					#else
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat0.x * u_xlat12.x;
					    u_xlat16_21.xyz = u_xlat0.xxx * u_xlat4.xyz + u_xlat16_21.xyz;
					    u_xlat16_9.x = u_xlat0.x * 4.0 + u_xlat16_9.x;
					    u_xlat16_11.xy = (-u_xlat25.xx) + u_xlat16_21.yx;
					    u_xlat16_11.xy = u_xlat16_11.xy * vec2(10000.0, 10000.0);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_11.xy = min(max(u_xlat16_11.xy, 0.0), 1.0);
					#else
					    u_xlat16_11.xy = clamp(u_xlat16_11.xy, 0.0, 1.0);
					#endif
					    u_xlat16_21.xy = (-u_xlat16_21.xy) + u_xlat16_21.yx;
					    u_xlat16_21.xy = (-vec2(u_xlat38)) + u_xlat16_21.xy;
					    u_xlat16_21.xy = u_xlat16_21.xy * vec2(10000.0, 10000.0);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_21.xy = min(max(u_xlat16_21.xy, 0.0), 1.0);
					#else
					    u_xlat16_21.xy = clamp(u_xlat16_21.xy, 0.0, 1.0);
					#endif
					    u_xlat16_9.y = u_xlat16_21.y + u_xlat16_21.x;
					    u_xlat16_33 = u_xlat26 * u_xlat14 + (-u_xlat16_21.z);
					    u_xlat16_33 = u_xlat16_33 * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_33 = min(max(u_xlat16_33, 0.0), 1.0);
					#else
					    u_xlat16_33 = clamp(u_xlat16_33, 0.0, 1.0);
					#endif
					    u_xlat16_9.xw = u_xlat16_9.xx + vec2(-4.0, 1.0);
					    u_xlat16_9.x = abs(u_xlat16_9.x) * 10000.0;
					    u_xlat16_9.w = u_xlat16_9.w * 10000.0;
					    u_xlat16_9.xyw = min(u_xlat16_9.xyw, vec3(1.0, 1.0, 1.0));
					    u_xlat16_9.x = u_xlat3.w * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_9.w * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_11.x * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_11.y * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_9.y * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_33 * u_xlat16_9.x;
					    u_xlat3.w = u_xlat16_9.x * _Visibility;
					    SV_Target0 = u_xlat3;
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
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    vs_TEXCOORD0.xy = hlslcc_mtx4x4unity_ObjectToWorld[3].xz * in_POSITION0.ww + u_xlat0.xz;
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
					uniform 	float _Visibility;
					uniform 	vec3 _FocalPointPosition;
					uniform 	float _FocalPointRange;
					uniform 	float _FocalPointRadius;
					uniform 	float _FocalPointFadePower;
					uniform 	float _GridScale;
					uniform 	float _GeometryEdgeFadeWidth;
					uniform 	vec4 _GridColorBase;
					uniform 	vec4 _GridColorFocalPoint;
					uniform 	float _ColorMixFocalPoint;
					uniform 	vec4 _GridColorEdge;
					uniform 	float _ColorMixEdge;
					uniform 	float _CellScale;
					uniform 	float _ScaleFocalPoint;
					uniform 	float _ScaleFocalPointMix;
					uniform 	float _ScaleEdge;
					uniform 	float _ScaleEdgeMix;
					uniform 	float _CellFill;
					uniform 	float _CellFillFocalPoint;
					uniform 	float _CellFillMixFocalPoint;
					uniform 	float _CellFillEdge;
					uniform 	float _CellFillMixEdge;
					uniform 	float _OccludeCornerBase;
					uniform 	float _CellCornerOccludeFocalPoint;
					uniform 	float _CellCornerOccludeMixFocalPoint;
					uniform 	float _CellCornerOccludeEdge;
					uniform 	float _CellCornerOccludeMixEdge;
					uniform 	float _OccludeEdgeBase;
					uniform 	float _CellEdgeOccludeFocalPoint;
					uniform 	float _CellEdgeOccludeMixFocalPoint;
					uniform 	float _CellEdgeOccludeEdge;
					uniform 	float _CellEdgeOccludeMixEdge;
					uniform 	vec4 _Bounds;
					uniform lowp sampler2D _PerimeterDist;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec2 u_xlat2;
					bool u_xlatb2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec3 u_xlat7;
					vec3 u_xlat8;
					mediump vec4 u_xlat16_9;
					vec3 u_xlat10;
					mediump vec2 u_xlat16_11;
					vec3 u_xlat12;
					vec3 u_xlat13;
					float u_xlat14;
					float u_xlat16;
					float u_xlat17;
					mediump vec3 u_xlat16_21;
					float u_xlat24;
					vec2 u_xlat25;
					lowp float u_xlat10_25;
					float u_xlat26;
					vec2 u_xlat29;
					vec2 u_xlat31;
					mediump float u_xlat16_33;
					float u_xlat36;
					float u_xlat37;
					float u_xlat38;
					void main()
					{
					    u_xlat0 = vs_TEXCOORD0.xyxy / vec4(vec4(_GridScale, _GridScale, _GridScale, _GridScale));
					    u_xlat0 = roundEven(u_xlat0);
					    u_xlat1.xy = vec2(u_xlat0.z * float(_GridScale), u_xlat0.w * float(_GridScale));
					    u_xlat25.xy = u_xlat0.zw * vec2(vec2(_GridScale, _GridScale)) + (-_Bounds.xy);
					    u_xlat25.xy = vec2(u_xlat25.x / _Bounds.z, u_xlat25.y / _Bounds.w);
					    u_xlat10_25 = texture(_PerimeterDist, u_xlat25.xy).x;
					    u_xlat25.x = u_xlat10_25 * _Bounds.z;
					    u_xlat25.x = u_xlat25.x * 0.5;
					    u_xlat37 = _GridScale * 0.5;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb2 = !!(u_xlat25.x<u_xlat37);
					#else
					    u_xlatb2 = u_xlat25.x<u_xlat37;
					#endif
					    if(u_xlatb2){
					        SV_Target0.xyz = _GridColorBase.xyz;
					        SV_Target0.w = 0.0;
					        return;
					    //ENDIF
					    }
					    u_xlat25.x = u_xlat25.x / _GeometryEdgeFadeWidth;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat25.x = min(max(u_xlat25.x, 0.0), 1.0);
					#else
					    u_xlat25.x = clamp(u_xlat25.x, 0.0, 1.0);
					#endif
					    u_xlat25.x = (-u_xlat25.x) + 1.0;
					    u_xlat2.xy = (-u_xlat0.zw) * vec2(vec2(_GridScale, _GridScale)) + vec2(_FocalPointPosition.x, _FocalPointPosition.z);
					    u_xlat2.x = dot(u_xlat2.xy, u_xlat2.xy);
					    u_xlat2.x = sqrt(u_xlat2.x);
					    u_xlat2.x = (-u_xlat2.x) + _FocalPointRadius;
					    u_xlat2.x = abs(u_xlat2.x) / _FocalPointRange;
					    u_xlat2.x = (-u_xlat2.x) + 1.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.x = min(max(u_xlat2.x, 0.0), 1.0);
					#else
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					#endif
					    u_xlat14 = float(1.0) / _FocalPointFadePower;
					    u_xlat2.x = log2(u_xlat2.x);
					    u_xlat2.x = u_xlat2.x * u_xlat14;
					    u_xlat2.x = exp2(u_xlat2.x);
					    u_xlat14 = u_xlat25.x * _ScaleEdgeMix;
					    u_xlat26 = (-_CellScale) + _ScaleEdge;
					    u_xlat14 = u_xlat14 * u_xlat26 + _CellScale;
					    u_xlat26 = u_xlat2.x * _ScaleFocalPointMix;
					    u_xlat38 = (-_CellScale) + _ScaleFocalPoint;
					    u_xlat26 = u_xlat26 * u_xlat38 + _CellScale;
					    u_xlat37 = u_xlat37 * _CellScale;
					    u_xlat37 = u_xlat14 * u_xlat37;
					    u_xlat37 = u_xlat26 * u_xlat37;
					    u_xlat14 = u_xlat25.x * _CellFillMixEdge;
					    u_xlat26 = (-_CellFill) + _CellFillEdge;
					    u_xlat14 = u_xlat14 * u_xlat26 + _CellFill;
					    u_xlat26 = u_xlat2.x * _CellFillMixFocalPoint;
					    u_xlat38 = (-_CellFill) + _CellFillFocalPoint;
					    u_xlat26 = u_xlat26 * u_xlat38 + _CellFill;
					    u_xlat38 = u_xlat2.x * _ColorMixFocalPoint;
					    u_xlat3 = (-_GridColorBase) + _GridColorFocalPoint;
					    u_xlat3 = vec4(u_xlat38) * u_xlat3 + _GridColorBase;
					    u_xlat38 = u_xlat25.x * _ColorMixEdge;
					    u_xlat4 = (-u_xlat3) + _GridColorEdge;
					    u_xlat3 = vec4(u_xlat38) * u_xlat4 + u_xlat3;
					    u_xlat38 = u_xlat2.x * _CellEdgeOccludeMixFocalPoint;
					    u_xlat4.x = (-_OccludeEdgeBase) + _CellEdgeOccludeFocalPoint;
					    u_xlat38 = u_xlat38 * u_xlat4.x + _OccludeEdgeBase;
					    u_xlat4.x = u_xlat25.x * _CellEdgeOccludeMixEdge;
					    u_xlat16 = (-u_xlat38) + _CellEdgeOccludeEdge;
					    u_xlat38 = u_xlat4.x * u_xlat16 + u_xlat38;
					    u_xlat2.x = u_xlat2.x * _CellCornerOccludeMixFocalPoint;
					    u_xlat4.x = (-_OccludeCornerBase) + _CellCornerOccludeFocalPoint;
					    u_xlat2.x = u_xlat2.x * u_xlat4.x + _OccludeCornerBase;
					    u_xlat25.x = u_xlat25.x * _CellCornerOccludeMixEdge;
					    u_xlat4.x = (-u_xlat2.x) + _CellCornerOccludeEdge;
					    u_xlat25.x = u_xlat25.x * u_xlat4.x + u_xlat2.x;
					    u_xlat4 = vec4(u_xlat37) * vec4(0.707106769, 0.707106769, -0.707106769, -0.707106769) + u_xlat1.xyxy;
					    u_xlat1.xy = vec2((-u_xlat4.x) + u_xlat4.z, (-u_xlat4.y) + u_xlat4.w);
					    u_xlat5 = u_xlat0.zwzw * vec4(vec4(_GridScale, _GridScale, _GridScale, _GridScale)) + (-u_xlat4.xyzy);
					    u_xlat6 = (-u_xlat4.xyzy) + vs_TEXCOORD0.xyxy;
					    u_xlat7.xy = u_xlat1.xy * u_xlat1.xy;
					    u_xlat31.xy = u_xlat1.xy * u_xlat5.xw;
					    u_xlat1.xy = u_xlat1.xy * u_xlat6.xw;
					    u_xlat37 = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat2.x = dot(u_xlat5.xy, u_xlat6.xy);
					    u_xlat5.xy = u_xlat31.xy * u_xlat31.xy;
					    u_xlat5.x = u_xlat7.x * u_xlat37 + (-u_xlat5.x);
					    u_xlat5.x = float(1.0) / u_xlat5.x;
					    u_xlat6.x = u_xlat2.x * u_xlat31.x;
					    u_xlat1.w = u_xlat37 * u_xlat1.x + (-u_xlat6.x);
					    u_xlat6.xy = u_xlat1.xy * u_xlat31.xy;
					    u_xlat1.x = u_xlat7.x * u_xlat2.x + (-u_xlat6.x);
					    u_xlat8.yz = u_xlat5.xx * u_xlat1.wx;
					    u_xlat2.x = (-u_xlat1.w) * u_xlat5.x + 1.0;
					    u_xlat8.x = (-u_xlat1.x) * u_xlat5.x + u_xlat2.x;
					    u_xlat7.xz = vec2(u_xlat8.y * float(10000.0), u_xlat8.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat7.xz = min(max(u_xlat7.xz, 0.0), 1.0);
					#else
					    u_xlat7.xz = clamp(u_xlat7.xz, 0.0, 1.0);
					#endif
					    u_xlat1.x = u_xlat7.z * u_xlat7.x;
					    u_xlat37 = u_xlat1.w * u_xlat5.x + u_xlat8.z;
					    u_xlat37 = (-u_xlat37) + 1.0;
					    u_xlat37 = u_xlat37 * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat37 = min(max(u_xlat37, 0.0), 1.0);
					#else
					    u_xlat37 = clamp(u_xlat37, 0.0, 1.0);
					#endif
					    u_xlat2.x = u_xlat37 * u_xlat1.x;
					    u_xlat16_9.x = u_xlat1.x * u_xlat37 + -1.0;
					    u_xlat1.x = dot(u_xlat5.zw, u_xlat5.zw);
					    u_xlat37 = dot(u_xlat5.zw, u_xlat6.zw);
					    u_xlat5.x = u_xlat7.y * u_xlat1.x + (-u_xlat5.y);
					    u_xlat5.x = float(1.0) / u_xlat5.x;
					    u_xlat17 = u_xlat37 * u_xlat31.y;
					    u_xlat1.x = u_xlat1.x * u_xlat1.y + (-u_xlat17);
					    u_xlat1.y = u_xlat7.y * u_xlat37 + (-u_xlat6.y);
					    u_xlat10.yz = u_xlat5.xx * u_xlat1.xy;
					    u_xlat37 = (-u_xlat1.x) * u_xlat5.x + 1.0;
					    u_xlat10.x = (-u_xlat1.y) * u_xlat5.x + u_xlat37;
					    u_xlat13.xz = vec2(u_xlat10.y * float(10000.0), u_xlat10.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat13.xz = min(max(u_xlat13.xz, 0.0), 1.0);
					#else
					    u_xlat13.xz = clamp(u_xlat13.xz, 0.0, 1.0);
					#endif
					    u_xlat13.x = u_xlat13.z * u_xlat13.x;
					    u_xlat1.x = u_xlat1.x * u_xlat5.x + u_xlat10.z;
					    u_xlat1.x = (-u_xlat1.x) + 1.0;
					    u_xlat1.x = u_xlat1.x * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    u_xlat1.x = u_xlat1.x * u_xlat13.x;
					    u_xlat16_21.xyz = u_xlat10.xyz * u_xlat1.xxx;
					    u_xlat16_21.xyz = u_xlat2.xxx * u_xlat8.xyz + u_xlat16_21.xyz;
					    u_xlat16_9.x = u_xlat1.x * 2.0 + u_xlat16_9.x;
					    u_xlat1.xy = vec2((-u_xlat4.z) + u_xlat4.x, (-u_xlat4.w) + u_xlat4.y);
					    u_xlat0 = u_xlat0 * vec4(vec4(_GridScale, _GridScale, _GridScale, _GridScale)) + (-u_xlat4.zwxw);
					    u_xlat4 = (-u_xlat4.zwxw) + vs_TEXCOORD0.xyxy;
					    u_xlat5.xy = u_xlat1.xy * u_xlat1.xy;
					    u_xlat29.xy = u_xlat0.xw * u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * u_xlat4.xw;
					    u_xlat37 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat0.x = dot(u_xlat0.xy, u_xlat4.xy);
					    u_xlat4.xy = u_xlat29.xy * u_xlat29.xy;
					    u_xlat12.x = u_xlat5.x * u_xlat37 + (-u_xlat4.x);
					    u_xlat12.x = float(1.0) / u_xlat12.x;
					    u_xlat2.x = u_xlat0.x * u_xlat29.x;
					    u_xlat37 = u_xlat37 * u_xlat1.x + (-u_xlat2.x);
					    u_xlat6.y = u_xlat12.x * u_xlat37;
					    u_xlat7.xy = u_xlat1.xy * u_xlat29.xy;
					    u_xlat0.x = u_xlat5.x * u_xlat0.x + (-u_xlat7.x);
					    u_xlat6.z = u_xlat12.x * u_xlat0.x;
					    u_xlat1.x = (-u_xlat37) * u_xlat12.x + 1.0;
					    u_xlat6.x = (-u_xlat0.x) * u_xlat12.x + u_xlat1.x;
					    u_xlat5.xz = vec2(u_xlat6.y * float(10000.0), u_xlat6.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat5.xz = min(max(u_xlat5.xz, 0.0), 1.0);
					#else
					    u_xlat5.xz = clamp(u_xlat5.xz, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat5.z * u_xlat5.x;
					    u_xlat12.x = u_xlat37 * u_xlat12.x + u_xlat6.z;
					    u_xlat12.x = (-u_xlat12.x) + 1.0;
					    u_xlat12.x = u_xlat12.x * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat12.x = min(max(u_xlat12.x, 0.0), 1.0);
					#else
					    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat12.x * u_xlat0.x;
					    u_xlat16_21.xyz = u_xlat0.xxx * u_xlat6.xyz + u_xlat16_21.xyz;
					    u_xlat16_9.x = u_xlat0.x * 3.0 + u_xlat16_9.x;
					    u_xlat0.x = dot(u_xlat0.zw, u_xlat0.zw);
					    u_xlat12.x = dot(u_xlat0.zw, u_xlat4.zw);
					    u_xlat24 = u_xlat5.y * u_xlat0.x + (-u_xlat4.y);
					    u_xlat24 = float(1.0) / u_xlat24;
					    u_xlat36 = u_xlat12.x * u_xlat29.y;
					    u_xlat0.x = u_xlat0.x * u_xlat1.y + (-u_xlat36);
					    u_xlat0.y = u_xlat5.y * u_xlat12.x + (-u_xlat7.y);
					    u_xlat4.yz = vec2(u_xlat24) * u_xlat0.xy;
					    u_xlat36 = (-u_xlat0.x) * u_xlat24 + 1.0;
					    u_xlat4.x = (-u_xlat0.y) * u_xlat24 + u_xlat36;
					    u_xlat12.xz = vec2(u_xlat4.y * float(10000.0), u_xlat4.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat12.xz = min(max(u_xlat12.xz, 0.0), 1.0);
					#else
					    u_xlat12.xz = clamp(u_xlat12.xz, 0.0, 1.0);
					#endif
					    u_xlat12.x = u_xlat12.z * u_xlat12.x;
					    u_xlat0.x = u_xlat0.x * u_xlat24 + u_xlat4.z;
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = u_xlat0.x * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
					#else
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat0.x * u_xlat12.x;
					    u_xlat16_21.xyz = u_xlat0.xxx * u_xlat4.xyz + u_xlat16_21.xyz;
					    u_xlat16_9.x = u_xlat0.x * 4.0 + u_xlat16_9.x;
					    u_xlat16_11.xy = (-u_xlat25.xx) + u_xlat16_21.yx;
					    u_xlat16_11.xy = u_xlat16_11.xy * vec2(10000.0, 10000.0);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_11.xy = min(max(u_xlat16_11.xy, 0.0), 1.0);
					#else
					    u_xlat16_11.xy = clamp(u_xlat16_11.xy, 0.0, 1.0);
					#endif
					    u_xlat16_21.xy = (-u_xlat16_21.xy) + u_xlat16_21.yx;
					    u_xlat16_21.xy = (-vec2(u_xlat38)) + u_xlat16_21.xy;
					    u_xlat16_21.xy = u_xlat16_21.xy * vec2(10000.0, 10000.0);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_21.xy = min(max(u_xlat16_21.xy, 0.0), 1.0);
					#else
					    u_xlat16_21.xy = clamp(u_xlat16_21.xy, 0.0, 1.0);
					#endif
					    u_xlat16_9.y = u_xlat16_21.y + u_xlat16_21.x;
					    u_xlat16_33 = u_xlat26 * u_xlat14 + (-u_xlat16_21.z);
					    u_xlat16_33 = u_xlat16_33 * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_33 = min(max(u_xlat16_33, 0.0), 1.0);
					#else
					    u_xlat16_33 = clamp(u_xlat16_33, 0.0, 1.0);
					#endif
					    u_xlat16_9.xw = u_xlat16_9.xx + vec2(-4.0, 1.0);
					    u_xlat16_9.x = abs(u_xlat16_9.x) * 10000.0;
					    u_xlat16_9.w = u_xlat16_9.w * 10000.0;
					    u_xlat16_9.xyw = min(u_xlat16_9.xyw, vec3(1.0, 1.0, 1.0));
					    u_xlat16_9.x = u_xlat3.w * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_9.w * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_11.x * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_11.y * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_9.y * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_33 * u_xlat16_9.x;
					    u_xlat3.w = u_xlat16_9.x * _Visibility;
					    SV_Target0 = u_xlat3;
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
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    vs_TEXCOORD0.xy = hlslcc_mtx4x4unity_ObjectToWorld[3].xz * in_POSITION0.ww + u_xlat0.xz;
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
					uniform 	float _Visibility;
					uniform 	vec3 _FocalPointPosition;
					uniform 	float _FocalPointRange;
					uniform 	float _FocalPointRadius;
					uniform 	float _FocalPointFadePower;
					uniform 	float _GridScale;
					uniform 	float _GeometryEdgeFadeWidth;
					uniform 	vec4 _GridColorBase;
					uniform 	vec4 _GridColorFocalPoint;
					uniform 	float _ColorMixFocalPoint;
					uniform 	vec4 _GridColorEdge;
					uniform 	float _ColorMixEdge;
					uniform 	float _CellScale;
					uniform 	float _ScaleFocalPoint;
					uniform 	float _ScaleFocalPointMix;
					uniform 	float _ScaleEdge;
					uniform 	float _ScaleEdgeMix;
					uniform 	float _CellFill;
					uniform 	float _CellFillFocalPoint;
					uniform 	float _CellFillMixFocalPoint;
					uniform 	float _CellFillEdge;
					uniform 	float _CellFillMixEdge;
					uniform 	float _OccludeCornerBase;
					uniform 	float _CellCornerOccludeFocalPoint;
					uniform 	float _CellCornerOccludeMixFocalPoint;
					uniform 	float _CellCornerOccludeEdge;
					uniform 	float _CellCornerOccludeMixEdge;
					uniform 	float _OccludeEdgeBase;
					uniform 	float _CellEdgeOccludeFocalPoint;
					uniform 	float _CellEdgeOccludeMixFocalPoint;
					uniform 	float _CellEdgeOccludeEdge;
					uniform 	float _CellEdgeOccludeMixEdge;
					uniform 	vec4 _Bounds;
					uniform lowp sampler2D _PerimeterDist;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					vec2 u_xlat2;
					bool u_xlatb2;
					vec4 u_xlat3;
					vec4 u_xlat4;
					vec4 u_xlat5;
					vec4 u_xlat6;
					vec3 u_xlat7;
					vec3 u_xlat8;
					mediump vec4 u_xlat16_9;
					vec3 u_xlat10;
					mediump vec2 u_xlat16_11;
					vec3 u_xlat12;
					vec3 u_xlat13;
					float u_xlat14;
					float u_xlat16;
					float u_xlat17;
					mediump vec3 u_xlat16_21;
					float u_xlat24;
					vec2 u_xlat25;
					lowp float u_xlat10_25;
					float u_xlat26;
					vec2 u_xlat29;
					vec2 u_xlat31;
					mediump float u_xlat16_33;
					float u_xlat36;
					float u_xlat37;
					float u_xlat38;
					void main()
					{
					    u_xlat0 = vs_TEXCOORD0.xyxy / vec4(vec4(_GridScale, _GridScale, _GridScale, _GridScale));
					    u_xlat0 = roundEven(u_xlat0);
					    u_xlat1.xy = vec2(u_xlat0.z * float(_GridScale), u_xlat0.w * float(_GridScale));
					    u_xlat25.xy = u_xlat0.zw * vec2(vec2(_GridScale, _GridScale)) + (-_Bounds.xy);
					    u_xlat25.xy = vec2(u_xlat25.x / _Bounds.z, u_xlat25.y / _Bounds.w);
					    u_xlat10_25 = texture(_PerimeterDist, u_xlat25.xy).x;
					    u_xlat25.x = u_xlat10_25 * _Bounds.z;
					    u_xlat25.x = u_xlat25.x * 0.5;
					    u_xlat37 = _GridScale * 0.5;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb2 = !!(u_xlat25.x<u_xlat37);
					#else
					    u_xlatb2 = u_xlat25.x<u_xlat37;
					#endif
					    if(u_xlatb2){
					        SV_Target0.xyz = _GridColorBase.xyz;
					        SV_Target0.w = 0.0;
					        return;
					    //ENDIF
					    }
					    u_xlat25.x = u_xlat25.x / _GeometryEdgeFadeWidth;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat25.x = min(max(u_xlat25.x, 0.0), 1.0);
					#else
					    u_xlat25.x = clamp(u_xlat25.x, 0.0, 1.0);
					#endif
					    u_xlat25.x = (-u_xlat25.x) + 1.0;
					    u_xlat2.xy = (-u_xlat0.zw) * vec2(vec2(_GridScale, _GridScale)) + vec2(_FocalPointPosition.x, _FocalPointPosition.z);
					    u_xlat2.x = dot(u_xlat2.xy, u_xlat2.xy);
					    u_xlat2.x = sqrt(u_xlat2.x);
					    u_xlat2.x = (-u_xlat2.x) + _FocalPointRadius;
					    u_xlat2.x = abs(u_xlat2.x) / _FocalPointRange;
					    u_xlat2.x = (-u_xlat2.x) + 1.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat2.x = min(max(u_xlat2.x, 0.0), 1.0);
					#else
					    u_xlat2.x = clamp(u_xlat2.x, 0.0, 1.0);
					#endif
					    u_xlat14 = float(1.0) / _FocalPointFadePower;
					    u_xlat2.x = log2(u_xlat2.x);
					    u_xlat2.x = u_xlat2.x * u_xlat14;
					    u_xlat2.x = exp2(u_xlat2.x);
					    u_xlat14 = u_xlat25.x * _ScaleEdgeMix;
					    u_xlat26 = (-_CellScale) + _ScaleEdge;
					    u_xlat14 = u_xlat14 * u_xlat26 + _CellScale;
					    u_xlat26 = u_xlat2.x * _ScaleFocalPointMix;
					    u_xlat38 = (-_CellScale) + _ScaleFocalPoint;
					    u_xlat26 = u_xlat26 * u_xlat38 + _CellScale;
					    u_xlat37 = u_xlat37 * _CellScale;
					    u_xlat37 = u_xlat14 * u_xlat37;
					    u_xlat37 = u_xlat26 * u_xlat37;
					    u_xlat14 = u_xlat25.x * _CellFillMixEdge;
					    u_xlat26 = (-_CellFill) + _CellFillEdge;
					    u_xlat14 = u_xlat14 * u_xlat26 + _CellFill;
					    u_xlat26 = u_xlat2.x * _CellFillMixFocalPoint;
					    u_xlat38 = (-_CellFill) + _CellFillFocalPoint;
					    u_xlat26 = u_xlat26 * u_xlat38 + _CellFill;
					    u_xlat38 = u_xlat2.x * _ColorMixFocalPoint;
					    u_xlat3 = (-_GridColorBase) + _GridColorFocalPoint;
					    u_xlat3 = vec4(u_xlat38) * u_xlat3 + _GridColorBase;
					    u_xlat38 = u_xlat25.x * _ColorMixEdge;
					    u_xlat4 = (-u_xlat3) + _GridColorEdge;
					    u_xlat3 = vec4(u_xlat38) * u_xlat4 + u_xlat3;
					    u_xlat38 = u_xlat2.x * _CellEdgeOccludeMixFocalPoint;
					    u_xlat4.x = (-_OccludeEdgeBase) + _CellEdgeOccludeFocalPoint;
					    u_xlat38 = u_xlat38 * u_xlat4.x + _OccludeEdgeBase;
					    u_xlat4.x = u_xlat25.x * _CellEdgeOccludeMixEdge;
					    u_xlat16 = (-u_xlat38) + _CellEdgeOccludeEdge;
					    u_xlat38 = u_xlat4.x * u_xlat16 + u_xlat38;
					    u_xlat2.x = u_xlat2.x * _CellCornerOccludeMixFocalPoint;
					    u_xlat4.x = (-_OccludeCornerBase) + _CellCornerOccludeFocalPoint;
					    u_xlat2.x = u_xlat2.x * u_xlat4.x + _OccludeCornerBase;
					    u_xlat25.x = u_xlat25.x * _CellCornerOccludeMixEdge;
					    u_xlat4.x = (-u_xlat2.x) + _CellCornerOccludeEdge;
					    u_xlat25.x = u_xlat25.x * u_xlat4.x + u_xlat2.x;
					    u_xlat4 = vec4(u_xlat37) * vec4(0.707106769, 0.707106769, -0.707106769, -0.707106769) + u_xlat1.xyxy;
					    u_xlat1.xy = vec2((-u_xlat4.x) + u_xlat4.z, (-u_xlat4.y) + u_xlat4.w);
					    u_xlat5 = u_xlat0.zwzw * vec4(vec4(_GridScale, _GridScale, _GridScale, _GridScale)) + (-u_xlat4.xyzy);
					    u_xlat6 = (-u_xlat4.xyzy) + vs_TEXCOORD0.xyxy;
					    u_xlat7.xy = u_xlat1.xy * u_xlat1.xy;
					    u_xlat31.xy = u_xlat1.xy * u_xlat5.xw;
					    u_xlat1.xy = u_xlat1.xy * u_xlat6.xw;
					    u_xlat37 = dot(u_xlat5.xy, u_xlat5.xy);
					    u_xlat2.x = dot(u_xlat5.xy, u_xlat6.xy);
					    u_xlat5.xy = u_xlat31.xy * u_xlat31.xy;
					    u_xlat5.x = u_xlat7.x * u_xlat37 + (-u_xlat5.x);
					    u_xlat5.x = float(1.0) / u_xlat5.x;
					    u_xlat6.x = u_xlat2.x * u_xlat31.x;
					    u_xlat1.w = u_xlat37 * u_xlat1.x + (-u_xlat6.x);
					    u_xlat6.xy = u_xlat1.xy * u_xlat31.xy;
					    u_xlat1.x = u_xlat7.x * u_xlat2.x + (-u_xlat6.x);
					    u_xlat8.yz = u_xlat5.xx * u_xlat1.wx;
					    u_xlat2.x = (-u_xlat1.w) * u_xlat5.x + 1.0;
					    u_xlat8.x = (-u_xlat1.x) * u_xlat5.x + u_xlat2.x;
					    u_xlat7.xz = vec2(u_xlat8.y * float(10000.0), u_xlat8.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat7.xz = min(max(u_xlat7.xz, 0.0), 1.0);
					#else
					    u_xlat7.xz = clamp(u_xlat7.xz, 0.0, 1.0);
					#endif
					    u_xlat1.x = u_xlat7.z * u_xlat7.x;
					    u_xlat37 = u_xlat1.w * u_xlat5.x + u_xlat8.z;
					    u_xlat37 = (-u_xlat37) + 1.0;
					    u_xlat37 = u_xlat37 * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat37 = min(max(u_xlat37, 0.0), 1.0);
					#else
					    u_xlat37 = clamp(u_xlat37, 0.0, 1.0);
					#endif
					    u_xlat2.x = u_xlat37 * u_xlat1.x;
					    u_xlat16_9.x = u_xlat1.x * u_xlat37 + -1.0;
					    u_xlat1.x = dot(u_xlat5.zw, u_xlat5.zw);
					    u_xlat37 = dot(u_xlat5.zw, u_xlat6.zw);
					    u_xlat5.x = u_xlat7.y * u_xlat1.x + (-u_xlat5.y);
					    u_xlat5.x = float(1.0) / u_xlat5.x;
					    u_xlat17 = u_xlat37 * u_xlat31.y;
					    u_xlat1.x = u_xlat1.x * u_xlat1.y + (-u_xlat17);
					    u_xlat1.y = u_xlat7.y * u_xlat37 + (-u_xlat6.y);
					    u_xlat10.yz = u_xlat5.xx * u_xlat1.xy;
					    u_xlat37 = (-u_xlat1.x) * u_xlat5.x + 1.0;
					    u_xlat10.x = (-u_xlat1.y) * u_xlat5.x + u_xlat37;
					    u_xlat13.xz = vec2(u_xlat10.y * float(10000.0), u_xlat10.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat13.xz = min(max(u_xlat13.xz, 0.0), 1.0);
					#else
					    u_xlat13.xz = clamp(u_xlat13.xz, 0.0, 1.0);
					#endif
					    u_xlat13.x = u_xlat13.z * u_xlat13.x;
					    u_xlat1.x = u_xlat1.x * u_xlat5.x + u_xlat10.z;
					    u_xlat1.x = (-u_xlat1.x) + 1.0;
					    u_xlat1.x = u_xlat1.x * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    u_xlat1.x = u_xlat1.x * u_xlat13.x;
					    u_xlat16_21.xyz = u_xlat10.xyz * u_xlat1.xxx;
					    u_xlat16_21.xyz = u_xlat2.xxx * u_xlat8.xyz + u_xlat16_21.xyz;
					    u_xlat16_9.x = u_xlat1.x * 2.0 + u_xlat16_9.x;
					    u_xlat1.xy = vec2((-u_xlat4.z) + u_xlat4.x, (-u_xlat4.w) + u_xlat4.y);
					    u_xlat0 = u_xlat0 * vec4(vec4(_GridScale, _GridScale, _GridScale, _GridScale)) + (-u_xlat4.zwxw);
					    u_xlat4 = (-u_xlat4.zwxw) + vs_TEXCOORD0.xyxy;
					    u_xlat5.xy = u_xlat1.xy * u_xlat1.xy;
					    u_xlat29.xy = u_xlat0.xw * u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * u_xlat4.xw;
					    u_xlat37 = dot(u_xlat0.xy, u_xlat0.xy);
					    u_xlat0.x = dot(u_xlat0.xy, u_xlat4.xy);
					    u_xlat4.xy = u_xlat29.xy * u_xlat29.xy;
					    u_xlat12.x = u_xlat5.x * u_xlat37 + (-u_xlat4.x);
					    u_xlat12.x = float(1.0) / u_xlat12.x;
					    u_xlat2.x = u_xlat0.x * u_xlat29.x;
					    u_xlat37 = u_xlat37 * u_xlat1.x + (-u_xlat2.x);
					    u_xlat6.y = u_xlat12.x * u_xlat37;
					    u_xlat7.xy = u_xlat1.xy * u_xlat29.xy;
					    u_xlat0.x = u_xlat5.x * u_xlat0.x + (-u_xlat7.x);
					    u_xlat6.z = u_xlat12.x * u_xlat0.x;
					    u_xlat1.x = (-u_xlat37) * u_xlat12.x + 1.0;
					    u_xlat6.x = (-u_xlat0.x) * u_xlat12.x + u_xlat1.x;
					    u_xlat5.xz = vec2(u_xlat6.y * float(10000.0), u_xlat6.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat5.xz = min(max(u_xlat5.xz, 0.0), 1.0);
					#else
					    u_xlat5.xz = clamp(u_xlat5.xz, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat5.z * u_xlat5.x;
					    u_xlat12.x = u_xlat37 * u_xlat12.x + u_xlat6.z;
					    u_xlat12.x = (-u_xlat12.x) + 1.0;
					    u_xlat12.x = u_xlat12.x * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat12.x = min(max(u_xlat12.x, 0.0), 1.0);
					#else
					    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat12.x * u_xlat0.x;
					    u_xlat16_21.xyz = u_xlat0.xxx * u_xlat6.xyz + u_xlat16_21.xyz;
					    u_xlat16_9.x = u_xlat0.x * 3.0 + u_xlat16_9.x;
					    u_xlat0.x = dot(u_xlat0.zw, u_xlat0.zw);
					    u_xlat12.x = dot(u_xlat0.zw, u_xlat4.zw);
					    u_xlat24 = u_xlat5.y * u_xlat0.x + (-u_xlat4.y);
					    u_xlat24 = float(1.0) / u_xlat24;
					    u_xlat36 = u_xlat12.x * u_xlat29.y;
					    u_xlat0.x = u_xlat0.x * u_xlat1.y + (-u_xlat36);
					    u_xlat0.y = u_xlat5.y * u_xlat12.x + (-u_xlat7.y);
					    u_xlat4.yz = vec2(u_xlat24) * u_xlat0.xy;
					    u_xlat36 = (-u_xlat0.x) * u_xlat24 + 1.0;
					    u_xlat4.x = (-u_xlat0.y) * u_xlat24 + u_xlat36;
					    u_xlat12.xz = vec2(u_xlat4.y * float(10000.0), u_xlat4.z * float(10000.0));
					#ifdef UNITY_ADRENO_ES3
					    u_xlat12.xz = min(max(u_xlat12.xz, 0.0), 1.0);
					#else
					    u_xlat12.xz = clamp(u_xlat12.xz, 0.0, 1.0);
					#endif
					    u_xlat12.x = u_xlat12.z * u_xlat12.x;
					    u_xlat0.x = u_xlat0.x * u_xlat24 + u_xlat4.z;
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = u_xlat0.x * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
					#else
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					#endif
					    u_xlat0.x = u_xlat0.x * u_xlat12.x;
					    u_xlat16_21.xyz = u_xlat0.xxx * u_xlat4.xyz + u_xlat16_21.xyz;
					    u_xlat16_9.x = u_xlat0.x * 4.0 + u_xlat16_9.x;
					    u_xlat16_11.xy = (-u_xlat25.xx) + u_xlat16_21.yx;
					    u_xlat16_11.xy = u_xlat16_11.xy * vec2(10000.0, 10000.0);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_11.xy = min(max(u_xlat16_11.xy, 0.0), 1.0);
					#else
					    u_xlat16_11.xy = clamp(u_xlat16_11.xy, 0.0, 1.0);
					#endif
					    u_xlat16_21.xy = (-u_xlat16_21.xy) + u_xlat16_21.yx;
					    u_xlat16_21.xy = (-vec2(u_xlat38)) + u_xlat16_21.xy;
					    u_xlat16_21.xy = u_xlat16_21.xy * vec2(10000.0, 10000.0);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_21.xy = min(max(u_xlat16_21.xy, 0.0), 1.0);
					#else
					    u_xlat16_21.xy = clamp(u_xlat16_21.xy, 0.0, 1.0);
					#endif
					    u_xlat16_9.y = u_xlat16_21.y + u_xlat16_21.x;
					    u_xlat16_33 = u_xlat26 * u_xlat14 + (-u_xlat16_21.z);
					    u_xlat16_33 = u_xlat16_33 * 10000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_33 = min(max(u_xlat16_33, 0.0), 1.0);
					#else
					    u_xlat16_33 = clamp(u_xlat16_33, 0.0, 1.0);
					#endif
					    u_xlat16_9.xw = u_xlat16_9.xx + vec2(-4.0, 1.0);
					    u_xlat16_9.x = abs(u_xlat16_9.x) * 10000.0;
					    u_xlat16_9.w = u_xlat16_9.w * 10000.0;
					    u_xlat16_9.xyw = min(u_xlat16_9.xyw, vec3(1.0, 1.0, 1.0));
					    u_xlat16_9.x = u_xlat3.w * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_9.w * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_11.x * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_11.y * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_9.y * u_xlat16_9.x;
					    u_xlat16_9.x = u_xlat16_33 * u_xlat16_9.x;
					    u_xlat3.w = u_xlat16_9.x * _Visibility;
					    SV_Target0 = u_xlat3;
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