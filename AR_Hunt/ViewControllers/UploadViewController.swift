//
//  UploadViewController.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/20/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, BaseDataSourceDelegate {

  let dataSource:BaseDataSource = BaseDataSource { (cell, object) in
    let cell:UploadTableViewCell = cell as! UploadTableViewCell
        cell.mapToObject(object: object)
    }
  
  @IBOutlet weak var tableView: UITableView!
  
  var arr:Array<Any>?
  
  override func viewDidLoad() {
      super.viewDidLoad()
      dataSource.delegate = self
      tableView.dataSource = dataSource
      tableView.delegate = dataSource
      
      tableView.register(UINib(nibName: "UploadTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

    }
    

  // MARK: - Datasource callback
  func didSelectTableWithObject(obj: Any, path: IndexPath) {
      
    print(obj)
    
  }
  
  func loadUploads(){
    
    let _:UploadRequest = UploadRequest { [weak self] results in
      
      guard let strongSelf = self else {return}
      let uploads:Upload = results as! Upload
      print(uploads.objects)
      strongSelf.arr = uploads.objects
      strongSelf.tableView.reloadData()
      
    }
    
  }

  
}
