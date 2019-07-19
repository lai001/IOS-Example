//
//  ViewController.swift
//  CameraDemo
//
//  Created by 赖敏聪 on 2019/7/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    class PreviewView: UIView {
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    lazy var preView: PreviewView = {
        let view = PreviewView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 400))
        return view
    }()
    
    lazy var layer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 400)
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        view.addSubview(preView)
        
        view.layer.addSublayer(layer)
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        preView.videoPreviewLayer.session = captureSession
        
        guard #available(iOS 10.2, *) else {
            return
        }
        
        if let device = AVCaptureDevice.default(for: .video) {
            
            do {
                
                let input = try AVCaptureDeviceInput(device: device)
                
                let captureVideoDataOutput = AVCaptureVideoDataOutput()
                captureVideoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)] as [String : Any]
                captureVideoDataOutput.alwaysDiscardsLateVideoFrames = true
                
                captureSession.addOutput(captureVideoDataOutput)
                captureVideoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
                
                
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                    
                    captureSession.startRunning()
                    
                }
                
            } catch {
                
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        layer.contents = image.cgImage
    }
    
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
    {
        
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        
        
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
        
        
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
        
        let width = CVPixelBufferGetWidth(imageBuffer!);
        let height = CVPixelBufferGetHeight(imageBuffer!);
        
        
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        
        let quartzImage = context?.makeImage();
        
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        
        let image = UIImage.init(cgImage: quartzImage!);
        
        return (image);
    }
    
}


extension CMSampleBuffer {
    func image(orientation: UIImage.Orientation = .up,
               scale: CGFloat = 1.0) -> UIImage? {
        if let buffer = CMSampleBufferGetImageBuffer(self) {
            let ciImage = CIImage(cvPixelBuffer: buffer)
            
            return UIImage(ciImage: ciImage,
                           scale: scale,
                           orientation: orientation)
        }
        
        return nil
    }
}
