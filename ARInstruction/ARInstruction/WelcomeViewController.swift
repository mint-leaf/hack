//
//  WelcomeViewController.swift
//  ARInstruction
//
//  Created by Ray on 2018/6/2.
//  Copyright © 2018年 top.rayzhao. All rights reserved.
//

import UIKit
import ARKit

class WelcomeViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var WelcomeARSceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        WelcomeARSceneView.delegate = self
        WelcomeARSceneView.showsStatistics = true
        
        let text = SCNText(string: "Hello, welcome to use IKEA AR Assembly!", extrusionDepth: 0.5)
        text.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
//        text.chamferRadius = 1.0
//        text.flatness = 0.1
//        text.font =
        text.containerFrame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
        text.truncationMode = kCATruncationNone
        text.isWrapped = true
        let WelcomeInfoNode = SCNNode()
        WelcomeInfoNode.geometry = text
        WelcomeInfoNode.scale = SCNVector3(0.05, 0.05, 0.05)
        WelcomeInfoNode.position = SCNVector3(-0.5, -10, -10)
        WelcomeARSceneView.scene.rootNode.addChildNode(WelcomeInfoNode)
        // Do any additional setup after loading the view.
    }

    @IBAction func ClickButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showQRCodeView", sender: Any?.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        WelcomeARSceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        WelcomeARSceneView.session.pause()
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
