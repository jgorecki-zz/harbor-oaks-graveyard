//
//  UploadViewController.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/20/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import KeychainSwift
import Alamofire

class UploadViewController: UIViewController, BaseDataSourceDelegate, VideoPickerDelegate {
  
  var videoPicker:VideoPicker?

  let dataSource:BaseDataSource = BaseDataSource { (cell, object) in
    
    let cell:UploadTableViewCell = cell as! UploadTableViewCell
        cell.mapToObject(object: object)
    }
  
  @IBOutlet weak var tableView: UITableView!
  var arr:Array<Any>?
  var audioPlayer = AVAudioPlayer()
  var playerViewController:AVPlayerViewController!
  
  override func viewDidLoad() {
      
    super.viewDidLoad()
      
      dataSource.delegate = self
      tableView.dataSource = dataSource
      tableView.delegate = dataSource
      
      tableView.register(UINib(nibName: "UploadTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    
      self.videoPicker = VideoPicker(presentationController: self, delegate: self)
      
    }
    
  override func viewDidAppear(_ animated: Bool) {
    loadUploads()
  }
  
  @IBAction func uploadButtonPressed(_ sender: Any) {
    
    self.videoPicker!.present(from: self.view)
    
  }
  
  func didSelect(url: URL?) {

    if url != nil {
    
      let fileURL = url
      
      
      let keychain:KeychainSwift = KeychainSwift()
      let username:String = keychain.get("username")!
      let apikey:String = keychain.get("apikey")!

//      print(url)
      
      let headers:HTTPHeaders = [
        "Authorization": "ApiKey \(username):\(apikey)",
      ]

      AF.upload(multipartFormData: { (multipartdata) in
        // add any additional parameters first
        //multipartdata.append(<data>, withName: <Param Name>)
        multipartdata.append(fileURL!, withName: "upload")
      }, to: "https://harbor-oaks-graveyard-cms.herokuapp.com/api/v1/upload/video/", headers: headers).responseJSON { (data) in
          
//        DispatchQueue.main.async{ [self] in
        
//          self.playerViewController.dismiss(animated: true, completion: nil)
          HudHelper.showSuccess(msg: "Video uploaded for processing.")
          
//        }
        
      }
      
    }

  }
  
  // MARK: - Datasource callback
  func didSelectTableWithObject(obj: Any, path: IndexPath) {
      
    let upload:Upload.Object = obj as! Upload.Object
    let url = URL(string: upload.upload)!
    
    jumpScare(url: url)
    
  }
  
  func loadUploads(){
    
    let _:UploadRequest = UploadRequest { [weak self] results in
      
      guard let strongSelf = self else {return}
      let uploads:Upload = results as! Upload
      print(uploads.objects)
      strongSelf.dataSource.arr = uploads.objects
      strongSelf.tableView.reloadData()
      
    }
    
  }
  
  func jumpScare(url:URL) {

  
    let player = AVPlayer(url: url)
    
    playerViewController = AVPlayerViewController()
    playerViewController.player = player
    playerViewController.showsPlaybackControls = true

    self.present((playerViewController)!, animated: true) {
      self.playerViewController.player!.play()
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    
  }
  
  @objc func playerDidFinishPlaying(notification: NSNotification) {
    
    DispatchQueue.main.async{ [self] in
    
      self.playerViewController.dismiss(animated: true, completion: nil)
      
    }
  
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  
}
