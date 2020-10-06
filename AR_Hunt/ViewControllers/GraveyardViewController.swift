//
//  GraveyardViewController.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/5/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit
import AVFoundation

class GraveyardViewController: UIViewController {

  var cameraSession: AVCaptureSession?
  var cameraLayer: AVCaptureVideoPreviewLayer?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      loadCamera()
      self.cameraSession?.startRunning()
        // Do any additional setup after loading the view.
    }
    

  @IBAction func didPressPow(_ sender: Any) {
    
    let _:ScoreRequest = ScoreRequest(score:5) {[weak self] results in
        print("request sent")
    }
    
  }
  
  func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?) {

    var error: NSError?
    var captureSession: AVCaptureSession?

    let backVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)

    if backVideoDevice != nil {

      var videoInput: AVCaptureDeviceInput!
      do {
        videoInput = try AVCaptureDeviceInput(device: backVideoDevice!)
      } catch let error1 as NSError {
        error = error1
        videoInput = nil
      }

      if error == nil {

        captureSession = AVCaptureSession()

        if captureSession!.canAddInput(videoInput) {
          captureSession!.addInput(videoInput)
        } else {
          error = NSError(domain: "", code: 0, userInfo: ["description": "Error adding video input."])
        }

      } else {
        error = NSError(domain: "", code: 1, userInfo: ["description": "Error creating capture device input."])

      }

    } else {
      error = NSError(domain: "", code: 2, userInfo: ["description": "Back video device not found."])
    }

    return (session: captureSession, error: error)
  }
  
  func loadCamera() {
    
    let captureSessionResult = createCaptureSession()
    
    guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
      print("Error creating capture session")
      return
    }
    
    self.cameraSession = session
    
    let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession!)
    cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    cameraLayer.frame = self.view.bounds
    self.view.layer.insertSublayer(cameraLayer, at: 0)
    self.cameraLayer = cameraLayer
    
  }

}
