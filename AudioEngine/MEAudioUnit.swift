//
//  MEAudioUnit.swift
//  AudioEngine
//
//  Created by lai001 on 2019/12/19.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import AVFoundation

class MEAudioUnit: NSObject {
    
    var audioFile: AVAudioFile
    
    var effectUnitGroup: [AVAudioUnit] = []
    
    var playerNode: AVAudioPlayerNode
    
    var processingFormat: AVAudioFormat {
        return audioFile.processingFormat
    }
    
    var sampleRate: Double {
        return processingFormat.sampleRate
    }
    
    var startFrame: AVAudioFramePosition = 0
    
    var numberFrames: AVAudioFrameCount = 0
    
    var when: AVAudioTime = .init()
    
    init(connectingAudioFile: AVAudioFile) {
        self.audioFile = connectingAudioFile
        self.playerNode = AVAudioPlayerNode()
        super.init()
        
        print(connectingAudioFile.processingFormat.formatDescription)
        
        
        self.when = AVAudioTime(sampleTime: AVAudioFramePosition(0), atRate: sampleRate)
        self.numberFrames = AVAudioFrameCount(audioFile.length)
    }
    
}
