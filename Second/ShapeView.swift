//
//  ShapeView.swift
//  DifferentFigures
//
//  Created by Artur Kablak on 16/11/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit

class ShapeView: UIView {
    
//    var size: CGFloat {
//        return min(bounds.size.width, bounds.size.height) / 2 }
    let lineWidth: CGFloat = 3
    var fillColor: UIColor!
    var path: UIBezierPath!
    var bits: Int? = 60 {
        didSet {
            print("setNeedsDisplay")
            setNeedsDisplay()
        }
    }
    
    // MARK: Choosing geometrical figure according to heart rate
    
    private func randomPath(pulse: Int) -> UIBezierPath {
        var figure: UIBezierPath?
        let insetRect = self.bounds.insetBy(dx: lineWidth, dy: lineWidth)
        let insetSquare = self.bounds.insetBy(dx: 15, dy: 15)
        
        switch pulse {
            
        case 0...39:
            figure = UIBezierPath(ovalIn: insetRect)
            
        case 40...75:
            figure = UIBezierPath(roundedRect: insetSquare, cornerRadius: 10.0)
            
        case 76...100:
            figure = trianglePathInRect(rect: insetRect)
            
        case 101...125:
            figure = regularPolygonInRect(rect: insetRect, pulse: pulse)
            
        case 126...220:
            figure = starInRect(rect: insetRect, pulse: pulse)
            
        default:
            print("Unrecognized pulse, mutation!")
        }
        return figure!
    }
    
    // MARK: Drawing geometrical figures
    
    func trianglePathInRect(rect:CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.width / 2.0, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))
        path.close()
        
        return path
    }
    
    func pointFrom(some angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
    }
    
    func regularPolygonInRect(rect: CGRect, pulse: Int) -> UIBezierPath {
        
        let degree = pulse/10 - 5
        
        let path = UIBezierPath()
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        var angle: CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(degree))
        let radius = rect.width / 2.0
        
        path.move(to: pointFrom(some: angle, radius: radius, offset: center))
        
        for _ in 1...degree - 1 {
            angle += angleIncrement
            path.addLine(to: pointFrom(some: angle, radius: radius, offset: center))
        }
        
        path.close()
        
        return path
    }
    
    func starInRect(rect:CGRect, pulse: Int) -> UIBezierPath {
        
        var degree = pulse / 10 - 12
        degree = degree % 2 == 0 ? degree + 8 : degree + 7
        let path = UIBezierPath()
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        var angle: CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(degree))
        var radius = rect.width / 2.0
        
        path.move(to: pointFrom(some: angle, radius: radius, offset: center))
        
        for _ in 1...degree - 1 {
            angle += angleIncrement
            radius = radius == rect.width/2 ? rect.width/4 : rect.width/2
            path.addLine(to: pointFrom(some: angle, radius: radius, offset: center))
        }
        
        path.close()
        
        return path
    }
    
    
    //    init(origin: CGPoint) {
    //        super.init(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
    //        self.path = randomPath()
    //        self.fillColor = randomColor()
    //        self.center = origin
    //        self.backgroundColor = UIColor.clear
    //
    //        initGestureRecognizers()
    //    }
    
    // We need to implement init(coder) to avoid compilation errors
    //    required init(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
//    func randomColor() -> UIColor {
//        let hue: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
//        
//        return UIColor(hue: hue, saturation: 0.9, brightness: 1.0, alpha: 1.0)
//    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.backgroundColor = UIColor.clear
        
        if let heartBits = bits {
            self.path = randomPath(pulse: heartBits)
        } else {
            self.path = randomPath(pulse: 60)
            
        }
        
        self.fillColor = UIColor(red: 105/255, green: 235/255, blue: 255/255, alpha: 1.0) // randomColor()
        self.fillColor.setFill()
        self.path.fill()
        
        
//        self.path.lineWidth = self.lineWidth
//        UIColor.black.setStroke()
//        self.path.stroke()
        
        
    }
    
}


