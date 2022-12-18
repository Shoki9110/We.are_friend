//
//  ViewController.swift
//  We are friend
//
//  Created by おのしょうき on 2022/06/26.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //StoryBoardで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    
    var postArray: [Post] = []
    var database: Firestore! //宣言
    var selectedText: String = ""
    var selectedID: String = ""
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //        let destination =  segue.destination as! AddViewController
//
//        if segue.identifier == "toReplay" {
//
//            let nextView = segue.destination as! ReplyViewController
//
//            nextView.argString = "text"
//
//        }
//    }
    
    //投稿追加画面に遷移するボタンを押したときの動作を記述。
    @IBAction func toAddViewController() {
        performSegue(withIdentifier: "Add", sender: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        table.delegate = self  // 追加
        table.dataSource = self // 追加
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        database = Firestore.firestore()
        database.collection("posts").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                self.postArray = []
                for document in snapshot.documents {
                    let data = document.data()
                    let post = Post(data: data)
                    self.postArray.append(post)
                }
                print(self.postArray)
                self.table.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //セルの数をpostArrayの数にする
        return postArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        
        cell?.textLabel?.text = postArray[indexPath.row].content
        cell?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        return cell!
    }
    //セルが押された時に呼ばれるメゾット
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(postArray[indexPath.row])が選ばれました！")
        performSegue(withIdentifier: "toReplay", sender: nil)
        selectedText = postArray[indexPath.row].content
        selectedID = postArray[indexPath.row].postID
        if selectedText != nil {
        performSegue(withIdentifier: "toReplay",sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toReplay") {
        let subVC: ReplyViewController = (segue.destination as? ReplyViewController)!
        subVC.selectedText = selectedText
        subVC.selectedID = selectedID
        }
    }
}
    
