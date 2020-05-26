//
//  ViewBase.swift
//  Patterner
//
//  Created by Connor yass on 3/17/19.
//  Copyright © 2019 HSY_Technologies. All rights reserved.
//

import MetalKit
import SwiftUI

// MARK: -

class PatternMTKView: MTKView {
    
    struct Uniforms: Codable {
        var gradientCount: uint
    }
    
    // MARK: Properties
    
    var Pattern: Pattern
    
    var gradient: CBGradient
    
    // MARK: Variables
    
    var commandQueue: MTLCommandQueue!
    
    var pipelineState: MTLRenderPipelineState!
    
    // MARK: Lifecycle
    
    init(Pattern: Pattern, gradient: CBGradient) {
        self.Pattern = Pattern
        self.gradient = gradient
        
        super.init(frame: .zero, device: nil)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        device = MTLCreateSystemDefaultDevice()
        isPaused = true
        enableSetNeedsDisplay = true
        
        let library = device!.makeDefaultLibrary()
        let fragmentProgram = library!.makeFunction(name: "fragment_shader")
        let vertexProgram = library!.makeFunction(name: "vertex_shader")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction   = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        backgroundColor = .clear
        clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        
        do {
            pipelineState = try device!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error as NSError {
            print(error);
        }
        
        commandQueue = device!.makeCommandQueue()
    }
    
    // MARK: Functions
    
    override func draw(_ rect: CGRect) {
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            print("commandQueue.makeCommandBuffer() failed"); return;
        }
        
        guard let renderPassDescriptor = currentRenderPassDescriptor else {
            print("get currentRenderPassDescriptor failed"); return;
        }
        
        renderPassDescriptor.depthAttachment = .none
        
        guard let drawable = currentDrawable else {
            print("get currentDrawable failed"); return;
        }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            print("commandBuffer.makeRenderCommandEncoder(...) failed"); return;
        }
        renderEncoder.setRenderPipelineState(pipelineState)
        
        var uniforms = Uniforms(
            gradientCount: uint(gradient.keys.count)
        )
        
        renderEncoder.setVertexBytes(&gradient.keys, length: MemoryLayout<CBGradient.Key>.stride * gradient.keys.count, index: 1)
        renderEncoder.setVertexBytes(&uniforms,      length: MemoryLayout<Uniforms>.stride,                             index: 2)

        renderEncoder.drawPrimitives(type: .lineStrip, vertexStart: 0, vertexCount: Int(parameters.vertexCount), instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

// MARK: -

struct PatternView: UIViewRepresentable {
    typealias UIViewType = PatternMTKView
    
    @State var Pattern: Pattern
    
    @ObservedObject var gradient: CBGradient
    
    func makeCoordinator() -> PatternView.Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PatternView>) -> PatternMTKView {
        let parent = context.coordinator.parent
        return PatternMTKView(
            Pattern: parent.Pattern,
            gradient: parent.gradient
        )
    }
    
    func updateUIView(_ uiView: PatternMTKView, context: UIViewRepresentableContext<PatternView>) {
        uiView.Pattern = Pattern
        uiView.gradient = gradient
        uiView.setNeedsDisplay()
    }
    
    class Coordinator: NSObject {
        var parent: PatternView
        
        init(_ parent: PatternView) {
            self.parent = parent
        }
    }
}

#if DEBUG
struct PatternView_Previews: PreviewProvider {
    
    static var previews: some View {
        PatternView(
            Pattern: TEST_PATRN,
            gradient: TEST_GRAD
        ).previewLayout(.fixed(width: 300, height: 300))
    }
}
#endif
