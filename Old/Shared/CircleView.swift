//
//  Circle.swift
//  _circleMultiplication
//
//  Created by Connor yass on 5/16/18.
//  Copyright © 2018 HSY_Technologies. All rights reserved.
//

import Cocoa

/* ----------------------------------------------------------------------------------------- */

class CircleView: NSView {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    private var center: CGPoint {
        get {
            return CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
        }
    }
    
    private var diameter: CGFloat {
        get {
            let a = self.frame.width - 15
            let b = self.frame.height - 15
            return (a > b) ? b : a
        }
    }
    
    private var points = [CGPoint]()
    
    private var _divisions: Int = 10
    @objc var divisions: Int {
        get { return _divisions }
        set {
            _divisions = newValue
            updatePoints()
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    private var _multiple: Int = 5
    @objc var multiple: Int {
        get { return _multiple }
        set {
            _multiple = newValue
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    func updatePoints() {
        points.removeAll()
        
        let da = (CGFloat.pi * 2) / CGFloat(_divisions)
        
        for i in 0..<_divisions {
            let x = center.x + cos(CGFloat(i) * da) * (diameter / 2.0)
            let y = center.y + sin(CGFloat(i) * da) * (diameter / 2.0)
            points += [CGPoint(x: x, y: y)]
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    var drawPoints = false
    var drawCircle = true
    var drawLines = true
    
    @objc var lineColor = NSColor.red {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if(drawCircle) {
            let origin = CGPoint(x: center.x - diameter/2.0, y: center.y - diameter/2.0)
            let rect = CGRect(origin: origin, size: CGSize(width: diameter, height: diameter))
            let circle = NSBezierPath(ovalIn: rect)
            
            NSColor.darkGray.setStroke()
            circle.stroke()
        }
        
        if(drawPoints) {
            for point in points {
                let rect2 = CGRect(origin: point, size: CGSize(width: 4.0, height: 4.0))
                let circle2 = NSBezierPath(ovalIn: rect2)
                circle2.fill()
            }
        }
        
        if(drawLines) {
            lineColor.setStroke()
            for (i, pointA) in points.enumerated() {
                let line = NSBezierPath()
                line.move(to: pointA)
                let pointB = getPoint(for: i)
                line.line(to: pointB)
                line.stroke()
            }
        }
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    private func getPoint(for division: Int) -> CGPoint {
        var x = division * multiple
        if(x >= divisions){
            x = x % divisions
        }
        return points[x]
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    func printPoints() {
        
        print("------------------------------------------------------")
        print("------------------------------------------------------")
        
        if(drawLines) {
            lineColor.setStroke()
            for (i, pointA) in points.enumerated() {
                let line = NSBezierPath()
                line.move(to: pointA)
                let pointB = getPoint(for: i)
                line.line(to: pointB)
                print(pointA, pointB)
            }
        }
        print("------------------------------------------------------")
        print("------------------------------------------------------")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */







