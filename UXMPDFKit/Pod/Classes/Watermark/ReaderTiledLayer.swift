//
//  ReaderTiledLayer.swift
//  Pods-UXMPDFKit_Example
//
//  Created by mozhe on 2018/11/27.
//  Inspired by UXReader UXReaderTiledLayer

import UIKit


open class ReaderTiledLayer: CATiledLayer {
    
    private static let levelsOfDetail: CGFloat = 4
    
    open class var minimumZoom: CGFloat {
        return 0.5
    }
    open class var maximumzoom: CGFloat {
        return levelsOfDetail
    }
    open override class func fadeDuration() -> CFTimeInterval {
        return 0.001 //iOS bug (blank tile) workaround
    }
    
    public override init() {
        super.init()
        
        self.levelsOfDetail = Int(ReaderTiledLayer.levelsOfDetail)
        self.levelsOfDetailBias = Int(ReaderTiledLayer.levelsOfDetail) - 1
        self.tileSize = CGSize(width: 1024, height: 1024)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//    CATiledLayer levelsOfDetail
//
//    To provide multiple levels of content, you need to set the levelsOfDetail property.
//    For this sample, we have 5 levels of detail (1/4x - 4x).
//    By setting the value to 5, we establish that we have levels of 1/16x - 1x (2^-4 - 2^0)
//    we use the levelsOfDetailBias property we shift this up by 2 raised to the power
//    of the bias, changing the range to 1/4-4x (2^-2 - 2^2).
//
//    exampleCATiledLayer.levelsOfDetail = 5;
//    exampleCATiledLayer.levelsOfDetailBias = 2;
//
//    The base level of detail is a zoom level of 2^0 (1 level of detail
//    only allows for a single representation like that). Each additional
//    level of detail is a zoom level half that size smaller (thus a 2nd
//    level if 2^-1x or 1/2x, then 2^-2x or 1/4x, etc). The bias adds to the
//    base level's exponent, thus a bias of 2 means the base level if 2^2x
//    (4x) zoom instead of 2^0x zoom.
//
//    There are no powers of 4, (or 5 or any other except for 2). The level
//    of detail is range of the exponent, not the base.
//
