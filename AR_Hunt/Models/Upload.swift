//
//  Upload.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/20/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation

public struct Upload: Codable{

    public let objects:[Object]
    
    public struct Object : Codable{
        
      public let message:String
      public let success:Bool
      public let url:String
      public let username:String
        
    }
    
}

