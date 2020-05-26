//
//  CBGradient.metal
//  L-System-Studio
//
//  Created by Connor yass on 5/5/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include "../Color/CBColor.h"

#ifndef CBMTLGRADIENT_H
#define CBMTLGRADIENT_H

// Alias: CBGRadient.Key
struct CBGradientKey {
    CBColor color;
    float location;
};

// Returns the color at the given location in a gradient
float4 sample(const device CBGradientKey*, int, float);

#endif
