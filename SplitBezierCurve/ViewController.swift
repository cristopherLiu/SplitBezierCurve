//
//  ViewController.swift
//  SplitBezierCurve
//
//  Created by hjliu on 2016/3/10.
//  Copyright © 2016年 hjliu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 150,y: 50))
        path.addCurveToPoint(CGPoint(x: 150,y: 250), controlPoint1: CGPoint(x: 300,y: 150), controlPoint2: CGPoint(x: 300,y: 150))
        
        //虛線
        self.view.addDashedLine(path.CGPath, color: UIColor.redColor())
        
        //split Point
        let points = Bezier.DeCasteljauBezier(
            path.CGPath.getPathPoint()
            ,splitNumber: 30)
        
        points.forEach({ point in
            let view = UIView(frame: CGRectMake(point.x,point.y,5,5))
            view.layer.cornerRadius = 2.5
            view.clipsToBounds = true
            view.backgroundColor = UIColor.blackColor()
            self.view.addSubview(view)
        })
    }
}

extension UIView {
    
    func addDashedLine(path:CGPathRef,color:UIColor = UIColor.blackColor()) {
        
        self.layer.sublayers?.filter({$0.name == "DashedLine"}).forEach({$0.removeFromSuperlayer()})
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedLine"
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color.CGColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 100
        shapeLayer.lineDashPattern = [10,10]
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
}

extension CGPath {
    func forEach(@noescape body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutablePointer<Void>, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, Body.self)
            body(element.memory)
        }
        let unsafeBody = unsafeBitCast(body, UnsafeMutablePointer<Void>.self)
        CGPathApply(self, unsafeBody, callback)
    }
    
    func getPathPoint()->[CGPoint]{
        
        var result = [CGPoint]()
        
        self.forEach { element in
            
            switch (element.type) {
                
            case CGPathElementType.MoveToPoint:
                result.append(element.points[0])
                //                print("move(\(element.points[0]))")
            case .AddLineToPoint:
                result.append(element.points[0])
                //                print("line(\(element.points[0]))")
            case .AddQuadCurveToPoint:
                result.append(element.points[0])
                result.append(element.points[1])
                //                print("quadCurve(\(element.points[0]), \(element.points[1]))")
            case .AddCurveToPoint:
                result.append(element.points[0])
                result.append(element.points[1])
                result.append(element.points[2])
                //                print("curve(\(element.points[0]), \(element.points[1]), \(element.points[2]))")
            case .CloseSubpath: break
            }
        }
        return result
    }
}

