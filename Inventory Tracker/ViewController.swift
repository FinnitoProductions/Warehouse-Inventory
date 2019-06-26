//
//  ViewController.swift
//  Inventory Tracker
//
//  Created by Finn Frankis on 6/25/19.
//  Copyright © 2019 FinnitoProductions. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class ViewController: UIViewController, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var cameraFeed: UIImageView!
    let captureSession = AVCaptureSession()
    lazy var vision = Vision.vision()
    @IBOutlet weak var barCodeRawValueLabel: UILabel!
    
    var barcodeDetector : VisionBarcodeDetector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodeDetector = vision.barcodeDetector(options: VisionBarcodeDetectorOptions(formats: VisionBarcodeFormat.all))
        setupCameraOutput()
        setupCameraInput()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startCameraSession()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupCameraInput() {
        captureSession.beginConfiguration()
        guard let device = self.captureDevice(forPosition: Constants.defaultCameraPos) else {
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
            captureSession.commitConfiguration()
        }
        catch {
            print("Failed")
        }
    }
    
    func setupCameraOutput() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .medium
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: Constants.videoFeedOutputLabel))
        
        captureSession.addOutput(output)
        captureSession.commitConfiguration()
        
        let imageLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        imageLayer.frame = CGRect(x: 0, y: 0, width: self.cameraFeed.frame.size.width + 100, height: self.cameraFeed.frame.size.height)
        imageLayer.videoGravity = .resizeAspectFill
        cameraFeed.layer.addSublayer(imageLayer)
    }
    
    func startCameraSession() {
        captureSession.startRunning()
    }
    
    func startBarcodeCapture() {
        captureSession.sessionPreset = .photo
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(deviceOutput)
        

        
        captureSession.startRunning()
    }
    
    func detectBarcodes(buffer: CMSampleBuffer) {
        let image = VisionImage(buffer: buffer)
        
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: .back)
        image.metadata = metadata
        
        if let barcodeDetector = self.barcodeDetector {
            barcodeDetector.detect(in: image) { barcodes, error in
                guard error == nil, let barcodes = barcodes else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }
                
                
                barcodes.forEach { barcode in
                    print("found")
                    self.barCodeRawValueLabel.text = "\(barcode.rawValue)"
                    self.barCodeRawValueLabel.textColor = .green
                }
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        detectBarcodes(buffer: sampleBuffer)
    }
    
    private func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
        ) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        }
    }
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .unspecified
            )
            return discoverySession.devices.first { $0.position == position }
        }
        return nil
    }
}
