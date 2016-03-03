//
//  Rocket.swift
//  Flick Off
//
//  Created by Aidan Curtis on 2/25/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation
import SpriteKit

class Rocket: SKSpriteNode{
    func setup(){
        self.size=CGSizeMake(60, 60);
        var textures=[SKTexture]();
        for(var a=1; a<=12; a+=1){
            textures.append(SKTexture(imageNamed: "Rocket for app v\(a)"))
        }
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.09)))
    }
}