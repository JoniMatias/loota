//
//  BoxOpenTopped.swift
//  Kangas
//
//  Created by Joni Rajala on 10.12.2024.
//

import Foundation


class BoxOpenTopped: BoxData {
    
    override class func isFaceOpen(_ face: Direction3D) -> Bool {
        return face == .ceiling ? true : false
    }
    
    override func toUrl(work: WorkSettings) -> String {
        let base = "https://boxes.hackerspace-bamberg.de/ABox?"
        let string = "x=\(outer.width.inMillimeter())&y=\(outer.depth.inMillimeter())&h=\(outer.height.inMillimeter())&outside=1&bottom_edge=\(BoxesPy.BottomEdge.finger.rawValue)&burn=\(work.kerf.inMillimeter())&render=1"
        return base + string
    }
    
}
