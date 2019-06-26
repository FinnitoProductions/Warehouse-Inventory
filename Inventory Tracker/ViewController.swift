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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraFeed: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func detectBarcodes() {
//        let format = VisionBarcodeFormat.all
//        let barcodeOptions = VisionBarcodeDetectorOptions(formats: format)
//        var vision = Vision.vision()
//        let barcodeDetector = vision.barcodeDetector(options: barcodeOptions)
//        let image = VisionImage(image: cameraFeed)
    }

    @IBAction func openPicker(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            cameraFeed.contentMode = .scaleAspectFit
            cameraFeed.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
