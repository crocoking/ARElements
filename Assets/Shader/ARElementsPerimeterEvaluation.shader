Shader "ARElements/PerimeterEvaluation" {
	Properties {
		_Resolution ("Resolution", Float) = 256
	}
	SubShader {
		Pass {
			Name "DistFromPerimeter"
			GpuProgramID 10916
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
					#line 44
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 38
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
					#line 36
					uniform highp float _Resolution;
					#line 50
					#line 58
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
					#line 50
					v2f vert( in appdata v ) {
					    v2f o;
					    o.vertex = UnityObjectToClipPos( v.vertex);
					    #line 54
					    o.uv = v.uv;
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
					(85,1): error: array index must be < 4
					(86,1): error: array index must be < 4
					(87,1): error: array index must be < 4
					(88,1): error: array index must be < 4
					(94,1): error: array index must be < 5
					(95,1): error: array index must be < 5
					(96,1): error: array index must be < 5
					(97,1): error: array index must be < 5
					(98,1): error: array index must be < 5
					(104,1): error: array index must be < 5
					(105,1): error: array index must be < 5
					(106,1): error: array index must be < 5
					(107,1): error: array index must be < 5
					(108,1): error: array index must be < 5
					(116,1): error: array index must be < 7
					(117,1): error: array index must be < 7
					(118,1): error: array index must be < 7
					(119,1): error: array index must be < 7
					(120,1): error: array index must be < 7
					(121,1): error: array index must be < 7
					(122,1): error: array index must be < 7
					(132,1): error: array index must be < 9
					(133,1): error: array index must be < 9
					(134,1): error: array index must be < 9
					(135,1): error: array index must be < 9
					(136,1): error: array index must be < 9
					(137,1): error: array index must be < 9
					(138,1): error: array index must be < 9
					(139,1): error: array index must be < 9
					(140,1): error: array index must be < 9
					(158,1): error: array index must be < 17
					(159,1): error: array index must be < 17
					(160,1): error: array index must be < 17
					(161,1): error: array index must be < 17
					(162,1): error: array index must be < 17
					(163,1): error: array index must be < 17
					(164,1): error: array index must be < 17
					(165,1): error: array index must be < 17
					(166,1): error: array index must be < 17
					(167,1): error: array index must be < 17
					(168,1): error: array index must be < 17
					(169,1): error: array index must be < 17
					(170,1): error: array index must be < 17
					(171,1): error: array index must be < 17
					(172,1): error: array index must be < 17
					(173,1): error: array index must be < 17
					(174,1): error: array index must be < 17
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
					#line 44
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 38
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
					#line 36
					uniform highp float _Resolution;
					#line 50
					#line 58
					#line 208
					highp float Angle( in highp vec3 A, in highp vec3 B ) {
					    #line 209
					    highp vec3 lineDir = (B - A);
					    highp vec3 perpDir = normalize(vec3( lineDir.z, 0.0, (-lineDir.x)));
					    highp float angle = atan( perpDir.z, perpDir.x);
					    return angle;
					}
					#line 201
					highp float DistToLine( in highp vec3 P, in highp vec3 A, in highp vec3 B ) {
					    highp vec3 lineDir = (B - A);
					    highp vec3 perpDir = vec3( lineDir.z, 0.0, (-lineDir.x));
					    highp vec3 dirToA = (A - P);
					    #line 205
					    return abs(dot( normalize(perpDir), dirToA));
					}
					#line 215
					PointRelationship GetPointLineRelationship( in highp vec3 p, in highp vec3 q, in highp vec3 r ) {
					    PointRelationship rel;
					    rel.dist = DistToLine( q, p, r);
					    rel.angle = Angle( p, r);
					    #line 219
					    return rel;
					}
					#line 58
					lowp vec4 frag( in v2f i ) {
					    highp vec2 uv = i.uv;
					    #line 62
					    highp float du = (1.0 / _Resolution);
					    highp float dv = (1.0 / _Resolution);
					    highp vec3 duv = vec3( du, dv, 0.0);
					    #line 66
					    highp vec3 localpos = vec3( i.uv.x, 0.0, i.uv.y);
					    PointRelationship perimeterRelationship;
					    PointRelationship tmpRel;
					    #line 70
					    perimeterRelationship.dist = 1000000.0;
					    highp int vi = 0;
					    for ( ; (float(vi) < (_NumVerts - 1.0)); (vi++)) {
					        tmpRel = GetPointLineRelationship( vec3( _PerimeterVerts[vi]), localpos, vec3( _PerimeterVerts[(vi + 1)]));
					        #line 74
					        lowp float distDiff = xll_saturate_f((100000.0 * (perimeterRelationship.dist - tmpRel.dist)));
					        perimeterRelationship.dist = (((1.0 - distDiff) * perimeterRelationship.dist) + (distDiff * tmpRel.dist));
					    }
					    #line 78
					    tmpRel = GetPointLineRelationship( vec3( _PerimeterVerts[int((_NumVerts - 1.0))]), localpos, vec3( _PerimeterVerts[0]));
					    lowp float distDiff_1 = xll_saturate_f((100000.0 * (perimeterRelationship.dist - tmpRel.dist)));
					    perimeterRelationship.dist = (((1.0 - distDiff_1) * perimeterRelationship.dist) + (distDiff_1 * tmpRel.dist));
					    #line 82
					    lowp vec4 col = vec4( (perimeterRelationship.dist * 2.0), 0.0, 0.0, 1.0);
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
					(113,1): error: array index must be < 4
					(114,1): error: array index must be < 4
					(115,1): error: array index must be < 4
					(116,1): error: array index must be < 4
					(122,1): error: array index must be < 5
					(123,1): error: array index must be < 5
					(124,1): error: array index must be < 5
					(125,1): error: array index must be < 5
					(126,1): error: array index must be < 5
					(132,1): error: array index must be < 5
					(133,1): error: array index must be < 5
					(134,1): error: array index must be < 5
					(135,1): error: array index must be < 5
					(136,1): error: array index must be < 5
					(144,1): error: array index must be < 7
					(145,1): error: array index must be < 7
					(146,1): error: array index must be < 7
					(147,1): error: array index must be < 7
					(148,1): error: array index must be < 7
					(149,1): error: array index must be < 7
					(150,1): error: array index must be < 7
					(160,1): error: array index must be < 9
					(161,1): error: array index must be < 9
					(162,1): error: array index must be < 9
					(163,1): error: array index must be < 9
					(164,1): error: array index must be < 9
					(165,1): error: array index must be < 9
					(166,1): error: array index must be < 9
					(167,1): error: array index must be < 9
					(168,1): error: array index must be < 9
					(186,1): error: array index must be < 17
					(187,1): error: array index must be < 17
					(188,1): error: array index must be < 17
					(189,1): error: array index must be < 17
					(190,1): error: array index must be < 17
					(191,1): error: array index must be < 17
					(192,1): error: array index must be < 17
					(193,1): error: array index must be < 17
					(194,1): error: array index must be < 17
					(195,1): error: array index must be < 17
					(196,1): error: array index must be < 17
					(197,1): error: array index must be < 17
					(198,1): error: array index must be < 17
					(199,1): error: array index must be < 17
					(200,1): error: array index must be < 17
					(201,1): error: array index must be < 17
					(202,1): error: array index must be < 17
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
					#line 44
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 38
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
					#line 36
					uniform highp float _Resolution;
					#line 50
					#line 58
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
					#line 50
					v2f vert( in appdata v ) {
					    v2f o;
					    o.vertex = UnityObjectToClipPos( v.vertex);
					    #line 54
					    o.uv = v.uv;
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
					(85,1): error: array index must be < 4
					(86,1): error: array index must be < 4
					(87,1): error: array index must be < 4
					(88,1): error: array index must be < 4
					(94,1): error: array index must be < 5
					(95,1): error: array index must be < 5
					(96,1): error: array index must be < 5
					(97,1): error: array index must be < 5
					(98,1): error: array index must be < 5
					(104,1): error: array index must be < 5
					(105,1): error: array index must be < 5
					(106,1): error: array index must be < 5
					(107,1): error: array index must be < 5
					(108,1): error: array index must be < 5
					(116,1): error: array index must be < 7
					(117,1): error: array index must be < 7
					(118,1): error: array index must be < 7
					(119,1): error: array index must be < 7
					(120,1): error: array index must be < 7
					(121,1): error: array index must be < 7
					(122,1): error: array index must be < 7
					(132,1): error: array index must be < 9
					(133,1): error: array index must be < 9
					(134,1): error: array index must be < 9
					(135,1): error: array index must be < 9
					(136,1): error: array index must be < 9
					(137,1): error: array index must be < 9
					(138,1): error: array index must be < 9
					(139,1): error: array index must be < 9
					(140,1): error: array index must be < 9
					(158,1): error: array index must be < 17
					(159,1): error: array index must be < 17
					(160,1): error: array index must be < 17
					(161,1): error: array index must be < 17
					(162,1): error: array index must be < 17
					(163,1): error: array index must be < 17
					(164,1): error: array index must be < 17
					(165,1): error: array index must be < 17
					(166,1): error: array index must be < 17
					(167,1): error: array index must be < 17
					(168,1): error: array index must be < 17
					(169,1): error: array index must be < 17
					(170,1): error: array index must be < 17
					(171,1): error: array index must be < 17
					(172,1): error: array index must be < 17
					(173,1): error: array index must be < 17
					(174,1): error: array index must be < 17
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
					#line 44
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 38
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
					#line 36
					uniform highp float _Resolution;
					#line 50
					#line 58
					#line 208
					highp float Angle( in highp vec3 A, in highp vec3 B ) {
					    #line 209
					    highp vec3 lineDir = (B - A);
					    highp vec3 perpDir = normalize(vec3( lineDir.z, 0.0, (-lineDir.x)));
					    highp float angle = atan( perpDir.z, perpDir.x);
					    return angle;
					}
					#line 201
					highp float DistToLine( in highp vec3 P, in highp vec3 A, in highp vec3 B ) {
					    highp vec3 lineDir = (B - A);
					    highp vec3 perpDir = vec3( lineDir.z, 0.0, (-lineDir.x));
					    highp vec3 dirToA = (A - P);
					    #line 205
					    return abs(dot( normalize(perpDir), dirToA));
					}
					#line 215
					PointRelationship GetPointLineRelationship( in highp vec3 p, in highp vec3 q, in highp vec3 r ) {
					    PointRelationship rel;
					    rel.dist = DistToLine( q, p, r);
					    rel.angle = Angle( p, r);
					    #line 219
					    return rel;
					}
					#line 58
					lowp vec4 frag( in v2f i ) {
					    highp vec2 uv = i.uv;
					    #line 62
					    highp float du = (1.0 / _Resolution);
					    highp float dv = (1.0 / _Resolution);
					    highp vec3 duv = vec3( du, dv, 0.0);
					    #line 66
					    highp vec3 localpos = vec3( i.uv.x, 0.0, i.uv.y);
					    PointRelationship perimeterRelationship;
					    PointRelationship tmpRel;
					    #line 70
					    perimeterRelationship.dist = 1000000.0;
					    highp int vi = 0;
					    for ( ; (float(vi) < (_NumVerts - 1.0)); (vi++)) {
					        tmpRel = GetPointLineRelationship( vec3( _PerimeterVerts[vi]), localpos, vec3( _PerimeterVerts[(vi + 1)]));
					        #line 74
					        lowp float distDiff = xll_saturate_f((100000.0 * (perimeterRelationship.dist - tmpRel.dist)));
					        perimeterRelationship.dist = (((1.0 - distDiff) * perimeterRelationship.dist) + (distDiff * tmpRel.dist));
					    }
					    #line 78
					    tmpRel = GetPointLineRelationship( vec3( _PerimeterVerts[int((_NumVerts - 1.0))]), localpos, vec3( _PerimeterVerts[0]));
					    lowp float distDiff_1 = xll_saturate_f((100000.0 * (perimeterRelationship.dist - tmpRel.dist)));
					    perimeterRelationship.dist = (((1.0 - distDiff_1) * perimeterRelationship.dist) + (distDiff_1 * tmpRel.dist));
					    #line 82
					    lowp vec4 col = vec4( (perimeterRelationship.dist * 2.0), 0.0, 0.0, 1.0);
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
					(113,1): error: array index must be < 4
					(114,1): error: array index must be < 4
					(115,1): error: array index must be < 4
					(116,1): error: array index must be < 4
					(122,1): error: array index must be < 5
					(123,1): error: array index must be < 5
					(124,1): error: array index must be < 5
					(125,1): error: array index must be < 5
					(126,1): error: array index must be < 5
					(132,1): error: array index must be < 5
					(133,1): error: array index must be < 5
					(134,1): error: array index must be < 5
					(135,1): error: array index must be < 5
					(136,1): error: array index must be < 5
					(144,1): error: array index must be < 7
					(145,1): error: array index must be < 7
					(146,1): error: array index must be < 7
					(147,1): error: array index must be < 7
					(148,1): error: array index must be < 7
					(149,1): error: array index must be < 7
					(150,1): error: array index must be < 7
					(160,1): error: array index must be < 9
					(161,1): error: array index must be < 9
					(162,1): error: array index must be < 9
					(163,1): error: array index must be < 9
					(164,1): error: array index must be < 9
					(165,1): error: array index must be < 9
					(166,1): error: array index must be < 9
					(167,1): error: array index must be < 9
					(168,1): error: array index must be < 9
					(186,1): error: array index must be < 17
					(187,1): error: array index must be < 17
					(188,1): error: array index must be < 17
					(189,1): error: array index must be < 17
					(190,1): error: array index must be < 17
					(191,1): error: array index must be < 17
					(192,1): error: array index must be < 17
					(193,1): error: array index must be < 17
					(194,1): error: array index must be < 17
					(195,1): error: array index must be < 17
					(196,1): error: array index must be < 17
					(197,1): error: array index must be < 17
					(198,1): error: array index must be < 17
					(199,1): error: array index must be < 17
					(200,1): error: array index must be < 17
					(201,1): error: array index must be < 17
					(202,1): error: array index must be < 17
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
					#line 44
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 38
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
					#line 36
					uniform highp float _Resolution;
					#line 50
					#line 58
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
					#line 50
					v2f vert( in appdata v ) {
					    v2f o;
					    o.vertex = UnityObjectToClipPos( v.vertex);
					    #line 54
					    o.uv = v.uv;
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
					(85,1): error: array index must be < 4
					(86,1): error: array index must be < 4
					(87,1): error: array index must be < 4
					(88,1): error: array index must be < 4
					(94,1): error: array index must be < 5
					(95,1): error: array index must be < 5
					(96,1): error: array index must be < 5
					(97,1): error: array index must be < 5
					(98,1): error: array index must be < 5
					(104,1): error: array index must be < 5
					(105,1): error: array index must be < 5
					(106,1): error: array index must be < 5
					(107,1): error: array index must be < 5
					(108,1): error: array index must be < 5
					(116,1): error: array index must be < 7
					(117,1): error: array index must be < 7
					(118,1): error: array index must be < 7
					(119,1): error: array index must be < 7
					(120,1): error: array index must be < 7
					(121,1): error: array index must be < 7
					(122,1): error: array index must be < 7
					(132,1): error: array index must be < 9
					(133,1): error: array index must be < 9
					(134,1): error: array index must be < 9
					(135,1): error: array index must be < 9
					(136,1): error: array index must be < 9
					(137,1): error: array index must be < 9
					(138,1): error: array index must be < 9
					(139,1): error: array index must be < 9
					(140,1): error: array index must be < 9
					(158,1): error: array index must be < 17
					(159,1): error: array index must be < 17
					(160,1): error: array index must be < 17
					(161,1): error: array index must be < 17
					(162,1): error: array index must be < 17
					(163,1): error: array index must be < 17
					(164,1): error: array index must be < 17
					(165,1): error: array index must be < 17
					(166,1): error: array index must be < 17
					(167,1): error: array index must be < 17
					(168,1): error: array index must be < 17
					(169,1): error: array index must be < 17
					(170,1): error: array index must be < 17
					(171,1): error: array index must be < 17
					(172,1): error: array index must be < 17
					(173,1): error: array index must be < 17
					(174,1): error: array index must be < 17
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
					#line 44
					struct v2f {
					    highp vec2 uv;
					    highp vec4 vertex;
					};
					#line 38
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
					#line 36
					uniform highp float _Resolution;
					#line 50
					#line 58
					#line 208
					highp float Angle( in highp vec3 A, in highp vec3 B ) {
					    #line 209
					    highp vec3 lineDir = (B - A);
					    highp vec3 perpDir = normalize(vec3( lineDir.z, 0.0, (-lineDir.x)));
					    highp float angle = atan( perpDir.z, perpDir.x);
					    return angle;
					}
					#line 201
					highp float DistToLine( in highp vec3 P, in highp vec3 A, in highp vec3 B ) {
					    highp vec3 lineDir = (B - A);
					    highp vec3 perpDir = vec3( lineDir.z, 0.0, (-lineDir.x));
					    highp vec3 dirToA = (A - P);
					    #line 205
					    return abs(dot( normalize(perpDir), dirToA));
					}
					#line 215
					PointRelationship GetPointLineRelationship( in highp vec3 p, in highp vec3 q, in highp vec3 r ) {
					    PointRelationship rel;
					    rel.dist = DistToLine( q, p, r);
					    rel.angle = Angle( p, r);
					    #line 219
					    return rel;
					}
					#line 58
					lowp vec4 frag( in v2f i ) {
					    highp vec2 uv = i.uv;
					    #line 62
					    highp float du = (1.0 / _Resolution);
					    highp float dv = (1.0 / _Resolution);
					    highp vec3 duv = vec3( du, dv, 0.0);
					    #line 66
					    highp vec3 localpos = vec3( i.uv.x, 0.0, i.uv.y);
					    PointRelationship perimeterRelationship;
					    PointRelationship tmpRel;
					    #line 70
					    perimeterRelationship.dist = 1000000.0;
					    highp int vi = 0;
					    for ( ; (float(vi) < (_NumVerts - 1.0)); (vi++)) {
					        tmpRel = GetPointLineRelationship( vec3( _PerimeterVerts[vi]), localpos, vec3( _PerimeterVerts[(vi + 1)]));
					        #line 74
					        lowp float distDiff = xll_saturate_f((100000.0 * (perimeterRelationship.dist - tmpRel.dist)));
					        perimeterRelationship.dist = (((1.0 - distDiff) * perimeterRelationship.dist) + (distDiff * tmpRel.dist));
					    }
					    #line 78
					    tmpRel = GetPointLineRelationship( vec3( _PerimeterVerts[int((_NumVerts - 1.0))]), localpos, vec3( _PerimeterVerts[0]));
					    lowp float distDiff_1 = xll_saturate_f((100000.0 * (perimeterRelationship.dist - tmpRel.dist)));
					    perimeterRelationship.dist = (((1.0 - distDiff_1) * perimeterRelationship.dist) + (distDiff_1 * tmpRel.dist));
					    #line 82
					    lowp vec4 col = vec4( (perimeterRelationship.dist * 2.0), 0.0, 0.0, 1.0);
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
					(113,1): error: array index must be < 4
					(114,1): error: array index must be < 4
					(115,1): error: array index must be < 4
					(116,1): error: array index must be < 4
					(122,1): error: array index must be < 5
					(123,1): error: array index must be < 5
					(124,1): error: array index must be < 5
					(125,1): error: array index must be < 5
					(126,1): error: array index must be < 5
					(132,1): error: array index must be < 5
					(133,1): error: array index must be < 5
					(134,1): error: array index must be < 5
					(135,1): error: array index must be < 5
					(136,1): error: array index must be < 5
					(144,1): error: array index must be < 7
					(145,1): error: array index must be < 7
					(146,1): error: array index must be < 7
					(147,1): error: array index must be < 7
					(148,1): error: array index must be < 7
					(149,1): error: array index must be < 7
					(150,1): error: array index must be < 7
					(160,1): error: array index must be < 9
					(161,1): error: array index must be < 9
					(162,1): error: array index must be < 9
					(163,1): error: array index must be < 9
					(164,1): error: array index must be < 9
					(165,1): error: array index must be < 9
					(166,1): error: array index must be < 9
					(167,1): error: array index must be < 9
					(168,1): error: array index must be < 9
					(186,1): error: array index must be < 17
					(187,1): error: array index must be < 17
					(188,1): error: array index must be < 17
					(189,1): error: array index must be < 17
					(190,1): error: array index must be < 17
					(191,1): error: array index must be < 17
					(192,1): error: array index must be < 17
					(193,1): error: array index must be < 17
					(194,1): error: array index must be < 17
					(195,1): error: array index must be < 17
					(196,1): error: array index must be < 17
					(197,1): error: array index must be < 17
					(198,1): error: array index must be < 17
					(199,1): error: array index must be < 17
					(200,1): error: array index must be < 17
					(201,1): error: array index must be < 17
					(202,1): error: array index must be < 17
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
					uniform 	float _NumVerts;
					uniform 	vec4 _PerimeterVerts[128];
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					uint u_xlatu0;
					vec3 u_xlat1;
					vec2 u_xlat2;
					mediump float u_xlat16_3;
					vec3 u_xlat4;
					float u_xlat5;
					float u_xlat8;
					float u_xlat12;
					bool u_xlatb12;
					void main()
					{
					    u_xlat0.x = _NumVerts + -1.0;
					    u_xlat4.x = float(1000000.0);
					    u_xlat4.y = float(0.0);
					    while(true){
					        u_xlat12 = float(floatBitsToInt(u_xlat4).y);
					#ifdef UNITY_ADRENO_ES3
					        u_xlatb12 = !!(u_xlat12>=u_xlat0.x);
					#else
					        u_xlatb12 = u_xlat12>=u_xlat0.x;
					#endif
					        if(u_xlatb12){break;}
					        u_xlat4.z = intBitsToFloat(floatBitsToInt(u_xlat4).y + 1);
					        u_xlat1.xy = (-_PerimeterVerts[floatBitsToInt(u_xlat4).y].xz) + _PerimeterVerts[floatBitsToInt(u_xlat4).z].xz;
					        u_xlat2.xy = (-vs_TEXCOORD0.xy) + _PerimeterVerts[floatBitsToInt(u_xlat4).y].xz;
					        u_xlat1.z = (-u_xlat1.x);
					        u_xlat1.x = dot(u_xlat1.yz, u_xlat1.yz);
					        u_xlat1.x = inversesqrt(u_xlat1.x);
					        u_xlat1.xy = vec2(u_xlat1.x * u_xlat1.y, u_xlat1.x * u_xlat1.z);
					        u_xlat1.x = dot(u_xlat1.xy, u_xlat2.xy);
					        u_xlat5 = u_xlat4.x + -abs(u_xlat1.x);
					        u_xlat5 = u_xlat5 * 100000.0;
					#ifdef UNITY_ADRENO_ES3
					        u_xlat5 = min(max(u_xlat5, 0.0), 1.0);
					#else
					        u_xlat5 = clamp(u_xlat5, 0.0, 1.0);
					#endif
					        u_xlat16_3 = (-u_xlat5) + 1.0;
					        u_xlat1.x = abs(u_xlat1.x) * u_xlat5;
					        u_xlat4.x = u_xlat16_3 * u_xlat4.x + u_xlat1.x;
					        u_xlat4.xy = u_xlat4.xz;
					    }
					    u_xlatu0 = uint(u_xlat0.x);
					    u_xlat1.xy = (-_PerimeterVerts[int(u_xlatu0)].xz) + _PerimeterVerts[0].xz;
					    u_xlat0.xz = (-vs_TEXCOORD0.xy) + _PerimeterVerts[int(u_xlatu0)].xz;
					    u_xlat1.z = (-u_xlat1.x);
					    u_xlat12 = dot(u_xlat1.yz, u_xlat1.yz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xy = vec2(float(u_xlat12) * u_xlat1.y, float(u_xlat12) * u_xlat1.z);
					    u_xlat0.x = dot(u_xlat1.xy, u_xlat0.xz);
					    u_xlat8 = -abs(u_xlat0.x) + u_xlat4.x;
					    u_xlat8 = u_xlat8 * 100000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
					#else
					    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
					#endif
					    u_xlat16_3 = (-u_xlat8) + 1.0;
					    u_xlat0.x = abs(u_xlat0.x) * u_xlat8;
					    u_xlat0.x = u_xlat16_3 * u_xlat4.x + u_xlat0.x;
					    u_xlat0.x = u_xlat0.x + u_xlat0.x;
					    SV_Target0.x = u_xlat0.x;
					    SV_Target0.yzw = vec3(0.0, 0.0, 1.0);
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
					uniform 	float _NumVerts;
					uniform 	vec4 _PerimeterVerts[128];
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					uint u_xlatu0;
					vec3 u_xlat1;
					vec2 u_xlat2;
					mediump float u_xlat16_3;
					vec3 u_xlat4;
					float u_xlat5;
					float u_xlat8;
					float u_xlat12;
					bool u_xlatb12;
					void main()
					{
					    u_xlat0.x = _NumVerts + -1.0;
					    u_xlat4.x = float(1000000.0);
					    u_xlat4.y = float(0.0);
					    while(true){
					        u_xlat12 = float(floatBitsToInt(u_xlat4).y);
					#ifdef UNITY_ADRENO_ES3
					        u_xlatb12 = !!(u_xlat12>=u_xlat0.x);
					#else
					        u_xlatb12 = u_xlat12>=u_xlat0.x;
					#endif
					        if(u_xlatb12){break;}
					        u_xlat4.z = intBitsToFloat(floatBitsToInt(u_xlat4).y + 1);
					        u_xlat1.xy = (-_PerimeterVerts[floatBitsToInt(u_xlat4).y].xz) + _PerimeterVerts[floatBitsToInt(u_xlat4).z].xz;
					        u_xlat2.xy = (-vs_TEXCOORD0.xy) + _PerimeterVerts[floatBitsToInt(u_xlat4).y].xz;
					        u_xlat1.z = (-u_xlat1.x);
					        u_xlat1.x = dot(u_xlat1.yz, u_xlat1.yz);
					        u_xlat1.x = inversesqrt(u_xlat1.x);
					        u_xlat1.xy = vec2(u_xlat1.x * u_xlat1.y, u_xlat1.x * u_xlat1.z);
					        u_xlat1.x = dot(u_xlat1.xy, u_xlat2.xy);
					        u_xlat5 = u_xlat4.x + -abs(u_xlat1.x);
					        u_xlat5 = u_xlat5 * 100000.0;
					#ifdef UNITY_ADRENO_ES3
					        u_xlat5 = min(max(u_xlat5, 0.0), 1.0);
					#else
					        u_xlat5 = clamp(u_xlat5, 0.0, 1.0);
					#endif
					        u_xlat16_3 = (-u_xlat5) + 1.0;
					        u_xlat1.x = abs(u_xlat1.x) * u_xlat5;
					        u_xlat4.x = u_xlat16_3 * u_xlat4.x + u_xlat1.x;
					        u_xlat4.xy = u_xlat4.xz;
					    }
					    u_xlatu0 = uint(u_xlat0.x);
					    u_xlat1.xy = (-_PerimeterVerts[int(u_xlatu0)].xz) + _PerimeterVerts[0].xz;
					    u_xlat0.xz = (-vs_TEXCOORD0.xy) + _PerimeterVerts[int(u_xlatu0)].xz;
					    u_xlat1.z = (-u_xlat1.x);
					    u_xlat12 = dot(u_xlat1.yz, u_xlat1.yz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xy = vec2(float(u_xlat12) * u_xlat1.y, float(u_xlat12) * u_xlat1.z);
					    u_xlat0.x = dot(u_xlat1.xy, u_xlat0.xz);
					    u_xlat8 = -abs(u_xlat0.x) + u_xlat4.x;
					    u_xlat8 = u_xlat8 * 100000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
					#else
					    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
					#endif
					    u_xlat16_3 = (-u_xlat8) + 1.0;
					    u_xlat0.x = abs(u_xlat0.x) * u_xlat8;
					    u_xlat0.x = u_xlat16_3 * u_xlat4.x + u_xlat0.x;
					    u_xlat0.x = u_xlat0.x + u_xlat0.x;
					    SV_Target0.x = u_xlat0.x;
					    SV_Target0.yzw = vec3(0.0, 0.0, 1.0);
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
					uniform 	float _NumVerts;
					uniform 	vec4 _PerimeterVerts[128];
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					uint u_xlatu0;
					vec3 u_xlat1;
					vec2 u_xlat2;
					mediump float u_xlat16_3;
					vec3 u_xlat4;
					float u_xlat5;
					float u_xlat8;
					float u_xlat12;
					bool u_xlatb12;
					void main()
					{
					    u_xlat0.x = _NumVerts + -1.0;
					    u_xlat4.x = float(1000000.0);
					    u_xlat4.y = float(0.0);
					    while(true){
					        u_xlat12 = float(floatBitsToInt(u_xlat4).y);
					#ifdef UNITY_ADRENO_ES3
					        u_xlatb12 = !!(u_xlat12>=u_xlat0.x);
					#else
					        u_xlatb12 = u_xlat12>=u_xlat0.x;
					#endif
					        if(u_xlatb12){break;}
					        u_xlat4.z = intBitsToFloat(floatBitsToInt(u_xlat4).y + 1);
					        u_xlat1.xy = (-_PerimeterVerts[floatBitsToInt(u_xlat4).y].xz) + _PerimeterVerts[floatBitsToInt(u_xlat4).z].xz;
					        u_xlat2.xy = (-vs_TEXCOORD0.xy) + _PerimeterVerts[floatBitsToInt(u_xlat4).y].xz;
					        u_xlat1.z = (-u_xlat1.x);
					        u_xlat1.x = dot(u_xlat1.yz, u_xlat1.yz);
					        u_xlat1.x = inversesqrt(u_xlat1.x);
					        u_xlat1.xy = vec2(u_xlat1.x * u_xlat1.y, u_xlat1.x * u_xlat1.z);
					        u_xlat1.x = dot(u_xlat1.xy, u_xlat2.xy);
					        u_xlat5 = u_xlat4.x + -abs(u_xlat1.x);
					        u_xlat5 = u_xlat5 * 100000.0;
					#ifdef UNITY_ADRENO_ES3
					        u_xlat5 = min(max(u_xlat5, 0.0), 1.0);
					#else
					        u_xlat5 = clamp(u_xlat5, 0.0, 1.0);
					#endif
					        u_xlat16_3 = (-u_xlat5) + 1.0;
					        u_xlat1.x = abs(u_xlat1.x) * u_xlat5;
					        u_xlat4.x = u_xlat16_3 * u_xlat4.x + u_xlat1.x;
					        u_xlat4.xy = u_xlat4.xz;
					    }
					    u_xlatu0 = uint(u_xlat0.x);
					    u_xlat1.xy = (-_PerimeterVerts[int(u_xlatu0)].xz) + _PerimeterVerts[0].xz;
					    u_xlat0.xz = (-vs_TEXCOORD0.xy) + _PerimeterVerts[int(u_xlatu0)].xz;
					    u_xlat1.z = (-u_xlat1.x);
					    u_xlat12 = dot(u_xlat1.yz, u_xlat1.yz);
					    u_xlat12 = inversesqrt(u_xlat12);
					    u_xlat1.xy = vec2(float(u_xlat12) * u_xlat1.y, float(u_xlat12) * u_xlat1.z);
					    u_xlat0.x = dot(u_xlat1.xy, u_xlat0.xz);
					    u_xlat8 = -abs(u_xlat0.x) + u_xlat4.x;
					    u_xlat8 = u_xlat8 * 100000.0;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
					#else
					    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
					#endif
					    u_xlat16_3 = (-u_xlat8) + 1.0;
					    u_xlat0.x = abs(u_xlat0.x) * u_xlat8;
					    u_xlat0.x = u_xlat16_3 * u_xlat4.x + u_xlat0.x;
					    u_xlat0.x = u_xlat0.x + u_xlat0.x;
					    SV_Target0.x = u_xlat0.x;
					    SV_Target0.yzw = vec3(0.0, 0.0, 1.0);
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