//
//  GameScene.swift
//  FinalProject
//
//  Created by Diana Luu on 11/9/18.
//  Copyright © 2018 Diana Luu. All rights reserved.
//

import SpriteKit
import GameplayKit

/**
 TODO:
    Implement health counter for player
    Implement score counter
    Implement collision mechanics for player, projectile, and monster
    Implement winning objective (default: survive for a certain amount of time; other ideas: endless mode (game runs indefinitely until player is KO'd), score attack (game ends when player reaches point threshold), no miss (game over if a monster isn't KO'd))
    Implement loss condition (default: player is KO'd; alt: monster is missed if in no miss mode)
    Add basic sound effects for shooting, jumping
    Find background music to play during the game
 CONSIDER:
    Implement difficulty settings (could possibly have it set up here as a pop-up before game begins), would determine monster spawn rate or player life (point multiplier for playing on higher difficulties?)
    Use larger player sprite?
    Find a projectile sprite to replace the placeholder one
    Create player sprite w/ run cycle to replace placeholder one
    Create monster sprite to replace placeholder one
 **/

//VECTOR FUNCTIONS
func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func +=(left: inout CGPoint, right: CGPoint) {
    left = left + right
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

struct PhysicsCategory {
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let monster : UInt32 = 0b1
    static let projectile : UInt32 = 0b10
    static let player : UInt32 = 0b101
}

class GameScene: SKScene {
    
    private let backgroundNode = BackgroundNode()
    private var jumpButton: SKNode! = nil
    private var shootButton: SKNode! = nil
    let player = SKSpriteNode(imageNamed: "playerrun3")
    //currently using placeholder for player sprite; should make texture for running animation
    
    var backgroundSpeed: CGFloat = 80.0
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    
    override func sceneDidLoad() {
        //set up background
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        setUpBackground()
        
        setUpPlayer()
        
        setUpButtons()
        
        physicsWorld.contactDelegate = self
        
        //set up different difficulty modes that alter spawn rate of monsters?
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMonster), SKAction.wait(forDuration: TimeInterval(arc4random_uniform(4)))])))
    }
    
    func setUpPlayer() {
        //set up player position
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.4)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.isDynamic = true
        player.physicsBody?.restitution = 0
        player.physicsBody?.allowsRotation = false
        
        let range = SKRange(lowerLimit: size.width * 0.1, upperLimit: size.width * 0.1)
        let lockToPosition = SKConstraint.positionX(range)
        player.constraints = [lockToPosition]
        addChild(player)
        
        //implement running cycle for player character
        //needs revision
        let run1 = SKTexture(imageNamed: "playerrun1")
        let run2 = SKTexture(imageNamed: "playerrun2")
        let run3 = SKTexture(imageNamed: "playerrun3")
        
        let cycle1 = SKAction.setTexture(run1, resize: true)
        let cycle2 = SKAction.setTexture(run2, resize: true)
        let cycle3 = SKAction.setTexture(run3, resize: true)
        let wait = SKAction.wait(forDuration: 0.2)
        
        player.run(SKAction.repeatForever(SKAction.sequence([cycle1, wait, cycle2, wait, cycle3, wait, cycle2, wait])))
    }
    
    func setUpButtons() {
        //set up jump and shoot buttons
        jumpButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 50, height: 50))
        jumpButton.position = CGPoint(x: size.width*0.9, y: size.height*0.1)
        jumpButton.zPosition = 2
        addChild(jumpButton)
        shootButton = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 50, height: 50))
        shootButton.position = CGPoint(x: size.width*0.8, y: size.height*0.1)
        shootButton.zPosition = 2
        addChild(shootButton)
    }
    
    func setUpBackground() {
        for i in 0..<2 {
            let backgroundTexture = SKTexture(imageNamed: "bg-\(i)")
            let background = SKSpriteNode(texture: backgroundTexture)
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * size.width, y: 0.0)
            background.size = size
            background.zPosition = -5
            background.name = "Background"
            addChild(background)
        }
        
        for i in 0..<2 {
            let groundTexture = SKTexture(imageNamed: "ground-\(i)")
            let ground = SKSpriteNode(texture: groundTexture)
            ground.anchorPoint = CGPoint.zero
            ground.size = CGSize(width: size.width, height: size.height*0.2)
            ground.position = CGPoint(x: CGFloat(i) * size.width, y: 0)
            ground.zPosition = 1
            ground.name = "ground"
            addChild(ground)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        updateBackground()
        updateGroundMovement()
    }
    
    func updateBackground() {
        self.enumerateChildNodes(withName: "Background") { (node, stop) in
            if let back = node as? SKSpriteNode {
                let move = CGPoint(x: -self.backgroundSpeed * CGFloat(self.deltaTime), y: 0)
                back.position += move
                
                if back.position.x < -back.size.width {
                    back.position += CGPoint(x: back.size.width * CGFloat(2), y: 0)
                }
            }
        }
    }
    
    func updateGroundMovement() {
        self.enumerateChildNodes(withName: "ground") { (node, stop) in
            if let back = node as? SKSpriteNode {
                let move = CGPoint(x: -self.backgroundSpeed * CGFloat(self.deltaTime), y: 0)
                back.position += move
                
                if back.position.x < -back.size.width {
                    back.position += CGPoint(x: back.size.width * CGFloat(2), y: 0)
                }
            }
        }
    }
    
    
    
    
    //METHODS FOR HANDLING PLAYER TOUCH INPUT
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        if jumpButton.contains(location) {
            jump()
        }
        if shootButton.contains(location) {
            shoot()
        }
    }
    
    
    
    
    //ACTION METHODS
    func jump() {
        if player.physicsBody?.velocity == CGVector(dx: 0, dy: 0) {
            player.run(SKAction.setTexture(SKTexture(imageNamed: "playerjump"), resize: true))
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
        }
    }
    
    func shoot() {
        //add texture for player shooting?
        let projectile = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 10, height: 10))
        projectile.position = player.position + CGPoint(x: 5, y: 0)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(projectile)
        
        let destination = projectile.position + CGPoint(x: 1000, y: 0)
        
        let actionMove = SKAction.move(to: destination, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    func addMonster() {
        //USING PLACEHOLDER SPRITE FOR MONSTERS; REPLACE WITH ACTUAL MONSTER SPRITE
        let monster = SKSpriteNode(imageNamed: "player")
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let yPos = random(min: (size.height*0.2) + (monster.size.width/2), max: (size.height*0.9) - monster.size.height/2)
        
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: yPos)
        
        addChild(monster)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: yPos), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func projectileDidHitMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        projectile.removeFromParent()
        monster.removeFromParent()
        //logic for increasing score or monster defeated count?
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) && (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let projectile = secondBody.node as? SKSpriteNode {
                projectileDidHitMonster(projectile: projectile, monster: monster)
            }
        }
    }
}
