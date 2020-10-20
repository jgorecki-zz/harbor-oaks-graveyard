//
//  AppDelegate.swift
//  gust
//
//  Created by Joseph Gorecki on 5/20/20.
//  Copyright © 2020 HarborDev. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    public class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    public class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    public class var isTV: Bool {
        return UIDevice.current.userInterfaceIdiom == .tv
    }

    public class var isCarPlay: Bool {
        return UIDevice.current.userInterfaceIdiom == .carPlay
    }
    
}
