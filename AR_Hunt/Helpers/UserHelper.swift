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
  
  let keychain:KeychainSwift = KeychainSwift()
  
  override init() {
      
    super.init()
    
    let username_check = keychain.get("username")
    let apikey_check = keychain.get("apikey")
    
    if (username_check == nil) || (apikey_check == nil){
    
      print("creating a placeholder user")
      
      let username:String = ProcessInfo.processInfo.globallyUniqueString
      let password:String = ProcessInfo.processInfo.globallyUniqueString
      
      let _:UserRequest = UserRequest(username: username, password: password) { [weak self] results in
        
        guard let strongSelf = self else {return}
        
        let user:User = results as! User

        strongSelf.keychain.set(user.key, forKey: "apikey")
        strongSelf.keychain.set(user.username, forKey: "username")
        strongSelf.keychain.set(password, forKey: "password")
        
      }
      
    }else{
      
      print("I already have a user")
    
    }
  
  }
  
}
