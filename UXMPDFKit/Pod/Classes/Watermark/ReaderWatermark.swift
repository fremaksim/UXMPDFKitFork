//
//  ReaderWatermark.swift
//  UXMPDFKit_Example
//
//  Created by mozhe on 2018/11/28.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

//
//    This class demonstrates implementing watermarking document page display
//    by adopting and implementing the UXReaderRenderTileInContext protocol.
//

open class ReaderWatermark: NSObject {
    //MARK: - Properties
    private var lineSizes: [CGSize] = [CGSize]()
    private var textLines: [NSAttributedString] = [NSAttributedString]()
    private var totalSize: CGSize   = CGSize.zero
    private var fudge: CGFloat = 0.7  //乳脂，软糖
    
    init?(textLines: [String] = ["mozheanquan"]) {
        guard  textLines.count > 0 else {
            return nil
        }
        super.init()
        self.prepareWatermark(lines: textLines)
        
    }
    
    private func prepareWatermark(lines: [String]){
        
        let font = UIFont.init(name: "Helvetica", size: 36.0)
        let color = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1)
        let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName: color]
        
        for line in lines { // Enumerate watermark text lines
            
            let trim = line.trimmingCharacters(in: CharacterSet.whitespaces)
            let text = NSAttributedString(string: trim, attributes: attributes)
            
            var textSize = text.size()
            textSize.width = ceil(textSize.width)
            textSize.height = ceil(textSize.height)
            
            totalSize.height += textSize.height
            if totalSize.width < textSize.width {
                totalSize.width = textSize.width
            }
            textLines.append(text)
            lineSizes.append(textSize)

        }
    }
    
}

extension ReaderWatermark: ReaderRenderTileInContext {
    
    public func renderTile(with documentPage: PDFPageContent, in Context: CGContext) {
        
    }
}
