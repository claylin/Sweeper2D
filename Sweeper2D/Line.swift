//
//  Line.swift
//  test
//
//  Created by 310_10 on 08/03/2018.
//  Copyright © 2018 Clay Lin. All rights reserved.
//

import Foundation

struct Line {
    var start:Int
    var end:Int
    
    mutating func swap() {
        let temp = start
        start = end
        end = temp
    }
}

extension Line: Hashable {
    var hashValue: Int {
        return start.hashValue ^ end.hashValue &* 16777619
    }
    
    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }
}
