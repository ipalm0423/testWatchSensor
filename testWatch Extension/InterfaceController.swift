//
//  InterfaceController.swift
//  gFinger Extension
//
//  Created by 陳冠宇 on 2016/1/23.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    //motion
    let motionManager = CMMotionManager()
    let accQueue = NSOperationQueue()
    let gyroQueue = NSOperationQueue()
    
    //connect
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.setupWCConnection()
        self.setupGSensor()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBOutlet var label1: WKInterfaceLabel!
    
    @IBOutlet var label2: WKInterfaceLabel!
    
    @IBOutlet var label3: WKInterfaceLabel!
    
    
    var xOriginal: Double = 0
    var yOriginal: Double = 0
    var zOriginal: Double = 0
    
    
    
    
    //setup g-sensor
    func setupGSensor() {
        if self.motionManager.accelerometerAvailable {
            print("accelerometer available")
            self.motionManager.accelerometerUpdateInterval = 0.4
            self.motionManager.startAccelerometerUpdatesToQueue(self.accQueue, withHandler: { (accData, error) -> Void in
                if let ACC = accData?.acceleration {
                    let xPosition =  String(format:"%.2f", ACC.x)
                    let yPosition =  String(format:"%.2f", ACC.y)
                    let zPosition =  String(format:"%.2f", ACC.z)
                    self.label1.setText("\(xPosition)")
                    self.label2.setText("\(yPosition)")
                    self.label3.setText("\(zPosition)")
                    
                    self.sendData2Phone([ACC.x, ACC.y, ACC.z])
                    
                }
                
                
                
                
                print(error)
            })
        }else {
            print("accelerometer unavailable")
        }
        
        
    }
    
    //watch connect
    let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    func setupWCConnection() {
        if let session = self.session {
            self.session?.delegate = self
            self.session?.activateSession()
            print("active session")
        }
    }
    
    
    
    func sendData2Phone(data: [Double]) {
        if self.session!.reachable {
            print("send cmd to iphone: data")
            self.session?.sendMessage(["data" : data], replyHandler: nil, errorHandler: { (error) -> Void in
                print(error)
            })
        }else {
            print("data can't send, session unreachable")
        }
    }
    
    func sendCMD2Phone(cmd: [String]) {
        if self.session!.reachable {
            print("send cmd to iphone: cmd")
            self.session?.sendMessage(["cmd" : cmd], replyHandler: nil, errorHandler: { (error) -> Void in
                print(error)
            })
        }else {
            print("data can't send, session unreachable")
        }
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        if session.reachable {
            print("session is connect")
        }else {
            print("session is disconnect")
        }
    }
    
    
}

