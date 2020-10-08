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

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    
    self.userLocation = userLocation.location
    
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
        
        let creature = ARItem(itemDescription: monster.monster, location: location, itemNode: nil)
        let annotation = MapAnnotation(location: creature.location.coordinate, item: creature)
      
        strongSelf.mapView.addAnnotation(annotation)
        
      }
    
    }
    
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
    let coordinate = view.annotation!.coordinate
    
    if let userCoordinate = userLocation {
      
      if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 50 {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ViewController {
          
          viewController.delegate = self
          
          if let mapAnnotation = view.annotation as? MapAnnotation {
            
            viewController.target = mapAnnotation.item
            viewController.userLocation = mapView.userLocation.location!
            selectedAnnotation = view.annotation
            self.present(viewController, animated: true, completion: nil)
          }
        }
      }
    }
  }
}

extension MapViewController: ViewControllerDelegate {
  func viewController(controller: ViewController, tappedTarget: ARItem) {
    
    DispatchQueue.main.async{ [self] in
      self.dismiss(animated: true, completion: nil)
      let index = self.targets.firstIndex(where: {$0.itemDescription == tappedTarget.itemDescription})
      self.targets.remove(at: index!)
    
      if selectedAnnotation != nil {
        self.mapView.removeAnnotation(selectedAnnotation!)
      }
    }
      
  }
}
