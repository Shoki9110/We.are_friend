    //
    //  ViewController.swift
    //  We are friend
    //
    //  Created by おのしょうき on 2022/06/26.
    //

    import UIKit
    import FirebaseFirestore

    class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
        
        
        //StoryBoardで扱うTableViewを宣言
        @IBOutlet var table: UITableView!
        
        var postArray: [Post] = []
        var database: Firestore! //宣言
        var selectedText: String = ""
        var selectedID: String = ""
        var blockPost = [""]
        let userDefault = UserDefaults()
        
        
        //投稿追加画面に遷移するボタンを押したときの動作を記述。
         func toTermsViewController() {
            performSegue(withIdentifier: "toTerms", sender: nil)
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            table.refreshControl = UIRefreshControl()
            table.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
            table.register(UINib(nibName: "MainTableViewCell", bundle: nil),forCellReuseIdentifier: "customCell")
            table.delegate = self  // 追加
            table.dataSource = self // 追加
            table.rowHeight = 80
            getData()
                
        }
        @objc private func onRefresh(_ sender: AnyObject) {
            getData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.table.reloadData()
                self?.table.refreshControl?.endRefreshing()
            }
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            getData()
        }
        func getData() {
            database = Firestore.firestore()
            database.collection("posts").getDocuments { (snapshot, error) in
                if error == nil, let snapshot = snapshot {
                    self.postArray = []
                    for document in snapshot.documents {
                        let data = document.data()
                        let post = Post(data: data)
                        self.postArray.append(post)
                    }
                    print("aaa")
                    self.blockPost = self.userDefault.stringArray(forKey: "post") ?? [""]
                    print(self.blockPost)
                    for i in 0 ..< self.blockPost.count {
                        self.postArray.removeAll(where: {$0.postID == self.blockPost[i]})
                    }
                    self.postArray.reverse()
                    self.table.reloadData()
                }
            }
            
        }
        override func viewDidAppear(_ animated: Bool) {
            if UserDefaults.standard.object(forKey: "agreedToTerms") == nil || UserDefaults.standard.bool(forKey: "agreedToTerms") == false {
                toTermsViewController()
                
            }

            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //セルの数をpostArrayの数にする
            return postArray.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
//            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
            cell.mainBackguround.layer.cornerRadius = 8
            cell.mainBackguround.layer.masksToBounds = true
            cell.backgroundColor = .systemGray6
            cell.label?.text = postArray[indexPath.row].content
            cell.label?.numberOfLines = 0
            return cell
        }
        //セルが押された時に呼ばれるメゾット
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("\(postArray[indexPath.row])が選ばれました！")
            selectedText = postArray[indexPath.row].content
            selectedID = postArray[indexPath.row].postID
            if selectedText != nil {
            performSegue(withIdentifier: "toReplay",sender: nil)
                self.table.reloadData()
            }
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
            if (segue.identifier == "toReplay") {
                print("%%%")
                print(selectedID)
                print("%%%")
            let subVC: ReplyViewController = (segue.destination as? ReplyViewController)!
                subVC.selectedText = self.selectedText
                subVC.selectedID = self.selectedID
            }
        }
        
                      }
        
