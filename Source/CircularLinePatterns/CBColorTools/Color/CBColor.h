//
//  CBColor.metal
//  L-System-Studio
//
//  Created by Connor yass on 5/5/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#ifndef CBCOLOR_H
#define CBCOLOR_H

struct CBColor {
    float r;
    float g;
    float b;
    float a;
};


// Converts a CBColor to a float4
float4 convertCBColor(CBColor);

#endif
