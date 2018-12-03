//
//  ReaderDocumentOutline.swift
//  UXMPDFKit_Example
//
//  Created by mozhe on 2018/11/29.
//  Copyright © 2018 CocoaPods. All rights reserved.
//  Inspired by GreatReader PDFDoucmentOutline

import UIKit
import CoreGraphics

fileprivate let kOutlines = "Outlines"
fileprivate let kFirst    = "First"
fileprivate let kNext     = "Next"
fileprivate let kTitle    = "Title"
fileprivate let kA        = "A"
fileprivate let kD        = "D"
fileprivate let kDest     = "Dest"
fileprivate let kNames    = "Names"
fileprivate let kDests    = "Dests"
fileprivate let kLimits   = "Limits"
fileprivate let kKids     = "Kids"

class ReaderDocumentOutline: NSObject {
    
    private(set) var items: [ReaderDocumentOutlineItem]?
    
    init(cgPDFDocument: CGPDFDocument) {
        super.init()
        items = outlineItems(for: cgPDFDocument)
    }
    
    private func outlineItems(for document: CGPDFDocument) -> [ReaderDocumentOutlineItem]?{
        let _ = se7enDebugUse(document: document)
        var outlines: CGPDFDictionaryRef? = nil
        guard let catalog = document.catalog else {
            Log.output().debug("No catelog in this PDF")
            return nil
        }
        CGPDFDictionaryGetDictionary(catalog, kOutlines, &outlines)
        guard let safeOutlines = outlines else {
            Log.output().debug("No Outlines in this PDF")
            return nil }
        return childItem(outlines: safeOutlines, document: document)
    }
    
    private func childItem(outlines: CGPDFDictionaryRef,
                           document: CGPDFDocument) -> [ReaderDocumentOutlineItem]? {
        
        var childs = [CGPDFDictionaryRef]()
        
        var current: CGPDFDictionaryRef? = nil
        CGPDFDictionaryGetDictionary(outlines, kFirst, &current)
        guard var safeCurrent = current else { return nil }
        childs.append(safeCurrent)
        
        var next: CGPDFDictionaryRef? = nil
        
        while CGPDFDictionaryGetDictionary(safeCurrent, kNext, &next) {
            guard let safeNext = next else {
                return nil
            }
            safeCurrent = safeNext
            childs.append(safeCurrent)
        }
        return childs.map({ (dic) -> ReaderDocumentOutlineItem in
            let children = childItem(outlines: dic, document: document)
            let title = titleOfDictionary(dic)
            var dest: CGPDFObjectRef? = nil
            let pageNumber = getPageNumber(dictionary: dic, document: document, destination: &dest)
            let item = ReaderDocumentOutlineItem(title: title, pageNumber: pageNumber, destination: dest, children: children)
            return item
        })
        
    }
    
    private func titleOfDictionary(_ dict: CGPDFDictionaryRef) -> String? {
        var title: CGPDFStringRef? = nil
        CGPDFDictionaryGetString(dict, kTitle, &title)
        guard let safeTitle = title else { return nil }
        let cfTitle = CGPDFStringCopyTextString(safeTitle)
        return cfTitle as String?
    }
    
    private func getPageNumber(dictionary: CGPDFDictionaryRef,
                               document: CGPDFDocument,
                               destination: UnsafeMutablePointer<CGPDFObjectRef?>?) -> Int {
        
        var pageDictonary: CGPDFDictionaryRef? = nil
        var destArray: CGPDFArrayRef? = nil
        var destString: CGPDFStringRef? = nil
        let destName: UnsafeMutablePointer<UnsafePointer<Int8>?>? = nil
        
        var a: CGPDFDictionaryRef? = nil
        if CGPDFDictionaryGetDictionary(dictionary, kA, &a),
            let safeA = a  {
            CGPDFDictionaryGetObject(safeA, kD, destination)
            if CGPDFDictionaryGetArray(safeA, kD, &destArray) ||
                CGPDFDictionaryGetString(safeA, kD, &destString) {}
        }else {
            CGPDFDictionaryGetObject(dictionary, kDest, destination)
            if CGPDFDictionaryGetArray(dictionary, kDest, &destArray) ||
                CGPDFDictionaryGetString(dictionary, kDest, &destString) ||
                CGPDFDictionaryGetName(dictionary, kDest, destName) {}
        }
        if let safeDestString = destString {
            let pointeeName = CGPDFStringGetBytePtr(safeDestString)
            destArray = findDestinationName(pointee: pointeeName, document: document)
        }
        
        if let safeDestName = destName,
            let destNamePointer = safeDestName.pointee {
            var dests: CGPDFDictionaryRef? = nil
            if let catalog = document.catalog,
                CGPDFDictionaryGetDictionary(catalog, kDests, &dests),
                let safeDests = dests {
                var dict: CGPDFDictionaryRef? = nil
                //TODO: - dirty , instead of safeDestName
                if CGPDFDictionaryGetDictionary(safeDests, destNamePointer, &dict),
                    let safeDict = dict {
                    CGPDFDictionaryGetArray(safeDict, kD, &destArray)
                }
            }
        }
        
        if let destArray = destArray {
            CGPDFArrayGetDictionary(destArray, 0, &pageDictonary)
            let numberOfpages = document.numberOfPages
            guard numberOfpages > 0 else {
                return 0
            }
            if numberOfpages == 1 {
                let page = document.page(at: 1)
                let pd = page?.dictionary
                if pd == pageDictonary {
                    return 1
                }
            }else {
                for i in 1...numberOfpages {
                    let page = document.page(at: i)
                    let pd = page?.dictionary
                    //TODO: - two Optional
                    if pd == pageDictonary {
                        return i
                    }
                }
            }
        }
        return 0
    }
    
    private func findDestinationName(pointee: UnsafePointer<UInt8>?,
                                     document: CGPDFDocument) -> CGPDFArrayRef? {
        guard let catalog = document.catalog else { return nil }
        var names: CGPDFDictionaryRef? = nil
        if CGPDFDictionaryGetDictionary(catalog, kNames, &names) {
            guard let safeNames = names else { return nil }
            var dests: CGPDFDictionaryRef? = nil
            if CGPDFDictionaryGetDictionary(safeNames, kDests, &dests) {
                if let safePointee = pointee ,let safeDests = dests {
                    return findDestinationName(pointee: safePointee, node: safeDests)
                }else {
                    return nil
                }
            }
        }
        
        return nil
    }
    
    private func findDestinationName(pointee: UnsafePointer<UInt8>, node: CGPDFDictionaryRef) -> CGPDFArrayRef? {
        
        var destArray: CGPDFArrayRef? = nil
        var limits: CGPDFArrayRef? = nil
        if CGPDFDictionaryGetArray(node, kLimits, &limits) {
            guard let safeLimits = limits else { return nil}
            var start: CGPDFStringRef? = nil
            var end: CGPDFStringRef? = nil
            if CGPDFArrayGetString(safeLimits, 0, &start) && CGPDFArrayGetString(safeLimits, 1, &end),let safeStart = start, let safeEnd = end {
                guard let startName = CGPDFStringGetBytePtr(safeStart),
                    let endName   = CGPDFStringGetBytePtr(safeEnd) else { return nil }
                
                //TODO: - Very dirty
                if  pointee.pointee < startName.pointee || pointee.pointee > endName.pointee {
                    return nil
                }
            }
        }
        
        var names: CGPDFArrayRef? = nil
        if CGPDFDictionaryGetArray(node, kNames, &names),
            let safeNames = names{
            let nameCount = CGPDFArrayGetCount(safeNames)
            
            let range = 0..<nameCount
            let targetInts = range.filter{ $0 % 2 == 0 }
            for (i, _) in targetInts.enumerated() {
                var name: CGPDFStringRef? = nil
                if CGPDFArrayGetString(safeNames, i, &name), let safeName = name {
                    let n = CGPDFStringGetBytePtr(safeName)
                    //TODO: - Very dirty
                    if  pointee.pointee == n?.pointee {
                        if CGPDFArrayGetArray(safeNames, i + 1, &destArray),
                            let safeDestArray = destArray {
                            return safeDestArray
                        } else {
                            var destDictionary: CGPDFDictionaryRef? = nil
                            if CGPDFArrayGetDictionary(safeNames, i + 1, &destDictionary),
                                let safeDestDictionary = destDictionary {
                                if CGPDFDictionaryGetArray(safeDestDictionary, kD, &destArray),
                                    let safeDestArray = destArray {
                                    return safeDestArray
                                }
                            }
                        }
                    }
                }
            }
        }
        
        var kids: CGPDFArrayRef? = nil
        if  CGPDFDictionaryGetArray(node, kKids, &kids),
            let safeKids = kids {
            let count = CGPDFArrayGetCount(safeKids)
            for i in 0..<count {
                var kid: CGPDFDictionaryRef? = nil
                if CGPDFArrayGetDictionary(safeKids, i, &kid), let safeKid = kid {
                    destArray = findDestinationName(pointee: pointee, node: safeKid)
                    if  destArray != nil {
                        return destArray
                    }
                    //                    return destArray
                }
            }
        }
        return nil
    }
    
    //MARK: -
    func selectionTitle(at index: Int) -> String {
        var current: ReaderDocumentOutlineItem? = nil
        if let items = self.items {
            for item in items {
                if item.pageNumber <= index {
                    current = item
                    if item.pageNumber == index {
                        break
                    }
                } else {
                    break
                }
            }
        }
        return current?.title ?? ""
    }
    
    override var description: String {
        if let newitems = items {
            let result =  newitems.map { (item) -> String in
                item.description
                }.joined(separator: "\n")
            return ("\n" + result)
        }else {
            return "Outline"
        }
    }
}

extension ReaderDocumentOutline {
    private func se7enDebugUse(document: CGPDFDocument)-> [ReaderDocumentOutlineItem]?{
        var outlines: CGPDFDictionaryRef? = nil
        guard let catalog = document.catalog else { return nil }
        CGPDFDictionaryApplyFunction(catalog, { (key, obj, info) in
            NSLog("%s", key) // Type Pages Version Outlines MarkInfo PageMode Names AcroForm ...
        }, &outlines)
        
        
        var pages: CGPDFArrayRef? = nil
        if  CGPDFDictionaryGetDictionary(catalog, "Pages", &pages),
            let _ = pages {
//            let count = CGPDFArrayGetCount(safePages)
//            for i in 0..<count {
              let page = document.page(at: 1)
                if let dict = page?.dictionary {
//                    CGPDFDictionaryApplyFunction(dict, { (key, object, info) in
//                        Log.output().debug("----")
//                        NSLog("%s", key)
//                    }, nil)
                    var annots: CGPDFArrayRef? = nil
                    if CGPDFDictionaryGetArray(dict, "Annots", &annots),
                        let safeAnnots = annots {
                        let count = CGPDFArrayGetCount(safeAnnots)
                        Log.output().info(count)
                        for i in 0..<count {
                            var annot: CGPDFDictionaryRef? = nil
                            if CGPDFArrayGetDictionary(safeAnnots, i, &annot),
                                let safeAnnot = annot {
                                
                                var contents: CGPDFStringRef? = nil
                                if CGPDFDictionaryGetString(safeAnnot, "Contents", &contents),
                                    let safeContents = contents {
                                    if let ref: CFString = CGPDFStringCopyTextString(safeContents) {
                                        let text = ref as String
                                        Log.output().verbose(text)
                                    }
                                }
                                
                                var rect: CGPDFArrayRef? = nil
                                if CGPDFDictionaryGetObject(safeAnnot, "Rect", &rect),
                                    let safeRect = rect {
                                    
                                    Log.output().info(CGPDFArrayGetCount(safeRect))
                                    return nil
                                    
                                    var ll: CGPDFStringRef? = nil
                                    for j in 0..<CGPDFArrayGetCount(safeRect) {
                                        Log.output().debug(i)
                                        Log.output().debug(j)
                                        
                                        CGPDFArrayGetString(safeRect, j, &ll)
                                        if let safeLl = ll {
                                            if let ref: CFString = CGPDFStringCopyTextString(safeLl) {
                                                let point = ref as String
                                                Log.output().verbose(point)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
              
//            }
        }
        return nil
    }
}
