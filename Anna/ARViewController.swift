//
//  ARViewController.swift
//  Anna
//
//  Created by Harin Wu on 2020-03-18.
//  Copyright © 2020 Hao Wu. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class ARViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    //2. Create Our ARWorld Tracking Configuration & Session
    let configuration = ARWorldTrackingConfiguration()
    let augmentedRealitySession = ARSession()
    
    //3. Create A Reference To Our PlaneNode
    var planeNode: SCNNode?
    var planeGeomeryImage: UIImage?
    
    var ballNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupARSession()
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

           view.addGestureRecognizer(tap)

           view.isUserInteractionEnabled = true

    }
    
    override func didReceiveMemoryWarning()  { super.didReceiveMemoryWarning() }
    
    func setupARSession(){
        //1. Run Our Session
        sceneView.session = augmentedRealitySession
        augmentedRealitySession.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        //1. Check We Have A Valid Image
        let selectedImage = UIImage(named: "Us")
        
        //2. We Havent Created Our PlaneNode So Create It
        if planeNode == nil{
            
            
            //a. Create An SCNPlane Geometry
            let planeGeometry = SCNPlane(width: 0.5, height: 0.5)
            
            //b. Set's It's Contents To The Picked Image
            planeGeometry.firstMaterial?.diffuse.contents = self.correctlyOrientated(selectedImage!)
            
            //c. Set The Geometry & Add It To The Scene
            self.planeNode = SCNNode()
            self.planeNode?.geometry = planeGeometry
            self.sceneView.scene.rootNode.addChildNode(self.planeNode!)
            self.planeNode?.position = SCNVector3(0, 0, -1.5)
            
        }
        
    }
    
    /// Correctly Orientates A UIImage
    ///
    /// - Parameter image: UIImage
    /// - Returns: UIImage?
    func correctlyOrientated(_ image: UIImage) -> UIImage {
        if (image.imageOrientation == .up) { return image }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
  

    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "Back", sender: self)
      }
    
}
