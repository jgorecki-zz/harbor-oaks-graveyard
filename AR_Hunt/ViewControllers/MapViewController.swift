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

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  
  var targets = [ARItem]()
  let locationManager = CLLocationManager()
  var userLocation: CLLocation?
  var selectedAnnotation: MKAnnotation?
  var audioPlayer = AVAudioPlayer()
  var locked:Bool=false
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    mapView.userTrackingMode = MKUserTrackingMode.followWithHeading    
    if CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    playSoundTrack()
  }
  
  func setup(userLocation:MKUserLocation){
    
    self.userLocation = userLocation.location
    
    if locked == false{
    
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
}

// Map Kit View Controller Delegate Extensions
extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    setup(userLocation: userLocation)
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let coordinate = view.annotation!.coordinate
    if let userCoordinate = userLocation {
      if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 50 {
        let viewController = GhostViewController.init()
        let annotation:MapAnnotation = view.annotation as! MapAnnotation
        viewController.ghost = annotation.item
        self.present(viewController, animated: true, completion: nil)
        
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
