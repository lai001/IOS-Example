//
//  Shaders.metal
//  MetalDemo
//
//  Created by 赖敏聪 on 2019/7/22.
//  Copyright © 2019 l. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

typedef struct
{
    float4 position;
    float2 texCoords;
} VertexIn;

typedef struct
{
    float4 position [[position]];
    float2 texCoords;
}VertexOut;

vertex VertexOut myVertexShader(const device VertexIn* vertexArray [[buffer(0)]],
                                unsigned int vid  [[vertex_id]]){
    
    VertexOut verOut;
    verOut.position = vertexArray[vid].position;
    verOut.texCoords = vertexArray[vid].texCoords;
    return verOut;
    
}

fragment float4 myFragmentShader(
                                 VertexOut vertexIn [[stage_in]],
                                 texture2d<float,access::sample> inputImage [[ texture(0) ]],
                                 sampler textureSampler [[sampler(0)]]
                                 )
{
    float4 color = inputImage.sample(textureSampler, vertexIn.texCoords);
    return color;
}

struct Vertex {
    float4 position [[position]];
    float4 color;
};

// 第一个关键字 "vertex" 指明这个是定点着色器方法, 只能是 "vertex" "fragment" "kernel" 这三种
vertex Vertex vertex_func(constant Vertex *vertices [[buffer(0)]],uint vid [[vertex_id]]){
    return vertices[vid];
}

fragment float4 fragment_func(Vertex vert [[stage_in]]) {
    return vert.color;
}
