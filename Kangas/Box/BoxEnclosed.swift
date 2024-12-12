//
//  BoxEnclosed.swift
//  Kangas
//
//  Created by Joni Rajala on 10.12.2024.
//

import Foundation


class BoxEnclosed: BoxData {
    
    override class func isFaceOpen(_ face: Direction3D) -> Bool {
        return false
    }
    
    override func toUrl(work: WorkSettings) -> String {
        let base = "https://boxes.hackerspace-bamberg.de/ClosedBox?"
        let string = "x=\(outer.width.inMillimeter())&y=\(outer.depth.inMillimeter())&h=\(outer.height.inMillimeter())&thickness=\(work.materialThickness.inMillimeter())&outside=1&burn=\(work.kerf.inMillimeter())&render=1"
        return base + string
    }

}

