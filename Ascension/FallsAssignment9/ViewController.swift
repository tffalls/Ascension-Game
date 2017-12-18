//
//  ViewController.swift
//  FallsAssignment9
//
//  Created by Tarryn Falls on 11/15/17.
//  Copyright © 2017 Tarryn Falls. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {
    @IBOutlet var spriteView: SKView!
    var hello: Hello!
    var game: Game!
    var game2: Game2!
    var game3: Game3!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        spriteView.showsFPS = true
        spriteView.showsDrawCount = true
        spriteView.showsNodeCount = true
        
        hello = Hello(size: CGSize(width: view.frame.width, height: view.frame.height))//passing in size of the SKView
        hello.controller = self
        game = Game(size: CGSize(width: view.frame.width, height: view.frame.height))
        game.controller = self
        game2 = Game2(size: CGSize(width: view.frame.width, height: view.frame.height))
        game2.controller = self
        game3 = Game3(size: CGSize(width: view.frame.width, height: view.frame.height))
        game3.controller = self
        
        //commented out for testing w/ game scene
        spriteView.presentScene(hello)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

