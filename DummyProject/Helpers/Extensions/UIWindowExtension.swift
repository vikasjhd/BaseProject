//
//  UIWindowExtension.swift
//  BaseProject
//
//

import Foundation
import UIKit

extension UIWindow {
  
//MARK:- TOP VIEW CONTROLLER
    
    //GET THE TOPMOST VIEW CONTROLLER ON ANY CONTROLLER OF APPLICATION
    
      func topViewController() -> UIViewController? {
      var top = self.rootViewController
      while true {
          if let presented = top?.presentedViewController {
              top = presented
          } else if let nav = top as? UINavigationController {
              top = nav.visibleViewController
          } else if let tab = top as? UITabBarController {
              top = tab.selectedViewController
          } else {
              break
          }
      }
      return top
  }
}

//USAGE :
//if let currentVC = GetWindow()?.topViewController() {
//
//}
