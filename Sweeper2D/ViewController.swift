//
//  ViewController.swift
//  Sweeper2D
//
//  Created by 310_10 on 08/03/2018.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        func drawArea(path:UIBezierPath, color:CGColor) {
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = color
            layer.strokeColor = color
            layer.position = CGPoint(x:300, y:300)
            self.view.layer.addSublayer(layer)
        }
        
        let scene = SCNScene(named: "room.dae")
        let areaNode = scene!.rootNode.childNode(withName: "Area", recursively: true)!
        var path = pathFromGeomery(areaNode.geometry!)
        
        drawArea(path:path, color:UIColor.red.cgColor)
        
        for child in areaNode.childNodes {
            path = pathFromGeomery(child.geometry!)
            drawArea(path:path, color:UIColor.green.cgColor)
        }
    }
}

