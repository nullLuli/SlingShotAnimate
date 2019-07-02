//
//  SlingShot.swift
//  swiftLearn
//
//  Created by nullLuli on 2019/7/2.
//  Copyright © 2019 nullLuli. All rights reserved.
//

import Foundation
import UIKit

class SlingShotController: UIViewController {
    //view
    let slingShotView: SlingShotView = SlingShotView()
    
    //数据
    var beginPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(slingShotView)
        slingShotView.frame = view.bounds
        slingShotView.backgroundColor = UIColor.white
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            beginPoint = gesture.location(in: view)
        case .changed:
            let currentPoint = gesture.location(in: view)
            if let begin = beginPoint {
                changeLine(begin: begin, current: currentPoint)
            }
//        case .ended:
//            let currentPoint = gesture.location(in: view)
//            if let begin = beginPoint {
//                changeLine(begin: begin, current: currentPoint)
//            }
        default:
            ()
        }
    }
    
    func changeLine(begin: CGPoint, current: CGPoint) {
        let leftContrY = (current.y - begin.y) / 2 + beginY + yDeviation
        let leftContrX = UIScreen.main.bounds.width / 4
        
        let rightContrY = leftContrY
        let rightContrX = UIScreen.main.bounds.width - leftContrX
        
        slingShotView.leftContr = CGPoint(x: leftContrX, y: leftContrY)
        slingShotView.rightContr = CGPoint(x: rightContrX, y: rightContrY)
        
        slingShotView.setNeedsDisplay()
    }
}

let beginY: CGFloat = 400
let yDeviation: CGFloat = 50

class SlingShotView: UIView {
    var leftContr: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 3, y: beginY)
    var rightContr: CGPoint = CGPoint(x: UIScreen.main.bounds.width * 2 / 3, y: beginY)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.black.setStroke()
        
        let beginPoint: CGPoint = CGPoint(x: 0, y: beginY)
        let endPoint: CGPoint = CGPoint(x: UIScreen.main.bounds.width, y: beginY)
        
        let path = UIBezierPath.init()
        path.move(to: beginPoint)
        path.addCurve(to: endPoint, controlPoint1: leftContr, controlPoint2: rightContr)
        path.lineWidth = 2
        
        path.stroke()
        
        let leftContrPath = UIBezierPath(rect: CGRect(origin: leftContr, size: CGSize(width: 2, height: 2)))
        leftContrPath.stroke()
        
        let rightContrPath = UIBezierPath(rect: CGRect(origin: rightContr, size: CGSize(width: 2, height: 2)))
        rightContrPath.stroke()
    }
}
