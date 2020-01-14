//
//  AudioUnitEffectFormat.swift
//  AudioEngine
//
//  Created by 赖敏聪 on 2020/1/14.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import AVFoundation

struct AudioUnitEffectFormat {
    
    static let origin: [AVAudioUnit] = []
    
    static var slow: [AVAudioUnit] {
        let rateEffect = AVAudioUnitVarispeed()
        rateEffect.rate = 0.2
        return [rateEffect]
    }
    
    static var fast: [AVAudioUnit] {
        let rateEffect = AVAudioUnitVarispeed()
        rateEffect.rate = 4.0
        return [rateEffect]
    }
    
    static var toMan: [AVAudioUnit] {
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = -440.9243
        pitchEffect.rate = 1
        pitchEffect.overlap = 8
        return [pitchEffect]
    }
    
    static var ghost: [AVAudioUnit] {
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = 662.71
        pitchEffect.rate = 1
        pitchEffect.overlap = 8
        
        let distortion = AVAudioUnitDistortion()
        distortion.preGain = -6
        distortion.wetDryMix = 30
        distortion.loadFactoryPreset(.multiEcho2)
        
        let delay = AVAudioUnitDelay()
        delay.delayTime = 0.02
        delay.feedback = 80.64
        delay.wetDryMix = 65.13
        
        return [pitchEffect, distortion, delay]
    }

    static var fan: [AVAudioUnit] {
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = 29.04
        pitchEffect.rate = 1
        pitchEffect.overlap = 8
        
        let delay = AVAudioUnitDelay()
        delay.delayTime = 0.01
        delay.feedback = 87.02
        delay.wetDryMix = 65.46
        
        let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(.largeHall)
        reverb.wetDryMix = 50
        
        return [pitchEffect, reverb, delay]
    }
    
}
