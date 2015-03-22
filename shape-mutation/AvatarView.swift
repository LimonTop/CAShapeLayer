//
//  AvatarView.swift
//  shape-mutation
//
//  Created by Marin Todorov on 8/6/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

class AvatarView: UIView {

    let photoLayer = CALayer()
    let circleLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    
    var image: UIImage? {
        didSet {
            photoLayer.contents = image?.CGImage
        }
    }
    
    var name: String? {
        didSet {
            label.text = name
        }
    }

    let label: UILabel = UILabel()
    
    let lineWidth: CGFloat = 6.0
    let animationDuration = 1.0
    
    var shouldTransitionToFinishedState = false
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = UIColor.clearColor()
        
        //add the initial image of the avatar view
        let blankImage = UIImage(named: "empty.png")!
        photoLayer.contents = blankImage.CGImage
        photoLayer.frame = CGRect(
            x: (bounds.size.width - blankImage.size.width + lineWidth)/2,
            y: (bounds.size.height - blankImage.size.height - lineWidth)/2,
            width: blankImage.size.width,
            height: blankImage.size.height)
        
        layer.addSublayer(photoLayer)
        
        //draw the circle
        // path决定形状, UIBezierPath的ovalInRect创建圆形path
        circleLayer.path = UIBezierPath(ovalInRect: bounds).CGPath
        circleLayer.strokeColor = UIColor.whiteColor().CGColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clearColor().CGColor
        layer.addSublayer(circleLayer)

        //mask layer
        maskLayer.path = circleLayer.path
        maskLayer.position = CGPoint(x: 0.0, y: 10.0)
        photoLayer.mask = maskLayer
        
        //add label
        label.frame = CGRect(x: 0.0, y: bounds.size.height + 10, width: bounds.size.width, height: 24)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 18.0)
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        addSubview(label)
    }

    func bounceOffPoint(bouncePoint: CGPoint, morphSize: CGSize) {
        let originalCenter = center

        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
            self.center = bouncePoint

        }, completion: {_ in

            if self.shouldTransitionToFinishedState {
                self.animateToSquare()
            }

            UIView.animateWithDuration(self.animationDuration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: nil, animations: {
                self.center = originalCenter
            }, completion: {_ in

                if !self.shouldTransitionToFinishedState {
                    delay(seconds: 0.1, {
                        self.bounceOffPoint(bouncePoint, morphSize: morphSize)
                    })
                }
            })
        })

        // 变形 - 椭圆
        let morphFrame = (originalCenter.x > bouncePoint.x) ?
            CGRect(x: 0.0, y: bounds.height - morphSize.height, width: morphSize.width, height: morphSize.height) :
            CGRect(x: bounds.width - morphSize.width, y: bounds.height - morphSize.height, width: morphSize.width, height: morphSize.height)

        let morphAnimation = CABasicAnimation(keyPath: "path")
        morphAnimation.duration = animationDuration
        morphAnimation.toValue = UIBezierPath(ovalInRect: morphFrame).CGPath
        morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        circleLayer.addAnimation(morphAnimation, forKey: nil)
        maskLayer.addAnimation(morphAnimation, forKey: nil)
    }

    // 变形 - 正方形
    func animateToSquare() {
        let morphAnimation = CABasicAnimation(keyPath: "path")
        morphAnimation.duration = 0.25
        morphAnimation.fromValue = circleLayer.path
        morphAnimation.toValue = UIBezierPath(rect: bounds).CGPath
        // 保持变形后的形状
        morphAnimation.removedOnCompletion = false
        morphAnimation.fillMode = kCAFillModeBoth

        //add morphing to both the shape and the image mask
        circleLayer.addAnimation(morphAnimation, forKey:nil)
        maskLayer.addAnimation(morphAnimation, forKey: nil)
    }
    
}
