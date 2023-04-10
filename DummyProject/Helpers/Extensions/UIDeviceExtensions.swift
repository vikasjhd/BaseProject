//
//  UIDeviceExtensions.swift
//  DummyProject
//
//

import Foundation
import AudioToolbox
import  AVKit


//MARK:- UIDEVICE EXTENSIONS



//UIDEVICE EXTENSION FOR VIBRATE
//UIDEVICE EXTENSION FOR SIMUATOR DETECTION
//UIDEVICE EXTENSION FOR NOTCH DETECTION

extension UIDevice {
    
    //vibrate devie
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    //usage : UIDevice.vibrate()
    
    
    //check if current device is simulator or real device
    var isSimulator: Bool {
            #if IOS_SIMULATOR
                return true
            #else
                return false
            #endif
        }
    //usage : if UIDeive.current.isSimulator {}else {}
    
    
    //checking if current device has a notch
     var hasNotch: Bool {
        let bottom = GetWindow()?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    //usage : if UIDeive.current.hasNotch {}else {}

}
