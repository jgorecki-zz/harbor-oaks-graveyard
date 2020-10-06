//
//  ScoreRequest.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/5/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import CoreLocation
import KeychainSwift

class ScoreRequest:NSObject {
    
  init(score:Int!, completion:@escaping (Any)->Void){
          
    super.init()
    
    let keychain:KeychainSwift = KeychainSwift()
    let username:String = keychain.get("username")!
    let apikey:String = keychain.get("apikey")!
    
    let urlString:String = "http://127.0.0.1:8000/api/v1/score/post/"
        
    let redirect:Redirector = Redirector(behavior: .follow)

    let parameters = ["score":score!]
    let headers:HTTPHeaders = [
      "Authorization": "ApiKey \(username):\(apikey)",
    ]
    AF.request(urlString, method: .post, parameters: parameters, headers: headers)
        .redirect(using: redirect)
        .cURLDescription{ description in
            print(description)
        }.responseData { response in
            print(response)
        }
    }
    
}
