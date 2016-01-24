//
//  GameScene.swift
//  Flick Off
//
//  Created by Aidan Curtis on 12/30/15.
//  Copyright (c) 2015 southpawac. All rights reserved.
//

import SpriteKit
import CoreMotion




class GameScene: SKScene {
    
    
    
    var backgroundNode=SKSpriteNode();
    var falling_objects=[SKSpriteNode]();
    var coins=[SKSpriteNode]()
    var coins_position_x=0
    //hearts init
    var hearts=[SKSpriteNode]()
    var permanant_hearts=[SKSpriteNode]()
    var number_of_hearts=3;
    //let space_objects:[String] = ["meteorBrown_big1", "meteorBrown_big2", "meteorBrown_big3", "meteorBrown_big4"];
    //fix later to stramline string formatting
    let paralax=["rain.sks"]
    
    let space_objects: [String] = ["a30000","a10000", "b10000", "b30000", "c10000", "c30000", "c40000"];
    let city_objects: [String] = ["cat", "dog"]
    let underwater_objects: [String] = ["Fish1","Fish2", "Fish3", "Shark"]
    let mars_objects: [String] = ["UFO1", "UFO2", "UFO3"]
    var objects = Array<Array<String>>()
    
    let backgrounds: [String] = ["garaxee", "urban-landscape-background-Preview.png", "", ""]
    
    let character_images: [String] = ["playerShip1_green", "playerShip1_green"]
    
    var space_actions = [SKAction]();
    var frame_counter=0;
    var moving_object=SKSpriteNode();
    var touched_location=CGPoint();
    var isTouching=false;
    var character = SKSpriteNode();
    var fuel = SKEmitterNode(fileNamed: "MyParticle.sks");
    
    
    var game_mode=0
    
    
    var spinning_asteroid = SKAction();
    let manager = CMMotionManager();
    var currentRoll = Double();
    
    override func didMoveToView(view: SKView) {
        
        
        
        
        setStaticHearts(3)
        objects=[space_objects, city_objects,underwater_objects, mars_objects]
        self.physicsWorld.gravity=CGVectorMake(0, 0);
        self.manager.deviceMotionUpdateInterval=1.0/60.0;
        self.manager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryCorrectedZVertical);
    
        fuel!.targetNode=self;
        
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()
    
        backgroundNode.texture=SKTexture(imageNamed: backgrounds[game_mode]);
        backgroundNode.position = CGPointMake(self.size.width/2, self.size.height/2)
        backgroundNode.zPosition = -10000
        backgroundNode.size = CGSizeMake(self.size.width, self.size.height)
        addChild(backgroundNode)
        
        
        character.texture=SKTexture(imageNamed: character_images[game_mode]);
        character.position=CGPointMake(self.size.width/2, 90);
        character.size=CGSizeMake(50, 38);
        character.physicsBody=SKPhysicsBody(rectangleOfSize:character.size);
        
        character.physicsBody!.dynamic=false;
        addChild(character);
        fuel!.position=CGPointMake(self.size.width/2, 73);
        
        addChild(fuel!);
        
        if(game_mode==0){
        var emitterNode = starfieldEmitter(SKColor.lightGrayColor(), starSpeedY: 300, starsPerSecond: 10, starScaleFactor: 0.2)
        emitterNode.zPosition = -10
        self.addChild(emitterNode)
        
        emitterNode = starfieldEmitter(SKColor.grayColor(), starSpeedY: 150, starsPerSecond: 20, starScaleFactor: 0.1)
        emitterNode.zPosition = -11
        self.addChild(emitterNode)
            
        }
        else{
            let emitterNode = SKEmitterNode(fileNamed: "Rain.sks")!
            emitterNode.zPosition = -11
            emitterNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
            emitterNode.particlePositionRange = CGVector(dx: frame.size.width+200, dy: 0)
            addChild(emitterNode)
            
        }
        
        //        emitterNode = starfieldEmitter(SKColor.darkGrayColor(), starSpeedY: 1, starsPerSecond: 4, starScaleFactor: 0.05)
        //        emitterNode.zPosition = -12
        //        self.addChild(emitterNode)
        
    
        
        
        
        
        
    }
    
    func addFallingObject(){

        let falling_object = SKSpriteNode();
        let num = Int(arc4random_uniform(UInt32(objects[game_mode].count)));
        NSLog("%i", num);
        //falling_object.runAction(SKAction.repeatActionForever(space_actions[1]));
        falling_object.texture=SKTexture(imageNamed: objects[game_mode][num]);
        falling_object.position = CGPointMake( CGFloat(arc4random_uniform(UInt32(self.size.width)))
                                                ,self.size.height+25);
        falling_object.size = CGSizeMake(100, 100);
    
        //falling_object.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2.0*M_PI), duration: Double(arc4random_uniform(4)+1))))
        //falling_object.runAction(SKAction.repeatActionForever(SKAction.moveBy(CGVectorMake(0,-100), duration: Double(arc4random_uniform(2)+1))));
        falling_object.physicsBody=SKPhysicsBody(circleOfRadius: falling_object.size.width/4);
        falling_object.physicsBody!.dynamic=true;
        falling_object.physicsBody!.allowsRotation=true;
        falling_object.physicsBody!.velocity=CGVectorMake(0, -300);
        falling_object.physicsBody!.angularVelocity=CGFloat(arc4random_uniform(4));
        falling_object.physicsBody!.friction=100;
        falling_objects.append(falling_object);
        
        addChild(falling_object);

        
    
    }
    

    func starfieldEmitter(color: SKColor, starSpeedY: CGFloat, starsPerSecond: CGFloat, starScaleFactor: CGFloat) -> SKEmitterNode {
        
        // Determine the time a star is visible on screen
        let lifetime =  frame.size.height * UIScreen.mainScreen().scale / starSpeedY
        
        // Create the emitter node
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = SKTexture(imageNamed: "spark")
        emitterNode.particleBirthRate = starsPerSecond
        emitterNode.particleColor = SKColor.lightGrayColor()
        emitterNode.particleSpeed = starSpeedY * -1
        emitterNode.particleScale = starScaleFactor
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleLifetime = lifetime
        
        // Position in the middle at top of the screen
        emitterNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
        emitterNode.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)
        
        // Fast forward the effect to start with a filled screen
        emitterNode.advanceSimulationTime(NSTimeInterval(lifetime))
        
        return emitterNode
    }
    func setStaticHearts(num : Int){
        for(var i=0; i<num; i+=1){
            let heart = addHeart()
            heart.size=CGSizeMake(40, 40)
            heart.position=CGPointMake(CGFloat(30+(45*i)), 30)
            addChild(heart)
            
        }
    }
    func addCoin(){
        let coin = SKSpriteNode()
        if(arc4random_uniform(20)==0){
            coins_position_x=2*Int(arc4random_uniform(UInt32(self.size.width)-40)+20)
        }
        if(coins_position_x<Int(self.size.width)){
        //coin.texture=SKTexture(imageNamed:"spinning_coin_gold_1")
        var coin_textures=[SKTexture]()
        for (var i=0; i<8; i=i+1){
            let name="spinning_coin_gold_"+(i+1 as NSNumber).stringValue
            coin_textures.append(SKTexture(imageNamed: name))
        }
        coin.runAction(SKAction.repeatActionForever( SKAction.animateWithTextures(coin_textures, timePerFrame: 0.1)))
        coin.position=CGPointMake(CGFloat(coins_position_x), self.size.height+25)
        coin.size=CGSizeMake(30, 30);
        addChild(coin)
        coins.append(coin)
        }
    }
    func addHeart() -> SKSpriteNode{
        let heart = SKSpriteNode()
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "red_glow"))
        let heart_image = SKSpriteNode(texture: SKTexture(imageNamed: "heart"))
        
        
        background.size=CGSizeMake(90, 90)
        background.position=CGPointMake(0, 5)
        
        heart_image.size=CGSizeMake(42,42)
        heart_image.position=CGPointMake(0, 0)

        heart.position=CGPointMake(CGFloat(Int(arc4random_uniform(UInt32(self.size.width)-40)+20)), self.size.height+25)
        heart.runAction(SKAction.repeatActionForever( SKAction.sequence([SKAction.fadeAlphaTo(0.5, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5) ])))
        heart.addChild(background);
        heart.addChild(heart_image);
        return heart
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touches: AnyObject in touches{
            
            let location = touches.locationInNode(self)
             if(Mirror(reflecting: self.nodeAtPoint(location)).subjectType == SKSpriteNode.self && falling_objects.contains((self.nodeAtPoint(location) as! SKSpriteNode))){
                touched_location = touches.locationInNode(self)
                isTouching=true
                moving_object=self.nodeAtPoint(location) as! SKSpriteNode
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touches: AnyObject in touches{
                touched_location = touches.locationInNode(self)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouching=false
    }
    override func update(currentTime: CFTimeInterval) {
        
        if(isTouching){
            //let force_vector = CGVectorMake(3*(touched_location.x - moving_object.position.x) , 3*(touched_location.y - moving_object.position.y))
            let velocity_vector = CGVectorMake(15*(touched_location.x - moving_object.position.x), 15*(touched_location.y - moving_object.position.y))
            moving_object.physicsBody?.velocity=velocity_vector
        }
        frame_counter++;
        let deviceMotion = self.manager.deviceMotion;
        if((deviceMotion) != nil){
        currentRoll=deviceMotion!.attitude.roll as Double;
        }
        character.runAction(SKAction.moveBy(CGVectorMake(CGFloat(10.0*currentRoll),0), duration: 0.10));
        fuel!.runAction(SKAction.moveBy(CGVectorMake(CGFloat(10.0*currentRoll),0), duration: 0.10));
    
        //NSLog("pitch:%f", currentRoll);
        
//        NSLog("yaw:%i", (self.manager.deviceMotion?.attitude.yaw)!);
//        NSLog("roll:%i", (self.manager.deviceMotion?.attitude.roll)!);
        
        //add coins
        if(frame_counter%7==0){
            addCoin();
        }
        //move hearts
        for heart: SKSpriteNode in hearts{
            heart.position=CGPointMake(heart.position.x, heart.position.y-5)
        }
        //move coins
        for coin: SKSpriteNode in coins{
            if(CGRectIntersectsRect(coin.frame,character.frame)){
                let b = { () -> Void in
                    coin.removeFromParent()
                    
                }
                let a = { () -> Void in
                    coin.runAction(SKAction.moveTo(CGPointMake(self.size.width,0), duration: 0.5), completion: b)
                    //coin.runAction(SKAction.scaleTo(CGFloat(0), duration: 0.5), completion: b)
                }
                
                
                coin.runAction(SKAction.runBlock(a) )
                
            }
            coin.position=CGPointMake(coin.position.x, coin.position.y-5)
        }
        //adding heart nodes
        if(frame_counter%600==0){
            let heart = addHeart()
            heart.size=CGSizeMake(90, 90);
            addChild(heart)
            hearts.append(heart);
        }
        //add falling objects
        if(frame_counter%50==0 && !(frame_counter%600==0)){
            addFallingObject();
        }
    }
}
