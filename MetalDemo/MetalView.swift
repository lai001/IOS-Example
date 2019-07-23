//
//  MetalView.swift
//  MetalDemo
//
//  Created by 赖敏聪 on 2019/7/23.
//  Copyright © 2019 none. All rights reserved.
//

import MetalKit

class MetalView: MTKView {
    
    var rps: MTLRenderPipelineState?
    
    var vertexBuffer: MTLBuffer?
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        render()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(){
        
        let vertex_data = [Vertex(position: [-1.0, -1.0, 0.0, 1.0], color: [1, 0, 0, 1]),
                           Vertex(position: [ 1.0, -1.0, 0.0, 1.0], color: [0, 1, 0, 1]),
                           Vertex(position: [ 0.0,  1.0, 0.0, 1.0], color: [0, 0, 1, 1])]
        
        let dataSize = vertex_data.map { (vertex) -> Int in return 8 * MemoryLayout<Float>.size }.reduce(0, +)
        
        vertexBuffer = device?.makeBuffer(bytes: vertex_data, length: dataSize, options: [])
        
        let des = MTLRenderPipelineDescriptor()
        des.vertexFunction = GPU.vertex_func
        des.fragmentFunction = GPU.frag_func
        des.colorAttachments[0].pixelFormat = .bgra8Unorm
        do{
            try rps = device?.makeRenderPipelineState(descriptor: des)
        }catch let error{
            fatalError("\(error)")
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
//            rpd.colorAttachments[0].clearColor = MTLClearColorMake(0, 0.5, 0.5, 1.0)
            let commandBuffer = GPU.CommandQueue.makeCommandBuffer()
            let commandEncode = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            commandEncode?.setRenderPipelineState(rps!)
            commandEncode?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncode?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            commandEncode?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
    
}
