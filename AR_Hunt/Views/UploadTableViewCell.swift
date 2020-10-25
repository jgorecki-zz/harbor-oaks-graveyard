//
//  UploadTableViewCell.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/20/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit

class UploadTableViewCell: UITableViewCell, Cellable {
  
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var mainLabel: UILabel!
  
  func mapToObject(object: Any) {
   
    let upload:Upload.Object = object as! Upload.Object

      mainLabel.text = upload.user
      
    }
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
