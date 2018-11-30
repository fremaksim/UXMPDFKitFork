//
//  ReaderDocumentOutlineItem.swift
//  UXMPDFKit_Example
//
//  Created by mozhe on 2018/11/29.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreGraphics

class ReaderDocumentOutlineItem: NSObject {
    
    private(set) var title: String?
    private(set) var pageNumber: Int
    private(set) var destination: CGPDFObjectRef?
    private(set) var children: [ReaderDocumentOutlineItem]?
    
    init(title: String?,
         pageNumber: Int,
         destination: CGPDFObjectRef?,
         children: [ReaderDocumentOutlineItem]?) {
        
        self.title = title
        self.pageNumber = pageNumber
        self.destination = destination
        self.children = children
        
        super.init()
    }
    
    override var description: String {
        return "[Outline Item] + \(title ?? "") ):\(pageNumber)"
    }
    
}
