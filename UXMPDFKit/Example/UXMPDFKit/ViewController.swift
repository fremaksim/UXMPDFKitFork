//
//  ViewController.swift
//  UXMPDFKit
//
//  Created by Chris Anderson on 03/05/2016.
//  Copyright (c) 2016 Chris Anderson. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var collectionView: PDFSinglePageViewer!
    fileprivate var alert: UIAlertController!
    fileprivate var urlPath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let url = Bundle.main.path(forResource: "sample", ofType: "pdf")!
        //        let url = Bundle.main.path(forResource: "xmidnCompare-protected", ofType: "pdf")!
        
        loadPDFDoucment(forResource: "xmidnCompare-protected", type: "pdf", password: "")
    }
    
    fileprivate func loadPDFDoucment(forResource: String, type: String, password: String?){
        let url = Bundle.main.path(forResource: forResource, ofType: type)!
        self.urlPath = url
        
        showDocument(urlPath: url, password: password)
    }
    
    fileprivate func showDocument(urlPath: String, password: String? ){
        do {
            let document =  try PDFDocument(filePath: urlPath, password: password)
            self.collectionView.document = document
            self.collectionView.reloadData()
        } catch let error as CGPDFDocumentError {
            if   error.rawValue == CGPDFDocumentError.couldNotUnlock.rawValue {
                alertInputPassword()
            }else{
                print(error.localizedDescription)
            }
            
        }catch {
            print(error)
        }
    }
}

extension ViewController {
    fileprivate func alertInputPassword() {
        let alert = UIAlertController(title: "请输入文件密码", message: "该文档有密码保护，需要输入密码查看", preferredStyle: .alert)
        alert.addTextField {[weak self] textfiled in
            guard let `self` = self else {return}
            textfiled.placeholder = "输入文档密码"
            textfiled.delegate = self
        }
        let okAction = UIAlertAction(title: "确定", style: .default) {[weak self] action in
            guard let `self` = self else {return}
            guard let textfield = self.alert.textFields?.first, textfield.hasText else {
                
                return
            }
            self.alert.dismiss(animated: true, completion: nil)
            self.showDocument(urlPath: self.urlPath, password: textfield.text!)
        }
        okAction.isEnabled = !(alert.textFields?.first?.text?.isEmpty  ?? true)
        alert.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
        self.alert = alert
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField.hasText {
            guard let okAction = self.alert.actions.first else {
                return true
            }
            okAction.isEnabled = textField.hasText
//        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let okAction = self.alert.actions.first else {
            return
        }
        okAction.isEnabled = textField.hasText
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

