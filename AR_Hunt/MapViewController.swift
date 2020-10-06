/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  var targets = [ARItem]()
  let locationManager = CLLocationManager()
  var userLocation: CLLocation?
  var selectedAnnotation: MKAnnotation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    
    if CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
  }

}

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    
    self.userLocation = userLocation.location
    
    let _:MonsterRequest=MonsterRequest(location: self.userLocation) { [weak self] results in

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
