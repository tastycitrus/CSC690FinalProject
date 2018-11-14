//
//  BackgroundNode.swift
//  FinalProject
//
//  Created by Diana Luu on 11/13/18.
//  Copyright © 2018 Diana Luu. All rights reserved.
//

import SpriteKit

public class BackgroundNode: SKNode {
    
    //figure out how to add moving background and possibly a tile map for platforming
    public func setup(size: CGSize) {
        let yPos: CGFloat = size.height * 0.2
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint = CGPoint(x: size.width, y: yPos)
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.restitution = 0
    }
    
}
