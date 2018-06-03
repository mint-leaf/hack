//
//  ViewController.swift
//  ARInstruction
//
//  Created by Ray on 2018/6/2.
//  Copyright © 2018年 top.rayzhao. All rights reserved.
//

import UIKit
import ARKit
import AVFoundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,  ARSCNViewDelegate, AVCaptureMetadataOutputObjectsDelegate{
    var session = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var QRCodeScanView: UIView? = nil
    var TipsLabel: UILabel? = nil
    var device: AVCaptureDevice? = nil
    var currentStep = 0
    var content: String = ""
    var item_name: String = ""
    var next_item: Int = 0
    var item_id: Int = 0
    var product_id: Int = 0
    var time_cost: Int = 0
    var isARViewCurrent = false
    let url = "https://hack.vvmint.cn/prompt"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanQRCode()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func awakeFromNib() {
        setupScanQRCode()
    }

    func setupScanQRCode() {
        self.scaning()
    }
    
    func scaning() {
        //获取摄像设备
        device = AVCaptureDevice.default(for: .video)!
        
        do {
            try! device?.lockForConfiguration()
            device?.focusMode = .continuousAutoFocus
            device?.unlockForConfiguration()
        }
        let input: AVCaptureDeviceInput
        do {
            //创建输入流
            input = try AVCaptureDeviceInput.init(device: device!)
        } catch {
            return
        }
        if (session.canAddInput(input)) {
            session.addInput(input)
        } else {
            failed()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.frame = self.view.layer.bounds
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = .landscapeRight
        self.view.layer.addSublayer(videoPreviewLayer!)
        
        session.startRunning()
    }
    
    func failed() {
        print("failed")
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var stringValue: String?
        session.stopRunning()
        if metadataObjects.count > 0 {
            self.session.stopRunning()
            
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                stringValue = metadataObject.stringValue
                if stringValue!.count != 0 {
                    product_id = stringValueDic(base64Decode(base64Encoded: stringValue!))!["product_id"] as! Int
                    item_id = stringValueDic(base64Decode(base64Encoded: stringValue!))!["item_id"] as! Int
                    next_item = stringValueDic(base64Decode(base64Encoded: stringValue!))!["next_items"] as! Int
//                    product_name = stringValueDic(base64Decode(base64Encoded: stringValue!))!["]
                    let new_url = url + "?product_id=" + String(product_id) + "&step_id=" + String(item_id)
                    print(new_url)
                    Alamofire.request(new_url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                        if let j = response.result.value {
                            let jsonDic = JSON(j)
                            print(jsonDic)
                            self.content = jsonDic["content"].string!
                            self.item_name = jsonDic["item_name"].string!
                            self.time_cost = jsonDic["time_cost"].int!
                            self.performSegue(withIdentifier: "showARScene", sender: Any?.self)
                        }
                    })
                    
                }
                print(base64Decode(base64Encoded: stringValue!))
            }
        }
    }
    
    func stringValueDic(_ str: String) -> [String : Any]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            print(dict)
            return dict
        }
        
        return nil
    }
    
    func base64Decode(base64Encoded: String) -> String {
        let decodedData = Data(base64Encoded: base64Encoded)
        let decodedString = String(data: decodedData!, encoding: .utf8)
        return decodedString!
    }
    
    @IBAction func nextStep(segue: UIStoryboardSegue) {
        setupScanQRCode()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showARScene" {
            let controller = segue.destination as! ARSceneViewController
            controller.content = self.content
            controller.item_name = self.item_name
            controller.time_cost = self.time_cost
            controller.item_id = self.item_id
            controller.product_id = self.product_id
            controller.next_item = self.next_item
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if session.isRunning == false {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if session.isRunning == true {
            session.stopRunning()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

