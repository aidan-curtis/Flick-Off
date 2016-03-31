//
//  Life.swift
//  Flick Off
//
//  Created by Aidan Curtis on 3/5/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation

import SpriteKit

class Life: SKSpriteNode{
    func setup(size: CGSize){
        self.texture=SKTexture(imageNamed: "Life2v2");
        self.size = CGSizeMake(CGFloat(size.width*3/4.0), CGFloat(size.width*3/4.0));
        zPosition=10001
    }
}