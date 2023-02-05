//
//  SteiViewController.swift
//  We are friend
//
//  Created by おのしょうき on 2023/02/05.
//

import UIKit

class SteiViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        }
    
    
    @IBAction func googleform(_ sender: Any) {
    if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSffLoV6vQPmVfpYZCef-g7V95rn85a5x5T_crfT3MgPUcS8EA/viewform?usp=sf_link") {
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
