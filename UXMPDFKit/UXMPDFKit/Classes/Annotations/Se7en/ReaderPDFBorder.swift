//
//  ReaerPDFBorder.swift
//  UXMPDFKit_Example
//
//  Created by mozhe on 2018/12/3.
//  Copyright © 2018 CocoaPods. All rights reserved.
//  

import UIKit


// Style in which PDFBorder is displayed.

public enum ReaderPDFBorderStyle : Int {
    
    
    case solid
    
    case dashed
    
    case beveled
    
    case inset
    
    case underline
}

// Border style dictionary keys.
public struct ReaderPDFBorderKey : Hashable, Equatable, RawRepresentable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
extension ReaderPDFBorderKey {
    
    
    public static let lineWidth: ReaderPDFBorderKey = ReaderPDFBorderKey(rawValue: "ReaderPDFBoarderKeyLineWidth")
    
    public static let style: ReaderPDFBorderKey = ReaderPDFBorderKey(rawValue: "ReaderPDFBoarderKeyStyle")
    
    public static let dashPattern: ReaderPDFBorderKey = ReaderPDFBorderKey(rawValue: "ReaderPDFBoarderKeyDashPattern")
}

// PDFBorder is not directly an annotation, but instead is a supportive structure common to a few annotations.


open class ReaderPDFBorder: NSObject, NSCoding{
    
    // -------- accessors
    
    // See styles above. Whether border is drawn solid, dashed etc.
    open var style: ReaderPDFBorderStyle
    
    
    // Width of line used to stroke border.
    open var lineWidth: CGFloat
    
    
    // Array of floats specifying the dash pattern (see NSBezierPath for more detail).
    open var dashPattern: [Any]?
    
    
    // List all border properties as key-value pairs; returns a deep copy of all pairs. Helpful for debugging.
    //    open var borderKeyValues: [AnyHashable : Any] {
    //        return
    //    }
    
    
    // Draw method. Not generally needed since the annotations themselves call this method when they are drawn.
    // Call -[NSColor set] before calling (the various annotations do this often calling -[PDFAnnotation color] or whatever
    // is appropriate for their class.
    open func draw(in rect: CGRect) {
        
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.style, forKey: "style")
        aCoder.encode(self.lineWidth, forKey: "lineWidth")
        if let dashPattern = self.dashPattern {
            aCoder.encode(dashPattern, forKey: "dashPattern")
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.style = aDecoder.decodeObject(forKey: "style") as! ReaderPDFBorderStyle
        self.lineWidth = aDecoder.decodeObject(forKey: "lineWidth") as! CGFloat
        self.dashPattern = aDecoder.decodeObject(forKey: "dashPattern") as? [Any]
        
        super.init()
        
    }
    
}
