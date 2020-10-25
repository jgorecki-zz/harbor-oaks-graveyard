//
//  ScoreViewController.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/25/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

  @IBOutlet weak var pointsLabel: UILabel!
  
  override func viewDidLoad() {
        super.viewDidLoad()

    pointsLabel.text = "0"
    
        // Do any additional setup after loading the view.
    }
    
  override func viewDidAppear(_ animated: Bool) {
    
    let _:ScoreRequest = ScoreRequest(score:0) {[weak self] results in
//      self?.pointsLabel.text =
    }
    
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
