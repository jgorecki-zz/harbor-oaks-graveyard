//
//  GraveyardViewController.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/5/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation
import AVKit

class MapViewController: UIViewController, UserHelperDelegate {

  @IBOutlet weak var mapView: MKMapView!
  
  var targets = [ARItem]()
  let locationManager = CLLocationManager()
  var userLocation: CLLocation?
  var selectedAnnotation: MKAnnotation?
  var audioPlayer = AVAudioPlayer()
  var playerViewController:AVPlayerViewController!
  var locked:Bool=false
  var userExists:Bool=false
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let userhelper:UserHelper = UserHelper()
    userhelper.delegate = self
    userhelper.create()
    
    mapView.showsCompass = true
    mapView.isScrollEnabled = false
    mapView.isRotateEnabled = false
    
    mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    if CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
    
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    playSoundTrack()

  }
  
  func userIsLoaded() {
    userExists = true
  }
  
  func setup(){
    if locked == false && userExists == true{
      loadMonsters()
      let scale: CLLocationDistance = 20
      let region = MKCoordinateRegion(center: self.userLocation!.coordinate, latitudinalMeters: scale, longitudinalMeters: scale)
      mapView.setRegion(region, animated: true)
      locked = true
    }
  }
  
  func loadMonsters(){
    
    let _:MonsterRequest = MonsterRequest(location: self.userLocation) { [weak self] results in
      guard let strongSelf = self else {return}
      let monsters:Monster = results as! Monster
      let formatter = NumberFormatter()
      formatter.generatesDecimalNumbers = true
      formatter.numberStyle = .decimal
      for monster in monsters.objects {
        let a_latitude:Double = formatter.number(from: monster.latitude)?.doubleValue ?? 0.0
        let a_longitude:Double = formatter.number(from: monster.longitude)?.doubleValue ?? 0.0
        let location:CLLocation = CLLocation(latitude: a_latitude, longitude: a_longitude)
        let creature = ARItem(
          itemDescription: monster.monster,
          location: location,
          itemNode: nil, score: monster.score, image: monster.image)
        let annotation = MapAnnotation(location: creature.location.coordinate, item: creature)
        strongSelf.mapView.addAnnotation(annotation)
      }
    }
    
  }
  
  func playSoundTrack() {
    let sound = Bundle.main.path(forResource: "DarkAmbience", ofType: "mp3")
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
      audioPlayer.play()
      audioPlayer.numberOfLoops = -1
    }catch{
      print(error)
    }
  }
  
  func jumpScare() {
  
    let _:RandomRequest = RandomRequest { [weak self] result in
      
      guard let weakSelf = self else { return }
      
      let random:Random = result as! Random
      let videoURL = URL(string: random.url)
      let player = AVPlayer(url: videoURL!)
      
      weakSelf.playerViewController = AVPlayerViewController()
      weakSelf.playerViewController.player = player
      weakSelf.playerViewController.showsPlaybackControls = false
      
      weakSelf.present((weakSelf.playerViewController)!, animated: false) {
        weakSelf.playerViewController.player!.play()
      }
      
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    
  }
  
  @objc func playerDidFinishPlaying(notification: NSNotification) {
    
    DispatchQueue.main.async{ [self] in
    
      self.playerViewController.dismiss(animated: false, completion: nil)
      
    }
  
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
}


///////////
// Map Kit View Controller Delegate Extensions
extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    self.userLocation = userLocation.location
    if self.userLocation != nil{
      setup()
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
    let coordinate = view.annotation!.coordinate
    
    if let userCoordinate = userLocation {
    
      if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 10 {
        
        let number = Int.random(in: 0..<10)
        
        print(number)
        
        if(number > 8){
          jumpScare()
        
        }else{
        
          if (view.annotation is MKUserLocation) {
          
            print("its a user annotation")
            
          }else{
            
            let viewController = GhostViewController.init()
            let annotation:MapAnnotation = view.annotation as! MapAnnotation
            viewController.ghost = annotation.item
            self.present(viewController, animated: true, completion: nil)
            
          }
    
        }
          
        let sound = Bundle.main.path(forResource: "ghost", ofType: "mp3")
        do {
          let audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
          audioPlayer.play()
          audioPlayer.numberOfLoops = -1
        }catch{
          print(error)
        }
        
      }
    }
  }
}

//extension MapViewController: ViewControllerDelegate {
//  func viewController(controller: ViewController, tappedTarget: ARItem) {
//
//    DispatchQueue.main.async{ [self] in
//      self.dismiss(animated: true, completion: nil)
//      let index = self.targets.firstIndex(where: {$0.itemDescription == tappedTarget.itemDescription})
//      self.targets.remove(at: index!)
//
//      if selectedAnnotation != nil {
//        self.mapView.removeAnnotation(selectedAnnotation!)
//      }
//    }
//
//  }
//}
