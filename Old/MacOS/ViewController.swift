//
//  ViewController.swift
//  MacOS
//
//  Created by Connor yass on 3/31/19.
//  Copyright © 2019 HSY_Technologies. All rights reserved.
//

import Cocoa

/* ----------------------------------------------------------------------------------------- */

class ViewController: NSViewController {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    @IBOutlet weak var circleView: CircleView!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
        
        circleView.divisions = 300
        circleView.multiple = 7
    }
    
    override func viewDidLayout() { circleView.updatePoints() }
    
    override func keyDown(with event: NSEvent) {
        print("keypressed: ", event.keyCode)
    }
    
    @IBAction func outputPoints(_ sender: Any) {
        circleView.printPoints()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
