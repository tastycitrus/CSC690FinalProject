//
//  GameScene.swift
//  FinalProject
//
//  Created by Diana Luu on 11/9/18.
//  Copyright © 2018 Diana Luu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let backgroundNode = BackgroundNode()
    let player = SKSpriteNode(imageNamed: "player")
    
    override func sceneDidLoad() {
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.16)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        addChild(player)
    }
    
    
}
