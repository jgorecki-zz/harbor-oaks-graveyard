//
//  GhostViewController.swift
//  AR_Hunt
//
//  Created by Joseph Gorecki on 10/8/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class GhostViewController: UIViewController, ARSKViewDelegate {

      @IBOutlet var sceneView: ARSKView!
    
      var ghost:ARItem!
  var texture:SKTexture?
      
      override func viewDidLoad() {
          
        super.viewDidLoad()

        print(ghost.itemDescription)
        
          // Set the view's delegate
          sceneView.delegate = self
          
          // Show statistics such as fps and node count
          sceneView.showsFPS = true
          sceneView.showsNodeCount = true
          
        do{
          let url = URL(string: ghost.image!) //NSURL(string: ghost.image!)
          let data = try Data(contentsOf: url!)
          let image = UIImage(data: data)
          texture = SKTexture(image: image!)
        }catch let error {
          print(error)
        }
        
          let scene = Ghost(size: sceneView.bounds.size)
          scene.scaleMode = .resizeFill
          scene.item = ghost
          sceneView.presentScene(scene)
      
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          // Create a session configuration
          let configuration = ARWorldTrackingConfiguration()
          //configuration.planeDetection = .horizontal
          
          // Run the view's session
          sceneView.session.run(configuration)
      }
      
      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          
          // Pause the view's session
          sceneView.session.pause()
      }
      
      override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Release any cached data, images, etc that aren't in use.
      }
      
      func randomInt(min: Int, max: Int) -> Int {
          return min + Int(arc4random_uniform(UInt32(max - min + 1)))
      }
      
      // MARK: - ARSKViewDelegate
      
      func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
//          let ghostId = randomInt(min: 1, max: 6)
          
//          let node = SKSpriteNode(imageNamed: "ghost\(ghostId)")
//        let node = SKSpriteNode(imageNamed: "ghost1")
        let node = SKSpriteNode(texture: texture)
        node.name = "ghost"
        return node
        
      }
      
      func session(_ session: ARSession, didFailWithError error: Error) {
          // Present an error message to the user
          
      }
      
      func sessionWasInterrupted(_ session: ARSession) {
          // Inform the user that the session has been interrupted, for example, by presenting an overlay
          
      }
      
      func sessionInterruptionEnded(_ session: ARSession) {
          // Reset tracking and/or remove existing anchors if consistent tracking is required
          
      }
  }
