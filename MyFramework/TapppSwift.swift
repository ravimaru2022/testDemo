//
//  TapppSwift.swift
//  MyFramework
//

import Foundation
import Flutter
import SwiftMessageBar

public class TapppSwift {
    public init() {}
    public var nativeChannel: FlutterMethodChannel!
    lazy var flutterEngine = FlutterEngine(name: "io.flutter")

    public func log(message: String) {
        print("Log message: ", message)
    }

    public func initSwiftPanel(currView : UIView){
        DispatchQueue.main.async {
            self.flutterEngine.run();
            //let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
            let flutterViewController =
            FlutterViewController(engine: self.flutterEngine, nibName: nil, bundle: nil)
            flutterViewController.view.frame = currView.bounds
            flutterViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.nativeChannel = FlutterMethodChannel(name: "demo/channel", binaryMessenger: flutterViewController.binaryMessenger)
            self.setCallHandler()
            currView.backgroundColor = UIColor.clear
            flutterViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            currView.addSubview(flutterViewController.view)
        }
    }
    
    public func setCallHandler() {
        nativeChannel.setMethodCallHandler { (call : FlutterMethodCall, result: @escaping FlutterResult) in
            print("set method call handler")
            if(call.method == "GET_FROM_NATIVE") {
                let rand = Int.random(in: 1...100)
                let myDict:[String:String] = ["VALUE": "\(rand)", "MESSAGE": "Get data from native"]
                result(myDict)
            } else if (call.method == "NATIVE_NOTIFICATION"){
                guard let resultNew = call.arguments as? [String:Any] else {
                    return
                }
                let value = resultNew["VALUE"] as! String
                let msg = resultNew["MESSAGE"] as! String
                
                SwiftMessageBar.showMessage(withTitle: value, message: msg, type: .info)
            }
            else{
                result(FlutterMethodNotImplemented) // to handle undeclared methods
                return
            }
        }
    }

}
