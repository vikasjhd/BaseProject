//
//  PublicFunctions.swift
//  DummyProject
//
//  Created by Vikas saini on 16/01/21.
//

import Foundation
import AVFoundation
import UIKit



//MARK:- PRINT TO CONSOLE


//FUNCTION USE PRINT STATEMENT TO PRINT ONLY IN DEBUG MODE AND PREVENT TO  PRINT TO CONSOLE IF IS NOT DEBUGGING
//PRINT STATEMENT IN RELEASE MODE CAN SLOW DOWN THE APPLICATION

public func PrintToConsole(_ message: String) {
    #if DEBUG
    print(message)
    #endif
}

//USAGE :  PrintToConsole("SomeMessage")

//MARK:- TEXT TO SPEECH


var utterance = AVSpeechUtterance()
var synthesizer = AVSpeechSynthesizer()

func SpeakAText(_ text : String){
    utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
    utterance.rate = 0.5
    if !synthesizer.isSpeaking {
    synthesizer.speak(utterance)
    }
}

//USAGE : SpeakAText("Welcome Home")


//MARK:- GET WINDOW WHILE USING SCENE DELEGATE

func GetWindow() -> UIWindow? {

if #available(iOS 13.0, *) {
    let sceneDelegate = UIApplication.shared.connectedScenes
        .first?.delegate as? SceneDelegate
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    return sceneDelegate?.window ?? appDelegate?.window
} else {
 
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    return appDelegate?.window
}
}
//USAGE:  if let window = GetWindow() {}


