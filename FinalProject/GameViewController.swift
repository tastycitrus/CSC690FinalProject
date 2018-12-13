//
//  GameViewController.swift
//  FinalProject
//
//  Created by Diana Luu on 11/9/18.
//  Copyright © 2018 Diana Luu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneNode = MenuScene(size: view.bounds.size)
            if let view = self.view as! SKView? {
                view.presentScene(sceneNode)
                view.ignoresSiblingOrder = true
//                view.showsPhysics = true
//                view.showsFPS = true
//                view.showsNodeCount = true
            }
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
