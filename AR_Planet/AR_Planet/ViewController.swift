//
//  ViewController.swift
//  AR_Planet
//
//  Created by Vampire on 2017/9/4.
//  Copyright © 2017年 hs_itAdmin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    
        let scene = SCNScene()
        
        //创建几何
        let sphere = SCNSphere(radius: 0.1)
        //渲染
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "earth.png")
        sphere.materials = [material]
        //创建节点
        let sphereNode = SCNNode(geometry: sphere)
        //设置节点位置
        sphereNode.position = SCNVector3(0, 0, -0.6)
        //把节点添加到跟节点上面·
        scene.rootNode.addChildNode(sphereNode)
        
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        //添加一个手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(ViewController.handTap(gestureRecognizer:)))
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func handTap(gestureRecognizer:UIGestureRecognizer){
        
        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
        
        //创建一张图片
        let imagePlane = SCNPlane(width: sceneView.bounds.width/6000, height: sceneView.bounds.height/6000)
        //渲染图片
        imagePlane.firstMaterial?.diffuse.contents = sceneView.snapshot() //截屏
        imagePlane.firstMaterial?.lightingModel = .constant
        
        //创建一个节点
        let planeNode = SCNNode(geometry: imagePlane)
        sceneView.scene.rootNode.addChildNode(planeNode)
        //跟踪相机位置
        var translate = matrix_identity_float4x4
        translate.columns.3.z = -0.4
        
        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translate)
        
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

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
