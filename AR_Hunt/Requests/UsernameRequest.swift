//
//  UserRequest.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/6/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import KeychainSwift

class UsernameRequest:NSObject {
    
  init(username:String!, password:String!, completion:@escaping (Any)->Void){
          
    super.init()
    
    let keychain:KeychainSwift = KeychainSwift()
    let apikey:String = keychain.get("apikey")!
    
    let urlString:String = "https://harbor-oaks-graveyard-cms.herokuapp.com/api/v1/user/update/"
    
    let redirect:Redirector = Redirector(behavior: .follow)

    let parameters = ["username":username,"password":password]
        
    let headers:HTTPHeaders = [
      "Authorization": "ApiKey \(username ?? ""):\(apikey)",
    ]
        AF.request(urlString, method: .post, parameters: parameters, headers: headers)
            .redirect(using: redirect)
            .cURLDescription{ description in
//              print(description)
            }.responseData { response in
//                print(response)
                switch response.result {
                case .success(let json):
                  print(json)
                    do {
                        let decoder:JSONDecoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: response.data!)
                        keychain.set(user.username, forKey: "username")
                        completion(user)
                    }catch let error{
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
}

