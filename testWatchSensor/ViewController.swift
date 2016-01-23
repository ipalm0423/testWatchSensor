//
//  ViewController.swift
//  testWatchSensor
//
//  Created by 陳冠宇 on 2016/1/23.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupWCConnection()
        let frame = self.view.frame
        self.imageView.frame = CGRect(x: frame.width / 2 - 150, y: frame.height / 2, width: 300, height: 300)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var label1: UILabel!
    
    @IBOutlet var label2: UILabel!
    
    @IBOutlet var label3: UILabel!
    
    @IBOutlet var imageView: UIImageView!

    var yPosition = 0.0
    
//watch connection
    let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    func setupWCConnection() {
        if let session = self.session {
            self.session?.delegate = self
            self.session?.activateSession()
            print("active session")
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        // get command from watch
        if let data = message["data"] as? [Double] {
            print("recieve cmd from watch: data")
            print("data: \(data)")
            print("data: \(data)")
            let heightRatio = data[0]
            let rotateRatio = -data[1]
            let midHeight = Double(self.view.frame.height / 2)
            let midWidth = (self.view.frame.width) / 2
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                
                //move height
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    let rotate = CGAffineTransformMakeRotation(CGFloat(rotateRatio * M_PI / 2))
                    self.imageView.transform = rotate
                    self.imageView.center = CGPoint(x: midWidth, y: CGFloat(midHeight * (1 + heightRatio) - 150))
                    
                    }, completion: { (bool) -> Void in
                        
                })
                
            
                
                
            })
            
        }
        
        
    }
    
    
}

