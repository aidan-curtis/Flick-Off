//
//  Heart.swift
//  Flick Off
//
//  Created by Aidan Curtis on 2/29/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation
import SpriteKit

class Heart: SKSpriteNode{
    func setup(size: Int, parentsize: CGSize){
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "red_glow"))
        let heart_image = SKSpriteNode(texture: SKTexture(imageNamed: "heart"))

        background.size=CGSizeMake(CGFloat(size),CGFloat(size))
        background.position=CGPointMake(0, 5)
        heart_image.size=CGSizeMake(CGFloat(size),CGFloat(size))
        heart_image.position=CGPointMake(0, 0)
    
        position=CGPointMake(CGFloat(Int(arc4random_uniform(UInt32(parentsize.width)-40)+20)), parentsize.height+25)
        runAction(SKAction.repeatActionForever( SKAction.sequence([SKAction.fadeAlphaTo(0.5, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5) ])))
        addChild(background);
        addChild(heart_image);
    }
}