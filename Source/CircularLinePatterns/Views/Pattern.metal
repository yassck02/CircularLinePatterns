//
//  Pattern.metal
//  Patterner
//
//  Created by Connor yass on 1/16/19.
//  Copyright © 2019 HSY_Technologies. All rights reserved.
//

#include <metal_stdlib>
#include <metal_math>

#include "../CBColorTools/Gradient/CBGradient.h"

using namespace metal;

struct Uniforms {
    uint gradientCount;
};

struct Pattern {
    uint divisions;
    uint multiple;
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
};

// MARK: -

vertex VertexOut vertex_shader(const device CBGradientKey *K [[ buffer(1) ]],
                               const device Uniforms &U      [[ buffer(2) ]],
                               const device Pattern &P       [[ buffer(3) ]],
                               const unsigned int i          [[ vertex_id ]])
{
    VertexOut vert;
    
    vert.position = float4(x, y, 0, 1);
    vert.color = sample(K, U.gradientCount, n);

    return vert;
}

// MARK: -

fragment float4 fragment_shader(const VertexOut vert [[ stage_in ]]) {
    return vert.color;
}
