//
//  RandomRequest.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/13/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import CoreLocation
import KeychainSwift

class RandomRequest:NSObject {
    
  init(completion:@escaping (Any)->Void){
          
    super.init()
    
    let keychain:KeychainSwift = KeychainSwift()
    let username:String = keychain.get("username")!
    let apikey:String = keychain.get("apikey")!
    
    let urlString:String = "https://harbor-oaks-graveyard-cms.herokuapp.com/api/v1/upload/random/"
        
    let redirect:Redirector = Redirector(behavior: .follow)
    
    let headers:HTTPHeaders = [
      "Authorization": "ApiKey \(username):\(apikey)",
    ]
    AF.request(urlString, method: .get, headers: headers)
        .redirect(using: redirect)
        .cURLDescription{ description in
            print(description)
        }.responseData { response in
            print(response)
            do {
                let decoder:JSONDecoder = JSONDecoder()
                let user = try decoder.decode(Random.self, from: response.data!)
                completion(user)
            }catch let error{
                print(error)
            }
        }
    }
    
}
