//
//  CustomPageControlls.swift
//  BaseProject
//
//

import Foundation
import UIKit


//MARK:- Custom UIPageController

//WE CAN SET CUSTOM IMAGES IN PLACE OF DOTS

class CustomPageControl: UIPageControl {
   // active and inactive images
    let imgActive: UIImage = R.image.fill_line()! // UIImage(named: "fill_line")!
    let imgInactive: UIImage = R.image.line()!    // UIImage(named: "line")!

   // adjust these parameters for specific case
   let customActiveYOffset: CGFloat = 5.0
   let customInactiveYOffset: CGFloat = 5.0
   var hasCustomTintColor: Bool = false
    let customActiveDotColor: UIColor = UIColor(white: 0xe62f3e, alpha: 1.0)

   override var numberOfPages: Int {
       didSet {
           updateDots()
       }
   }

   override var currentPage: Int {
       didSet {
           updateDots()
       }
   }

   override func awakeFromNib() {
       super.awakeFromNib()
       self.pageIndicatorTintColor = .clear
       self.currentPageIndicatorTintColor = .clear
       self.clipsToBounds = false
   }

   func updateDots() {
      var i = 0
      let activeSize = self.imgActive.size
    let activeRect = CGRect(x: -5, y: 0, width: activeSize.width/2 , height: activeSize.height/2)
      let inactiveRect = CGRect(x:-2, y: 0, width: activeSize.width / 3, height: activeSize.height / 2)

      for view in self.subviews {
          if let imageView = self.imageForSubview(view) {
              if i == self.currentPage {
                imageView.image = self.imgActive
                if self.hasCustomTintColor {
                    imageView.tintColor = customActiveDotColor
                }
                imageView.frame = activeRect
                imageView.frame.origin.y = imageView.frame.origin.y - customActiveYOffset
              } else {
                imageView.image = self.imgInactive
                imageView.frame = inactiveRect
                imageView.frame.origin.y = imageView.frame.origin.y - customInactiveYOffset
              }
              i = i + 1
          } else {
              var dotImage = self.imgInactive
              if i == self.currentPage {
                  dotImage = self.imgActive
              }
              view.clipsToBounds = false
              let addedImageView: UIImageView = UIImageView(image: dotImage)
              if dotImage == self.imgActive {
                 addedImageView.frame = activeRect
                 addedImageView.frame.origin.y = addedImageView.frame.origin.y - customActiveYOffset
                if self.hasCustomTintColor {
                    addedImageView.tintColor = customActiveDotColor
                }
             } else {
                 addedImageView.frame.origin.y = addedImageView.frame.origin.y - customInactiveYOffset
             }
             view.addSubview(addedImageView)
             i = i + 1
          }
      }
  }

 func imageForSubview(_ view:UIView) -> UIImageView? {
    var dot: UIImageView?
    if let dotImageView = view as? UIImageView {
        dot = dotImageView
    } else {
        for foundView in view.subviews {
            if let imageView = foundView as? UIImageView {
                dot = imageView
                break
            }
        }
    }
    return dot
}

}
