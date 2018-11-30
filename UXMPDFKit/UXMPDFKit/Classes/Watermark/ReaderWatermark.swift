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
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : font!,
            NSAttributedString.Key.foregroundColor: color]
        
        for line in lines { // Enumerate watermark text lines
            
            let trim = line.trimmingCharacters(in: CharacterSet.whitespaces)
            let text = NSAttributedString(string: trim, attributes: attributes)
            
            var textSize = text.size()
            textSize.width = ceil(textSize.width)
            textSize.height = ceil(textSize.height)
            
            totalSize.height += textSize.height
            if totalSize.width < textSize.width { // get maximum text width
                totalSize.width = textSize.width
            }
            textLines.append(text)
            lineSizes.append(textSize)
        }
    }
    
}

extension ReaderWatermark: ReaderRenderTileInContext {
    
    public func renderTile(with documentPage: PDFPageContent, in ctx: CGContext) {
        guard textLines.count > 0  else { return }
        
        ctx.saveGState()
        
        let pageSize = documentPage.viewRect.size // In points
        let bw = pageSize.width
        let bh = pageSize.height
        let ar = (bw > bh) ? (bh / bw) : (bw / bh)
        let sf = (sqrt(sqrt(ar)) * fudge)
        
        // scale 0.5
        ctx.translateBy(x: bw * 0.5, y: bh * 0.5)
        // clockwise rotate
        ctx.rotate(by: -atan2(bh, bw))
        
        let ts = ((sqrt(bw * bw + bh * bh) / totalSize.width) * sf)
        ctx.scaleBy(x: ts, y: -ts)
        
        // center
        let xt = -floor(totalSize.width * 0.5)
        var yp = -floor(totalSize.height * 0.5)
        
        // reverse order
        var reverseLineSizes = lineSizes
        var reverseTextLines = textLines
        reverseLineSizes = reverseLineSizes.reversed()
        reverseTextLines = reverseTextLines.reversed()
        
        for i in 0..<reverseTextLines.count {
            let linesize = reverseLineSizes[i]
            let xp = ((totalSize.width - linesize.width) * 0.5 + xt) //line X
            
            let cfAttributeString = textLines[i] as CFAttributedString
            let ctLine = CTLineCreateWithAttributedString(cfAttributeString)
            
            ctx.textPosition = CGPoint(x: xp, y: yp)
            CTLineDraw(ctLine,ctx)
            yp += linesize.height //Next line Y
        }
        ctx.restoreGState()
    }
}
