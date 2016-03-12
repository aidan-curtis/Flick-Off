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
    //YOU CAN CHANGE THESE CONSTANTS
    let power_speed=3;
    let regular_speed=1;
    let heart_frequency=1450;
    let rocket_frequency=1600;
    let shield_frequency=963;
    let UFO_frequency=3000;
    let MAX_HEALTH = 150
    //DO NOT EDIT BELOW
    
    var game_status=0

    var current_coins=0;
    var shield_activity:Int = 0
    var UFO_Column:CGPoint=CGPointMake(-1000,0);
    var UFO = SKSpriteNode();
    var emitterNode = SKEmitterNode();
    var UFO_set = false;
    
    var laser=SKEmitterNode();
    //var backup_emitterNode = SKEmitterNode();
    
    
    
    enum GameMode : Int {
        case SPACE=0,CITY,UNDERWATER,MARS
    }
    enum Objects : UInt32{
        case Meteor=100
    }
    let life = Life();
    let next_coin: coin_dispenser = coin_dispenser()
    var oldparticlecolor=UIColor.clearColor();
    var oldparticlesize:CGFloat=20.0;
    //labels
    let score = SKLabelNode()
    var score_number = 0;
    var gems = [SKSpriteNode]();
    let number_of_backgrounds=8;
    var backgroundNode=[SKSpriteNode]();
    var rockets=[SKSpriteNode]();
    var shields=[SKSpriteNode]();
    
    var rocket_power=0;
    var number_of_rockets=0;
    
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
    
    let space_objects: [String] = ["a30000","a10000", "a40000","b10000", "b30000", "b40000"];
    let city_objects: [String] = ["cat", "dog"]
    let underwater_objects: [String] = ["color_fish_1","color_fish_2","color_fish_3","color_fish_4","color_fish_5"]
    let mars_objects: [String] = ["UFO1", "UFO2", "UFO3"]
    var objects = Array<Array<String>>()
 
    
    var space_actions = [SKAction]();
    var frame_counter=0;
    var moving_object=SKSpriteNode();
    var touched_location=CGPoint();
    var isTouching=false;
    var character = SKSpriteNode();
    var shield_follow = Shield();
    var fuel = SKEmitterNode();
    
    
    var game_mode=GameMode.SPACE.rawValue
    
    var coin_alternator=false;
    var spinning_asteroid = SKAction();
    let manager = CMMotionManager();
    var currentRoll = Double();
    
    var explosion = [SKTexture]()
    var menu = SKSpriteNode();
    
    let life_bar=SKSpriteNode();
    let shield_bar=SKSpriteNode();
    var health_cover=SKSpriteNode();
    var shield_cover=SKSpriteNode();
    var coin_cover=SKSpriteNode();
    var coin_image = SKSpriteNode();
    var coin_label = SKLabelNode();
    func presentMenu(){
        menu.size=CGSizeMake(200, 100)
        menu.color=UIColor.redColor()
    }
    
    
    override func didMoveToView(view: SKView) {
        
        current_coins = NSUserDefaults.standardUserDefaults().integerForKey("coins");
        
        shield_follow.setup(CGSizeMake(120,107))
      
        
        
        
        self.physicsWorld.contactDelegate = self
        for(var i=0; i<34; i+=1){
            explosion.append(SKTexture(imageNamed: "explosion_\(i+1)"))
        }
        health_cover.position = CGPointMake(100, 18);
        health_cover.size = CGSizeMake(200,40);
        health_cover.texture = SKTexture(imageNamed: "Health Bar")
        
        addChild(health_cover);
        
        shield_cover.position = CGPointMake(100, 54);
        shield_cover.size = CGSizeMake(200,40);
        shield_cover.texture = SKTexture(imageNamed: "Shield Bar")
        shield_cover.hidden=true;
    
        addChild(shield_cover);
        
        coin_cover.position = CGPointMake(self.size.width-50, 18);
        coin_cover.size = CGSizeMake(1, 1);
        coin_cover.texture = SKTexture(imageNamed: "coin_cover");
       
        addChild(coin_cover);
        
        coin_image.position = CGPointMake(self.size.width+20, 18);
        coin_image.size = CGSizeMake(1 ,1)
        var coin_textures=[SKTexture]()
        for (var i=0; i<8; i=i+1){
            let name="spinning_coin_gold_"+(i+1 as NSNumber).stringValue
            coin_textures.append(SKTexture(imageNamed: name))
        }
        coin_image.runAction(SKAction.repeatActionForever( SKAction.animateWithTextures(coin_textures, timePerFrame: 0.1)))

        addChild(coin_image);
        
        coin_label.position = CGPointMake(self.size.width-30, 12);
        coin_label.fontName="04b_19"
        coin_label.fontSize=20
        coin_label.fontColor=UIColor.yellowColor()
        coin_label.text="\(current_coins)"
        coin_label.hidden=true;
        addChild(coin_label);
        
        //present menu at beginning and after death
        presentMenu()
        
        //addGem(CGPointMake(200, 200))
        
        //setting score label
        score.position = CGPointMake(30, self.size.height-30)
        score.fontName = "04b_19"
        score.fontSize = 30
        score.text = "0"
        addChild(score)
        
        game_starting_values()
        shield_bar.hidden=true;
        addChild(shield_bar)
        addChild(life_bar)
        
        objects=[space_objects, city_objects,underwater_objects, mars_objects]
        self.physicsWorld.gravity=CGVectorMake(0, 0);
        self.manager.deviceMotionUpdateInterval=1.0/60.0;
        self.manager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryCorrectedZVertical);
    
      
        
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()
        for(var i=0; i<number_of_backgrounds; i++){
            backgroundNode.append(SKSpriteNode())
            backgroundNode[i].texture=SKTexture(imageNamed: "Background7_\(i+1)k.png");
            backgroundNode[i].zPosition = -10000
            backgroundNode[i].size = CGSizeMake(self.size.width, self.size.width*6)
            addChild(backgroundNode[i])
        }
    
        if(NSUserDefaults.standardUserDefaults().objectForKey("ship") == nil){
            NSUserDefaults.standardUserDefaults().setObject("playerShip1_green.png", forKey: "ship")
            
        }
        character.texture=SKTexture(imageNamed: NSUserDefaults.standardUserDefaults().objectForKey("ship") as! String);
        
        
        character.position=CGPointMake(3*self.size.width/5, 4*self.size.height/24);
        character.zPosition=0
        character.size=CGSizeMake(50, 38);
        addChild(character);
        
        shield_follow.position = CGPointMake(3*self.size.width/5-3, 4*self.size.height/24+3);
        shield_follow.size = CGSizeMake(120, 107);
        addChild(shield_follow);
        shield_follow.hidden=true;
        
        fuel = SKEmitterNode(fileNamed: "MyParticle.sks")!
        fuel.position=CGPointMake(3*self.size.width/5, (4*self.size.height/24)-15);
        addChild(fuel);
        fuel.targetNode=self
        fuel.removeFromParent()
        oldparticlecolor=fuel.particleColor;
        oldparticlesize=fuel.particleScale;

        
        emitterNode=starfieldEmitter(SKColor.grayColor(), starSpeedY: 150, starsPerSecond: 20, starScaleFactor: 0.1,backup: false)
        emitterNode.zPosition = -11
        self.addChild(emitterNode)
        emitterNode.paused=true
        
//
//        backup_emitterNode=starfieldEmitter(SKColor.grayColor(), starSpeedY: 150, starsPerSecond: 20, starScaleFactor: 0.1,backup:  true)
//        backup_emitterNode.zPosition = -11
//        self.addChild(backup_emitterNode)
        
            
        
        //        emitterNode = starfieldEmitter(SKColor.darkGrayColor(), starSpeedY: 1, starsPerSecond: 4, starScaleFactor: 0.05)
        //        emitterNode.zPosition = -12
        //        self.addChild(emitterNode)
    }
    func didBeginContact(contact: SKPhysicsContact) {
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
            explode(CGSizeMake(power/15.0, power/15.0), location: CGPointMake((location1.x+location2.x)/2, (location1.y+location2.y)/2), speed: 0.01, explosion_color: "gray")
        }
    }
    func game_starting_values(){
        setStaticHearts(MAX_HEALTH)
        setShieldBar(MAX_HEALTH)
        
        number_of_rockets=0;
        rocketIter(number_of_rockets);
        for coin: SKSpriteNode in coins{
            coin.removeFromParent()
        }
        coins.removeAll()
        for falling_object: SKSpriteNode in falling_objects{
            falling_object.removeFromParent()
        }
        falling_objects.removeAll()
        
        for heart: SKSpriteNode in hearts{
            heart.removeFromParent()
        }
        hearts.removeAll()
        UFO.removeFromParent()
        laser.removeFromParent()
        UFO_Column=CGPointMake(-1000, 0);
        for rocket: SKSpriteNode in rockets{
            rocket.removeFromParent()
        }
        rockets.removeAll()
        for shield: SKSpriteNode in shields{
            shield.removeFromParent()
        }
        shields.removeAll()
        character.position=CGPointMake(3*self.size.width/5, 4*self.size.height/24);
        fuel.position=CGPointMake(3*self.size.width/5, (4*self.size.height/24)-15);
        
    }
    func addFallingObject(speed : Int){
        let falling_object = SKSpriteNode();
        let num = Int(arc4random_uniform(UInt32(objects[game_mode].count)));
        NSLog("%i", num);
        falling_object.zPosition=1000
        //falling_object.runAction(SKAction.repeatActionForever(space_actions[1]));
        falling_object.texture=SKTexture(imageNamed: objects[game_mode][num]);
        var temp_position:CGPoint=CGPointMake(CGFloat(arc4random_uniform(UInt32(self.size.width))),self.size.height+25);
        while(temp_position.x>UFO_Column.x-70 && temp_position.x<UFO_Column.x+70){
            temp_position=CGPointMake( CGFloat(arc4random_uniform(UInt32(self.size.width))),self.size.height+25);
        }

        falling_object.position = temp_position;
        falling_object.zRotation = CGFloat(3*M_PI/2)
        if(game_mode==GameMode.SPACE.rawValue){
            falling_object.size = CGSizeMake(100, 100);
        }
        else if(game_mode==GameMode.UNDERWATER.rawValue){
            falling_object.size = CGSizeMake(100, 55);
        }
        
        
//        if(arc4random_uniform(UInt32(11))==10){
//            falling_object.name="purple"
//            //add emitter_node
//            let emitterNode = SKEmitterNode(fileNamed: "Magic")!
//            emitterNode.zPosition = -11
//            emitterNode.position = CGPointMake(0, 0)
//            emitterNode.targetNode=self
//            falling_object.addChild(emitterNode)
//        }
//        else if(arc4random_uniform(UInt32(11))==10){
//            falling_object.name="blue"
//            //add emitter_node
//            let emitterNode = SKEmitterNode(fileNamed: "Magic2")!
//            
//            emitterNode.zPosition = -11
//            emitterNode.position = CGPointMake(0, 0)
//            emitterNode.targetNode=self
//            falling_object.addChild(emitterNode)
//        }
        
        //add physics body
        
        falling_object.physicsBody=SKPhysicsBody(circleOfRadius: falling_object.size.width/4);
        falling_object.physicsBody!.dynamic=true;
        falling_object.physicsBody!.allowsRotation=true;
        falling_object.physicsBody!.categoryBitMask = Objects.Meteor.rawValue
        falling_object.physicsBody!.usesPreciseCollisionDetection=true;
        falling_object.physicsBody!.contactTestBitMask = Objects.Meteor.rawValue
   
        
        
        
        if(rocket_power<=0){
            falling_object.physicsBody!.velocity=CGVectorMake(0, CGFloat(speed));
        }
        else{
            falling_object.physicsBody!.velocity=CGVectorMake(0, CGFloat(power_speed*speed));
        }
        if(!(GameMode.UNDERWATER.rawValue==game_mode)){
            falling_object.physicsBody!.angularVelocity=CGFloat(arc4random_uniform(4));
        }
        falling_object.physicsBody!.friction=100;
        falling_objects.append(falling_object);
        
        addChild(falling_object);
        
    
    }
    func explode(size: CGSize, location: CGPoint, speed: Double, explosion_color: String){
        var explosion_node=SKEmitterNode();
        if(explosion_color=="blue"){
            explosion_node=SKEmitterNode(fileNamed: "Blue_Explosion.sks")!;
        }
        else if(explosion_color=="gray"){
            explosion_node=SKEmitterNode(fileNamed: "Gray_Explosion.sks")!;
        }
        else{
            explosion_node=SKEmitterNode(fileNamed: "Fire_Explosion.sks")!;
        }
        
        explosion_node.position=location;
        explosion_node.zPosition=5000;
        explosion_node.particleAlpha=1
        explosion_node.targetNode=self;
        
        explosion_node.particleSpeed=CGFloat(Int(explosion_node.particleSpeed)*Int(size.width)/90)
        addChild(explosion_node);
        
//        let explosion_node = SKSpriteNode()
//        explosion_node.size = size
//        explosion_node.position = location
//        explosion_node.zPosition = 50
//        explosion_node.runAction(SKAction.animateWithTextures(explosion, timePerFrame: speed), completion:{explosion_node.removeFromParent()})
//        addChild(explosion_node)
    }
    func starfieldEmitter(color: SKColor, starSpeedY: CGFloat, starsPerSecond: CGFloat, starScaleFactor: CGFloat, backup: Bool) -> SKEmitterNode {
        
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
        
        if(backup){
            
        emitterNode.advanceSimulationTime(NSTimeInterval(lifetime))
        }
        
        return emitterNode
    }
    func setStaticHearts(num : Int){
        
        life_bar.size=CGSizeMake(CGFloat(num+10), 14);
        life_bar.color=UIColor.redColor()

        life_bar.position=CGPointMake(CGFloat((num+10)/2)+3, 18)
    }
    func setShieldBar(num : Int){
        if(num<=0){
            shield_bar.hidden=true;
        }
        shield_bar.size=CGSizeMake(CGFloat((num+10))+4, 14);
        shield_bar.color=UIColor.blueColor()

        shield_bar.position=CGPointMake(CGFloat((num+10)/2)+4, 54)
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
            if(coin_alternator==true){
            let mode=Int(arc4random_uniform(3))
            next_coin.begin_action(mode, starting_location: Int(arc4random_uniform(UInt32(self.size.width)-40)+20))
            next_coin.setAlternate(Int(arc4random_uniform(UInt32(self.size.width)-40)+20))
            next_coin.setWidth(Int(arc4random_uniform(15))+10)
            next_coin.power(Int(arc4random_uniform(2)))
                coin_alternator=false;
            }
            else{
                coin_alternator=true;
            }
        }
        if(coin_alternator==true){
        coins_position_x=next_coin.fetch_next_coin()
        if(next_coin.status==1){
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
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
   
        for touches: AnyObject in touches{
            
            let location = touches.locationInNode(self)

            if(game_status==4){
                //check for X button
                
                if(location.x > CGFloat(life.position.x)+CGFloat(life.size.width/2.0) - 30 && location.x < CGFloat(life.position.x)+CGFloat(life.size.width/2.0) + 30){
                    if(location.y > CGFloat(life.position.y)+CGFloat(life.size.height/2.0) - 30 && location.y < CGFloat(life.position.y)+CGFloat(life.size.height/2.0) + 30){
                        life.runAction(SKAction.moveToY(-500, duration: 0.8));
                        game_status=5;
                    }
                }
            }
             if(Mirror(reflecting: self.nodeAtPoint(location)).subjectType == SKSpriteNode.self && falling_objects.contains((self.nodeAtPoint(location) as! SKSpriteNode))){
                touched_location = touches.locationInNode(self)
                isTouching=true
                moving_object=self.nodeAtPoint(location) as! SKSpriteNode
            }
        }
    }
    var static_rockets=[Rocket]();
    func rocketIter(number: Int){
        for rocket: Rocket in static_rockets{
            rocket.removeFromParent()
        }
        static_rockets.removeAll();
        var rocket_temp=Rocket();
        for (var i=0; i<number; i++){
            rocket_temp=Rocket();
            rocket_temp.setup(CGSizeMake(30, 30));
            rocket_temp.position=CGPointMake(CGFloat(Int(self.size.width)-(20*i+20)), CGFloat(Int(self.size.height)-(30)))
            static_rockets.append(rocket_temp);
        }
        for rocket: Rocket in static_rockets{
            addChild(rocket);
        }
        
        
    }
    func blastOff(){
        rocket_power=200;
        shield_follow.physicsBody=SKPhysicsBody(circleOfRadius: 50);
        shield_follow.physicsBody!.dynamic=false;
        fuel.particleColorSequence = nil;
        fuel.particleColorBlendFactor = 0.9;
        fuel.particleColor = SKColor.blueColor();
        fuel.particleScale=fuel.particleScale*2
        
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
    var last_coin_submit=0;
    override func update(currentTime: CFTimeInterval) {
        last_coin_submit--;
        if (last_coin_submit<=0){
            self.coin_cover.runAction(SKAction.scaleXTo(1, duration: 0.1));
            self.coin_cover.runAction(SKAction.scaleYTo(1, duration: 0.1));
            self.coin_image.runAction(SKAction.scaleXTo(1, duration: 0.1));
            self.coin_image.runAction(SKAction.scaleYTo(1, duration: 0.1));
            coin_label.hidden=true;
            self.coin_image.runAction(SKAction.moveToX(self.size.width+25, duration: 0.1))
        }
        if( last_coin_submit == 40){
             self.coin_label.hidden=false
        }
       coin_label.text="\(current_coins)"

        rocket_power-=1;
//        if(shield_power==0){
//            shield_follow.removeFromParent()
//            shield_follow=Shield();
//            shield_follow.setup(CGSizeMake(120, 107))
//            shield_follow.position = CGPointMake(character.position.x-3, character.position.y+3);
//            addChild(shield_follow);
//            shield_follow.hidden=true;
//            shield_bar.hidden=true;
//        }
        
        if(rocket_power==0){
            shield_follow.removeFromParent()
            shield_follow=Shield();
            shield_follow.position = CGPointMake(character.position.x-3, character.position.y+3);
            shield_follow.setup(CGSizeMake(120, 107))
            addChild(shield_follow);
            //shield_follow.hidden=true;
            fuel.particleColor=oldparticlecolor;
            fuel.particleColorBlendFactor=1
            fuel.particleScale=fuel.particleScale*0.5
            
        }
        //improve shield power
        //score_label.text = "\(Int(score_label.text!)!+1)"
        if(game_status==0){
            emitterNode.paused=true
            game_starting_values()
            frame_counter=0
    
            for(var i=0; i<number_of_backgrounds; i++){
                backgroundNode[i].position = CGPointMake(self.size.width/2, (self.size.width*6/2)+CGFloat(i*Int(self.size.width*6)))
            }
            game_status=1
        }
        else if(game_status==1){
            addChild(fuel)
            score.text="0"
            score_number=0;
            //backup_emitterNode.hidden=true
            emitterNode.resetSimulation()
            emitterNode.hidden=false
            emitterNode.paused=true
            for(var i=0; i<number_of_backgrounds; i++){
                backgroundNode[i].position = CGPointMake(self.size.width/2, (self.size.width*6/2)+CGFloat(i*Int(self.size.width*6)))
            }
            
            game_status=2
        }
        if(game_status==2){
            if(frame_counter<=150){
                for(var i=0; i<number_of_backgrounds; i++){
                    backgroundNode[i].position = CGPointMake(self.size.width/2,backgroundNode[i].position.y-(25-24.0*CGFloat(1-CGFloat(CGFloat(frame_counter)/150.0))))
                }
                frame_counter++
            }
            else{
                
                
                if(UFO_set==true && character.position.x>UFO_Column.x-50 && character.position.x<UFO_Column.x+50){
                    explode(CGSizeMake(50, 50), location: character.position, speed: 0.02, explosion_color: "blue");
                    laser.removeFromParent()
                    life_bar.size.width = -1;
                    shield_bar.size.width = -1;
                }
                //UFO Special
                if(UFO_Column.x == -1000){
                if(arc4random_uniform(UInt32(UFO_frequency))==0){
                    
                    var texture_list=[SKTexture]();
                    for(var i=1; i<=12; i++){
                        texture_list.append(SKTexture(imageNamed: "UFO_\(i)"))
                        
                    }
                    UFO.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(texture_list, timePerFrame: 0.02)));
                    UFO.size=CGSizeMake(106,62);
                    UFO.position=CGPointMake(0,self.size.height*3/4);
                    let destination_point=CGPointMake(CGFloat(arc4random_uniform(UInt32(self.size.width-200))+100),self.size.height*3/4);
                    UFO_Column=destination_point;
                    UFO.runAction(SKAction.moveTo(destination_point, duration: 1));
                    
                    //laser
                    laser=SKEmitterNode(fileNamed: "Laser.sks")!;
                    laser.particleBirthRate=0
                    laser.targetNode=self;
                    laser.position=CGPointMake(destination_point.x, destination_point.y-30);
                    laser.runAction(
                        SKAction.sequence([
                        SKAction.waitForDuration(1),
                        SKAction.repeatAction(
                           SKAction.sequence([
                            SKAction.runBlock({ () -> Void in
                                self.laser.particleBirthRate=1934
                        self.laser.particlePositionRange=CGVectorMake(self.laser.particlePositionRange.dx, self.laser.particlePositionRange.dy+10)
                                self.laser.position=CGPointMake(self.laser.position.x, self.laser.position.y-5);
                            }), SKAction.waitForDuration(0.025)])
                            , count: 50), SKAction.runBlock({ () -> Void in
                                self.UFO_set=true;
                            })]) );
             
                    addChild(laser)
                    addChild(UFO)
                }
                }
                //end UFO special
                
                emitterNode.paused=false
                for(var i=0; i<number_of_backgrounds; i++){
                    backgroundNode[i].position = CGPointMake(self.size.width/2, backgroundNode[i].position.y-1)
                }
                if(life_bar.size.width<0){
                    print("game over");
                    game_status=3
                }
                
                if(frame_counter%5==0){
                    if(rocket_power<=0){
                        score_number++;
                        
                    }
                    else{
                        score_number+=power_speed;
                    }
                    score.text = "\(score_number)"
                }
                if(arc4random_uniform(UInt32(shield_frequency))==0  && coin_alternator==false){
                    let shield=Shield();
                    shield.setup(CGSizeMake(60, 50))
                    shield.position=CGPointMake(CGFloat(arc4random_uniform(UInt32 (self.size.width))),self.size.height);
                    addChild(shield)
                    
                    shields.append(shield);
                }

        if(isTouching){
            //let force_vector = CGVectorMake(3*(touched_location.x - moving_object.position.x) , 3*(touched_location.y - moving_object.position.y))
            let velocity_vector = CGVectorMake(15*(touched_location.x - moving_object.position.x), 15*(touched_location.y - moving_object.position.y))
            moving_object.physicsBody?.velocity=velocity_vector
        }
        
        frame_counter+=1;
        
        let deviceMotion = self.manager.deviceMotion;
        if((deviceMotion) != nil){
            currentRoll=deviceMotion!.attitude.roll as Double;
        }
                
        if(character.position.x<0){
            character.position.x=self.size.width;
            fuel.position.x=self.size.width;
        }
                
        if(character.position.x>self.size.width){
            character.position.x=0;
            fuel.position.x=0;
        }
                
            shield_follow.position=CGPointMake(character.position.x-3, character.position.y+3);
            character.runAction(SKAction.moveBy(CGVectorMake(CGFloat(10.0*currentRoll),0), duration: 0.10));
            fuel.runAction(SKAction.moveBy(CGVectorMake(CGFloat(10.0*currentRoll),0), duration: 0.10));
    
        
        //add coins
                if(rocket_power>=0){
                    if(frame_counter%(Int(7/power_speed)+1)==0){
                        addCoin();
                    }
                }
                else{
                    if(frame_counter%7==0){
                        addCoin();
                    }
                }
        for shield: SKSpriteNode in shields{
            shield.position=CGPointMake(shield.position.x, shield.position.y-5)
            if(CGRectIntersectsRect(shield.frame,character.frame)){
                
                //shield_power=500;
                //shield_follow.physicsBody=SKPhysicsBody(circleOfRadius: 50);
                //shield_follow.physicsBody!.dynamic=false;
                shield_follow.hidden=false;
                shield_cover.hidden=false;
                setShieldBar(MAX_HEALTH)
                shield_bar.hidden=false;
                shield.removeFromParent()
                shields.removeAtIndex(shields.indexOf(shield)!)
            }
        }
        for rocket: SKSpriteNode in rockets{
            rocket.position=CGPointMake(rocket.position.x, rocket.position.y-5)
            if(CGRectIntersectsRect(rocket.frame,character.frame)){
                number_of_rockets++;
                rocketIter(number_of_rockets);
                rockets.removeAtIndex(rockets.indexOf(rocket)!)
                rocket.removeFromParent()
            }
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

        for falling: SKSpriteNode in falling_objects{
            if(rocket_power==199){
                falling.physicsBody!.velocity=CGVector(dx: CGFloat((falling.physicsBody?.velocity.dx)!)*CGFloat(power_speed), dy: CGFloat((falling.physicsBody?.velocity.dy)!)*CGFloat(power_speed));
                
                
            }
            if(rocket_power==0){
                 falling.physicsBody!.velocity=CGVector(dx: CGFloat((falling.physicsBody?.velocity.dx)!)*CGFloat(1.0/Double(power_speed)), dy: CGFloat((falling.physicsBody?.velocity.dy)!)*CGFloat(1.0/Double(power_speed)));
                falling.speed*=0.2;
                
            }
            let shrinkx:CGFloat=character.frame.width/2, shrinkx_m=character.frame.width/2
            let shrinky:CGFloat=character.frame.height/2, shrinky_m=character.frame.height/2
            if(CGRectIntersectsRect(CGRectMake(falling.frame.origin.x+shrinkx_m, falling.frame.origin.y+shrinky_m, 70, 70), CGRectMake(character.frame.origin.x+shrinkx, character.frame.origin.y+shrinky, 1, 1))){
                
                
                var explosion_size = 0.1*pow(pow((falling.physicsBody?.velocity.dx)!, 2)+pow((falling.physicsBody?.velocity.dy)!, 2), 0.5)
                if(explosion_size < 60){
                    explosion_size = 60
                }
                if(shield_follow.hidden==true){
                    self.explode(CGSizeMake(explosion_size, explosion_size), location: CGPointMake((character.position.x+falling.position.x)/2, (character.position.y+falling.position.y)/2), speed: (0.02), explosion_color: "red")
                    
                    setStaticHearts(Int(life_bar.size.width) - Int(explosion_size))
                }
                else{
                    
                    self.explode(CGSizeMake(explosion_size, explosion_size), location: CGPointMake((character.position.x+falling.position.x)/2, (character.position.y+falling.position.y)/2), speed: (0.02), explosion_color: "gray")
                    let change_shield=shield_bar.size.width-explosion_size
                    setShieldBar(Int(change_shield))
                    if(change_shield<0){
                        shield_cover.hidden=true;
                        shield_bar.hidden=true;
                        shield_follow.hidden=true;
                    }
                }
                falling_objects.removeAtIndex(falling_objects.indexOf(falling)!)
                
                
                falling.removeFromParent()
                
                

            }
            if(UFO_set==true){
            if(CGRectIntersectsRect(
                falling.frame, CGRectMake(UFO.position.x, UFO.position.y, 50, 50)
                )){
                explode(CGSizeMake(100, 100), location: UFO.position, speed: 0.02, explosion_color: "blue");
                UFO.removeFromParent();
                laser.removeFromParent()
                UFO=SKSpriteNode();
                UFO_Column=CGPointMake(-1000, 0);
                UFO_set=false;
            }
            }
            if(falling.position.y<character.position.y-character.size.height*2){
                falling_objects.removeAtIndex(falling_objects.indexOf(falling)!)
                falling.removeFromParent()
            }
                
        }
        
        //blast off
                if(number_of_rockets==3){
                    number_of_rockets=0 ;
                    rocketIter(number_of_rockets);
                    blastOff();
                }
        
        //move coins
        for coin: SKSpriteNode in coins{
            if(CGRectIntersectsRect(coin.frame,character.frame)){
                current_coins++;
                
                
                let b = { () -> Void in
                  
                    coin.removeFromParent()
                    
                    
                }
                let a = { () -> Void in
                    self.coin_label.hidden=false;
                    coin.runAction(SKAction.moveTo(CGPointMake(self.size.width,0), duration: 0.5), completion: b)
                    self.coin_cover.runAction(SKAction.scaleXTo(100, duration: 0.1));
                    self.coin_cover.runAction(SKAction.scaleYTo(40, duration: 0.1));
                    self.coin_image.runAction(SKAction.scaleXTo(20, duration: 0.1));
                    self.coin_image.runAction(SKAction.scaleYTo(20, duration: 0.1));
                    self.last_coin_submit=50;
                    self.coin_image.runAction(SKAction.moveToX(self.size.width-75, duration: 0.1))
                    
                
                    //coin.runAction(SKAction.scaleTo(CGFloat(0), duration: 0.5), completion: b)
                }
               
             
                coin.runAction(SKAction.runBlock(a))
            }
            if(rocket_power>0){
            coin.position=CGPointMake(coin.position.x, coin.position.y-CGFloat(5*power_speed))
            }
            else{
                coin.position=CGPointMake(coin.position.x, coin.position.y-CGFloat(5))
            }
            if(coin.position.y<character.position.y-character.size.height*2){
                coins.removeAtIndex(coins.indexOf(coin)!)
                coin.removeFromParent()
            }
        }

        //adding heart nodes
        if(arc4random_uniform(UInt32(heart_frequency))==0 && coin_alternator==false){
            let heart = Heart();
            heart.setup(30, parentsize: self.size)
            addChild(heart)
            hearts.append(heart);
        }
                
        if(arc4random_uniform(UInt32(rocket_frequency))==0 && coin_alternator==false){
            let rocket = Rocket();
            rocket.setup(CGSizeMake(60, 60));
            
            rocket.position=CGPointMake(CGFloat(arc4random_uniform(UInt32(self.size.width))), self.size.height)
            addChild(rocket);
            rockets.append(rocket);
        }
        //add falling objects
        var object_sequence = 50-frame_counter/200
            if(object_sequence<5){
                object_sequence = 5
            }
        let object_speed = -300-frame_counter/50
        
        if(frame_counter%(object_sequence)==0 && !(frame_counter%600==0)){
            addFallingObject(object_speed);
            }
        }
        }
        else if (game_status==3){
           
            life.setup(self.size);
            life.position = CGPointMake(self.size.width/2.0, -500);
            addChild(life);
            life.runAction(SKAction.moveToY(self.size.height/2.0, duration: 0.8))
            game_status=4;
        
        }
        else if (game_status==4){
            //holding pattern
        }
        else if(game_status==5){
            
            NSUserDefaults.standardUserDefaults().setObject(current_coins, forKey: "coins");
            
            let scene = TitleScene()
            // Configure the view.
            let skView = self.view as SKView?
            let transition = SKTransition.fadeWithDuration(1)
            skView!.showsFPS = false
            skView!.showsNodeCount = false
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView!.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.size=skView!.bounds.size;
            scene.scaleMode = .AspectFill
            skView!.presentScene(scene, transition:  transition)
            
        }
        
    }
    
}