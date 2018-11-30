//
//  ExampleViewController.swift
//  UXMPDFKit
//
//  Created by Chris Anderson on 5/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//
import UIKit
import CoreGraphics


class ExampleViewController: UIViewController {
    
    @IBAction func loadPDF() {
//
       // let url = Bundle.main.path(forResource: "Systems Engineering - EAA - Patterns of Enterprise Application Architecture - Addison Wesley", ofType: "pdf")!
//        let url = Bundle.main.path(forResource: "Reader", ofType: "pdf")!
//        let url = Bundle.main.path(forResource: "pdf_reference_1-7", ofType: "pdf")!
        let url = Bundle.main.path(forResource: "testA", ofType: "pdf")!
        let document = try! PDFDocument.from(filePath: url)
        
        if let cgDocument = document?.documentRef {
            let outline = ReaderDocumentOutline(cgPDFDocument: cgDocument)
            Log.output().warning(outline.description)
        }
        
        let pdf = PDFViewController(document: document!)
        pdf.annotationController.annotationTypes = [
            PDFHighlighterAnnotation.self,
            PDFPenAnnotation.self,
            PDFTextAnnotation.self
        ]
        
        let watermark = ReaderWatermark(textLines: ["mozheanquan", "www.mozheanquan.com"])
        document?.setRenderTile(renderer: watermark!)
        
        self.navigationController?.pushViewController(pdf, animated: true)
        
    }
}
