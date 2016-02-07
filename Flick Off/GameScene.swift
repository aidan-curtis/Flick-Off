//
//  GameScene.swift
//  Flick Off
//
//  Created by Aidan Curtis on 12/30/15.
//  Copyright (c) 2015 southpawac. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    let MAX_HEALTH = 150
    enum GameMode : Int {
        case SPACE=0,CITY,UNDERWATER,MARS
    }
    enum Objects : UInt32{
        case Meteor=100
    }
    
    let next_coin: coin_dispenser = coin_dispenser()
    
    
    //labels
    let score = SKLabelNode()
    var score_number = 0;
    var gems = [SKSpriteNode]();
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
    let paralax=["Rain.sks", "Bubbles.sks"]
    
    let space_objects: [String] = ["a30000","a10000", "b10000", "b30000", "c10000", "c30000", "c40000"];
    let city_objects: [String] = ["cat", "dog"]
    let underwater_objects: [String] = ["color_fish_1","color_fish_2","color_fish_3","color_fish_4","color_fish_5"]
    let mars_objects: [String] = ["UFO1", "UFO2", "UFO3"]
    var objects = Array<Array<String>>()
    
    let backgrounds: [String] = ["Background7", "urban-landscape-background-Preview.png", "ocean_background", ""]
    
    let character_images: [String] = ["playerShip1_green", "playerShip1_green", "playerShip1_green"]
    
    var space_actions = [SKAction]();
    var frame_counter=0;
    var moving_object=SKSpriteNode();
    var touched_location=CGPoint();
    var isTouching=false;
    var character = SKSpriteNode();
    var fuel = SKEmitterNode(fileNamed: "MyParticle.sks");
    
    
    var game_mode=GameMode.SPACE.rawValue
    
    
    var spinning_asteroid = SKAction();
    let manager = CMMotionManager();
    var currentRoll = Double();
    
    var explosion = [SKTexture]()
    var menu = SKSpriteNode();
    
    let life_bar=SKSpriteNode();
    let shield_bar=SKSpriteNode();

    
    func presentMenu(){
        menu.size=CGSizeMake(200, 100)
        menu.color=UIColor.redColor()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("contact!");
        var velocity1 = CGVector(), velocity2=CGVector();
        var location1 = CGPoint(), location2=CGPoint();
        var node1=SKSpriteNode(), node2=SKSpriteNode()
        for node: SKSpriteNode in falling_objects{
            if(node.physicsBody==contact.bodyA){

                velocity1=(node.physicsBody?.velocity)!
                location1=node.position;
                node1=node;
            }
            if(node.physicsBody==contact.bodyB){

                velocity2=(node.physicsBody?.velocity)!
                location2=node.position;
                node2=node;
            }
        }
        let power = pow(pow(velocity1.dx,2)+pow(velocity1.dy,2),0.5)+pow(pow(velocity2.dx,2)+pow(velocity2.dy,2),0.5) ;
        if(power>1000){
            if(node1.name=="purple" || node2.name=="purple"){
                addGem(node1.position)
            }
            node1.removeFromParent()
            node2.removeFromParent()
            
            falling_objects.removeAtIndex(falling_objects.indexOf(node1)!)
            falling_objects.removeAtIndex(falling_objects.indexOf(node2)!)
            explode(CGSizeMake(power/15.0, power/15.0), location: CGPointMake((location1.x+location2.x)/2, (location1.y+location2.y)/2), speed: 0.01)
        }
    }
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        for(var i=0; i<34; i+=1){
            explosion.append(SKTexture(imageNamed: "explosion_\(i+1)"))
        }
        
        
        //present menu at beginning and after death
        presentMenu()
        
        //addGem(CGPointMake(200, 200))
        
        //setting score label
        score.position = CGPointMake(30, self.size.height-30)
        score.fontName = "04b_19"
        score.fontSize = 30
        score.text = "0"
        addChild(score)
        
        setStaticHearts(MAX_HEALTH)
        setShieldBar(MAX_HEALTH)
        addChild(shield_bar)
        addChild(life_bar)
        objects=[space_objects, city_objects,underwater_objects, mars_objects]
        self.physicsWorld.gravity=CGVectorMake(0, 0);
        self.manager.deviceMotionUpdateInterval=1.0/60.0;
        self.manager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryCorrectedZVertical);
    
        fuel!.targetNode=self;
        
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()
//        if(game_mode==2) {
//            self.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 153/255.0, blue: 153/255.0, alpha: 1)
//        }
//        else{
        backgroundNode.texture=SKTexture(imageNamed: backgrounds[game_mode]);
        
        backgroundNode.position = CGPointMake(self.size.width/2, self.size.height*30/2)
        backgroundNode.zPosition = -10000
        backgroundNode.size = CGSizeMake(self.size.width, self.size.height*30)
        addChild(backgroundNode)
//        }
        
        
        character.texture=SKTexture(imageNamed: character_images[game_mode]);
        character.position=CGPointMake(self.size.width/2, 90);
        character.size=CGSizeMake(50, 38);
        addChild(character);
        fuel!.position=CGPointMake(self.size.width/2, 73);
        
        addChild(fuel!);
        
        if(game_mode==GameMode.SPACE.rawValue){
//      var emitterNode = starfieldEmitter(SKColor.lightGrayColor(), starSpeedY: 300, starsPerSecond: 10, starScaleFactor: 0.2)
//        emitterNode.zPosition = -10
//        self.addChild(emitterNode)
        
        var emitterNode = starfieldEmitter(SKColor.grayColor(), starSpeedY: 150, starsPerSecond: 20, starScaleFactor: 0.1)
        emitterNode.zPosition = -11
        self.addChild(emitterNode)
            
        }
        else{
            let emitterNode = SKEmitterNode(fileNamed: paralax[game_mode-1])!
            emitterNode.zPosition = -11
            if(game_mode==GameMode.CITY.rawValue){
                emitterNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
            }
            else if(game_mode==GameMode.UNDERWATER.rawValue){
                emitterNode.position = CGPoint(x: frame.size.width/2, y: 0)
            }
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
        falling_object.zPosition=1000
        //falling_object.runAction(SKAction.repeatActionForever(space_actions[1]));
        falling_object.texture=SKTexture(imageNamed: objects[game_mode][num]);
        falling_object.position = CGPointMake( CGFloat(arc4random_uniform(UInt32(self.size.width))),self.size.height+25);
        falling_object.zRotation = CGFloat(3*M_PI/2)
        if(game_mode==GameMode.SPACE.rawValue){
            falling_object.size = CGSizeMake(100, 100);
        }
        else if(game_mode==GameMode.UNDERWATER.rawValue){
            falling_object.size = CGSizeMake(100, 55);
        }
        
        
        if(arc4random_uniform(UInt32(11))==10){
        falling_object.name="purple"
        //add emitter_node
        let emitterNode = SKEmitterNode(fileNamed: "Magic")!
        emitterNode.zPosition = -11
        emitterNode.position = CGPointMake(0, 0)
        emitterNode.targetNode=self
        falling_object.addChild(emitterNode)
        }
        
        //add physics body
        falling_object.physicsBody=SKPhysicsBody(circleOfRadius: falling_object.size.width/4);
        falling_object.physicsBody!.dynamic=true;
        falling_object.physicsBody!.allowsRotation=true;
        falling_object.physicsBody!.categoryBitMask = Objects.Meteor.rawValue
        falling_object.physicsBody!.usesPreciseCollisionDetection=true;
        falling_object.physicsBody!.contactTestBitMask = Objects.Meteor.rawValue
        
        
        
        
        falling_object.physicsBody!.velocity=CGVectorMake(0, -300);
        if(!(GameMode.UNDERWATER.rawValue==game_mode)){
            falling_object.physicsBody!.angularVelocity=CGFloat(arc4random_uniform(4));
        }
        falling_object.physicsBody!.friction=100;
        falling_objects.append(falling_object);
        
        addChild(falling_object);

        
    
    }
    func explode(size: CGSize, location: CGPoint, speed: Double){
        let explosion_node = SKSpriteNode()
        explosion_node.size = size
        explosion_node.position = location
        explosion_node.zPosition = 50
        explosion_node.runAction(SKAction.animateWithTextures(explosion, timePerFrame: speed), completion:{explosion_node.removeFromParent()})
        addChild(explosion_node)
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
        
        life_bar.size=CGSizeMake(CGFloat(num), 8);
        life_bar.color=UIColor.redColor()
        life_bar.alpha=0.5
        life_bar.position=CGPointMake(CGFloat(num/2), 4)
    }
    func setShieldBar(num : Int){
        shield_bar.size=CGSizeMake(CGFloat(num), 8);
        shield_bar.color=UIColor.blueColor()
        shield_bar.alpha=0.5
        shield_bar.position=CGPointMake(CGFloat(num/2), 12)
    }
    
    func addGem(location:CGPoint){
        let gem = SKSpriteNode()
        gem.size = CGSizeMake(50, 40)
        gem.position=location
        var gem_textures = [SKTexture]()
        for(var i = 7; i<106; i+=8){

            gem_textures.append(SKTexture(imageNamed: "Gem v\(i)"))
        }
        gem.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(gem_textures, timePerFrame: 0.1)))
        
        addChild(gem)
        gems.append(gem)
        
    }
    func addCoin(){
        let coin = SKSpriteNode()
        if(arc4random_uniform(20)==0){
            let mode=Int(arc4random_uniform(3))
            next_coin.begin_action(mode, starting_location: Int(arc4random_uniform(UInt32(self.size.width)-40)+20))
            next_coin.setAlternate(Int(arc4random_uniform(UInt32(self.size.width)-40)+20))
            next_coin.setWidth(Int(arc4random_uniform(15))+10)
            next_coin.power(Int(arc4random_uniform(2)))
        }
        coins_position_x=next_coin.fetch_next_coin()
        if(coins_position_x<Int(self.size.width) && next_coin.status==1){
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
    func addHeart(size: Int) -> SKSpriteNode{
        let heart = SKSpriteNode()
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "red_glow"))
        let heart_image = SKSpriteNode(texture: SKTexture(imageNamed: "heart"))
        
        
        background.size=CGSizeMake(CGFloat(size),CGFloat(size))
        background.position=CGPointMake(0, 5)
        
        heart_image.size=CGSizeMake(CGFloat(size),CGFloat(size))
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
        moving_object.runAction(SKAction.rotateToAngle(atan2(CGFloat((touched_location.y - moving_object.position.y)),CGFloat((touched_location.x - moving_object.position.x))), duration: 0.01))
        for touches: AnyObject in touches{
                touched_location = touches.locationInNode(self)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouching=false
    }
    override func update(currentTime: CFTimeInterval) {
        //improve shield power
        
        if(frame_counter<=150){
        backgroundNode.position = CGPointMake(self.size.width/2,backgroundNode.position.y-(25-24.0*CGFloat(1-CGFloat(CGFloat(frame_counter)/150.0))))
        frame_counter++
        }
        else{
        backgroundNode.position = CGPointMake(self.size.width/2, backgroundNode.position.y-1)
        
        
        if(life_bar.size.width<0){
            //game over
            print("game over");
        }
        
        if(frame_counter%3==0 && shield_bar.size.width<CGFloat(MAX_HEALTH)){
        
        setShieldBar(Int(shield_bar.size.width+1))
        }
        
        if(frame_counter%5==0){
            score_number++
            score.text = "\(score_number)"
        }
//        if(GameMode.UNDERWATER.rawValue==game_mode){
//            for fish: AnyObject in falling_objects{
//                fish.runAction(SKAction.rotateToAngle(, duration: 0.01))
//            }
//        }
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
            if(CGRectIntersectsRect(heart.frame,character.frame)){
                setStaticHearts(Int(CGFloat(life_bar.size.width)+CGFloat(50.0)))
                if(life_bar.size.width>CGFloat(MAX_HEALTH)){
                    setStaticHearts(MAX_HEALTH)
                }
                hearts.removeAtIndex(hearts.indexOf(heart)!)
                heart.removeFromParent()
            }
        }
        for gem: SKSpriteNode in gems{
            gem.position=CGPointMake(gem.position.x, gem.position.y-5)
        }
        //falling objects enumerate
        var falling_temp = falling_objects
        for falling: SKSpriteNode in falling_objects{
            let shrinkx:CGFloat=character.frame.width/2, shrinkx_m=character.frame.width/2
            let shrinky:CGFloat=character.frame.height/2, shrinky_m=character.frame.height/2
            if(CGRectIntersectsRect(CGRectMake(falling.frame.origin.x+shrinkx_m, falling.frame.origin.y+shrinky_m, 70, 70), CGRectMake(character.frame.origin.x+shrinkx, character.frame.origin.y+shrinky, 1, 1))){
                var explosion_size = 0.1*pow(pow((falling.physicsBody?.velocity.dx)!, 2)+pow((falling.physicsBody?.velocity.dy)!, 2), 0.5)
                if(explosion_size < 60){
                    explosion_size = 60
                }

                self.explode(CGSizeMake(explosion_size, explosion_size), location: CGPointMake((character.position.x+falling.position.x)/2, (character.position.y+falling.position.y)/2), speed: (0.02))
                falling_objects.removeAtIndex(falling_objects.indexOf(falling)!)
                
                var change_health=0
                var change_shield=shield_bar.size.width-explosion_size
         
                if(change_shield<0){
                    change_health=abs(Int(change_shield))
                    change_shield=0
                }
                setShieldBar(Int(change_shield))
                setStaticHearts(Int(life_bar.size.width) - change_health)
                falling.removeFromParent()

            }
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
            let heart = addHeart(40)
            addChild(heart)
            hearts.append(heart);
        }
        //add falling objects
        if(frame_counter%50==0 && !(frame_counter%600==0)){
            addFallingObject();
        }
        }
    }
}