//
//  AddViewController.swift
//  We are friend
//
//  Created by おのしょうき on 2022/08/07.
//

import UIKit
import Firebase

class AddViewController: UIViewController {
    
    @IBOutlet var contentTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postContent() {
        let content = contentTextView.text!
        let saveDocument = Firestore.firestore().collection("posts").document()
        saveDocument.setData([
            "content": content,
            "postID": saveDocument.documentID,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]) {error in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func setupTextView() {
        let toolBar = UIToolbar() // キーボードの上に置くツールバーの生成
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // 今回は、右端にDoneボタンを置きたいので、左に空白を入れる
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard)) // Doneボタン
        toolBar.items = [flexibleSpaceBarButton, doneButton] // ツールバーにボタンを配置
        toolBar.sizeToFit()
        contentTextView.inputAccessoryView = toolBar // テキストビューにツールバーをセット
    }

    // キーボードを閉じる処理。
    @objc func dismissKeyboard() {
        contentTextView.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
