//
//  ViewBase.swift
//  Spirographer
//
//  Created by Connor yass on 3/17/19.
//  Copyright © 2019 HSY_Technologies. All rights reserved.
//

import SwiftUI
import MetalKit

struct Uniforms: Codable { }

final class LifeMTKView: MTKView {
    
    // MARK: Properties
    
    let gridSize = CGSize(width: 100, height: 100)
    
    // MARK: Variables
    
    private let vertexData: [Float] = [
        -1.0, -1.0, 0.0, 1.0,  1.0, -1.0, 0.0, 1.0,
        -1.0,  1.0, 0.0, 1.0, -1.0,  1.0, 0.0, 1.0,
         1.0, -1.0, 0.0, 1.0,  1.0,  1.0, 0.0, 1.0
    ]
    
    var vertexBuffer: MTLBuffer!
    
    private var commandQueue: MTLCommandQueue!
    
    private var pipelineState: MTLRenderPipelineState!
    
    private var computeState: MTLComputePipelineState!
    
    private var generationA: MTLTexture!
    
    private var generationB: MTLTexture!
    
    private(set) var generation = 0
    
    private func getTexture(nextGeneration: Bool = false) -> MTLTexture {
        if nextGeneration {
            return generation % 2 == 0 ? generationB : generationA
        } else {
            return generation % 2 == 0 ? generationA : generationB
        }
    }
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero, device: nil)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        device = MTLCreateSystemDefaultDevice()
        //isPaused = true
        //enableSetNeedsDisplay = true
        
        let dataSize = vertexData.count * MemoryLayout<Float>.size
        vertexBuffer = device!.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
        
        let library = device!.makeDefaultLibrary()
        let fragmentProgram = library!.makeFunction(name: "fragment_shader")
        let vertexProgram = library!.makeFunction(name: "vertex_shader")
        let computeFunction = library!.makeFunction(name: "compute_function")
        
        clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        backgroundColor = .clear
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
            computeState = try device!.makeComputePipelineState(function: computeFunction!)
        } catch let error as NSError {
            print(error);
        }
        
        commandQueue = device!.makeCommandQueue()
        
        (generationA, generationB) = Self.makeTextures(
            device: device!,
            width: Int(gridSize.width),
            height: Int(gridSize.height)
        )
        
        restart(random: true)
    }
    
    static func makeTextures(device: MTLDevice, width: Int, height: Int) -> (MTLTexture, MTLTexture) {
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.storageMode = .shared
        textureDescriptor.usage = [.shaderWrite, .shaderRead]
        textureDescriptor.pixelFormat = .r8Uint
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.depth = 1
        
        let generationA = device.makeTexture(descriptor: textureDescriptor)!
        let generationB = device.makeTexture(descriptor: textureDescriptor)!
        
        return (generationA, generationB)
    }
    
    // MARK: Functions
    
    func restart(random: Bool) {
        generation = 0
        var seed = [UInt8](repeating: 0, count: Int(gridSize.width) * Int(gridSize.height))
        if random {
            let numberOfCells = Int(gridSize.width) * Int(gridSize.height)
            let numberOfLiveCells = Int(pow(Double(numberOfCells), 0.8))
            for _ in (0..<numberOfLiveCells) {
                let r = (0..<numberOfCells).randomElement()!
                seed[r] = 1
            }
        }
        getTexture().replace(
            region: MTLRegionMake2D(0, 0, Int(gridSize.width), Int(gridSize.height)),
            mipmapLevel: 0,
            withBytes: seed,
            bytesPerRow: Int(gridSize.width) * MemoryLayout<UInt8>.stride
        )
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let buffer = commandQueue.makeCommandBuffer(),
            let renderPassDescriptor = currentRenderPassDescriptor,
            let renderEncoder = buffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            else { return }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentTexture(getTexture(), index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        renderEncoder.endEncoding()
        
        guard let computeEncoder = buffer.makeComputeCommandEncoder() else { return }
        
        computeEncoder.setComputePipelineState(computeState)
        computeEncoder.setTexture(getTexture(), index: 0)
        computeEncoder.setTexture(getTexture(nextGeneration: true), index: 1)
        
        let threadWidth = computeState.threadExecutionWidth
        let threadHeight = computeState.maxTotalThreadsPerThreadgroup / threadWidth
        let threadsPerThreadgroup = MTLSizeMake(threadWidth, threadHeight, 1)
        let threadsPerGrid = MTLSizeMake(Int(gridSize.width), Int(gridSize.height), 1)
        
        computeEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        computeEncoder.endEncoding()
        
        guard let drawable = currentDrawable else {
            print("get currentDrawable failed"); return;
        }
        
        buffer.present(drawable)
        buffer.commit()
        
        generation += 1
    }
}

// MARK: -

struct LifeView: UIViewRepresentable {
    typealias UIViewType = LifeMTKView
    
    func makeCoordinator() -> LifeView.Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<LifeView>) -> LifeMTKView {
        return LifeMTKView()
    }
    
    func updateUIView(_ uiView: LifeMTKView, context: UIViewRepresentableContext<LifeView>) {
        uiView.setNeedsDisplay()
    }
    
    class Coordinator: NSObject {
        var parent: LifeView
        
        init(_ parent: LifeView) {
            self.parent = parent
        }
    }
}

#if DEBUG
struct LifeView_Previews: PreviewProvider {
    
    static var previews: some View {
        LifeView()
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
#endif
