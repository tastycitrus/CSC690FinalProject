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
    private var jumpButton: SKNode! = nil
    private var shootButton: SKNode! = nil
    let player = SKSpriteNode(imageNamed: "player")
    //currently using placeholder for player sprite; should make texture for running animation
    
    override func sceneDidLoad() {
        //set up background
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        
        //set up player position
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.3)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.isDynamic = true
        player.physicsBody?.restitution = 0
        addChild(player)
        
        //set up jump and shoot buttons
        jumpButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 50, height: 50))
        jumpButton.position = CGPoint(x: size.width*0.9, y: size.height*0.1)
        addChild(jumpButton)
        shootButton = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 50, height: 50))
        shootButton.position = CGPoint(x: size.width*0.8, y: size.height*0.1)
        addChild(shootButton)
    }
    
    func touchUp(atPoint pos: CGPoint) {
        //return player to neutral position
    }
    
    func jump() {
        //add texture for player jumping
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 75))
    }
    
    func shoot() {
        //add texture for player shooting
        //add logic for firing projectile from player position
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            if jumpButton.contains(location) {
                jump()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
}
