//
//  MenuScene.swift
//  FinalProject
//
//  Created by Diana Luu on 11/21/18.
//  Copyright © 2018 Diana Luu. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    /**
     TODO:
        Make main menu look nicer (create buttons, find a background image)
        Implement different game modes somehow (passing something to game scene?)
        Have a tutorial page for displaying how to play the game
    **/
    private var startButton: SKNode! = nil
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let titleLabel = SKLabelNode(fontNamed: "Chalkduster")
        titleLabel.text = "Jump 'N Shoot Man"
        titleLabel.fontSize = 40
        titleLabel.fontColor = SKColor.black
        titleLabel.position = CGPoint(x: size.width/2, y: (size.height*2/3))
        
        addChild(titleLabel)
        
        startButton = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 100, height: 40))
        startButton.position = CGPoint(x: size.width/2, y: size.height/2)
        
        addChild(startButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            if startButton.contains(location) {
                run(SKAction.sequence([
                    SKAction.wait(forDuration: 1.0),
                    SKAction.run() {
                        [weak self] in
                        guard let `self` = self else {return}
                        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                        let scene = GameScene(size: self.size)
                        self.view?.presentScene(scene, transition: reveal)
                    }
                    ]))
            }
        }
    }
}
