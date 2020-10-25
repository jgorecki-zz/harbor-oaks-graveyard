//
//  UploadRequest.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/20/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import CoreLocation
import KeychainSwift

class UploadRequest:NSObject {
    
init(completion:@escaping (Any)->Void){
    
  super.init()
  
  let keychain:KeychainSwift = KeychainSwift()
  let username:String = keychain.get("username")!
  let apikey:String = keychain.get("apikey")!

  let urlString:String = "https://harbor-oaks-graveyard-cms.herokuapp.com/api/v1/upload/"

  let redirect:Redirector = Redirector(behavior: .follow)

  let parameters:Parameters = [:]

  let headers:HTTPHeaders = [
    "Authorization": "ApiKey \(username):\(apikey)",
  ]
  
  AF.request(urlString, method: .get, parameters: parameters, encoding:URLEncoding.queryString, headers: headers)
  .redirect(using: redirect)
  .cURLDescription{ description in
    print(description)
  }.responseData { response in
    print(response)
    switch response.result {
    case .success(let json):
        do {
            let decoder:JSONDecoder = JSONDecoder()
            let uploads = try decoder.decode(Upload.self, from: json)
            completion(uploads)
        }catch let error{
            print(error)
        }
    case .failure(let error):
        print(error)
    }
  }
}
    
}

