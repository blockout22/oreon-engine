#version 430

in vec2 texCoord1;

layout(location = 0) out vec4 fragColor;

uniform sampler2D opaqueSceneTexture;
uniform sampler2D opaqueSceneDepthMap;
uniform sampler2D transparencyLayer;
uniform sampler2D transparencyLayerDepthMap;
uniform sampler2D alphaMap;

const float zfar = 10000;
const float znear = 0.1;

float linearizeDepth(float depth)
{
	return (2 * znear) / (zfar + znear - depth * (zfar - znear));
}

void main()
{
	vec4 opaqueColor 	   = texture(opaqueSceneTexture, texCoord1);
	vec4 transparencyColor = texture(transparencyLayer, texCoord1);
	vec4 opaqueDepth 	   = texture(opaqueSceneDepthMap, texCoord1);
	vec4 transparencyDepth = texture(transparencyLayerDepthMap, texCoord1);
	float alpha 		   = texture(alphaMap, texCoord1).r;
	
	vec4 rgba;
	if (opaqueDepth.r <= transparencyDepth.r){
		rgba = opaqueColor;
	}
	else{
		rgba = transparencyColor + opaqueColor * (1-alpha);
	}
		
	fragColor = rgba;
}