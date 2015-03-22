//
//  ViewController.swift
//  shape-mutation
//
//  Created by Marin Todorov on 8/6/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

//
// Util delay function
//
func delay(#seconds: Double, completion:()->()) {
  let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime, dispatch_get_main_queue()) {
      completion()
  }
}

class ViewController: UIViewController {

    let arialRounded = UIFont(name: "ArialRoundedMTBold", size: 36.0)

    @IBOutlet var myAvatar: AvatarView!
    @IBOutlet var opponentAvatar: AvatarView!

    @IBOutlet var status: UILabel!
    @IBOutlet var vs: UILabel!
    @IBOutlet var searchAgain: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        //initial setup
        myAvatar.name = "Me"
        myAvatar.image = UIImage(named: "avatar-1")

        status.font = arialRounded
        vs.font = arialRounded
        searchAgain.titleLabel?.font = arialRounded

        vs.alpha = 0.0
        searchAgain.alpha = 0.0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchForOpponent()
    }

    private func searchForOpponent() {
        let bounceXOffset: CGFloat = 46.0
        let leftBouncePoint = CGPoint(x: 160.0 + bounceXOffset, y: myAvatar.center.y)
        myAvatar.bounceOffPoint(leftBouncePoint, morphSize: CGSize(width: 75, height: 100))
        let rightBouncePoint = CGPoint(x: 160.0 - bounceXOffset, y: myAvatar.center.y)
        opponentAvatar.bounceOffPoint(rightBouncePoint, morphSize: CGSize(width: 75, height: 100))

        delay(seconds: 2.0, foundOpponent)
    }


    func foundOpponent() {
        status.text = "Connecting..."

        opponentAvatar.image = UIImage(named: "avatar-2")
        opponentAvatar.name = "Ray"

        delay(seconds: 2.0, connectedToOpponent)
    }

    func connectedToOpponent() {
        myAvatar.shouldTransitionToFinishedState = true
        opponentAvatar.shouldTransitionToFinishedState = true

        delay(seconds: 1.0, completed)
    }

    func completed() {
        status.text = "Ready to play"
        UIView.animateWithDuration(0.2, animations: {
            self.vs.alpha = 1.0
            self.searchAgain.alpha = 1.0
        })
    }


    @IBAction func actionSearchAgain() {
        UIApplication.sharedApplication().keyWindow!.rootViewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? UIViewController
    }
}

