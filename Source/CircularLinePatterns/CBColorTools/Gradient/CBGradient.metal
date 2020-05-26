//
//  CBGradient.metal
//  L-System-Studio
//
//  Created by Connor yass on 5/5/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

#include <metal_stdlib>
#include "CBGradient.h"

using namespace metal;

float4 sample(const device CBGradientKey* keys, int keyCount, float _location) {

    if (_location >= 1.0) {
        return convertCBColor(keys[keyCount-1].color);
    } else if (_location <= 0.0) {
        return convertCBColor(keys[0].color);
    }

    float location = min(max(0.0, _location), 1.0);

    int lowerIndex = int(floor(location * float(keyCount)));
    int upperIndex = int(ceil(location * float(keyCount)));

    if (lowerIndex == upperIndex) {
        return convertCBColor(keys[lowerIndex].color);
    }

    float4 colorA = convertCBColor(keys[lowerIndex].color);
    float4 colorB = convertCBColor(keys[upperIndex].color);

    float x = (location - keys[lowerIndex].location) /
        (keys[upperIndex].location - keys[lowerIndex].location);
    
    return mix(colorA, colorB, x);
}

