//
//  UIViewExtension.swift
//  BaseProject
//
//

import Foundation
import UIKit




extension UIView {
    
    // MARK:- Custom Shadow to View
    
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool) {
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(0)
        }
        if (!bottom) {
            viewHeight-=(0)
        }
        if (!left) {
            x+=(0+1)
        }
        if (!right) {
            viewWidth-=(0)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    
    
    //MARK:- ROUND VIEW CORNERS
    func roundCorner(radius : CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    //MARK:- GIVE BORDER TO BUTTON
    func giveBorder(color:UIColor){
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    //MARK:- ROUND CORNERS AND GIVING SHADOW
    
    func giveShadowAndRoundCorners(shadowOffset: CGSize , shadowRadius : Int , opacity : Float , shadowColor : UIColor , cornerRadius :
                                   CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        DispatchQueue.main.async {
            self.layer.shadowPath =  UIBezierPath(roundedRect: self.bounds,cornerRadius: self.layer.cornerRadius).cgPath
        }
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.shadowOffset = shadowOffset
        self.layer.masksToBounds = false
    }
    //USAGE:- someView.giveShadowAndRoundCorners(shadowOffset: CGSize.zero, shadowRadius: 12, opacity: 0.8, shadowColor: Some_color, cornerRadius: 10)
    
    
    //MARK:- ROUND PARTICULAR CORNERS OF A VIEW
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    //USAGE:  someView.roundCorners(corners: [.topRight , .bottomLeft , .bottomRight], radius: 30)
    
    
    //MARK:- DRAW LINE FROM ONE POINT TO ANOTHER POINT
    
    func drawStraightLine(startingFrom : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor) {
        //design the path
        let path = UIBezierPath()
        path.move(to: startingFrom)
        path.addLine(to: end)
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 4.0
        self.layer.addSublayer(shapeLayer)
    }
    
    //USAGE: YOURVIEW.drawStraightLine(startingFrom : SOMEPOINT , toPoint : ENDPOINT , ofColor: UIColor.red)
    
    
    //MARK:- MAKE A VIEW CLICKABLE
    //ADDED BY VIKAS SAINI DATED 24 MAY 2021
    func makeClickable(target: Any, selector: Selector){
        self.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: target, action: selector)
        self.addGestureRecognizer(guestureRecognizer)
    }
    /*
     USAGE:
     YOURLABEL.makeClickable(target: self, selector: #selector(SOME_METHOD))
     @objc func SOME_METHOD(){
     //do something on click
     }
     */
    
    
    
    //MARK:- R0UND BOTTOM EDGE
    
    func addBottomRoundedEdge(desiredCurve: CGFloat?) {
        let offset: CGFloat = self.frame.width / desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer
    }
    
    /* Usage Example
     * bgView.addBottomRoundedEdge(desiredCurve: 1.5)
     */
    
    
    
    //MARK:-  Set the view layer as an hexagon
    func setupHexagonView(_ cornerRadius: CGFloat = 4) {
        let lineWidth: CGFloat = 2
        let path = self.roundedPolygonPath(rect: self.bounds, lineWidth: lineWidth, sides: 6, cornerRadius: cornerRadius, rotationOffset: CGFloat(.pi / 2.0))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = lineWidth
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = UIColor.white.cgColor
        self.layer.mask = mask
        
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = lineWidth
        border.strokeColor = UIColor.white.cgColor
        border.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(border)
    }
    
    
    /// Makes a bezier path which can be used for a rounded polygon
    /// layer
    ///
    /// - Parameters:
    ///   - rect: uiview rect bounds
    ///   - lineWidth: width border line
    ///   - sides: number of polygon's sides
    ///   - cornerRadius: radius for corners
    ///   - rotationOffset: offset of rotation of the view
    /// - Returns: the newly created bezier path for layer mask
    public func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * .pi) / CGFloat(sides) // How much to turn at every corner
        let width = min(rect.size.width, rect.size.height)        // Width of the square
        
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        
        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        
        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0..<sides {
            angle += theta
            
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }
        
        path.close()
        
        // Move the path to the correct origins
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        
        return path
    }
    
    //MARK:- ADD TOP , RIGHT , LEFT AND BOTTOM BORDERS SEPERATELY
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }
    
    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
    
    
}


