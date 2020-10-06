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

class UserRequest:NSObject {
    
  init(username:String!, password:String!, completion:@escaping (Any)->Void){
          
    super.init()
    
    let urlString:String = "http://127.0.0.1:8000/api/v1/user/register/"
    
    let redirect:Redirector = Redirector(behavior: .follow)

    let parameters = ["username":username,"password":password]
        
        AF.request(urlString, method: .post, parameters: parameters)
            .redirect(using: redirect)
            .cURLDescription{ description in
              print(description)
            }.responseData { response in
//                print(response)
                switch response.result {
                case .success(let json):
                  print(json)
                    do {
                        let decoder:JSONDecoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: response.data!)
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
