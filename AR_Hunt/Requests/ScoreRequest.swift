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

class ScoreRequest:NSObject {
    
  init(score:Int!, completion:@escaping (Any)->Void){
          
    let urlString:String = "https://harbor-oaks-graveyard-cms.herokuapp.com/api/v1/score/"
        
        super.init()
        
        let redirect:Redirector = Redirector(behavior: .follow)

        let parameters = ["score":score]
        
        AF.request(urlString, method: .post, parameters: parameters)
            .authenticate(username: "graveyard.harbordev.com", password: "not-needed-yet")
            .redirect(using: redirect)
            .cURLDescription{ description in
                print(description)
            }.responseData { response in
                print(response)
    //            switch response.result {
    //            case .success(let json):
    //                do {
    //                    let decoder:JSONDecoder = JSONDecoder()
    //                    let monsters = try decoder.decode(Monster.self, from: json)
    //                    completion(monsters)
    //                }catch let error{
    //                    print(error)
    //                }
    //            case .failure(let error):
    //                print(error)
    //            }
        }
    }
    
}
