//
//  ReaderReaderPDFAnnotation.swift
//  UXMPDFKit_Example
//
//  Created by mozhe on 2018/12/3.
//  Copyright © 2018 CocoaPods. All rights reserved.
//
import UIKit
import CoreGraphics
// All PDF annotation subtypes that PDFKit can render: based on Adobe PDF specification, Table 8.20: Annotation types.
// Annotation subtypes not supported: Polygon, PolyLine, Squiggly, Caret, Caret, FileAttachment,
// Sound, Movie, Screen, PrinterMark, TrapNet, Watermark, 3D, Rect.
public struct ReaderPDFAnnotationSubtype : Hashable, Equatable, RawRepresentable {
    public var rawValue: String
    public init(rawValue: String){
        self.rawValue = rawValue
    }
}

// Common keys used for all annotations
// Adobe PDF Specification (1.7), Table 8.15: Entries common to all annotation dictionaries
public struct ReaderPDFAnnotationKey : Hashable, Equatable, RawRepresentable {
    public var rawValue: String
    public init(rawValue: String){
        self.rawValue = rawValue
    }
}

public enum ReaderPDFDisplayBox : Int {
    
    
    case mediaBox
    
    case cropBox
    
    case bleedBox
    
    case trimBox
    
    case artBox
}

extension ReaderPDFAnnotationKey {
    
    public static let appearanceDictionary: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_appearanceDictionary")
    
    // "/AS": Name
    public static let appearanceState: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_appearanceState")
    
    // "/Border": Array of Integers; or a PDFBorder object
    public static let border: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_border")
    
    // "/C": Array of Floats; or a PDFKitPlatformColor object
    public static let color: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_color")
    
    // "/Contents": String
    public static let contents: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_contents")
    
    // "/F": Integer
    public static let flags: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_flags")
    
    // "/M": Date or String
    public static let date: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_date")
    
    // "/NM": String
    public static let name: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_name")
    
    // "/P": Dictionary; or a PDFPage object.
    public static let page: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_page")
    
    // "/Rect": CGRect
    public static let rect: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_rect")
    
    // "/Subtype": Name (See Table 8.20: Annotation types)
    public static let subtype: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_subtype")
    
    
    // Additional annotation extensions...
    // Adobe PDF Specification (1.7), Table 8.23: Additional entries specific to a text annotation
    // Adobe PDF Specification (1.7), Table 8.24: Additional entries specific to a link annotation
    // Adobe PDF Specification (1.7), Table 8.25: Additional entries specific to a free text annotation
    // Adobe PDF Specification (1.7), Table 8.26: Additional entries specific to a line annotation
    // Adobe PDF Specification (1.7), Table 8.28: Additional entries specific to a square or circle annotation
    // Adobe PDF Specification (1.7), Table 8.30: Additional entries specific to text markup annotations (highlight, underline, strikeout)
    // Adobe PDF Specification (1.7), Table 8.32: Additional entries specific to a rubber stamp annotation
    // Adobe PDF Specification (1.7), Table 8.33: Additional entries specific to an ink annotation
    // Adobe PDF Specification (1.7), Table 8.34: Additional entries specific to a pop-up annotation
    
    // "/A": Dictionary; or a PDFAction object
    public static let action: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_action")
    
    // "/AA": Dictionary; or a PDFAction object
    public static let additionalActions: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_additionalActions")
    
    // "/BS": Dictionary
    public static let borderStyle: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_borderStyle")
    
    // "/DA": String
    public static let defaultAppearance: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_defaultAppearance")
    
    // "/Dest": Array, Name, or String
    public static let destination: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_destination")
    
    // "/H": Name
    public static let highlightingMode: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_highlightingMode")
    
    // "/Inklist": Array of Arrays (each array representing a stroked path)
    public static let inklist: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_inklist")
    
    // "/IC": Array of Floats; or a PDFKitPlatformColor object
    public static let interiorColor: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_interiorColor")
    
    // "/L": Array of Floats
    public static let linePoints: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_linePoints")
    
    // "/LE": Array of Strings
    public static let lineEndingStyles: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_lineEndingStyles")
    
    // "/Name": Name
    public static let iconName: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_iconName")
    
    // // "/Open": Boolean
    public static let open: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_open")
    
    // "/Parent": Dictionary; or a ReaderPDFAnnotation object
    public static let parent: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_parent")
    
    // "/Popup": Dictionary; or a ReaderPDFAnnotation object of type "Popup"
    public static let popup: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_popup")
    
    // "/Q": Integer
    public static let quadding: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_quadding")
    
    
    // "/QuadPoints": Array of Floats
    public static let quadPoints: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_quadPoints")
    
    // "/T": String
    public static let textLabel: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_textLabel")
    
    
    // Widget annotation extensions
    // Adobe PDF Specification (1.7), Table 8.39: Additional entries specific to a widget annotation
    // Adobe PDF Specification (1.7), Table 8.40: Entries in an appearance characteristics dictionary
    // Adobe PDF Specification (1.7), Table 8.69: Entries common to all field dictionaries
    // Adobe PDF Specification (1.7), Table 8.76: Additional entry specific to check box and radio button fields
    // Adobe PDF Specification (1.7), Table 8.78: Additional entry specific to a text field
    // Adobe PDF Specification (1.7), Table 8.80: Additional entries specific to a choice field
    
    // "/AC": String
    public static let widgetDownCaption: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetDownCaption")
    
    // "/BC": Array of Floats; or a PDFKitPlatformColor object
    public static let widgetBorderColor: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetBorderColor")
    
    // "/BG": Array of Floats; or a PDFKitPlatformColor object
    public static let widgetBackgroundColor: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetBackgroundColor")
    
    // "/CA": String
    public static let widgetCaption: ReaderPDFAnnotationKey =  ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetCaption")
    
    // "/DV": (various)
    public static let widgetDefaultValue: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetDefaultValue")
    
    // "/Ff": Integer
    public static let widgetFieldFlags: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetFieldFlags")
    
    // "/FT": Name
    public static let widgetFieldType: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetFieldType")
    
    // "/MK": Dictionary; or PDFAppearanceCharacteristics object
    public static let widgetAppearanceDictionary: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetAppearanceDictionary")
    
    // "/MaxLen": Integer
    public static let widgetMaxLen: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetMaxLen")
    
    // "/Opt": Array (each element is either a string, or an array of two strings)
    public static let widgetOptions: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetOptions")
    
    // "/R": Integer
    public static let widgetRotation: ReaderPDFAnnotationKey  = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetRotation")
    
    // "/RC": String
    public static let widgetRolloverCaption: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetRolloverCaption")
    
    // "/TU": String
    public static let widgetTextLabelUI: ReaderPDFAnnotationKey = ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetTextLabelUI")
    
    // "/V": (various)
    public static let widgetValue: ReaderPDFAnnotationKey =  ReaderPDFAnnotationKey(rawValue: "ReaderPDFAnnotationKey_widgetValue")
}

open class ReaderPDFAnnotation: NSObject, NSCopying, NSCoding{
    
    public func encode(with aCoder: NSCoder) {
        if let type = self.type {
            aCoder.encode(type, forKey: "type")
        }
        if let properties = self.properties {
            aCoder.encode(properties, forKey: "properties")
        }
        //        if let page = self.page {
        //            aCoder.encode(page, forKey: "page")
        //        }
        aCoder.encode(self.bounds, forKey: "bounds")
        aCoder.encode(self.pageNumber, forKey: "pageNumber")
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        self.type = aDecoder.decodeObject(forKey: "type") as? String
        self.properties = aDecoder.decodeObject(forKey: "properties") as? [AnyHashable: Any]
        
        self.bounds = aDecoder.decodeCGRect(forKey: "bounds")
        self.pageNumber = aDecoder.decodeInteger(forKey: "pageNumber")
        
        super.init()
    }
    
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return  ""
    }
    
    
    // This is the base class for all annotations. A ReaderPDFAnnotation object by itself is not useful, only subclasses (like
    // ReaderPDFAnnotationCircle, ReaderPDFAnnotationText) are interesting. In parsing a PDF however, any unknown or unsupported
    // annotations will be represented as this base class.
    
    // -------- initializer
    
    // Create a custom annotation with bounds, a type (ReaderPDFAnnotationSubtype), and an (optional) dictionary of annotation properties.
    
    public init(bounds: CGRect, forType annotationType: ReaderPDFAnnotationSubtype, withProperties properties: [AnyHashable : Any]?) {
        self.bounds = bounds
        self.type   = annotationType.rawValue
        self.properties = properties
        
        super.init()
        
    }
    
    // -------- Private Properties
    private var properties: [AnyHashable: Any]?
    
    // -------- accessors
    
    // Returns the page the annotation is associated with (may return nil if annotation not associated with a page).
    weak open var page: CGPDFPage?
    
    open var pageNumber: Int = 1
    
    
    // Returns the annotation type (called "Subtype" in the PDF specification since "Annot" is the type). Examples include:
    // "Text", "Link", "Line", etc. Required. Note that you are only allowed to set the type of an annotation once.
    open var type: String?
    
    
    // Required for all annotations. The bounding box in page-space of the annotation.
    open var bounds: CGRect
    
    
    // Indicates whether the annotation should be displayed on screen (depending upon -[shouldPrint] it may still print).
    open var shouldDisplay: Bool = true
    
    
    // Indicates whether the annotation should be printed or not.
    open var shouldPrint: Bool = false
    
    // Optional (-[modificationDate] may return nil). Modification date of the annotation.
    open var modificationDate: Date?
    
    
    // Optional (-[userName] may return nil). Name of the user who created the annotation.
    open var userName: String?
    
    
    // Optional (-[popup] may return nil). Not used with links or widgets, a popup annotation associated with this
    // annotation. The bounds and open state of the popup indicate the placement and open state of the popup window.
    open var popup: ReaderPDFAnnotation?
    
    
    // Optional border or border style that describes how to draw the annotation border (if any). For the "geometry"
    // annotations (Circle, Ink, Line, Square), the border indicates the line width and whether to draw with a dash pattern
    // or solid pattern. ReaderPDFAnnotation markup types (Highlight, Strikethrough, Underline) ignores the border.
    open var border: ReaderPDFBorder?
    
    
    // For many annotations ("Circle", "Square") the stroke color. Used for other annotations as well.
    @NSCopying open var color: UIColor = UIColor.yellow.withAlphaComponent(0.5)
    
    
    // A string of text associated with an annotation. Often displayed in a window when the annotation is clicked on
    // ("FreeText" and "Text" especially).
    open var contents: String?
    
    
    // Optional action performed when a user clicks / taps an annotation. PDF readers ignore actions except
    // for those associated with Link or button Widget annotations.
    open var action: ReaderPDFAction?
    
    
    // Returns YES if the annotation has an appearance stream. Annotations with appearance streams are drawn using their
    // stream. As a result setting many parameters (like -[setColor:] above) will have no visible effect.
    //    open var hasAppearanceStream: Bool { get }
    
    
    // The highlight state dictates how the annotation is drawn. For example, if a user has clicked on a
    // "Link" annotation, you should set highlighted to YES and redraw it. When the user lets up, set highlighted to
    // NO and redraw again.
    
    open var isHighlighted: Bool = false
    
    
    // -------- drawing
    
    // Draw method. Draws in page-space relative to origin of "box" passed in and to the given context
    
    open func draw(with box: ReaderPDFDisplayBox, in context: CGContext) {
        
    }
    
    
    // -------- attribute mutations
    
    // Allows you to set a key-value pair in this annotation's dictionary. Returns true on successful
    // assignment, false on error. Key must be valid for a PDF annotation's object type, and must have
    // a value that is acceptable for the key type. These values can either be an NSString, NSNumber,
    // NSArray of strings or numbers, or an NSDictionary of the previously listed types. Some keys expect
    // a complex type, for example the key "/C" expects a color in the format of an array of 0, 1, 3,
    // or 4 elements, with each element being a floating-point number in the range of 0.0 - 1.0 ). As
    // a convenience, these kind of keys will directly accept NSColor / UIColor values. Other convenience
    // functions provide similar support can be found in PDFAnnotationUtilities header file. Note that you
    // can set the environment variable "PDFKIT_LOG_ANNOTATIONS" to log any key-value assignment failures.
    
    open func setValue(_ value: Any, forAnnotationKey key: ReaderPDFAnnotationKey) -> Bool {
        
        return true
    }
    
    
    open func setBoolean(_ value: Bool, forAnnotationKey key: ReaderPDFAnnotationKey) -> Bool {
        
        return true
    }
    
    
    open func setRect(_ value: CGRect, forAnnotationKey key: ReaderPDFAnnotationKey) -> Bool {
        
        return true
    }
    
    
    // List all key-value pairs for this annotation; returns a deep copy of all pairs.
    // Note that this method will not include a copy of the value for /Parent. This is by design as to avoid
    // introduing a memory cycle. If you would like to get the /Parent propery, use -[PDFAnnotation valueForAnnotationKey:]
    // with key PDFAnnotationKeyParent.
    
    //    open var annotationKeyValues: [AnyHashable : Any] { get }
    
    
    // Retrieves a deep copy of the key-value pair based on the given key; key can either be
    // from the keys PDFAnnotationKey, or an appropriate string from the PDF specification.
    
    open func value(forAnnotationKey key: ReaderPDFAnnotationKey) -> Any? {
        
        return nil
    }
    
    
    // Remove the key-value pair from the annotation dictionary. Returns true on successful removal.
    
    open func removeValue(forAnnotationKey key:
        ReaderPDFAnnotationKey) {
        
    }
    
    
    
}
