//
//  GameScene.swift
//  FinalProject
//
//  Created by Diana Luu on 11/9/18.
//  Copyright © 2018 Diana Luu. All rights reserved.
//

import SpriteKit
import GameplayKit

//VECTOR FUNCTIONS
func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
    
    private let backgroundNode = BackgroundNode()
    private var jumpButton: SKNode! = nil
    private var shootButton: SKNode! = nil
    let player = SKSpriteNode(imageNamed: "playerrun3")
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
        let range = SKRange(lowerLimit: size.width * 0.1, upperLimit: size.width * 0.1)
        let lockToPosition = SKConstraint.positionX(range)
        player.constraints = [lockToPosition]
        addChild(player)
        
        //implement running cycle for player character
        //possibly needs revision
        let run1 = SKTexture(imageNamed: "playerrun1")
        let run2 = SKTexture(imageNamed: "playerrun2")
        let run3 = SKTexture(imageNamed: "playerrun3")
        
        let cycle1 = SKAction.setTexture(run1, resize: true)
        let cycle2 = SKAction.setTexture(run2, resize: true)
        let cycle3 = SKAction.setTexture(run3, resize: true)
        let wait = SKAction.wait(forDuration: 0.2)
        
        player.run(SKAction.repeatForever(SKAction.sequence([cycle1, wait, cycle2, wait, cycle3, wait, cycle2, wait])))
        
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
        let projectile = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 10, height: 10))
        projectile.position = player.position + CGPoint(x: 0.3, y: 0)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.affectedByGravity = false
        addChild(projectile)
        
        let destination = projectile.position + CGPoint(x: 1000, y: 0)
        
        let actionMove = SKAction.move(to: destination, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            if jumpButton.contains(location) {
                jump()
            }
            if shootButton.contains(location) {
                shoot()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
}
