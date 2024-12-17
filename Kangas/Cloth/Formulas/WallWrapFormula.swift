//
//  WallWrap.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation


extension Cloth {
 
    struct WallWrapOptions {
        let outerWallFill: Micron;//Paljonko ulkoseinää täytetään ylhäältä päin. Jos isompi kuin korkeus, niin käytetään korkeutta.
        
        let bottomSlack: Micron; //Jos koko ulkoseinä täytetään, niin paljonko alapintaan jätetään ylimääräistä. Ei tee mitään, jo outerWallFill on vähemmän kuin korkeus.
        
        init(outerWallFill: Micron, bottomSlack: Micron) {
            self.outerWallFill = outerWallFill
            self.bottomSlack = bottomSlack
        }
        
        static func defaults() -> WallWrapOptions {
            return WallWrapOptions(outerWallFill: Micron(-1), bottomSlack: Micron(-1))
        }
    }
    
    /*
     Palauttaa stringing, jossa on svg-tiedoston sisältö.
     */
    static func createWallWrap(parameters: WallWrapOptions, box: BoxData, work: WorkSettings) -> [String]  {
        
        ClothState.reset()
        
        let hasBottomSlack = parameters.bottomSlack > Micron(0) && parameters.outerWallFill > box.outer.height
        let outerFillLength = parameters.outerWallFill > Micron(0) ? min(box.outer.height, parameters.outerWallFill) : box.outer.height
        
        
        let outerWall1 = Rect(origin: p(0,0), size: Size(width: box.outer.width, height: outerFillLength))
        let outerWall2 = Rect.withHillEdge(from: outerWall1, towards: .right, distance: box.outer.depth, work: work)
        let outerWall3 = Rect.withHillEdge(from: outerWall2, towards: .right, distance: box.outer.width, work: work)
        let outerWall4 = Rect.withHillEdge(from: outerWall3, towards: .right, distance: box.outer.depth, work: work)
        let _/*outerFlap*/ = Flap.withHillEdge(from: outerWall4, towards: .right, distance: outerFillLength / 6, work: work)
        
        let rim1 = Flap.withHillEdge(from: outerWall1, towards: .up, distance: work.materialThickness, work: work)
        let rim2 = Flap.withHillEdge(from: outerWall2, towards: .up, distance: work.materialThickness, work: work)
        let rim3 = Flap.withHillEdge(from: outerWall3, towards: .up, distance: work.materialThickness, work: work)
        let rim4 = Flap.withHillEdge(from: outerWall4, towards: .up, distance: work.materialThickness, work: work)
        
        
        let innerWall1 = Rect.withHillEdge(from: rim1, towards: .up, distance: box.inner.height, work: work)
        let innerWall2 = Rect.withHillEdge(from: rim2, towards: .up, distance: box.inner.height, work: work)
        let innerWall3 = Rect.withHillEdge(from: rim3, towards: .up, distance: box.inner.height, work: work)
        let innerWall4 = Rect.withHillEdge(from: rim4, towards: .up, distance: box.inner.height, work: work)
        
        let _/*slack1*/ = Flap.withValleyEdge(from: innerWall1, towards: .up, distance: work.clothSlack, work: work)
        let _/*slack2*/ = Flap.withValleyEdge(from: innerWall2, towards: .up, distance: work.clothSlack, work: work)
        let _/*slack3*/ = Flap.withValleyEdge(from: innerWall3, towards: .up, distance: work.clothSlack, work: work)
        let _/*slack4*/ = Flap.withValleyEdge(from: innerWall4, towards: .up, distance: work.clothSlack, work: work)
        
        
        return [svgFrom(lines: findCuttableLines(from: ClothState.allRects))]
    }

    
}
