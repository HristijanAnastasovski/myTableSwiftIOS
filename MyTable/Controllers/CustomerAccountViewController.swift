//
//  CustomerAccountViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/29/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class CustomerAccountViewController: UIViewController {
    
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailAddressLbl: UILabel!
    @IBOutlet weak var editBtn: CustomButton!
    @IBOutlet weak var changePasswordBtn: CustomButton!
    var customer: CustomerUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUserDetails()
        initializeLabels()
    }
    
    func loadUserDetails(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "customerUser")
        if(decoded != nil){
            do{
                let decodedCustomerUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! CustomerUser
                customer = decodedCustomerUser
                
            }catch let error {
                print(error)
            }
        } else {
            Toast.showToast(message: "Error with loading the user data", viewController: self)
        }
    }
    
    func initializeLabels(){
        firstNameLbl.textColor = .white
        firstNameLbl.text = "First name: " + customer.firstName
        
        lastNameLbl.textColor = .white
        lastNameLbl.text = "Last name: " + customer.lastName
        
        emailAddressLbl.textColor = .white
        emailAddressLbl.text = "E-mail: " + customer.email
    }
    
    
    @IBAction func onEditBtnClick (_ sender: Any){
        performSegue(withIdentifier: "segueCustomerAccountToEdit", sender: self)
    }
    
    @IBAction func onChangePasswordBtnClick (_ sender: Any){
        performSegue(withIdentifier: "segueCustomerAccountToPassword", sender: self)
    }
    
    @IBAction func onSignOutBtnClick (_ sender: Any){
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "customerUser")
        userDefaults.synchronize()
        performSegue(withIdentifier: "segueCustomerSignOut", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueCustomerAccountToEdit"){
            let editCustomerViewController = segue.destination as! CustomerEditInfoViewController
            editCustomerViewController.customer = self.customer
        }
        if(segue.identifier == "segueCustomerAccountToPassword"){
            let changePasswordCustomerViewController = segue.destination as! CustomerChangePasswordViewController
            changePasswordCustomerViewController.customer = self.customer
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
