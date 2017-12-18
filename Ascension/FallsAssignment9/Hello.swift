//
//  Hello.swift
//  FallsAssignment9
//
//  Created by Tarryn Falls on 11/15/17.
//  Copyright © 2017 Tarryn Falls. All rights reserved.
//

import Cocoa
import SpriteKit

class Hello: SKScene {
    // Scene will be the central place around wich things happen
    
    var contentsCreated = false
    
    // Tell hello about view controller
    var controller: ViewController!
    let loseSound = SKAction.playSoundFileNamed("Lose.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        if contentsCreated == false {
            backgroundColor = SKColor.yellow
            makeTextNode()
        }
    }
    
    
    
    func makeTextNode() {
        let textNode = SKLabelNode(fontNamed: "Futura")
        textNode.text = "Ascension"
        textNode.fontSize = 48
        textNode.fontColor = NSColor.black
        textNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        textNode.name = "HelloText"  // there isn't significance to what this string is, the name just lets us look up and get access to that node in the scene
        addChild(textNode)
        
        
        let textNode2 = SKLabelNode(fontNamed: "Futura")
        textNode2.text = "Click to Play"
        textNode2.fontSize = 36
        textNode2.fontColor = NSColor.black
        textNode2.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - 50.0)
        textNode2.name = "OtherText"  // there isn't significance to what this string is, the name just lets us look up and get access to that node in the scene
        addChild(textNode2)
        
        
        let textNode3 = SKLabelNode(fontNamed: "Futura")
        textNode3.text = "Your goal is to climb to the top of the screen! Use the left and right arrows to navigate, click to drop blocks, and watch out for falling bananas!"
        textNode3.fontSize = 18
        textNode3.fontColor = NSColor.black
        textNode3.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - 300.0)
        textNode3.name = "Instructions"  // there isn't significance to what this string is, the name just lets us look up and get access to that node in the scene
        addChild(textNode3)
        
    }
    
    
    // switch to game scene on click
    override func mouseDown(with event: NSEvent) {
        
        
        if let node = childNode(withName: "HelloText")
        {
            // doing optional unwrapping so if no node with name it returns nil
            // making a sequence out of multiple actions
            
            let moveUp = SKAction.moveBy(x: 0.0, y: 200.0, duration: 0.5)
            let pause = SKAction.wait(forDuration: 0.5)
            let fade = SKAction.fadeOut(withDuration: 0.25)
            let remove = SKAction.removeFromParent() //remove the node
            
            let sequence = SKAction.sequence([moveUp, pause, fade, remove])
            
            
            node.run(sequence, completion: {
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                self.view?.presentScene(self.controller.game, transition: transition)
            })
        }
        else
        {
            print("There is no HelloText node.")
        }
    }
    
    
    
    func updateText() {
        if let node = childNode(withName: "HelloText") as! SKLabelNode? {
            node.text = "You Win!"
        }
        
    }
    
    func updateText2() {
        if let node = childNode(withName: "HelloText") as! SKLabelNode? {
            node.text = "You Lose!"
            run(loseSound)
        }
    }
}

