//
//  GPU.swift
//  MetalDemo
//
//  Created by 赖敏聪 on 2019/7/23.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation
import MetalKit
import Metal


class GPU {
    
    static let Device = MTLCreateSystemDefaultDevice()!
    static let CommandQueue: MTLCommandQueue = Device.makeCommandQueue()!
    static let Library: MTLLibrary = Device.makeDefaultLibrary()!
    
    static let MyVertexShader = Library.makeFunction(name: "myVertexShader")
    static let MyFragmentShader = Library.makeFunction(name: "myFragmentShader")
    
    static let vertex_func = Library.makeFunction(name: "vertex_func")
    static let frag_func = Library.makeFunction(name: "fragment_func")
}
