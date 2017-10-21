//
//  ViewController.swift
//  ARDrawing
//
//  Created by Demick McMullin on 10/2/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, colorPalleteDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var draw: UIButton!
    @IBOutlet var colorPaletteView: UIView!
    @IBOutlet var colorButton: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    var selectedColor: UIColor = .red
    var isColorPaletteOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideColorPalette()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
    }

    @IBAction func colorButtonTapped(_ sender: UIButton) {
        if isColorPaletteOpen {
            hideColorPalette()
        } else {
            showColorPalette()
        }
    }
    
    @IBAction func clearAll(_ sender: Any) {
        self.sceneView.scene.rootNode.enumerateChildNodes( { (node, _) in
                node.removeFromParentNode()
        })
    }
    
    
    @IBAction func draw(_ sender: Any) {
    }
    
    func selectColor(_ sender: ColorPalleteViewController, color: UIColor) {
        DispatchQueue.main.async {
            self.selectedColor = color
            self.colorButton.backgroundColor = color
            if sender.viewIsShowing == false {
                self.hideColorPalette()
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // get position of camera
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        // end get position of camera
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = self.selectedColor
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.position = currentPositionOfCamera
                pointer.name = "pointer"
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "pointer" {
                    node.removeFromParentNode()
                    }
                })
                
                pointer.geometry?.firstMaterial?.diffuse.contents = self.selectedColor
                self.sceneView.scene.rootNode.addChildNode(pointer)
                
            }
        }
    }
    
    func hideColorPalette() {
        UIView.animate(withDuration: 0.4) {
            let transformHeight = self.colorPaletteView.frame.height
            self.colorPaletteView.transform = CGAffineTransform(translationX: 0, y: transformHeight)
        }
    }
    
    func showColorPalette() {
        UIView.animate(withDuration: 0.4) {
            self.colorPaletteView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toColorPalette" {
            guard let destination = segue.destination as? ColorPalleteViewController else { return }
            destination.delegate = self
        }
    }
}
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    

