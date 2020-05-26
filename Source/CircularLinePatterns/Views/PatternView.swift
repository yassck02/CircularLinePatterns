//
//  ViewBase.swift
//  Patterner
//
//  Created by Connor yass on 3/17/19.
//  Copyright © 2019 HSY_Technologies. All rights reserved.
//

import MetalKit
import SwiftUI
import CBTLogger

// MARK: -

class PatternMTKView: MTKView {
    
    struct Uniforms {
        var gradientCount: uint
    }
    
    // MARK: Properties
    
    var pattern: Pattern
    
    var gradient: CBGradient
    
    var percent: Float = 1.0
    
    // MARK: Variables
    
    var commandQueue: MTLCommandQueue!
    
    var pipelineState: MTLRenderPipelineState!
    
    // MARK: Lifecycle
    
    init(pattern: Pattern, gradient: CBGradient) {
        self.pattern = pattern
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
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        backgroundColor = .clear
        clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        
        do {
            pipelineState = try device!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error as NSError {
            Log.error(error);
        }
        
        commandQueue = device!.makeCommandQueue()
    }
    
    // MARK: Functions
    
    override func draw(_ rect: CGRect) {
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            Log.error("commandQueue.makeCommandBuffer() failed"); return;
        }
        
        guard let renderPassDescriptor = currentRenderPassDescriptor else {
            Log.error("get currentRenderPassDescriptor failed"); return;
        }
        
        renderPassDescriptor.depthAttachment = .none
        
        guard let drawable = currentDrawable else {
            Log.error("get currentDrawable failed"); return;
        }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            Log.error("commandBuffer.makeRenderCommandEncoder(...) failed"); return;
        }
        renderEncoder.setRenderPipelineState(pipelineState)
        
        var uniforms = Uniforms(
            gradientCount: uint(gradient.keys.count)
        )
        
        let vertexCount = Int(Float(pattern.divisions * 2) * percent)
        
        renderEncoder.setVertexBytes(&pattern,       length: MemoryLayout<Pattern>.stride,                              index: 0)
        renderEncoder.setVertexBytes(&gradient.keys, length: MemoryLayout<CBGradient.Key>.stride * gradient.keys.count, index: 1)
        renderEncoder.setVertexBytes(&uniforms,      length: MemoryLayout<Uniforms>.stride,                             index: 2)

        renderEncoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: vertexCount, instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func screenshot() -> UIImage? {
        guard let texture = currentDrawable?.texture else {
            return nil
        }
        
        guard let cgimage = texture.toImage() else {
            return nil
        }
        
        return UIImage(cgImage: cgimage)
    }
}

// MARK: -

struct PatternView: UIViewRepresentable {
    typealias UIViewType = PatternMTKView
    
    @Binding var pattern: Pattern
    
    @ObservedObject var gradient: CBGradient
    
    @Binding var percent: Float
    
    func makeCoordinator() -> PatternView.Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PatternView>) -> PatternMTKView {
        let parent = context.coordinator.parent
        return PatternMTKView(
            pattern: parent.pattern,
            gradient: parent.gradient
        )
    }
    
    func updateUIView(_ uiView: PatternMTKView, context: UIViewRepresentableContext<PatternView>) {
        uiView.pattern = pattern
        uiView.gradient = gradient
        uiView.percent = percent
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
            pattern: .constant(TEST_PATRN),
            gradient: TEST_GRAD,
            percent: .constant(1.0)
        ).previewLayout(.fixed(width: 300, height: 300))
    }
}
#endif
