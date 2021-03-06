//
//  Game.swift
//  FallsAssignment9
//
//  Created by Tarryn Falls on 11/15/17.
//  Copyright © 2017 Tarryn Falls. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit // using for random numvers
import AVFoundation

// add contact deligate so we can track collison
class Game: SKScene, SKPhysicsContactDelegate {
    
    var contentsCreated = false
    var hasClimbed = false
    var controller: ViewController!
    var points = 0
    let scoreSound = SKAction.playSoundFileNamed("good.mp3", waitForCompletion: false)
    let blockSound = SKAction.playSoundFileNamed("block.mp3", waitForCompletion: false)
    var endAudioPlayer: AVAudioPlayer? = nil
    //var pressed = false
    
    func loadAudio() {
        let path = Bundle.main.path(forResource: "bad", ofType: "mp3")
        let audioURL = URL(fileURLWithPath: path!)
        do {
            endAudioPlayer = try AVAudioPlayer(contentsOf: audioURL)
        } catch {
            print("unable to load audio file")
        }
    }
    
    override func didMove(to view: SKView) {
        if contentsCreated == false {
            backgroundColor = SKColor.black
            createBackdrop()
            createSceneObjects()
            contentsCreated = true
            physicsWorld.contactDelegate = self // set ourselves as contact delegate
        }
        else {
            resetMonkey()
            if let scoreNode = childNode(withName: "Score") as? SKLabelNode {
                scoreNode.text = "Start Climbing!"
            }
            
        }
    }
    
    
    
    func createBackdrop() {
        let floor = SKSpriteNode(color: SKColor.green, size: CGSize(width: frame.width, height: 205))
        floor.position = CGPoint(x: frame.midX, y: 10.0)
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.isDynamic = false
        floor.name = "floor"
        addChild(floor)
        
      
        var w: CGFloat = 336.0
        var x: CGFloat = w / 2.0
        let backTexture = SKTexture(imageNamed: "1.jpg")
        
        let originalWidth = 852
        let originalHeight = 480
        let newHeight = frame.height - 100
        let ratio = CGFloat(newHeight) /  CGFloat(originalHeight)
        w = CGFloat(originalWidth) * ratio
        x = w / 2.0
        while (x - w / 2.0) < (frame.width + w) {
            let back = SKSpriteNode(texture: backTexture)
            back.size = CGSize(width: w, height: newHeight)
            back.position = CGPoint(x: x, y: 112.0 + CGFloat(newHeight) / 2.0)
            back.name = "back"
            addChild(back)
            x = x + w
        }
        
        let ceiling = SKSpriteNode(color: SKColor.blue, size: CGSize(width: frame.width, height: 32))
        ceiling.position = CGPoint(x: frame.midX, y: frame.height + 16.0)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size)
        ceiling.physicsBody?.isDynamic = false
        ceiling.name = "ceiling"
        addChild(ceiling)
        
        let left = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 32, height: frame.height))
        left.position = CGPoint(x: frame.width + 16 , y: frame.midY)
        left.physicsBody = SKPhysicsBody(rectangleOf: left.size)
        left.physicsBody?.isDynamic = false
        left.name = "left"
        addChild(left)
        
        let right = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 32, height: frame.height))
        right.position = CGPoint(x: frame.width - 1217 , y: frame.midY)
        right.physicsBody = SKPhysicsBody(rectangleOf: right.size)
        right.physicsBody?.isDynamic = false
        right.name = "right"
        addChild(right)
        
    }
    
    func createSceneObjects() {
        
        physicsWorld.contactDelegate = self
        
        let scoreNode = SKLabelNode(fontNamed: "Courier")
        scoreNode.text = "Start Climbing!"
        scoreNode.fontSize = 24
        scoreNode.position = CGPoint(x: 150.0, y: size.height-58.0)
        scoreNode.name = "Score"  // there isn't significance to what this string is, the name just lets us look up and get access to that node in the scene
        addChild(scoreNode)
        
        let m = SKTexture(imageNamed: "monkey.png")
        let mTextures = [m]
        
        let monkey = SKSpriteNode(texture: m)
        monkey.position = CGPoint(x: frame.midX, y: 150)
        monkey.name = "Monkey"
        monkey.physicsBody = SKPhysicsBody(rectangleOf: monkey.size)
        monkey.physicsBody?.isDynamic = true
        monkey.physicsBody?.contactTestBitMask = 1
       
        addChild(monkey) // adding to the scene
        loadAudio()
    }
    
    func resetMonkey()
    {
        if let monkey = childNode(withName: "Monkey") {
            monkey.position = CGPoint(x: frame.midX, y: 150)
            hasClimbed = false
        }
    }
    
    
    
    override func mouseDown(with event: NSEvent) {
        
         run(blockSound)
         let point = event.location(in: self) // reporting location from coordinate system of scene
         let thing = SKSpriteNode(color: SKColor.brown, size: CGSize(width: 70, height: 70))
         thing.position = point  //position is where mouse is
         thing.name = "Thing"
         thing.physicsBody = SKPhysicsBody(rectangleOf: thing.size)
         addChild(thing)
 
        
        
        
    }
    
    
    
    /*  Control object with keyboard  */
    override func keyDown(with event: NSEvent) {
        print("keyCode is \(event.keyCode)")
        if let node = childNode(withName: "Monkey") {
            
            if event.keyCode == 124{ // if right arrow pressed
                
                node.run(SKAction.moveBy(x: 20.0, y: 45.0, duration: 0.1)) //move 10 right
                //if let node = childNode(withName: "Monkey") {
                  //  let ur = CGVector(dx: 10.0, dy: 60.0)
                    
                    //node.physicsBody?.applyImpulse(ur)
                    
                    
                //}
               
            }
            else if event.keyCode == 123 {
                node.run(SKAction.moveBy(x: -20.0, y: 45.0, duration: 0.1)) // 10 left
                //if let node = childNode(withName: "Monkey") {
                   // let ul = CGVector(dx: -10.0, dy: 60.0)
                    
                   // node.physicsBody?.applyImpulse(ul)
                //}
                
            }
       
        }
       
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ceiling" && contact.bodyB.node?.name == "Monkey" {
            
            
            run(scoreSound)
            let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
            view?.presentScene(controller.game2, transition: doors)
            
            //reset blocks
            removeAction(forKey: "thing")
            enumerateChildNodes(withName: "Thing") { (node, stop) in
                node.run(SKAction.removeFromParent())
            }
            
            
            controller.hello.updateText()
            
        }
        else if contact.bodyA.node?.name == "floor" && contact.bodyB.node?.name == "Monkey" && hasClimbed == true{
            //isPaused = true
            endAudioPlayer?.play()
            hasClimbed = false
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let node = childNode(withName: "Monkey") {
            if node.position.y > 250 && node.position.y < 499{
                if let scoreNode = childNode(withName: "Score") as? SKLabelNode {
                    scoreNode.text = "Keep Climbing!"
                    hasClimbed = true
                    
                    if node.position.y > 255 && node.position.y < 257{
                        run(scoreSound)
                    }
                }
            }
            else if node.position.y > 500 && node.position.y < 649 {
                if let scoreNode = childNode(withName: "Score") as? SKLabelNode {
                    scoreNode.text = "Almost there..."

                    if node.position.y > 505 && node.position.y < 507{
                        run(scoreSound)
                    }
                }
            }
            else if node.position.y > 650 {
                if let scoreNode = childNode(withName: "Score") as? SKLabelNode {
                    scoreNode.text = "Hit the top!"
                
                    if node.position.y > 655 && node.position.y < 657{
                        run(scoreSound)
                    }
                
                }
            }
            
        }
        
    }
    
}
