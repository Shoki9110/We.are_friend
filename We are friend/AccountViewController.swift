//
//  AccountViewController.swift
//  We are friend
//
//  Created by おのしょうき on 2022/08/07.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    var auth: Auth!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if auth.currentUser != nil {
            //もし既にユーザーにログインが出来ていれば、タイムライン画面に遷移する
            //このときに、ユーザーの情報を次の画面の変数に値渡ししておく（直接取得することも可能）
            performSegue(withIdentifier: "Timeline", sender: auth.currentUser!)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! AddViewController
        let user = sender as! User
        
    }
    
    
    //登録ボタンを押したときに呼ぶメゾット
    @IBAction func registerAccount() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if error == nil, let result = result {
                //errorが nil であり、resultがnilではない == user情報がきちんと取得されている。
                self.performSegue(withIdentifier: "Timeline", sender: result.user)//遷移先の画面でUser情報を渡している
            }
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

//デリゲートメゾットは可読性のためextensionで分けて記述します
extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    // アカウント登録後に呼ばれる。
    // error変数が nil -> 成功
    //            nilではない -> 失敗
    // result変数 ... user情報などをプロパティとして格納している。
  
}
