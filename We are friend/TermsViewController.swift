    //
    //  TermsViewController.swift
    //  We are friend
    //
    //  Created by おのしょうき on 2023/04/30.
    //

    import UIKit

    class TermsViewController: UIViewController {
        

        override func viewDidLoad() {
            super.viewDidLoad()
        }
        @IBAction func showAlert(){
           
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel,handler: { (action) -> Void in
            })
            
            // アラートを作成する
            let alertController = UIAlertController(title: "利用規約に同意しますか？", message: nil, preferredStyle: .alert)

            // OKボタンがタップされた時のアクションを作成する
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // UserDefaultsに値を保存する
                UserDefaults.standard.set(true, forKey: "agreedToTerms")
                self.dismiss(animated: true, completion: nil)
            }

            // アラートにアクションを追加する
            alertController.addAction(okAction)
            alertController.addAction(cancel)

            // アラートを表示する
            present(alertController, animated: true, completion: nil)

        }
        @IBAction func googleform(_ sender: Any) {
            if let url = URL(string: "https://doc-hosting.flycricket.io/we-are-friend-privacy-policy/ff840503-e9f0-4144-85ff-b13204fc370b/privacy") {
                UIApplication.shared.open(url)
            }
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
