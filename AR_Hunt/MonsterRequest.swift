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

class MonsterRequest:NSObject {
    
    init(location:CLLocation!, completion:@escaping (Any)->Void){
        
        let coordinates:CLLocationCoordinate2D = location.coordinate
        let latitude:Double = coordinates.latitude
        let longitude:Double = coordinates.longitude
        
        let urlString:String = "http://127.0.0.1:8000/api/v1/monster/"
        
        super.init()
        
        let redirect:Redirector = Redirector(behavior: .follow)

        AF.request(urlString)
        .authenticate(username: "graveyard.harbordev.com", password: "not-needed-yet")
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