//
//  SettingsViewController.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/6/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit
import KeychainSwift
import MessageUI

class SettingsViewController: UIViewController, UITextInputDelegate, MFMailComposeViewControllerDelegate {

  @IBOutlet weak var usernameLabel: UITextField!
  @IBOutlet weak var passwordLabel: UITextField!
  
  let keychain:KeychainSwift = KeychainSwift()
    
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
    
    let _:UsernameRequest = UsernameRequest(username: usernameLabel.text, password: passwordLabel.text) { [weak self] response in

        guard let strongSelf = self else {return}
        
      HudHelper.showSuccess(msg: "Updated")
        strongSelf.mapFormToKeychain()

      }
      
    }
    
  }
  
  @IBAction func didPressReport(_ sender: Any) {
  
    let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
              self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
    
  
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

  func configuredMailComposeViewController() -> MFMailComposeViewController {
          let mailComposerVC = MFMailComposeViewController()
          mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

          mailComposerVC.setToRecipients(["j@harbordev.com"])
          mailComposerVC.setSubject("Sending you an in-app e-mail...")
          mailComposerVC.setMessageBody("The Halloween app is ...", isHTML: false)

          return mailComposerVC
      }

      func showSendMailErrorAlert() {
          
        HudHelper.showError(msg: "Your device can not send an email.")
        
      }

      // MARK: MFMailComposeViewControllerDelegate

      func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismiss(animated: true, completion: nil)

      }
  
}
