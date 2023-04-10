//
//  UIViewControllerExtension.swift
//  DummyProject
//


import Foundation
import UIKit


extension UIViewController {
    
    
    //CONTACT VIKAS SAINI IN CASE OF COMPLAINTS / IMPROVEMENTS / CHANGES
    
    
    //MARK:- REMOVE CHILD
    func removeChild() {
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    //USAGE : self.removeChild()
    
    //MARK:- ADDING CHILD TO CONTAINER
    
    func addChildView(viewControllerToAdd: UIViewController, in view: UIView) {
        viewControllerToAdd.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewControllerToAdd.view.frame = view.bounds
        addChild(viewControllerToAdd)
        view.addSubview(viewControllerToAdd.view)
        viewControllerToAdd.didMove(toParent: self)
    }
    //USAGE: self.addChildView(viewControllerToAdd: your_vc_object, in: containerView)
    
    
    
    
}
