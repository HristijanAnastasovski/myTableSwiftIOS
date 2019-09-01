//
//  TypeOfUserViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/25/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class TypeOfUserViewController: UIViewController {

    @IBOutlet weak var logoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        //let userDefaults = UserDefaults.standard
        //userDefaults.set(nil, forKey: "restaurantUser")
        //userDefaults.set(nil, forKey: "customerUser")
        //userDefaults.synchronize()
        renderLogo()

        // Do any additional setup after loading the view.
    }
    
    func renderLogo(){
        logoLbl.font = UIFont(name:"SnellRoundhand-Black", size: 70.0)
        logoLbl.textColor = .white
        logoLbl.text = "MyTable"
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
