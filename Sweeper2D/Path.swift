//
//  Path.swift
//  test
//
//  Created by 310_10 on 08/03/2018.
//  Copyright © 2018 Clay Lin. All rights reserved.
//

//import AppKit
import Foundation
import CoreGraphics
import SceneKit

//Not necessary for UIBezierPath
//public extension NSBezierPath
//{
//    public var CGPath: CGPath
//    {
//        let path = CGMutablePath()
//        var points = [CGPoint](repeating: .zero, count: 3)
//        for i in 0 ..< self.elementCount {
//            let type = self.element(at: i, associatedPoints: &points)
//            switch type {
//            case .moveToBezierPathElement: path.move(to: CGPoint(x: points[0].x, y: points[0].y) )
//            case .lineToBezierPathElement: path.addLine(to: CGPoint(x: points[0].x, y: points[0].y) )
//            case .curveToBezierPathElement: path.addCurve(      to: CGPoint(x: points[2].x, y: points[2].y),
//                                                                control1: CGPoint(x: points[0].x, y: points[0].y),
//                                                                control2: CGPoint(x: points[1].x, y: points[1].y) )
//            case .closePathBezierPathElement: path.closeSubpath()
//            }
//        }
//        return path
//    }
//}

func pathFromGeomery(_ geometry:SCNGeometry) -> UIBezierPath {
    
    //Show the information for the geometry
//    print("\(geometry.name!)")
//    print(geometry.elements)
//    print(geometry.sources)
    
    //Get the points from the geometry
    var points = [CGPoint]()
    for source in geometry.sources {
        source.data.withUnsafeBytes { (dataPtr: UnsafePointer<Float32>) in
            let floatPtr = UnsafeMutablePointer<Float32>(mutating:dataPtr)
            for i in 0 ..< source.vectorCount {
                let x = floatPtr[i*3]
                let y = floatPtr[i*3+1]
                points.append(CGPoint(x:CGFloat(x), y:CGFloat(y)))
            }
        }
    }
    
    //Sort the lines and construct the path
    let path = UIBezierPath()
    for element in geometry.elements {
        //        var orphanLines:Set<Line> = Set<Line>()
        var orderedLines:Array<Line> = Array<Line>()
        
        element.data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
            let uint8Ptr = UnsafeMutablePointer<UInt8>(mutating:dataPtr)
            for i in 0 ..< element.primitiveCount {
                switch element.primitiveType {
                case .line:
                    var line = Line(start:Int(uint8Ptr[i*2]), end:Int(uint8Ptr[i*2+1]))
                    if orderedLines.count == 0 {
                        orderedLines.append(line)
                    } else if orderedLines.first?.start == line.end {
                        orderedLines.insert(line, at: 0)
                    } else if orderedLines.first?.start == line.start {
                        line.swap()
                        orderedLines.insert(line, at: 0)
                    } else if orderedLines.last?.end == line.start {
                        orderedLines.append(line)
                    } else if orderedLines.last?.end == line.end {
                        line.swap()
                        orderedLines.append(line)
                    } else {
                    }
                default:
                    break
                }
            }
            path.move(to: points[orderedLines.first!.start])
            for line in orderedLines {
                path.addLine(to: points[line.end])
            }
            path.close()
            orderedLines.removeAll()
        }
    }
    return path
}
