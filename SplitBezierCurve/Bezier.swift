//
//  i.swift
//  SplitBezierCurve
//
//  Created by hjliu on 2016/3/10.
//  Copyright © 2016年 hjliu. All rights reserved.
//

import UIKit

class Bezier{

    class func DeCasteljauBezier(points:[CGPoint],splitNumber:Int)->[CGPoint]{
        
        //資料結構
        class tempPoint{
            var x:CGFloat
            var y:CGFloat
            var dic:CGFloat
            
            init(x:CGFloat,y:CGFloat,dic:CGFloat){
                self.x = x
                self.y = y
                self.dic = dic
            }
        }
        
        let len = points.count //座標數
        
        //如果無座標
        if len == 0{
            return []
        }
        
        //只有一個點
        if len == 1{
            return points
        }
        
        var pointsArry = points //貝茲曲線宣告點
        var bezierLength:CGFloat = 0 //總長
        let lastPoint = points.last! //最後一個點
        var tempArray = [tempPoint(x: pointsArry.first!.x,y: pointsArry.first!.y,dic: 0)] //貝茲曲線描述點
        
        let step = 0.00001 // bezier遞迴步長
        
        // 遞迴
        for var t:Double = 0; t <= 1; t += step {
            for i in 1..<len{
                for j in 0..<len - i{
                    pointsArry[j].x = pointsArry[j].x * CGFloat(1 - t) + pointsArry[j + 1].x * CGFloat(t)
                    pointsArry[j].y = pointsArry[j].y * CGFloat(1 - t) + pointsArry[j + 1].y * CGFloat(t)
                }
            }
            
            let now = pointsArry[0]
            
            if pow(now.x-lastPoint.x, 2) + pow(now.y-lastPoint.y, 2) < CGFloat(step){
                break
            }
            
            //tempArray 最後一個點
            let last = tempArray.last!
            
            //計算總長距離
            bezierLength += sqrt(pow(now.x-last.x, 2) + pow(now.y-last.y, 2))
            
            tempArray.append(tempPoint(x:now.x, y:now.y, dic:bezierLength))
        }
        
        // 採樣
        let splitLength = bezierLength / CGFloat(splitNumber)//平均間距 = 總長 / 均分數
        
        var results = [CGPoint]()
        
        var i:CGFloat = 0
        for p in tempArray{
            
            //距離符合平均間距 則加入座標集合
            if p.dic >= i * splitLength{
                
                results.append(CGPoint(x: p.x, y: p.y))
                i++
            }
        }
        
        //缺少一節 則加入最後一個座標
        if results.count == splitNumber{
            results.append(lastPoint)
        }else{
            results[splitNumber] = lastPoint
        }
        
        return results
    }
}
