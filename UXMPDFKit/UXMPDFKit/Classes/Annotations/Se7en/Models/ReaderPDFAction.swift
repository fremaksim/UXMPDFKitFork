//
//  ReaderPDFAction.swift
//  UXMPDFKit_Example
//
//  Created by mozhe on 2018/12/3.
//  Copyright © 2018 CocoaPods. All rights reserved.
//
import UIKit

open class ReaderPDFAction: NSObject, NSCoding {
    
    public func encode(with aCoder: NSCoder) {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
    }
    
    // Type of action.  These won't always correspond to the PDFAction subclass in the way you might expect.  For example,
    // a PDFActionURL may return "URI" or "Launch" depending upon the original action (as defined in the PDF spec. - for
    // the PDFKit API we decided to handle the two actions within the same class and also use the more familiar 'URL' term
    // rather than 'URI').
    // Type based on the Adobe PDF Specification (1.7), Table 8.48: Action types.
    open func type() -> String {
        
        return "ReaderPDFAction"
    }
    
}
