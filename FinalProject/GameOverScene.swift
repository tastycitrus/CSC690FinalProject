//
//  GameOverScene.swift
//  FinalProject
//
//  Created by Diana Luu on 12/9/18.
//  Copyright © 2018 Diana Luu. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    init(size: CGSize, score: Int) {
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "GAME OVER"
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height*2/3)
        addChild(label)
        
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Final score: \(score)"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(scoreLabel)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.run() {
                [weak self] in
                guard let `self` = self else {return}
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
            ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
