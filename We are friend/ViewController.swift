//
//  ViewController.swift
//  We are friend
//
//  Created by おのしょうき on 2022/06/26.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var postArray: [Post] = []
    var database: Firestore! //宣言
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination =  segue.destination as! AddViewController
       
    }
    
    //投稿追加画面に遷移するボタンを押したときの動作を記述。
    @IBAction func toAddViewController() {
        performSegue(withIdentifier: "Add", sender: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        database.collection("posts").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                self.postArray = []
                for document in snapshot.documents {
                    let data = document.data()
                    let post = Post(data: data)
                    self.postArray.append(post)
                }
                print(self.postArray)
            }
        }
    }
    
}
    
    
    
