//
//  CBColor.metal
//  Patterner
//
//  Created by Connor yass on 5/19/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

#include <metal_stdlib>
#include "CBColor.h"

using namespace metal;

// Converts a CBColor to a float4
float4 convertCBColor(CBColor color) {
    return float4(color.r, color.g, color.b, color.a);
}
