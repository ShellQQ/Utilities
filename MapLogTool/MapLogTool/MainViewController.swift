//
//  MainViewController.swift
//  MapLogTool
//
//  Created by D02020015 on 2021/6/10.
//

import UIKit

class MainViewController: UIViewController, UIDocumentPickerDelegate {

    @IBAction func openFile(_ sender: Any) {
        openFileBrowser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func openFileBrowser() {
//        if let vc = Pages.documentBrowserViewController() {
//            //navigationController?.pushViewController(vc, animated: true)
//            self.present(vc, animated: true)
//
        // 可開啟的檔案類型: doc, docx, xls, xlsx, pdf, jpg.jpeg.png
        // 支援的檔案類型請查看
        //https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifie.html#//apple_ref/doc/uid/TP40009259-SW1
        let typeLists = ["com.microsoft.word.doc", "com.microsoft.excel.xls", "public.data", "public.image"]
        if #available(iOS 8.0, *) {
            let docPicker = UIDocumentPickerViewController(documentTypes: typeLists, in: .import)   // import可以匯入其他資料夾
            
            // TODO: present 錯誤訊息
            docPicker.shouldShowFileExtensions = true
            docPicker.allowsMultipleSelection = false
            docPicker.delegate = self
        
            //navigationController?.isModalInPresentation = true
            //navigationController?.modalPresentationStyle = .fullScreen
            
            present(docPicker, animated: true)
            //navigationController?.pushViewController(docPicker, animated: true)
            //self.show(docPicker, sender: true)
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            vc.fileURL = url
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
