//
//  SettingsViewController.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/6/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit
import KeychainSwift
import AVKit
import AVFoundation

class SettingsViewController: UIViewController, UITextInputDelegate {

  @IBOutlet weak var usernameLabel: UITextField!
  @IBOutlet weak var passwordLabel: UITextField!
  
  let keychain:KeychainSwift = KeychainSwift()
  
  var playerViewController:AVPlayerViewController!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    mapFormToKeychain()
    
  }
    
  func mapFormToKeychain() {
    
    let username = keychain.get("username")
    let password = keychain.get("password")
    
    print(keychain.allKeys)
    
    self.usernameLabel.text = username
    self.passwordLabel.text = password
    
  }
  
  @IBAction func didPressSave(_ sender: Any) {
    
    usernameLabel.resignFirstResponder()
    passwordLabel.resignFirstResponder()
    
    if (usernameLabel.text != nil) && (passwordLabel.text != nil){
    
//    let _:UserRequest = UserRequest(username: usernameLabel.text, password: passwordLabel.text) { [weak self] response in
//
//        guard let strongSelf = self else {return}
//
//        strongSelf.mapFormToKeychain()
//
//      }
      
    }
    
  }
  
  @IBAction func jumpScareTest(_ sender: Any) {
  
    let video = Bundle.main.path(forResource: "scare", ofType: "MOV")!
    print(video)
    let videoURL = URL(fileURLWithPath: video)
    let player = AVPlayer(url: videoURL)
    
    playerViewController = AVPlayerViewController()
    playerViewController.player = player
    playerViewController.showsPlaybackControls = false
    
    self.present(playerViewController, animated: false) {
      self.playerViewController.player!.play()
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)

    
  }
  
  @objc func playerDidFinishPlaying(notification: NSNotification) {
    
    self.playerViewController.dismiss(animated: false, completion: nil)
  
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @IBAction func didPressRecreate(_ sender: Any) {
    
    keychain.delete("username")
    keychain.delete("apikey")
    keychain.delete("password")
    
    let _:UserHelper = UserHelper()
  
    mapFormToKeychain()

  }
  
  func selectionWillChange(_ textInput: UITextInput?) {
   
  }
  
  func selectionDidChange(_ textInput: UITextInput?) {
   
  }
  
  func textWillChange(_ textInput: UITextInput?) {
   
  }
  
  func textDidChange(_ textInput: UITextInput?) {
   
  }

}
