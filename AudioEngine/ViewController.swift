//
//  ViewController.swift
//  AudioEngine
//
//  Created by lai001 on 2019/12/19.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    lazy var audioFileGroup: [AVAudioFile] = {
        var files: [AVAudioFile] = []
        
        if let url = Bundle.main.url(forResource: "Audio/01.Halcyon - Runaway (Feat. Valentina Franco) (Heuse Remix).mp3",
                                     withExtension: nil),
            let file = try? AVAudioFile(forReading: url)
        {
            files.append(file)
        }
        
        if let url = Bundle.main.url(forResource: "Audio/02.Ellis - Clear My Head (Radio Edit) [NCS].mp3",
                                     withExtension: nil),
            let file = try? AVAudioFile(forReading: url)
        {
            files.append(file)
        }
        
        return files
    }()
    
    let audioEngineWrapper = AVAudioEngineWrapper()
    
    lazy var numberFormatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        return numberFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngineWrapper.loadResource(from: audioFileGroup)
        
        
        try? audioEngineWrapper.updateSchedulePlayTimeRange(index: 0,
                                                            startFrame: 0,
                                                            numberFrames: 44100 * 20,
                                                            when: AVAudioTime(sampleTime: 0, atRate: 44100.0))
        
        try? audioEngineWrapper.updateSchedulePlayTimeRange(index: 1,
                                                            startFrame: 0,
                                                            numberFrames: 44100 * 10,
                                                            when: AVAudioTime(sampleTime: 0, atRate: 44100.0))
    }
    
    func exp() {
        do {
            let baseURL = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let storeURL = baseURL.appendingPathComponent("test1").appendingPathExtension("pcm")
            
            try audioEngineWrapper.export(to: storeURL) { (progress) in
                if progress == 1.0 {
                    print(storeURL.relativePath)
                    let a = UIActivityViewController(activityItems: [storeURL], applicationActivities: nil)
                    self.present(a, animated: true, completion: nil)
                }
            }
            
        } catch _ {
            
        }
    }
    
}
