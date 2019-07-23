//
//  ViewController.swift
//  MetalDemo
//
//  Created by 赖敏聪 on 2019/7/23.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
import MetalKit
import AVFoundation
import GLKit
import Metal

struct Vertex {
    var position: vector_float4
    var color: vector_float4
}

class ViewController: UIViewController {
    
    lazy var metalView: MetalView = {
        let view = MetalView(frame: self.view.bounds, device: GPU.Device)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(metalView)
        
    }


}

