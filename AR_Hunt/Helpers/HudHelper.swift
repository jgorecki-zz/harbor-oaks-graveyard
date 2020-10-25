//
//  HudHelper.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/21/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import JGProgressHUD

class HudHelper: NSObject {
    
    static func getTopView() -> UIView{
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController.view
        }
        
        return UIView()
        
    }
    
    static func showSuccess(msg:String) -> Void {
        
        let view:UIView = getTopView()
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.textLabel.text = msg
        hud.show(in: view)
        hud.dismiss(afterDelay: 3.0)
        
    }
    
    static func showError(msg:String) -> Void {
        
        let view:UIView = getTopView()
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.textLabel.text = msg
        hud.show(in: view)
        hud.dismiss(afterDelay: 3.0)
        
    }
    
}
