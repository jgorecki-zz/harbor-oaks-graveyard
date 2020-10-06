//
//  forecast.swift
//  gust
//
//  Created by Joseph Gorecki on 5/21/20.
//  Copyright © 2020 HarborDev. All rights reserved.
//

import Foundation

public struct Monster: Codable{

    public let objects:[Object]
    
    public struct Object : Codable{
        
      public let id:Int
      public let latitude:String
      public let longitude:String
      public let monster:String
      public let image:String
      public let score:Int
        
    }
    
}
