//
//  ReaderPageTiledView.swift
//  Pods-UXMPDFKit_Example
//
//  Created by mozhe on 2018/11/27.
//  Inspired by UXReader UXReaderPageTiledView


protocol ReaderPageTiledViewProtocol: class {}

import UIKit

open class ReaderPageTiledView: UIView {
    weak var delegate: ReaderPageTiledViewProtocol?
    private var document: PDFDocument? = nil
    private var page: Int? = nil
    private var documentPage: PDFPageContent? {
        get{
            return self.superview as? PDFPageContent
        }
    }
    
    //MARK: - UIView class methods
    override open class var layerClass: AnyClass {
        return ReaderTiledLayer.self
    }
    
    //MARK: - UIView instance methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        backgroundColor = .clear
        autoresizesSubviews = false
        isUserInteractionEnabled = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init?(frame: CGRect, documentx: PDFDocument,page: Int) {
        self.init(frame: frame)
        
        self.document = documentx
        self.page  = page
        
        setNeedsDisplay()
        
    }
    deinit {  // why badExe error
        //        layer.delegate = nil
        
    }
    
    //MARK: - CATiledLayer Delegate Method
    open override func draw(_ layer: CALayer, in ctx: CGContext) {
        // async draw ,not main thread 
        if let pageContent = documentPage {
            pageContent.renderTile(in: ctx)
            if let renderTile = document?.getRenderTile() {
                renderTile.renderTile(with: pageContent, in: ctx)
            }
        }
    }
}


