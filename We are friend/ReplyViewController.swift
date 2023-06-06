        //
        //  ReplyViewController.swift
        //  We are friend
        //
        //  Created by おのしょうき on 2022/11/20.
        //

        import UIKit
        import FirebaseFirestore

        class ReplyViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
            @IBOutlet var textField: UITextField!
            @IBOutlet var table:UITableView!
            var selectedText: String = ""
            var selectedID: String = ""
            var textFieldString = ""
            var argString = ""
            var commentArray = [Comment]()
            var database: Firestore!
            let userDefault = UserDefaults.standard
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
            @IBAction func tableViewTap(_ sender: Any){
                self.view.endEditing(true)
                resignFirstResponder()
            }
            @IBAction func alertbutton(sender: UIButton){
                let alert: UIAlertController = UIAlertController(title: "削除しますか？", message: "投稿が削除されますけどよろしいですか？", preferredStyle: UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    self.dismiss(animated: true, completion: nil)
                    self.database.collection("posts").document(self.selectedID).delete()
                    self.table.reloadData()
                }
                )
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("Cancel")
                })
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            @IBAction func buttonTapped(_ sender: Any) {
                var blockID = userDefault.array(forKey: "post") as? [String] ?? []
                let alertController = UIAlertController(title: "確認", message: "ブロックしますか？", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
                let blockAction = UIAlertAction(title: "ブロック", style: .destructive) { _ in
                    // ブロックする処理を記述する
                    self.dismiss(animated: true, completion: nil)
                    let doc = self.database.collection("posts").document(self.selectedID)
                    doc.getDocument { document, error in
                        if let document = document, document.exists {
                            // ドキュメントが存在する場合、フィールドの値を取得
                            if let postId = document.get("postID") as? String {
                                // 値を利用する処理をここに記述
                                print("Field value: \(postId)")
                                blockID.append(postId)
                                self.userDefault.set(blockID, forKey: "post")
                                print(UserDefaults().dictionaryRepresentation())
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(blockAction)
                
                present(alertController, animated: true, completion: nil)
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
