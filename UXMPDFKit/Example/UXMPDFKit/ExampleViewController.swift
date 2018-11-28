//
//  ExampleViewController.swift
//  UXMPDFKit
//
//  Created by Chris Anderson on 5/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit


class ExampleViewController: UIViewController {
    
    @IBAction func loadPDF() {
//
//        let url = Bundle.main.path(forResource: "Systems Engineering - EAA - Patterns of Enterprise Application Architecture - Addison Wesley", ofType: "pdf")!
        let url = Bundle.main.path(forResource: "Reader", ofType: "pdf")!
        let document = try! PDFDocument.from(filePath: url)
        
        let pdf = PDFViewController(document: document!)
        pdf.annotationController.annotationTypes = [
            PDFHighlighterAnnotation.self,
            PDFPenAnnotation.self,
            PDFTextAnnotation.self
        ]
        
        let watermark = ReaderWatermark(textLines: ["www.mozheanquan.com"])
        document?.setRenderTile(renderer: watermark!)
        
        self.navigationController?.pushViewController(pdf, animated: true)
    }
}
