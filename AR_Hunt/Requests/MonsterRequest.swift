//
//  LocationRequest.swift
//  gust
//
//  Created by Joseph Gorecki on 5/21/20.
//  Copyright © 2020 HarborDev. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import CoreLocation
import KeychainSwift

class MonsterRequest:NSObject {
    
init(location:CLLocation!, completion:@escaping (Any)->Void){
    
  super.init()
  
//  let coordinates:CLLocationCoordinate2D = location.coordinate
//  let latitude:Double = coordinates.latitude
//  let longitude:Double = coordinates.longitude
  let keychain:KeychainSwift = KeychainSwift()
  let username:String = keychain.get("username")!
  let apikey:String = keychain.get("apikey")!

  let urlString:String = "https://harbor-oaks-graveyard-cms.herokuapp.com/api/v1/monster/"

  let redirect:Redirector = Redirector(behavior: .follow)

  //[{"key":"Authorization","value":"ApiKey jgorecki:sdnxcnsfgnfgnfngsfdgmhg","description":"","enabled":true}]
//  let parameters:Parameters = ["latitude":latitude, "longitude":longitude]
  let parameters:Parameters = [:]

  let headers:HTTPHeaders = [
//    "Authorization": "ApiKey \(username):\(apikey)",
//    "Content-Type": "application/json",
//    "Accept": "application/json"
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
            let monsters = try decoder.decode(Monster.self, from: json)
            completion(monsters)
        }catch let error{
            print(error)
        }
    case .failure(let error):
        print(error)
    }
  }
}
    
}
