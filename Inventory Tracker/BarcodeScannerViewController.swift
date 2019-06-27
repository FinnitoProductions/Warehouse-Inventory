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

class BarcodeScannerViewController: UIViewController, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var cameraFeed: UIImageView!
    let captureSession = AVCaptureSession()
    @IBOutlet weak var barCodeRawValueLabel: UILabel!
    
    var barcodeDetector : VisionBarcodeDetector = Vision.vision().barcodeDetector(options: VisionBarcodeDetectorOptions(formats: VisionBarcodeFormat.all))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraOutput()
        setupCameraInput()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startCameraSession()
    }
    
    func setupCameraInput() {
        captureSession.beginConfiguration()
        guard let device = getCameraDevice() else { return }
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
        imageLayer.frame = CGRect(x: 0, y: 0, width: self.cameraFeed.frame.size.width, height: self.cameraFeed.frame.size.height)
        imageLayer.videoGravity = .resizeAspectFill
        cameraFeed.layer.addSublayer(imageLayer)
    }
    
    func startCameraSession() {
        captureSession.startRunning()
    }
    
    func detectBarcodes(buffer: CMSampleBuffer) {
        let image = VisionImage(buffer: buffer)
        
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: .back)
        image.metadata = metadata
        
        barcodeDetector.detect(in: image) { barcodes, error in
            guard error == nil, let barcodes = barcodes else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            
            barcodes.forEach { barcode in
                print("found")
                self.barCodeRawValueLabel.text = barcode.rawValue!
                self.barCodeRawValueLabel.textColor = .green
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
    
    private func getCameraDevice() -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: Constants.defaultCameraPos
        ) // filter by desired criteria

        return discoverySession.devices[0]
    }
}
