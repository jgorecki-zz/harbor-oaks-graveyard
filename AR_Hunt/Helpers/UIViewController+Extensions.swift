//
//  AppDelegate.swift
//  gust
//
//  Created by Joseph Gorecki on 5/20/20.
//  Copyright © 2020 HarborDev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlertWithCancel(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithAction(title: String?, message: String?, actionTitles: [String?], actions: [((UIAlertAction) -> Void)?]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActionSheetWithAction(title: String?, message: String?, actionTitles: [String?], actions: [((UIAlertAction) -> Void)?], showInView: UIView) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        
        alert.popoverPresentationController?.sourceView = showInView

        present(alert, animated: true, completion: nil)
        
    }
}
