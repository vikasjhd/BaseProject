//
//  ResizableView.swift
//  Resizable
//
//  Created by Caroline on 6/09/2014.
//  Copyright (c) 2014 Caroline. All rights reserved.
//

import UIKit

//WE CAN RESIZE A VIEW AND ALSO DRAG A VIEW USING THIS

class ResizableView: UIView,UIGestureRecognizerDelegate{
    
    var translation: CGPoint!
    var startPosition: CGPoint! //Start position for the gesture transition
    var originalHeight: CGFloat = 0 // Initial Height for the UIView
    var originalWidth: CGFloat = 0 // Initial Height for the UIView
    var difference: CGFloat!
    var topLeft:DragHandle!
    var topRight:DragHandle!
    var bottomLeft:DragHandle!
    var bottomRight:DragHandle!
    var rotateHandle:DragHandle!
    var borderView:ResizeBorder!
    var previousLocation = CGPoint.zero
    var rotateLine = CAShapeLayer()
    let aLabel = UILabel()
    var initialPointSize: CGFloat = 0
 
  override func didMoveToSuperview() {
    let resizeFillColor = UIColor.white
    let resizeStrokeColor =  UIColor.white
    let rotateFillColor =   UIColor.white
    let rotateStrokeColor =  UIColor.white
    topLeft = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    topRight = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    bottomLeft = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    bottomRight = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    rotateHandle = DragHandle(fillColor:rotateFillColor, strokeColor:rotateStrokeColor)
    
    rotateLine.opacity = 0.0
    rotateLine.lineDashPattern = [3,2]
    
    borderView = ResizeBorder(frame:self.bounds)
    borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(borderView)
    
    addLable()
    
    superview?.addSubview(topLeft)
    superview?.addSubview(topRight)
    superview?.addSubview(bottomLeft)
    superview?.addSubview(bottomRight)
    self.layer.addSublayer(rotateLine)
  
    initialPointSize = aLabel.font?.pointSize ?? 0
    
//    var pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handlePan(_:)))
//    topLeft.addGestureRecognizer(pan)
//    pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handlePan(_:)))
//    topRight.addGestureRecognizer(pan)
//    pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handlePan(_:)))
//    bottomLeft.addGestureRecognizer(pan)
//    pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handlePan(_:)))
//    bottomRight.addGestureRecognizer(pan)
//    pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handleRotate(_:)))
    self.updateDragHandles()
  }

  func updateDragHandles() {
    topLeft.center = self.transformedTopLeft()
    topRight.center = self.transformedTopRight()
    bottomLeft.center = self.transformedBottomLeft()
    bottomRight.center = self.transformedBottomRight()
    rotateHandle.center = self.transformedRotateHandle()
    borderView.bounds = self.bounds
    borderView.setNeedsDisplay()
  }
   
    func addLable(){
        self.addSubview(aLabel)
        addMovementGesturesToView(view: self)
        aLabel.backgroundColor = UIColor.clear
        aLabel.text = ""
        aLabel.numberOfLines = 0
        aLabel.textAlignment = .center
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingConstraint = NSLayoutConstraint(item: aLabel, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute:NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        
        let leadingConstraint =   NSLayoutConstraint(item: aLabel, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute:NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: aLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: aLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
       }
    
  //MARK: - Gesture Methods
       func addMovementGesturesToView(view: UIView) {
           view.isUserInteractionEnabled = true
        
           let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
           panGesture.delegate = self
        
           view.addGestureRecognizer(panGesture)
           panGesture.cancelsTouchesInView = false
         
           let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(pinchGesture:)))
           pinchGesture.delegate = self
           view.addGestureRecognizer(pinchGesture)
           pinchGesture.cancelsTouchesInView = false
           
//           let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(rotateGesture:)))
//           rotateGesture.delegate = self
//           rotateGesture.cancelsTouchesInView = false
//           view.addGestureRecognizer(rotateGesture)
       }
       
    @objc func handlePanGesture (panGesture: UIPanGestureRecognizer) {
           let translation = panGesture.translation(in: panGesture.view?.superview)
          if panGesture.state == .began || panGesture.state == .changed {
            panGesture.view?.center = CGPoint(x: (panGesture.view?.center.x)! + translation.x, y: (panGesture.view?.center.y)! + translation.y)
                panGesture.setTranslation(CGPoint.zero, in: self)}
         updateDragHandles()
       }

    @objc func handlePinchGesture (pinchGesture: UIPinchGestureRecognizer) {
       if pinchGesture.state == .began || pinchGesture.state == .changed {
               let currentScale: CGFloat = pinchGesture.view?.layer.value(forKeyPath: "transform.scale.x") as! CGFloat
               let minScale: CGFloat = 0.1
               let maxScale: CGFloat = 2.0
               let zoomSpeed: CGFloat = 0.5
               var deltaScale = pinchGesture.scale
               deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
               deltaScale = min(deltaScale, maxScale / currentScale)
               deltaScale = max(deltaScale, minScale / currentScale)
               
               let zoomTransform = (pinchGesture.view?.transform)!.scaledBy(x: deltaScale, y: deltaScale)
               pinchGesture.view?.transform = zoomTransform
               pinchGesture.scale = 1
           }
             updateDragHandles()
       }
       
    @objc open func handleRotateGesture (rotateGesture: UIRotationGestureRecognizer) {
           if rotateGesture.state == .began || rotateGesture.state == .changed {
               rotateGesture.view?.transform = (rotateGesture.view?.transform)!.rotated(by: rotateGesture.rotation)
               rotateGesture.rotation = 0
           }
       }
       
       open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           return true
       }
    
  func angleBetweenPoints(_ startPoint:CGPoint, endPoint:CGPoint)  -> CGFloat {
    let a = startPoint.x - self.center.x
    let b = startPoint.y - self.center.y
    let c = endPoint.x - self.center.x
    let d = endPoint.y - self.center.y
    let atanA = atan2(a, b)
    let atanB = atan2(c, d)
    return atanA - atanB
  }

  func drawRotateLine(_ fromPoint:CGPoint, toPoint:CGPoint) {
    let linePath = UIBezierPath()
    linePath.move(to: fromPoint)
    linePath.addLine(to: toPoint)
    rotateLine.path = linePath.cgPath
    rotateLine.fillColor = nil
    rotateLine.strokeColor = UIColor.orange.cgColor
    rotateLine.lineWidth = 2.0
    rotateLine.opacity = 1.0
  }
  
    @objc func handleRotate(_ gesture:UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      previousLocation = rotateHandle.center
      self.drawRotateLine(CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2), toPoint:CGPoint(x: self.bounds.size.width + diameter, y: self.bounds.size.height/2))
    case .ended:
      self.rotateLine.opacity = 0.0
    default:()
    }
    let location = gesture.location(in: self.superview!)
    let angle = angleBetweenPoints(previousLocation, endPoint: location)
    self.transform = self.transform.rotated(by: angle)
    previousLocation = location
    self.updateDragHandles()
  }
  
    @objc func handlePan(_ gesture:UIPanGestureRecognizer) {
     translation = gesture.translation(in: self)
    switch gesture.view! {
    case topLeft:
      if gesture.state == .began {
       startPosition = gesture.location(in: self)
       self.setAnchorPoint(CGPoint(x: 1, y: 1))
       }
      self.bounds.size.width -= translation.x
      self.bounds.size.height -= translation.y
    case topRight:
      if gesture.state == .began {
        startPosition = gesture.location(in: self)
        self.setAnchorPoint(CGPoint(x: 0, y: 1))
      }
      self.bounds.size.width += translation.x
      self.bounds.size.height -= translation.y

    case bottomLeft:
      if gesture.state == .began {
        startPosition = gesture.location(in: self)
        self.setAnchorPoint(CGPoint(x: 1, y: 0))
      }
      self.bounds.size.width -= translation.x
      self.bounds.size.height += translation.y
    case bottomRight:
      if gesture.state == .began {
        startPosition = gesture.location(in: self)
        self.setAnchorPoint(CGPoint.zero)
      }
      self.bounds.size.width += translation.x
      self.bounds.size.height += translation.y
    default:()
    }
    gesture.setTranslation(CGPoint.zero, in: self)
  
    if gesture.state == .ended {
      self.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
      self.updateDragHandles()
    }
  }
}




