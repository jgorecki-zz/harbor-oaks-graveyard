//
//  UserHelper.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/6/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import KeychainSwift

class UserHelper:NSObject {
  
  var username_check:String?
  var apikey_check:String?
  
  override init() {
      
    super.init()
    
    let keychain:KeychainSwift = KeychainSwift()
    
    self.username_check = keychain.get("username")
    self.apikey_check = keychain.get("apikey")
  
  }
  
  func create() {
  
    if (self.username_check == nil) || (self.apikey_check == nil){
    
      print("creating a placeholder user")
      
      let username:String = ProcessInfo.processInfo.globallyUniqueString
      let password:String = ProcessInfo.processInfo.globallyUniqueString
      
      let _:UserRequest = UserRequest(username: username, password: password) { results in
        
        let user:User = results as! User

        print(user)
        
        let keychain:KeychainSwift = KeychainSwift()
        keychain.set(user.key, forKey: "apikey")
        keychain.set(user.username, forKey: "username")
        keychain.set(password, forKey: "password")
        
        print(keychain.allKeys)
        
      }
      
    }else{
      
      print("I already have a user")
    
    }
    
  }
  
}
