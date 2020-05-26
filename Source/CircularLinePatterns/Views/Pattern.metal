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

float getAngle(int i, uint divisions) {
    return (360.0 / float(divisions)) *  float(i);
}

vertex VertexOut vertex_shader(const device Pattern &P       [[ buffer(0) ]],
                               const device CBGradientKey *K [[ buffer(1) ]],
                               const device Uniforms &U      [[ buffer(2) ]],
                               const unsigned int i          [[ vertex_id ]])
{
    VertexOut vert;
    
    float angle;
    int n = ceil(float(i) / 2.0);
    
    if (i % 2 == 0) {
        angle = getAngle(n, P.divisions);
    } else {
        int j = (n * P.multiple) % P.divisions;
        angle = getAngle(j, P.divisions);
    }
        
    vert.position = float4(cos(angle), sin(angle), 0, 1);
    
    float percent = i / (P.divisions * 2.0);
    vert.color = sample(K, U.gradientCount, percent);

    return vert;
}

// MARK: -

fragment float4 fragment_shader(const VertexOut vert [[ stage_in ]]) {
    return vert.color;
}
