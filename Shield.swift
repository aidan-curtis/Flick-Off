//
//  Shield.swift
//  Flick Off
//
//  Created by Aidan Curtis on 2/29/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation

import SpriteKit

class Shield: SKSpriteNode{
    func setup(size: CGSize){
        zPosition=2000;
        self.size=size;
        position=CGPointMake(100,110)
        var textures=[SKTexture]();
        for(var a=2; a<=10; a+=1){
            textures.append(SKTexture(imageNamed: "shield\(a)"))
        }
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.06)))
    }
}