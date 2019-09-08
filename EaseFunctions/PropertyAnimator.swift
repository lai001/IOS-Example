//
//  PropertyAnimator.swift
//  EaseFunctions
//
//  Created by lai001 on 2019/9/8.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

class PropertyAnimator: NSObject {
   
    private var execute: (() -> Bool)?

    private var _forcedInterruption: Bool = false
    
    var isAnimating: Bool {
        return execute != nil
    }
    
    override init() {
        super.init()
    }
    
    func forcedInterruption() {
        if isAnimating {
            _forcedInterruption = true
        }
    }
    
    func startAnimate(step: CGFloat = 0.01,
                      animationFormula: @escaping (CGFloat) -> CGFloat,
                      finish: ((Bool, _ x: CGFloat, _ y: CGFloat) -> Void)? = nil,
                      reply: @escaping (_ x: CGFloat, _ y: CGFloat) -> Void) {
        var initX: CGFloat = -step
        
        execute = { [weak self] in
            guard let self = self else { return true }
            if self._forcedInterruption {
                finish?(false, initX, animationFormula(initX))
                self._forcedInterruption = false
                return true
            }
            initX += step
            initX = min(max(0.0, initX), 1.0)
            reply(initX, animationFormula(initX))
            if initX >= 1.0 {
                finish?(true, initX, animationFormula(initX))
            }
            return initX >= 1.0
        }
        
        CADisplayLink(target: self, selector: #selector(updateProperty(displayLink:))).add(to: RunLoop.main, forMode: .common)
    }
    
    @objc private func updateProperty(displayLink: CADisplayLink) {
        if execute?() ?? true {
            displayLink.invalidate()
            execute = nil
        }
    }
    
}
