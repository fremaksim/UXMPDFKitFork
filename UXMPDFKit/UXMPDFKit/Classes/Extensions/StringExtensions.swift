//
//  StringExtensions.swift
//  UXMPDFKit_Example
//
//  Created by mozhe on 2018/11/29.
//  Copyright © 2018 CocoaPods. All rights reserved.
//  reference https://stackoverflow.com/questions/25554986/how-to-convert-string-to-unsafepointeruint8-and-length

import Foundation

extension String {
    
    func toPointer() -> UnsafePointer<UInt8>? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
        let stream = OutputStream(toBuffer: buffer, capacity: data.count)
        
        stream.open()
        data.withUnsafeBytes({ (p: UnsafePointer<UInt8>) -> Void in
            stream.write(p, maxLength: data.count)
        })
        
        stream.close()
        
        return UnsafePointer<UInt8>(buffer)
    }
    
    func toMutablePointer() -> UnsafeMutablePointer<Int8>? {
        let cString = strdup(self)
        return cString
    }

    /* To convert from String to UnsafeMutablePointer<Int8>
     
     let cString = strdup("Hello") // UnsafeMutablePointer<Int8>
     To convert from UnsafeMutablePointer<Int8> to String
     
     let string = String(cString: cString!) // String
     */
    
}
