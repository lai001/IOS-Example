//
//  MEAudioEngine.swift
//  MusicTest
//
//  Created by lai001 on 2019/12/19.
//

import UIKit
import AVFoundation

class AVAudioEngineWrapper: NSObject {
    
    static let defalutSettings: [String : Any] = [AVFormatIDKey : kAudioFormatLinearPCM,
                                                  AVSampleRateKey : 44_100,
                                                  AVNumberOfChannelsKey : 2,
                                                  AVLinearPCMBitDepthKey : 32]
    
    let engine: AVAudioEngine = AVAudioEngine()
    
    private(set) var meAudioUnitGroup: [MEAudioUnit] = []
    
    override init() {
        super.init()
    }
    
    func updateSchedulePlayTimeRange(index: Int, startFrame: Int64, numberFrames: Int64, when: AVAudioTime) throws {
        if meAudioUnitGroup.indices.contains(index) {
            meAudioUnitGroup[index].numberFrames = AVAudioFrameCount(numberFrames)
            meAudioUnitGroup[index].startFrame = startFrame
            meAudioUnitGroup[index].when = when
            clearAllPlayernodeScheduledEventsAndStopPlayback()
            schedule()
        } else {
            throw NSError(domain: "AVAudioEngineWrapper ext", code: 131, userInfo: [NSLocalizedDescriptionKey: "incorrect index"])
        }
    }
    
    func schedule() {
        for unit in meAudioUnitGroup {
            unit.playerNode.scheduleSegment(unit.audioFile, startingFrame: unit.startFrame, frameCount: unit.numberFrames, at: unit.when)
        }
    }
    
    func play() throws {
        if !engine.isRunning {
            throw NSError(domain: "AVAudioEngineWrapper ext", code: 109, userInfo: [NSLocalizedDescriptionKey : "cannot play when engine is not running, you may need to call start()"])
        }
        
        for unit in meAudioUnitGroup {
            unit.playerNode.play()
        }
    }
    
    func clearAllPlayernodeScheduledEventsAndStopPlayback() {
        for unit in meAudioUnitGroup {
            unit.playerNode.stop()
        }
    }
    
    func start() throws {
        try engine.start()
    }
    
    func loadResource(from files: [AVAudioFile]) {
        for unit in meAudioUnitGroup {
            unbind(meAudioUnit: unit)
        }
        
        meAudioUnitGroup.removeAll()
        
        for (_, file) in files.enumerated() {
            let unit = MEAudioUnit(connectingAudioFile: file)
            meAudioUnitGroup.append(unit)
        }
        
        for unit in meAudioUnitGroup {
            bind(meAudioUnit: unit)
        }
    }
    
    func calDuration() -> TimeInterval {
        var findMaxResult: (offset: Int, element: MEAudioUnit)?
        
        findMaxResult = meAudioUnitGroup.enumerated().max { (lhs, rhs) -> Bool in
            return lhs.element.when.sampleTime < rhs.element.when.sampleTime || lhs.element.numberFrames < rhs.element.numberFrames
        }
        
        if let findMaxResult = findMaxResult {
            return TimeInterval(AVAudioFramePosition(meAudioUnitGroup[findMaxResult.offset].numberFrames) + findMaxResult.element.when.sampleTime) / 44100.0
        }
        
        return meAudioUnitGroup.reduce(TimeInterval(0.0), { $0 + TimeInterval($1.numberFrames) / TimeInterval(44100) })
    }
    
    func bind(meAudioUnit: MEAudioUnit) {
        var nodeGroup: [AVAudioNode] = []
        
        nodeGroup.append(meAudioUnit.playerNode)
        nodeGroup.append(contentsOf: meAudioUnit.effectUnitGroup)
        
        for node in nodeGroup {
            engine.attach(node)
        }
        nodeGroup.append(engine.mainMixerNode)
        for index in 0..<nodeGroup.count - 1 {
            engine.connect(nodeGroup[index], to: nodeGroup[index + 1], format: meAudioUnit.processingFormat)
        }
    }
    
    func unbind(meAudioUnit: MEAudioUnit) {
        var nodeGroup: [AVAudioNode] = []
        nodeGroup.append(meAudioUnit.playerNode)
        nodeGroup.append(contentsOf: meAudioUnit.effectUnitGroup)
        
        engine.disconnectNodeInput(meAudioUnit.playerNode)
        
        for node in nodeGroup {
            engine.detach(node)
        }
    }
    
    func export(to storeURL: URL,
                commonFormat: AVAudioCommonFormat = .pcmFormatFloat32,
                interleaved: Bool = false,
                settings: [String:Any] = AVAudioEngineWrapper.defalutSettings,
                progress: ((Double) -> Void)? = nil) throws {
        
        let audioFile = try AVAudioFile(forWriting: storeURL,
                                        settings: settings,
                                        commonFormat: commonFormat,
                                        interleaved: interleaved)
        
        
        clearAllPlayernodeScheduledEventsAndStopPlayback()
        let buffer = try prepareRenderToFile(format: audioFile.processingFormat)
        schedule()
        try play()
        try renderTo(buffer, writeTo: audioFile, duration: calDuration(), progress: progress)
    }
    
    func prepareRenderToFile(format: AVAudioFormat, maximumFrameCount: AVAudioFrameCount = 1024) throws -> AVAudioPCMBuffer {
        if engine.isRunning { engine.stop() }
        try engine.enableManualRenderingMode(.offline, format: format, maximumFrameCount: maximumFrameCount)
        
        engine.reset()
        try engine.start()
        
        if let buffer = AVAudioPCMBuffer(pcmFormat: engine.manualRenderingFormat, frameCapacity: engine.manualRenderingMaximumFrameCount) {
            return buffer
        } else {
            throw NSError(domain: "AVAudioEngineWrapper ext", code: 1, userInfo: [NSLocalizedDescriptionKey: "Couldn't create buffer in renderToFile"])
        }
    }
    
    func renderTo(_ buffer: AVAudioPCMBuffer, writeTo audioFile: AVAudioFile, duration: Double, progress: ((Double) -> Void)? = nil) throws {
        let targetSamples = AVAudioFramePosition(duration * engine.manualRenderingFormat.sampleRate)
        
        while audioFile.framePosition < targetSamples {
            
            let framesToRender: AVAudioFrameCount
            
            if targetSamples > AVAudioFrameCount.max {
                framesToRender = min(buffer.frameCapacity, AVAudioFrameCount(AVAudioFramePosition(AVAudioFrameCount.max) - audioFile.framePosition))
            } else {
                framesToRender = min(buffer.frameCapacity, AVAudioFrameCount(targetSamples - audioFile.framePosition))
            }
            
            let status = try engine.renderOffline(framesToRender, to: buffer)
            
            switch status {
            case .success:
                try audioFile.write(from: buffer)
                progress?(min(Double(audioFile.framePosition) / Double(targetSamples), 1.0))
                
            case .cannotDoInCurrentContext:
                continue
                
            case .error, .insufficientDataFromInputNode:
                throw NSError(domain: "AVAudioEngineWrapper ext", code: 1,
                              userInfo: [NSLocalizedDescriptionKey: "renderToFile render error"])
                
            @unknown default:
                throw NSError(domain: "AVAudioEngineWrapper ext", code: 1,
                              userInfo: [NSLocalizedDescriptionKey: "Unknown render result"])
            }
        }
        
        engine.stop()
        engine.disableManualRenderingMode()
    }
    
}
