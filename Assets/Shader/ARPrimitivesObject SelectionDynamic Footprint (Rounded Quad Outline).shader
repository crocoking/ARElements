Shader "ARPrimitives/Object Selection/Dynamic Footprint (Rounded Quad Outline)" {
	Properties {
		_Color ("Main Color", Vector) = (1,1,1,0.25)
		_Width ("Width", Float) = 1
		_Length ("Length", Float) = 1
		_Height ("Height", Float) = 0.1
		_Sharpness ("Corner Sharpness", Range(0, 1)) = 0
		_Radius ("Corner Radius", Range(0.01, 1)) = 0.5
		_Thickness ("Stroke Thickness", Range(0, 1)) = 0.025
		_FrontIndicatorRange ("Front Indicator Range", Range(0, 1)) = 0.25
		_FrontIndicatorOpacity ("Front Indicator Opacity", Range(0, 1)) = 0.5
		_FrontArrowLength ("Front Arrow Length", Float) = 0
		_FrontArrowWidth ("Front Arrow Width", Float) = 0
		_FrontArrowShape ("Front Arrow Shape", Range(1, 10)) = 1
		_MinScale ("Minimum Scale", Range(0, 1)) = 0.75
		_StartingScaleUniform ("Starting Scale Uniformity", Range(0, 1)) = 1
		_Completion ("Scale Transition", Range(0, 1)) = 1
		_OpacityCompletion ("Opacity Transition", Range(0, 1)) = 0.5
		_GlobalLightEstimationScale ("Global Light Estimation Scale", Range(0, 1)) = 0.25
	}
	SubShader {
		LOD 100
		Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			LOD 100
			Tags { "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 59983
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#version 100
					
					#ifdef VERTEX
					attribute vec4 _glesVertex;
					attribute vec4 _glesMultiTexCoord0;
					uniform highp mat4 unity_ObjectToWorld;
					uniform highp mat4 unity_MatrixVP;
					uniform mediump vec4 _Color;
					uniform highp float _Width;
					uniform highp float _Length;
					uniform highp float _Height;
					uniform highp float _Sharpness;
					uniform highp float _Radius;
					uniform highp float _Thickness;
					uniform highp float _FrontArrowShape;
					uniform highp float _FrontArrowWidth;
					uniform highp float _FrontArrowLength;
					uniform highp float _MinScale;
					uniform highp float _StartingScaleUniform;
					uniform highp float _Completion;
					uniform highp float _OpacityCompletion;
					uniform highp float _GlobalLightEstimation;
					uniform highp float _GlobalLightEstimationScale;
					highp float xlat_mutable_Radius;
					highp float xlat_mutable_StartingScaleUniform;
					varying highp vec2 xlv_TEXCOORD0;
					varying mediump vec4 xlv_COLOR;
					void main ()
					{
					  highp vec4 finalVertexPos_1;
					  mediump vec4 tmpvar_2;
					  highp float tmpvar_3;
					  tmpvar_3 = max (0.0, _Width);
					  highp float tmpvar_4;
					  tmpvar_4 = max (0.0, _Length);
					  highp float tmpvar_5;
					  tmpvar_5 = min (tmpvar_3, tmpvar_4);
					  highp float tmpvar_6;
					  tmpvar_6 = min ((tmpvar_5 * 0.5), _Thickness);
					  highp float tmpvar_7;
					  tmpvar_7 = (1.0 - _Completion);
					  xlat_mutable_StartingScaleUniform = (_StartingScaleUniform * tmpvar_7);
					  highp float tmpvar_8;
					  tmpvar_8 = clamp ((_Completion + (_MinScale * tmpvar_7)), 0.0, 1.0);
					  xlat_mutable_Radius = (min ((tmpvar_5 * 0.5), max (tmpvar_6, _Radius)) * tmpvar_8);
					  highp vec2 tmpvar_9;
					  highp float tmpvar_10;
					  tmpvar_10 = (1.0 - _glesMultiTexCoord0.y);
					  tmpvar_9 = (normalize(_glesVertex.xz) * ((xlat_mutable_Radius * _glesMultiTexCoord0.y) + (
					    max (0.0, (xlat_mutable_Radius - tmpvar_6))
					   * tmpvar_10)));
					  highp vec4 tmpvar_11;
					  tmpvar_11.x = tmpvar_9.x;
					  tmpvar_11.y = (_glesVertex.y * max (0.0, _Height));
					  tmpvar_11.z = tmpvar_9.y;
					  tmpvar_11.w = _glesVertex.w;
					  finalVertexPos_1.yw = tmpvar_11.yw;
					  highp float tmpvar_12;
					  tmpvar_12 = (((
					    (tmpvar_3 * (1.0 - xlat_mutable_StartingScaleUniform))
					   + 
					    ((tmpvar_3 * (tmpvar_5 / tmpvar_3)) * xlat_mutable_StartingScaleUniform)
					  ) * 0.5) * tmpvar_8);
					  highp float tmpvar_13;
					  tmpvar_13 = (((
					    (tmpvar_4 * (1.0 - xlat_mutable_StartingScaleUniform))
					   + 
					    ((tmpvar_4 * (tmpvar_5 / tmpvar_4)) * xlat_mutable_StartingScaleUniform)
					  ) * 0.5) * tmpvar_8);
					  finalVertexPos_1.x = (tmpvar_9.x + ((tmpvar_12 - xlat_mutable_Radius) * sign(tmpvar_9.x)));
					  finalVertexPos_1.z = (tmpvar_9.y + ((tmpvar_13 - xlat_mutable_Radius) * sign(tmpvar_9.y)));
					  highp float tmpvar_14;
					  tmpvar_14 = (1.0 - _Sharpness);
					  highp float tmpvar_15;
					  tmpvar_15 = sign(_glesVertex.x);
					  finalVertexPos_1.x = ((finalVertexPos_1.x * tmpvar_14) + (_Sharpness * (
					    ((tmpvar_15 * tmpvar_12) * _glesMultiTexCoord0.y)
					   + 
					    ((tmpvar_15 * (tmpvar_12 - tmpvar_6)) * tmpvar_10)
					  )));
					  highp float tmpvar_16;
					  tmpvar_16 = sign(_glesVertex.z);
					  finalVertexPos_1.z = ((finalVertexPos_1.z * tmpvar_14) + (_Sharpness * (
					    ((tmpvar_16 * tmpvar_13) * _glesMultiTexCoord0.y)
					   + 
					    ((tmpvar_16 * (tmpvar_13 - tmpvar_6)) * tmpvar_10)
					  )));
					  finalVertexPos_1.z = (finalVertexPos_1.z + ((
					    (max (0.0, sign(finalVertexPos_1.z)) * (pow (max (0.0, 
					      (1.0 - (abs(finalVertexPos_1.x) / _FrontArrowWidth))
					    ), _FrontArrowShape) * _glesMultiTexCoord0.y))
					   * _FrontArrowLength) * _Completion));
					  highp vec4 tmpvar_17;
					  tmpvar_17.w = 1.0;
					  tmpvar_17.xyz = finalVertexPos_1.xyz;
					  tmpvar_2 = (((1.0 - _GlobalLightEstimationScale) * _Color) + ((_GlobalLightEstimationScale * _Color) * _GlobalLightEstimation));
					  tmpvar_2.w = (tmpvar_2.w * _OpacityCompletion);
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_17));
					  xlv_COLOR = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp float _FrontIndicatorRange;
					uniform mediump float _FrontIndicatorOpacity;
					uniform highp float _OpacityCompletion;
					varying highp vec2 xlv_TEXCOORD0;
					varying mediump vec4 xlv_COLOR;
					void main ()
					{
					  mediump float arcRange_1;
					  mediump float uvX_2;
					  mediump vec4 col_3;
					  col_3.xyz = xlv_COLOR.xyz;
					  highp float tmpvar_4;
					  tmpvar_4 = (1.0 - abs((
					    (2.0 * xlv_TEXCOORD0.x)
					   - 1.0)));
					  uvX_2 = tmpvar_4;
					  highp float tmpvar_5;
					  tmpvar_5 = (1.0 - _FrontIndicatorRange);
					  arcRange_1 = tmpvar_5;
					  mediump float tmpvar_6;
					  tmpvar_6 = clamp (((uvX_2 - arcRange_1) / (1.0 - arcRange_1)), 0.0, 1.0);
					  col_3.w = (xlv_COLOR.w + ((
					    clamp (((tmpvar_6 * (tmpvar_6 * 
					      (3.0 - (2.0 * tmpvar_6))
					    )) * 1000.0), 0.0, 1.0)
					   * _FrontIndicatorOpacity) * _OpacityCompletion));
					  gl_FragData[0] = col_3;
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
					uniform mediump vec4 _Color;
					uniform highp float _Width;
					uniform highp float _Length;
					uniform highp float _Height;
					uniform highp float _Sharpness;
					uniform highp float _Radius;
					uniform highp float _Thickness;
					uniform highp float _FrontArrowShape;
					uniform highp float _FrontArrowWidth;
					uniform highp float _FrontArrowLength;
					uniform highp float _MinScale;
					uniform highp float _StartingScaleUniform;
					uniform highp float _Completion;
					uniform highp float _OpacityCompletion;
					uniform highp float _GlobalLightEstimation;
					uniform highp float _GlobalLightEstimationScale;
					highp float xlat_mutable_Radius;
					highp float xlat_mutable_StartingScaleUniform;
					varying highp vec2 xlv_TEXCOORD0;
					varying mediump vec4 xlv_COLOR;
					void main ()
					{
					  highp vec4 finalVertexPos_1;
					  mediump vec4 tmpvar_2;
					  highp float tmpvar_3;
					  tmpvar_3 = max (0.0, _Width);
					  highp float tmpvar_4;
					  tmpvar_4 = max (0.0, _Length);
					  highp float tmpvar_5;
					  tmpvar_5 = min (tmpvar_3, tmpvar_4);
					  highp float tmpvar_6;
					  tmpvar_6 = min ((tmpvar_5 * 0.5), _Thickness);
					  highp float tmpvar_7;
					  tmpvar_7 = (1.0 - _Completion);
					  xlat_mutable_StartingScaleUniform = (_StartingScaleUniform * tmpvar_7);
					  highp float tmpvar_8;
					  tmpvar_8 = clamp ((_Completion + (_MinScale * tmpvar_7)), 0.0, 1.0);
					  xlat_mutable_Radius = (min ((tmpvar_5 * 0.5), max (tmpvar_6, _Radius)) * tmpvar_8);
					  highp vec2 tmpvar_9;
					  highp float tmpvar_10;
					  tmpvar_10 = (1.0 - _glesMultiTexCoord0.y);
					  tmpvar_9 = (normalize(_glesVertex.xz) * ((xlat_mutable_Radius * _glesMultiTexCoord0.y) + (
					    max (0.0, (xlat_mutable_Radius - tmpvar_6))
					   * tmpvar_10)));
					  highp vec4 tmpvar_11;
					  tmpvar_11.x = tmpvar_9.x;
					  tmpvar_11.y = (_glesVertex.y * max (0.0, _Height));
					  tmpvar_11.z = tmpvar_9.y;
					  tmpvar_11.w = _glesVertex.w;
					  finalVertexPos_1.yw = tmpvar_11.yw;
					  highp float tmpvar_12;
					  tmpvar_12 = (((
					    (tmpvar_3 * (1.0 - xlat_mutable_StartingScaleUniform))
					   + 
					    ((tmpvar_3 * (tmpvar_5 / tmpvar_3)) * xlat_mutable_StartingScaleUniform)
					  ) * 0.5) * tmpvar_8);
					  highp float tmpvar_13;
					  tmpvar_13 = (((
					    (tmpvar_4 * (1.0 - xlat_mutable_StartingScaleUniform))
					   + 
					    ((tmpvar_4 * (tmpvar_5 / tmpvar_4)) * xlat_mutable_StartingScaleUniform)
					  ) * 0.5) * tmpvar_8);
					  finalVertexPos_1.x = (tmpvar_9.x + ((tmpvar_12 - xlat_mutable_Radius) * sign(tmpvar_9.x)));
					  finalVertexPos_1.z = (tmpvar_9.y + ((tmpvar_13 - xlat_mutable_Radius) * sign(tmpvar_9.y)));
					  highp float tmpvar_14;
					  tmpvar_14 = (1.0 - _Sharpness);
					  highp float tmpvar_15;
					  tmpvar_15 = sign(_glesVertex.x);
					  finalVertexPos_1.x = ((finalVertexPos_1.x * tmpvar_14) + (_Sharpness * (
					    ((tmpvar_15 * tmpvar_12) * _glesMultiTexCoord0.y)
					   + 
					    ((tmpvar_15 * (tmpvar_12 - tmpvar_6)) * tmpvar_10)
					  )));
					  highp float tmpvar_16;
					  tmpvar_16 = sign(_glesVertex.z);
					  finalVertexPos_1.z = ((finalVertexPos_1.z * tmpvar_14) + (_Sharpness * (
					    ((tmpvar_16 * tmpvar_13) * _glesMultiTexCoord0.y)
					   + 
					    ((tmpvar_16 * (tmpvar_13 - tmpvar_6)) * tmpvar_10)
					  )));
					  finalVertexPos_1.z = (finalVertexPos_1.z + ((
					    (max (0.0, sign(finalVertexPos_1.z)) * (pow (max (0.0, 
					      (1.0 - (abs(finalVertexPos_1.x) / _FrontArrowWidth))
					    ), _FrontArrowShape) * _glesMultiTexCoord0.y))
					   * _FrontArrowLength) * _Completion));
					  highp vec4 tmpvar_17;
					  tmpvar_17.w = 1.0;
					  tmpvar_17.xyz = finalVertexPos_1.xyz;
					  tmpvar_2 = (((1.0 - _GlobalLightEstimationScale) * _Color) + ((_GlobalLightEstimationScale * _Color) * _GlobalLightEstimation));
					  tmpvar_2.w = (tmpvar_2.w * _OpacityCompletion);
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_17));
					  xlv_COLOR = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp float _FrontIndicatorRange;
					uniform mediump float _FrontIndicatorOpacity;
					uniform highp float _OpacityCompletion;
					varying highp vec2 xlv_TEXCOORD0;
					varying mediump vec4 xlv_COLOR;
					void main ()
					{
					  mediump float arcRange_1;
					  mediump float uvX_2;
					  mediump vec4 col_3;
					  col_3.xyz = xlv_COLOR.xyz;
					  highp float tmpvar_4;
					  tmpvar_4 = (1.0 - abs((
					    (2.0 * xlv_TEXCOORD0.x)
					   - 1.0)));
					  uvX_2 = tmpvar_4;
					  highp float tmpvar_5;
					  tmpvar_5 = (1.0 - _FrontIndicatorRange);
					  arcRange_1 = tmpvar_5;
					  mediump float tmpvar_6;
					  tmpvar_6 = clamp (((uvX_2 - arcRange_1) / (1.0 - arcRange_1)), 0.0, 1.0);
					  col_3.w = (xlv_COLOR.w + ((
					    clamp (((tmpvar_6 * (tmpvar_6 * 
					      (3.0 - (2.0 * tmpvar_6))
					    )) * 1000.0), 0.0, 1.0)
					   * _FrontIndicatorOpacity) * _OpacityCompletion));
					  gl_FragData[0] = col_3;
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
					uniform mediump vec4 _Color;
					uniform highp float _Width;
					uniform highp float _Length;
					uniform highp float _Height;
					uniform highp float _Sharpness;
					uniform highp float _Radius;
					uniform highp float _Thickness;
					uniform highp float _FrontArrowShape;
					uniform highp float _FrontArrowWidth;
					uniform highp float _FrontArrowLength;
					uniform highp float _MinScale;
					uniform highp float _StartingScaleUniform;
					uniform highp float _Completion;
					uniform highp float _OpacityCompletion;
					uniform highp float _GlobalLightEstimation;
					uniform highp float _GlobalLightEstimationScale;
					highp float xlat_mutable_Radius;
					highp float xlat_mutable_StartingScaleUniform;
					varying highp vec2 xlv_TEXCOORD0;
					varying mediump vec4 xlv_COLOR;
					void main ()
					{
					  highp vec4 finalVertexPos_1;
					  mediump vec4 tmpvar_2;
					  highp float tmpvar_3;
					  tmpvar_3 = max (0.0, _Width);
					  highp float tmpvar_4;
					  tmpvar_4 = max (0.0, _Length);
					  highp float tmpvar_5;
					  tmpvar_5 = min (tmpvar_3, tmpvar_4);
					  highp float tmpvar_6;
					  tmpvar_6 = min ((tmpvar_5 * 0.5), _Thickness);
					  highp float tmpvar_7;
					  tmpvar_7 = (1.0 - _Completion);
					  xlat_mutable_StartingScaleUniform = (_StartingScaleUniform * tmpvar_7);
					  highp float tmpvar_8;
					  tmpvar_8 = clamp ((_Completion + (_MinScale * tmpvar_7)), 0.0, 1.0);
					  xlat_mutable_Radius = (min ((tmpvar_5 * 0.5), max (tmpvar_6, _Radius)) * tmpvar_8);
					  highp vec2 tmpvar_9;
					  highp float tmpvar_10;
					  tmpvar_10 = (1.0 - _glesMultiTexCoord0.y);
					  tmpvar_9 = (normalize(_glesVertex.xz) * ((xlat_mutable_Radius * _glesMultiTexCoord0.y) + (
					    max (0.0, (xlat_mutable_Radius - tmpvar_6))
					   * tmpvar_10)));
					  highp vec4 tmpvar_11;
					  tmpvar_11.x = tmpvar_9.x;
					  tmpvar_11.y = (_glesVertex.y * max (0.0, _Height));
					  tmpvar_11.z = tmpvar_9.y;
					  tmpvar_11.w = _glesVertex.w;
					  finalVertexPos_1.yw = tmpvar_11.yw;
					  highp float tmpvar_12;
					  tmpvar_12 = (((
					    (tmpvar_3 * (1.0 - xlat_mutable_StartingScaleUniform))
					   + 
					    ((tmpvar_3 * (tmpvar_5 / tmpvar_3)) * xlat_mutable_StartingScaleUniform)
					  ) * 0.5) * tmpvar_8);
					  highp float tmpvar_13;
					  tmpvar_13 = (((
					    (tmpvar_4 * (1.0 - xlat_mutable_StartingScaleUniform))
					   + 
					    ((tmpvar_4 * (tmpvar_5 / tmpvar_4)) * xlat_mutable_StartingScaleUniform)
					  ) * 0.5) * tmpvar_8);
					  finalVertexPos_1.x = (tmpvar_9.x + ((tmpvar_12 - xlat_mutable_Radius) * sign(tmpvar_9.x)));
					  finalVertexPos_1.z = (tmpvar_9.y + ((tmpvar_13 - xlat_mutable_Radius) * sign(tmpvar_9.y)));
					  highp float tmpvar_14;
					  tmpvar_14 = (1.0 - _Sharpness);
					  highp float tmpvar_15;
					  tmpvar_15 = sign(_glesVertex.x);
					  finalVertexPos_1.x = ((finalVertexPos_1.x * tmpvar_14) + (_Sharpness * (
					    ((tmpvar_15 * tmpvar_12) * _glesMultiTexCoord0.y)
					   + 
					    ((tmpvar_15 * (tmpvar_12 - tmpvar_6)) * tmpvar_10)
					  )));
					  highp float tmpvar_16;
					  tmpvar_16 = sign(_glesVertex.z);
					  finalVertexPos_1.z = ((finalVertexPos_1.z * tmpvar_14) + (_Sharpness * (
					    ((tmpvar_16 * tmpvar_13) * _glesMultiTexCoord0.y)
					   + 
					    ((tmpvar_16 * (tmpvar_13 - tmpvar_6)) * tmpvar_10)
					  )));
					  finalVertexPos_1.z = (finalVertexPos_1.z + ((
					    (max (0.0, sign(finalVertexPos_1.z)) * (pow (max (0.0, 
					      (1.0 - (abs(finalVertexPos_1.x) / _FrontArrowWidth))
					    ), _FrontArrowShape) * _glesMultiTexCoord0.y))
					   * _FrontArrowLength) * _Completion));
					  highp vec4 tmpvar_17;
					  tmpvar_17.w = 1.0;
					  tmpvar_17.xyz = finalVertexPos_1.xyz;
					  tmpvar_2 = (((1.0 - _GlobalLightEstimationScale) * _Color) + ((_GlobalLightEstimationScale * _Color) * _GlobalLightEstimation));
					  tmpvar_2.w = (tmpvar_2.w * _OpacityCompletion);
					  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
					  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_17));
					  xlv_COLOR = tmpvar_2;
					}
					
					
					#endif
					#ifdef FRAGMENT
					uniform highp float _FrontIndicatorRange;
					uniform mediump float _FrontIndicatorOpacity;
					uniform highp float _OpacityCompletion;
					varying highp vec2 xlv_TEXCOORD0;
					varying mediump vec4 xlv_COLOR;
					void main ()
					{
					  mediump float arcRange_1;
					  mediump float uvX_2;
					  mediump vec4 col_3;
					  col_3.xyz = xlv_COLOR.xyz;
					  highp float tmpvar_4;
					  tmpvar_4 = (1.0 - abs((
					    (2.0 * xlv_TEXCOORD0.x)
					   - 1.0)));
					  uvX_2 = tmpvar_4;
					  highp float tmpvar_5;
					  tmpvar_5 = (1.0 - _FrontIndicatorRange);
					  arcRange_1 = tmpvar_5;
					  mediump float tmpvar_6;
					  tmpvar_6 = clamp (((uvX_2 - arcRange_1) / (1.0 - arcRange_1)), 0.0, 1.0);
					  col_3.w = (xlv_COLOR.w + ((
					    clamp (((tmpvar_6 * (tmpvar_6 * 
					      (3.0 - (2.0 * tmpvar_6))
					    )) * 1000.0), 0.0, 1.0)
					   * _FrontIndicatorOpacity) * _OpacityCompletion));
					  gl_FragData[0] = col_3;
					}
					
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	float _Width;
					uniform 	float _Length;
					uniform 	float _Height;
					uniform 	float _Sharpness;
					uniform 	float _Radius;
					uniform 	float _Thickness;
					uniform 	float _FrontArrowShape;
					uniform 	float _FrontArrowWidth;
					uniform 	float _FrontArrowLength;
					uniform 	float _MinScale;
					uniform 	float _StartingScaleUniform;
					uniform 	float _Completion;
					uniform 	float _OpacityCompletion;
					uniform 	float _GlobalLightEstimation;
					uniform 	float _GlobalLightEstimationScale;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					float u_xlat2;
					ivec2 u_xlati2;
					vec2 u_xlat3;
					ivec2 u_xlati3;
					vec4 u_xlat4;
					float u_xlat5;
					float u_xlat7;
					vec2 u_xlat10;
					int u_xlati10;
					vec2 u_xlat11;
					ivec2 u_xlati11;
					float u_xlat12;
					ivec2 u_xlati13;
					float u_xlat15;
					int u_xlati15;
					float u_xlat16;
					float u_xlat17;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0.x = dot(in_POSITION0.xz, in_POSITION0.xz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xy = u_xlat0.xx * in_POSITION0.xz;
					    u_xlat1.xyz = max(vec3(_Width, _Length, _Height), vec3(0.0, 0.0, 0.0));
					    u_xlat10.x = min(u_xlat1.y, u_xlat1.x);
					    u_xlat15 = u_xlat10.x * 0.5;
					    u_xlat16 = min(u_xlat15, _Thickness);
					    u_xlat2 = max(u_xlat16, _Radius);
					    u_xlat15 = min(u_xlat15, u_xlat2);
					    u_xlat2 = (-_Completion) + 1.0;
					    u_xlat7 = _MinScale * u_xlat2 + _Completion;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
					#else
					    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
					#endif
					    u_xlat12 = u_xlat15 * u_xlat7 + (-u_xlat16);
					    u_xlat15 = u_xlat15 * u_xlat7;
					    u_xlat12 = max(u_xlat12, 0.0);
					    u_xlat17 = (-in_TEXCOORD0.y) + 1.0;
					    u_xlat12 = u_xlat17 * u_xlat12;
					    u_xlat12 = u_xlat15 * in_TEXCOORD0.y + u_xlat12;
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat12);
					    u_xlati3.xy = ivec2(uvec2(lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat0.xyxx).xy) * 0xFFFFFFFFu);
					    u_xlati13.xy = ivec2(uvec2(lessThan(u_xlat0.xyxy, vec4(0.0, 0.0, 0.0, 0.0)).xy) * 0xFFFFFFFFu);
					    u_xlati3.xy = (-u_xlati3.xy) + u_xlati13.xy;
					    u_xlat3.xy = vec2(u_xlati3.xy);
					    u_xlat12 = (-_StartingScaleUniform) * u_xlat2 + 1.0;
					    u_xlat2 = u_xlat2 * _StartingScaleUniform;
					    u_xlat10.x = u_xlat10.x * u_xlat2;
					    u_xlat1.xy = u_xlat1.xy * vec2(u_xlat12) + u_xlat10.xx;
					    u_xlat10.x = u_xlat1.z * in_POSITION0.y;
					    u_xlat4 = u_xlat10.xxxx * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat1.xy = vec2(u_xlat7) * u_xlat1.xy;
					    u_xlat10.xy = u_xlat1.xy * vec2(0.5, 0.5) + (-vec2(u_xlat15));
					    u_xlat0.xy = u_xlat10.xy * u_xlat3.xy + u_xlat0.xy;
					    u_xlat10.xy = u_xlat1.xy * vec2(0.5, 0.5) + (-vec2(u_xlat16));
					    u_xlat1.xy = u_xlat1.xy * vec2(0.5, 0.5);
					    u_xlati11.xy = ivec2(uvec2(lessThan(vec4(0.0, 0.0, 0.0, 0.0), in_POSITION0.xzxz).xy) * 0xFFFFFFFFu);
					    u_xlati2.xy = ivec2(uvec2(lessThan(in_POSITION0.xzxx, vec4(0.0, 0.0, 0.0, 0.0)).xy) * 0xFFFFFFFFu);
					    u_xlati11.xy = (-u_xlati11.xy) + u_xlati2.xy;
					    u_xlat11.xy = vec2(u_xlati11.xy);
					    u_xlat10.xy = u_xlat10.xy * u_xlat11.xy;
					    u_xlat1.xy = u_xlat1.xy * u_xlat11.xy;
					    u_xlat10.xy = vec2(u_xlat17) * u_xlat10.xy;
					    u_xlat10.xy = u_xlat1.xy * in_TEXCOORD0.yy + u_xlat10.xy;
					    u_xlat10.xy = u_xlat10.xy * vec2(vec2(_Sharpness, _Sharpness));
					    u_xlat1.x = (-_Sharpness) + 1.0;
					    u_xlat0.xy = u_xlat0.xy * u_xlat1.xx + u_xlat10.xy;
					#ifdef UNITY_ADRENO_ES3
					    { bool cond = 0.0<u_xlat0.y; u_xlati10 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
					#else
					    u_xlati10 = int((0.0<u_xlat0.y) ? 0xFFFFFFFFu : uint(0u));
					#endif
					#ifdef UNITY_ADRENO_ES3
					    { bool cond = u_xlat0.y<0.0; u_xlati15 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
					#else
					    u_xlati15 = int((u_xlat0.y<0.0) ? 0xFFFFFFFFu : uint(0u));
					#endif
					    u_xlati10 = (-u_xlati10) + u_xlati15;
					    u_xlati10 = max(u_xlati10, 0);
					    u_xlat10.x = float(u_xlati10);
					    u_xlat15 = abs(u_xlat0.x) / _FrontArrowWidth;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = max(u_xlat15, 0.0);
					    u_xlat15 = log2(u_xlat15);
					    u_xlat15 = u_xlat15 * _FrontArrowShape;
					    u_xlat15 = exp2(u_xlat15);
					    u_xlat15 = u_xlat15 * in_TEXCOORD0.y;
					    u_xlat10.x = u_xlat15 * u_xlat10.x;
					    u_xlat10.x = u_xlat10.x * _FrontArrowLength;
					    u_xlat5 = u_xlat10.x * _Completion + u_xlat0.y;
					    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat4;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * vec4(u_xlat5) + u_xlat1;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat0 = _Color * vec4(_GlobalLightEstimationScale);
					    u_xlat0 = u_xlat0 * vec4(vec4(_GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation));
					    u_xlat1.x = (-_GlobalLightEstimationScale) + 1.0;
					    u_xlat0 = u_xlat1.xxxx * _Color + u_xlat0;
					    u_xlat0.w = u_xlat0.w * _OpacityCompletion;
					    vs_COLOR0 = u_xlat0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	float _FrontIndicatorRange;
					uniform 	mediump float _FrontIndicatorOpacity;
					uniform 	float _OpacityCompletion;
					in highp vec2 vs_TEXCOORD0;
					in mediump vec4 vs_COLOR0;
					layout(location = 0) out mediump vec4 SV_Target0;
					float u_xlat0;
					mediump float u_xlat16_1;
					float u_xlat2;
					mediump float u_xlat16_3;
					void main()
					{
					    u_xlat0 = vs_TEXCOORD0.x * 2.0 + -1.0;
					    u_xlat0 = -abs(u_xlat0) + 1.0;
					    u_xlat2 = (-_FrontIndicatorRange) + 1.0;
					    u_xlat16_1 = (-u_xlat2) + u_xlat0;
					    u_xlat16_3 = (-u_xlat2) + 1.0;
					    u_xlat16_3 = float(1.0) / u_xlat16_3;
					    u_xlat16_1 = u_xlat16_3 * u_xlat16_1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1 = min(max(u_xlat16_1, 0.0), 1.0);
					#else
					    u_xlat16_1 = clamp(u_xlat16_1, 0.0, 1.0);
					#endif
					    u_xlat16_3 = u_xlat16_1 * -2.0 + 3.0;
					    u_xlat16_1 = u_xlat16_1 * u_xlat16_1;
					    u_xlat16_1 = u_xlat16_1 * u_xlat16_3;
					    u_xlat16_1 = u_xlat16_1 * 1000.0;
					    u_xlat16_1 = min(u_xlat16_1, 1.0);
					    u_xlat16_1 = u_xlat16_1 * _FrontIndicatorOpacity;
					    u_xlat0 = u_xlat16_1 * _OpacityCompletion + vs_COLOR0.w;
					    SV_Target0.w = u_xlat0;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Width;
					uniform 	float _Length;
					uniform 	float _Height;
					uniform 	float _Sharpness;
					uniform 	float _Radius;
					uniform 	float _Thickness;
					uniform 	float _FrontArrowShape;
					uniform 	float _FrontArrowWidth;
					uniform 	float _FrontArrowLength;
					uniform 	float _MinScale;
					uniform 	float _StartingScaleUniform;
					uniform 	float _Completion;
					uniform 	float _OpacityCompletion;
					uniform 	float _GlobalLightEstimation;
					uniform 	float _GlobalLightEstimationScale;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					float u_xlat2;
					ivec2 u_xlati2;
					vec2 u_xlat3;
					ivec2 u_xlati3;
					vec4 u_xlat4;
					float u_xlat5;
					float u_xlat7;
					vec2 u_xlat10;
					int u_xlati10;
					vec2 u_xlat11;
					ivec2 u_xlati11;
					float u_xlat12;
					ivec2 u_xlati13;
					float u_xlat15;
					int u_xlati15;
					float u_xlat16;
					float u_xlat17;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0.x = dot(in_POSITION0.xz, in_POSITION0.xz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xy = u_xlat0.xx * in_POSITION0.xz;
					    u_xlat1.xyz = max(vec3(_Width, _Length, _Height), vec3(0.0, 0.0, 0.0));
					    u_xlat10.x = min(u_xlat1.y, u_xlat1.x);
					    u_xlat15 = u_xlat10.x * 0.5;
					    u_xlat16 = min(u_xlat15, _Thickness);
					    u_xlat2 = max(u_xlat16, _Radius);
					    u_xlat15 = min(u_xlat15, u_xlat2);
					    u_xlat2 = (-_Completion) + 1.0;
					    u_xlat7 = _MinScale * u_xlat2 + _Completion;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
					#else
					    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
					#endif
					    u_xlat12 = u_xlat15 * u_xlat7 + (-u_xlat16);
					    u_xlat15 = u_xlat15 * u_xlat7;
					    u_xlat12 = max(u_xlat12, 0.0);
					    u_xlat17 = (-in_TEXCOORD0.y) + 1.0;
					    u_xlat12 = u_xlat17 * u_xlat12;
					    u_xlat12 = u_xlat15 * in_TEXCOORD0.y + u_xlat12;
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat12);
					    u_xlati3.xy = ivec2(uvec2(lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat0.xyxx).xy) * 0xFFFFFFFFu);
					    u_xlati13.xy = ivec2(uvec2(lessThan(u_xlat0.xyxy, vec4(0.0, 0.0, 0.0, 0.0)).xy) * 0xFFFFFFFFu);
					    u_xlati3.xy = (-u_xlati3.xy) + u_xlati13.xy;
					    u_xlat3.xy = vec2(u_xlati3.xy);
					    u_xlat12 = (-_StartingScaleUniform) * u_xlat2 + 1.0;
					    u_xlat2 = u_xlat2 * _StartingScaleUniform;
					    u_xlat10.x = u_xlat10.x * u_xlat2;
					    u_xlat1.xy = u_xlat1.xy * vec2(u_xlat12) + u_xlat10.xx;
					    u_xlat10.x = u_xlat1.z * in_POSITION0.y;
					    u_xlat4 = u_xlat10.xxxx * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat1.xy = vec2(u_xlat7) * u_xlat1.xy;
					    u_xlat10.xy = u_xlat1.xy * vec2(0.5, 0.5) + (-vec2(u_xlat15));
					    u_xlat0.xy = u_xlat10.xy * u_xlat3.xy + u_xlat0.xy;
					    u_xlat10.xy = u_xlat1.xy * vec2(0.5, 0.5) + (-vec2(u_xlat16));
					    u_xlat1.xy = u_xlat1.xy * vec2(0.5, 0.5);
					    u_xlati11.xy = ivec2(uvec2(lessThan(vec4(0.0, 0.0, 0.0, 0.0), in_POSITION0.xzxz).xy) * 0xFFFFFFFFu);
					    u_xlati2.xy = ivec2(uvec2(lessThan(in_POSITION0.xzxx, vec4(0.0, 0.0, 0.0, 0.0)).xy) * 0xFFFFFFFFu);
					    u_xlati11.xy = (-u_xlati11.xy) + u_xlati2.xy;
					    u_xlat11.xy = vec2(u_xlati11.xy);
					    u_xlat10.xy = u_xlat10.xy * u_xlat11.xy;
					    u_xlat1.xy = u_xlat1.xy * u_xlat11.xy;
					    u_xlat10.xy = vec2(u_xlat17) * u_xlat10.xy;
					    u_xlat10.xy = u_xlat1.xy * in_TEXCOORD0.yy + u_xlat10.xy;
					    u_xlat10.xy = u_xlat10.xy * vec2(vec2(_Sharpness, _Sharpness));
					    u_xlat1.x = (-_Sharpness) + 1.0;
					    u_xlat0.xy = u_xlat0.xy * u_xlat1.xx + u_xlat10.xy;
					#ifdef UNITY_ADRENO_ES3
					    { bool cond = 0.0<u_xlat0.y; u_xlati10 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
					#else
					    u_xlati10 = int((0.0<u_xlat0.y) ? 0xFFFFFFFFu : uint(0u));
					#endif
					#ifdef UNITY_ADRENO_ES3
					    { bool cond = u_xlat0.y<0.0; u_xlati15 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
					#else
					    u_xlati15 = int((u_xlat0.y<0.0) ? 0xFFFFFFFFu : uint(0u));
					#endif
					    u_xlati10 = (-u_xlati10) + u_xlati15;
					    u_xlati10 = max(u_xlati10, 0);
					    u_xlat10.x = float(u_xlati10);
					    u_xlat15 = abs(u_xlat0.x) / _FrontArrowWidth;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = max(u_xlat15, 0.0);
					    u_xlat15 = log2(u_xlat15);
					    u_xlat15 = u_xlat15 * _FrontArrowShape;
					    u_xlat15 = exp2(u_xlat15);
					    u_xlat15 = u_xlat15 * in_TEXCOORD0.y;
					    u_xlat10.x = u_xlat15 * u_xlat10.x;
					    u_xlat10.x = u_xlat10.x * _FrontArrowLength;
					    u_xlat5 = u_xlat10.x * _Completion + u_xlat0.y;
					    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat4;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * vec4(u_xlat5) + u_xlat1;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat0 = _Color * vec4(_GlobalLightEstimationScale);
					    u_xlat0 = u_xlat0 * vec4(vec4(_GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation));
					    u_xlat1.x = (-_GlobalLightEstimationScale) + 1.0;
					    u_xlat0 = u_xlat1.xxxx * _Color + u_xlat0;
					    u_xlat0.w = u_xlat0.w * _OpacityCompletion;
					    vs_COLOR0 = u_xlat0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	float _FrontIndicatorRange;
					uniform 	mediump float _FrontIndicatorOpacity;
					uniform 	float _OpacityCompletion;
					in highp vec2 vs_TEXCOORD0;
					in mediump vec4 vs_COLOR0;
					layout(location = 0) out mediump vec4 SV_Target0;
					float u_xlat0;
					mediump float u_xlat16_1;
					float u_xlat2;
					mediump float u_xlat16_3;
					void main()
					{
					    u_xlat0 = vs_TEXCOORD0.x * 2.0 + -1.0;
					    u_xlat0 = -abs(u_xlat0) + 1.0;
					    u_xlat2 = (-_FrontIndicatorRange) + 1.0;
					    u_xlat16_1 = (-u_xlat2) + u_xlat0;
					    u_xlat16_3 = (-u_xlat2) + 1.0;
					    u_xlat16_3 = float(1.0) / u_xlat16_3;
					    u_xlat16_1 = u_xlat16_3 * u_xlat16_1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1 = min(max(u_xlat16_1, 0.0), 1.0);
					#else
					    u_xlat16_1 = clamp(u_xlat16_1, 0.0, 1.0);
					#endif
					    u_xlat16_3 = u_xlat16_1 * -2.0 + 3.0;
					    u_xlat16_1 = u_xlat16_1 * u_xlat16_1;
					    u_xlat16_1 = u_xlat16_1 * u_xlat16_3;
					    u_xlat16_1 = u_xlat16_1 * 1000.0;
					    u_xlat16_1 = min(u_xlat16_1, 1.0);
					    u_xlat16_1 = u_xlat16_1 * _FrontIndicatorOpacity;
					    u_xlat0 = u_xlat16_1 * _OpacityCompletion + vs_COLOR0.w;
					    SV_Target0.w = u_xlat0;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Width;
					uniform 	float _Length;
					uniform 	float _Height;
					uniform 	float _Sharpness;
					uniform 	float _Radius;
					uniform 	float _Thickness;
					uniform 	float _FrontArrowShape;
					uniform 	float _FrontArrowWidth;
					uniform 	float _FrontArrowLength;
					uniform 	float _MinScale;
					uniform 	float _StartingScaleUniform;
					uniform 	float _Completion;
					uniform 	float _OpacityCompletion;
					uniform 	float _GlobalLightEstimation;
					uniform 	float _GlobalLightEstimationScale;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					float u_xlat2;
					ivec2 u_xlati2;
					vec2 u_xlat3;
					ivec2 u_xlati3;
					vec4 u_xlat4;
					float u_xlat5;
					float u_xlat7;
					vec2 u_xlat10;
					int u_xlati10;
					vec2 u_xlat11;
					ivec2 u_xlati11;
					float u_xlat12;
					ivec2 u_xlati13;
					float u_xlat15;
					int u_xlati15;
					float u_xlat16;
					float u_xlat17;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0.x = dot(in_POSITION0.xz, in_POSITION0.xz);
					    u_xlat0.x = inversesqrt(u_xlat0.x);
					    u_xlat0.xy = u_xlat0.xx * in_POSITION0.xz;
					    u_xlat1.xyz = max(vec3(_Width, _Length, _Height), vec3(0.0, 0.0, 0.0));
					    u_xlat10.x = min(u_xlat1.y, u_xlat1.x);
					    u_xlat15 = u_xlat10.x * 0.5;
					    u_xlat16 = min(u_xlat15, _Thickness);
					    u_xlat2 = max(u_xlat16, _Radius);
					    u_xlat15 = min(u_xlat15, u_xlat2);
					    u_xlat2 = (-_Completion) + 1.0;
					    u_xlat7 = _MinScale * u_xlat2 + _Completion;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
					#else
					    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
					#endif
					    u_xlat12 = u_xlat15 * u_xlat7 + (-u_xlat16);
					    u_xlat15 = u_xlat15 * u_xlat7;
					    u_xlat12 = max(u_xlat12, 0.0);
					    u_xlat17 = (-in_TEXCOORD0.y) + 1.0;
					    u_xlat12 = u_xlat17 * u_xlat12;
					    u_xlat12 = u_xlat15 * in_TEXCOORD0.y + u_xlat12;
					    u_xlat0.xy = u_xlat0.xy * vec2(u_xlat12);
					    u_xlati3.xy = ivec2(uvec2(lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat0.xyxx).xy) * 0xFFFFFFFFu);
					    u_xlati13.xy = ivec2(uvec2(lessThan(u_xlat0.xyxy, vec4(0.0, 0.0, 0.0, 0.0)).xy) * 0xFFFFFFFFu);
					    u_xlati3.xy = (-u_xlati3.xy) + u_xlati13.xy;
					    u_xlat3.xy = vec2(u_xlati3.xy);
					    u_xlat12 = (-_StartingScaleUniform) * u_xlat2 + 1.0;
					    u_xlat2 = u_xlat2 * _StartingScaleUniform;
					    u_xlat10.x = u_xlat10.x * u_xlat2;
					    u_xlat1.xy = u_xlat1.xy * vec2(u_xlat12) + u_xlat10.xx;
					    u_xlat10.x = u_xlat1.z * in_POSITION0.y;
					    u_xlat4 = u_xlat10.xxxx * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat1.xy = vec2(u_xlat7) * u_xlat1.xy;
					    u_xlat10.xy = u_xlat1.xy * vec2(0.5, 0.5) + (-vec2(u_xlat15));
					    u_xlat0.xy = u_xlat10.xy * u_xlat3.xy + u_xlat0.xy;
					    u_xlat10.xy = u_xlat1.xy * vec2(0.5, 0.5) + (-vec2(u_xlat16));
					    u_xlat1.xy = u_xlat1.xy * vec2(0.5, 0.5);
					    u_xlati11.xy = ivec2(uvec2(lessThan(vec4(0.0, 0.0, 0.0, 0.0), in_POSITION0.xzxz).xy) * 0xFFFFFFFFu);
					    u_xlati2.xy = ivec2(uvec2(lessThan(in_POSITION0.xzxx, vec4(0.0, 0.0, 0.0, 0.0)).xy) * 0xFFFFFFFFu);
					    u_xlati11.xy = (-u_xlati11.xy) + u_xlati2.xy;
					    u_xlat11.xy = vec2(u_xlati11.xy);
					    u_xlat10.xy = u_xlat10.xy * u_xlat11.xy;
					    u_xlat1.xy = u_xlat1.xy * u_xlat11.xy;
					    u_xlat10.xy = vec2(u_xlat17) * u_xlat10.xy;
					    u_xlat10.xy = u_xlat1.xy * in_TEXCOORD0.yy + u_xlat10.xy;
					    u_xlat10.xy = u_xlat10.xy * vec2(vec2(_Sharpness, _Sharpness));
					    u_xlat1.x = (-_Sharpness) + 1.0;
					    u_xlat0.xy = u_xlat0.xy * u_xlat1.xx + u_xlat10.xy;
					#ifdef UNITY_ADRENO_ES3
					    { bool cond = 0.0<u_xlat0.y; u_xlati10 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
					#else
					    u_xlati10 = int((0.0<u_xlat0.y) ? 0xFFFFFFFFu : uint(0u));
					#endif
					#ifdef UNITY_ADRENO_ES3
					    { bool cond = u_xlat0.y<0.0; u_xlati15 = int(!!cond ? 0xFFFFFFFFu : uint(0u)); }
					#else
					    u_xlati15 = int((u_xlat0.y<0.0) ? 0xFFFFFFFFu : uint(0u));
					#endif
					    u_xlati10 = (-u_xlati10) + u_xlati15;
					    u_xlati10 = max(u_xlati10, 0);
					    u_xlat10.x = float(u_xlati10);
					    u_xlat15 = abs(u_xlat0.x) / _FrontArrowWidth;
					    u_xlat15 = (-u_xlat15) + 1.0;
					    u_xlat15 = max(u_xlat15, 0.0);
					    u_xlat15 = log2(u_xlat15);
					    u_xlat15 = u_xlat15 * _FrontArrowShape;
					    u_xlat15 = exp2(u_xlat15);
					    u_xlat15 = u_xlat15 * in_TEXCOORD0.y;
					    u_xlat10.x = u_xlat15 * u_xlat10.x;
					    u_xlat10.x = u_xlat10.x * _FrontArrowLength;
					    u_xlat5 = u_xlat10.x * _Completion + u_xlat0.y;
					    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * u_xlat0.xxxx + u_xlat4;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * vec4(u_xlat5) + u_xlat1;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    u_xlat0 = _Color * vec4(_GlobalLightEstimationScale);
					    u_xlat0 = u_xlat0 * vec4(vec4(_GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation, _GlobalLightEstimation));
					    u_xlat1.x = (-_GlobalLightEstimationScale) + 1.0;
					    u_xlat0 = u_xlat1.xxxx * _Color + u_xlat0;
					    u_xlat0.w = u_xlat0.w * _OpacityCompletion;
					    vs_COLOR0 = u_xlat0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp int;
					uniform 	float _FrontIndicatorRange;
					uniform 	mediump float _FrontIndicatorOpacity;
					uniform 	float _OpacityCompletion;
					in highp vec2 vs_TEXCOORD0;
					in mediump vec4 vs_COLOR0;
					layout(location = 0) out mediump vec4 SV_Target0;
					float u_xlat0;
					mediump float u_xlat16_1;
					float u_xlat2;
					mediump float u_xlat16_3;
					void main()
					{
					    u_xlat0 = vs_TEXCOORD0.x * 2.0 + -1.0;
					    u_xlat0 = -abs(u_xlat0) + 1.0;
					    u_xlat2 = (-_FrontIndicatorRange) + 1.0;
					    u_xlat16_1 = (-u_xlat2) + u_xlat0;
					    u_xlat16_3 = (-u_xlat2) + 1.0;
					    u_xlat16_3 = float(1.0) / u_xlat16_3;
					    u_xlat16_1 = u_xlat16_3 * u_xlat16_1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1 = min(max(u_xlat16_1, 0.0), 1.0);
					#else
					    u_xlat16_1 = clamp(u_xlat16_1, 0.0, 1.0);
					#endif
					    u_xlat16_3 = u_xlat16_1 * -2.0 + 3.0;
					    u_xlat16_1 = u_xlat16_1 * u_xlat16_1;
					    u_xlat16_1 = u_xlat16_1 * u_xlat16_3;
					    u_xlat16_1 = u_xlat16_1 * 1000.0;
					    u_xlat16_1 = min(u_xlat16_1, 1.0);
					    u_xlat16_1 = u_xlat16_1 * _FrontIndicatorOpacity;
					    u_xlat0 = u_xlat16_1 * _OpacityCompletion + vs_COLOR0.w;
					    SV_Target0.w = u_xlat0;
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