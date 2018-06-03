//
//  ARSceneViewController.swift
//  ARInstruction
//
//  Created by Ray on 2018/6/2.
//  Copyright © 2018年 top.rayzhao. All rights reserved.
//

import UIKit
import ARKit

class ARSceneViewController: UIViewController,  ARSCNViewDelegate{
    var infoNode = SCNNode()
    var boardOneNode = SCNNode()
    var boardTwoNode = SCNNode()
    var connectorNode = SCNNode()
    var item_name: String = ""
    var content: String = ""
    var time_cost: Int = 0
    var item_id: Int = 0
    var next_item: Int = 0
    var product_id: Int = 0
    
    @IBOutlet weak var nextStepButton: UIButton!
    
    @IBOutlet weak var nextItemTipLabel: UILabel!
    @IBOutlet weak var ARSceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ARSceneView.delegate = self
        ARSceneView.showsStatistics = true
        setupARScene()
        if self.item_id == 4 {
            nextStepButton.setTitle("完成啦", for: .normal)
        }
        // Do any additional setup after loading the view.
        nextItemTipLabel.text = "请扫描编号为\(self.next_item)的二维码"
    }

    func setupARScene() {
        
        // The floating Label
        var stringToDisplay = ""
        var timeCostString = ""
        if time_cost == 0 {
            timeCostString = "小于1分钟"
        } else {
            timeCostString = String(time_cost)
        }
        if self.item_id == 0 {
            stringToDisplay = "名称: " + self.content + "\n总计预计时间: " + timeCostString + "分钟"
        } else {
            stringToDisplay = "过程: " + self.content + "\n该步预计时间: " + timeCostString + "分钟"
        }
        
        let text = SCNText(string: stringToDisplay, extrusionDepth: 0.5)
        text.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        text.containerFrame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200.0))
        text.chamferRadius = 1.0
        text.isWrapped = true
        text.flatness = 0.1
        infoNode.geometry = text
        infoNode.scale = SCNVector3(0.05, 0.05, 0.05)
        infoNode.position = SCNVector3(-0.5, -10, -10)
        ARSceneView.scene.rootNode.addChildNode(infoNode)
        
        if item_id == 1 {
            step1()
            
//            let connectorGeometry = SCNCylinder(radius: 0.03, height: 0.1)
//            material.diffuse.contents = UIColor.gray
//            connectorGeometry.materials = [material]
//            let connectorNode1 = SCNNode(geometry: connectorGeometry)
//            let connectorNode2 = SCNNode(geometry: connectorGeometry)
//            let connectorNode3 = SCNNode(geometry: connectorGeometry)
//            let connectorNode4 = SCNNode(geometry: connectorGeometry)
            
        } else if item_id == 2 {
            step1()
            let board2Geometry = SCNBox(width: 0.1, height: 0.6, length: 0.8, chamferRadius: 0.0)
            let board2Node = SCNNode(geometry: board2Geometry)
            board2Node.position = SCNVector3(0.8, -1.8, -1.52)
            
            let repeatActions = [SCNAction.move(by: SCNVector3(-0.8, 0, 0), duration: 1.5), SCNAction.move(by: SCNVector3(0.8, 0, 0), duration: 0)]
            var actions = [SCNAction.repeatForever(SCNAction.group(repeatActions))]

            board2Node.runAction(SCNAction.group(actions))
            ARSceneView.scene.rootNode.addChildNode(board2Node)
        } else if item_id == 3 {
            let board1Geometry = SCNBox(width: 1.5, height: 0.1, length: 0.8 , chamferRadius: 0.0)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white
            board1Geometry.materials = [material]
            let board1Node = SCNNode(geometry: board1Geometry)
            board1Node.position = SCNVector3(0, -2, -1.5)
            
            let board2Geometry = SCNBox(width: 0.1, height: 0.6, length: 0.8, chamferRadius: 0.0)
            let board2Node = SCNNode(geometry: board2Geometry)
            board2Node.position = SCNVector3(0.75, 0.25, 0.03)
            board1Node.addChildNode(board2Node)
            
            ARSceneView.scene.rootNode.addChildNode(board1Node)
            
            let actions = [SCNAction.rotateBy(x: 0, y: 0, z: -.pi/2, duration: 1)]
            board1Node.runAction(SCNAction.group(actions))
            let board3Geometry = SCNBox(width: 0.5, height: 1.5, length: 0.1, chamferRadius: 0.0)
            let board3Node = SCNNode(geometry: board3Geometry)
            board3Node.position = SCNVector3(0.3, -2, -1.1)
            board3Node.opacity = 0
            ARSceneView.scene.rootNode.addChildNode(board3Node)
            let actions2 = [SCNAction.fadeIn(duration: 2)]
            let actions3 = [SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1), SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 0)]
            let actionRepeat = [SCNAction.repeatForever(SCNAction.group(actions3))]
            let actionAll = SCNAction.sequence([SCNAction.group(actions2), SCNAction.group(actionRepeat)])
            board3Node.runAction(actionAll)
        } else if item_id == 4 {
            let board1Geometry = SCNBox(width: 1.5, height: 0.1, length: 0.8 , chamferRadius: 0.0)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white
            board1Geometry.materials = [material]
            let board1Node = SCNNode(geometry: board1Geometry)
            board1Node.position = SCNVector3(0, -2, -1.5)
            
            let board2Geometry = SCNBox(width: 0.1, height: 0.6, length: 0.8, chamferRadius: 0.0)
            let board2Node = SCNNode(geometry: board2Geometry)
            board2Node.position = SCNVector3(0.75, 0.25, 0.03)
            board1Node.addChildNode(board2Node)
            ARSceneView.scene.rootNode.addChildNode(board1Node)
            var actions = [SCNAction.rotateBy(x: 0, y: 0, z: -.pi/2, duration: 0)]
            board1Node.runAction(SCNAction.group(actions))
            let board3Geometry = SCNBox(width: 0.5, height: 1.5, length: 0.1, chamferRadius: 0.0)
            let board3Node = SCNNode(geometry: board3Geometry)
            board3Node.position = SCNVector3(0.3, -2, -1.1)
            ARSceneView.scene.rootNode.addChildNode(board3Node)
            let board4Geometry = SCNBox(width: 0.5, height: 0.1, length: 0.8, chamferRadius: 0.0)
            let board4Node = SCNNode(geometry: board4Geometry)
            board4Node.position = SCNVector3(0.22, -1, -1.3)
            ARSceneView.scene.rootNode.addChildNode(board4Node)
            actions = [SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: 1), SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: 0)]
            let actionRepeat = [SCNAction.repeatForever(SCNAction.group(actions))]
            board4Node.runAction(SCNAction.group(actionRepeat))
        }
        // The two boards
//        let boardGeometry = SCNBox(width: 0.5, height: 0.05, length: 0.3, chamferRadius: 0.0)
//        boardOneNode = SCNNode(geometry: boardGeometry)
//        boardOneNode.position = SCNVector3(0, -4, -1.5)
//        ARSceneView.scene.rootNode.addChildNode(boardOneNode)
//        boardOneNode.pivot = SCNMatrix4MakeTranslation(-0.5/2, -0.05/2, 0)
//        var actions = [SCNAction]()
//        actions = [SCNAction.rotateBy(x: 0, y: 0, z: .pi/2, duration: 2.5)]
//        boardOneNode.runAction(SCNAction.group(actions))
//
//        boardTwoNode = SCNNode(geometry: boardGeometry)
//        boardTwoNode.position = SCNVector3(0, -4, -1.5)
//        ARSceneView.scene.rootNode.addChildNode(boardTwoNode)
//
//        // The connector
//        let connectorGeometry = SCNCylinder(radius: 0.02, height: 0.08)
//        connectorNode = SCNNode(geometry: connectorGeometry)
//        connectorNode.position = SCNVector3(-0.5/2+0.01, 0.04, -1.5)
//
//        let repeatActions = [SCNAction.moveBy(x: 0, y: -0.05, z: 0, duration: 1.5), SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 0)]
//        actions = [SCNAction.repeatForever(SCNAction.group(repeatActions))]
//
//        connectorNode.runAction(SCNAction.group(actions))
//        ARSceneView.scene.rootNode.addChildNode(connectorNode)
//
        // Set the scene to the view
    }
    
    func step1() {
        let board1Geometry = SCNBox(width: 1.5, height: 0.1, length: 0.8 , chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        board1Geometry.materials = [material]
        let board1Node = SCNNode(geometry: board1Geometry)
        board1Node.position = SCNVector3(0, -2, -1.5)
        ARSceneView.scene.rootNode.addChildNode(board1Node)
    }
    
    func step2() {
        let board2Geometry = SCNBox(width: 0.1, height: 0.6, length: 0.8, chamferRadius: 0.0)
        let board2Node = SCNNode(geometry: board2Geometry)
        board2Node.position = SCNVector3(0.8, -1.8, -1.52)
        ARSceneView.scene.rootNode.addChildNode(board2Node)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        ARSceneView.session.run(configuration)
    }
    
    @IBAction func nextStepAction(_ sender: Any) {
        if item_id == 4 {
            ARSceneView.scene.rootNode.childNodes.map {
                $0.removeFromParentNode()
            }
            let text = SCNText(string: "您共花了30分钟\n超过了全球百分之80%的用户", extrusionDepth: 0.5)
            text.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200.0))
            text.chamferRadius = 1.0
            text.isWrapped = true
            text.flatness = 0.1
            infoNode.geometry = text
            infoNode.scale = SCNVector3(0.05, 0.05, 0.05)
            infoNode.position = SCNVector3(-0.5, -10, -10)
            ARSceneView.scene.rootNode.addChildNode(infoNode)
        } else {
            self.performSegue(withIdentifier: "nextStep", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ARSceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
