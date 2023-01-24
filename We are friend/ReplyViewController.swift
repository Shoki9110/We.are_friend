    //
    //  ReplyViewController.swift
    //  We are friend
    //
    //  Created by おのしょうき on 2022/11/20.
    //

    import UIKit
    import Firebase

    class ReplyViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
        @IBOutlet var textField: UITextField!
        @IBOutlet var table:UITableView!
        var selectedText: String = ""
        var selectedID: String = ""
        var textFieldString = ""
        var argString = ""
        var commentArray = [Comment]()
        var database: Firestore!
        @IBOutlet var label1: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            database = Firestore.firestore()
            table.dataSource = self
            table.delegate = self
            label1.text = selectedText
            label1.numberOfLines = 0
            self.commentArray = []
            
        }
        @IBAction func backView1(_sender: Any){
            self.dismiss(animated: true, completion: nil)
        }
        @IBAction func tableViewTap(_ sender: Any){
            self.view.endEditing(true)
            resignFirstResponder()
        }
           
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            database = Firestore.firestore()
            database.collection("comments").whereField("postID",isEqualTo:selectedID).getDocuments { (snapshot, error) in
                if error == nil, let snapshot = snapshot {
                    self.commentArray = []
                    for document in snapshot.documents {
                        let data = document.data()
                        let comment = Comment(data: data)
                        self.commentArray.append(comment)
                    }
                    print(self.commentArray)
                    self.table.reloadData()
                }
            }
                let notification = NotificationCenter.default
                notification.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),
                                         name: UIResponder.keyboardWillShowNotification,
                                         object: nil)
                notification.addObserver(self, selector: #selector(self.keyboardWillHide(_:)),
                                         name: UIResponder.keyboardWillHideNotification,
                                         object: nil)
                
        }
                    
        @objc func keyboardWillShow(_ notification: Notification) {
            let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            guard let keyboardHeight = rect?.size.height else { return }
            let mainBoundsSize = UIScreen.main.bounds.size
            let textFieldHeight = textField.frame.height
            
            let textFieldPositionY = textField.frame.origin.y + textFieldHeight + 10.0
            let keyboardPositionY = keyboardHeight
            
            if keyboardPositionY <= textFieldPositionY {
                let duration: TimeInterval? =
                notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                UIView.animate(withDuration: duration!) {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardPositionY)
                }
            }
        }
                    
        // キーボード非表示通知の際の処理
        @objc func keyboardWillHide(_ notification: Notification) {
            let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
            UIView.animate(withDuration: duration ?? 0, delay: 0, options: .curveEaseOut) {
                self.view.transform = CGAffineTransform.identity
            }
        }
        @IBAction func pushBotton(_ sender: UIButton) {
            
            textFieldString = textField.text!
            print(textFieldString)
            print("a")
            
            textField.text = ""
            
//              commentArray.append(textFieldString)
            let content = textFieldString
            let saveDocument = Firestore.firestore().collection("comments").document()
            let data: [String: Any] = [
                        "content": content,
                        "postID": selectedID,
                        "commentID": saveDocument.documentID,
                        "createdAt": FieldValue.serverTimestamp(),
                    ]
            saveDocument.setData(data) {error in
                if error == nil {
                    let comment = Comment(data: data)
                    self.commentArray.append(comment)
                    self.table.reloadData()
                }
            }
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return commentArray.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = table.dequeueReusableCell(withIdentifier: "Cell")
            
            cell?.textLabel?.text = commentArray[indexPath.row].content
            return cell!
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("\(commentArray[indexPath.row])が選ばれました！")
        }
}
