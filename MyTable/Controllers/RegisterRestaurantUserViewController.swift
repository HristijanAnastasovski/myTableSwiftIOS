//
//  RegisterRestaurantUserViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/25/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class RegisterRestaurantUserViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var advanceToDetailsButton: CustomButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var logoLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        renderLogo()
        setUpTextFields()
        
        //self.title = "Register a New Restaurant"
    
        // Do any additional setup after loading the view.
    }
    
    func renderLogo(){
        logoLbl.font = UIFont(name:"SnellRoundhand-Black", size: 70.0)
        logoLbl.textColor = .white
        logoLbl.text = "MyTable"
    }
    
    func setUpTextFields(){
        emailTextField.textColor = .white
        emailTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "New E-mail",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordTextField.textColor = .white
        passwordTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.isSecureTextEntry = true
        
        
        retypePasswordTextField.textColor = .white
        retypePasswordTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        retypePasswordTextField.attributedPlaceholder = NSAttributedString(string: "Re-Type New Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        retypePasswordTextField.isSecureTextEntry = true
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        retypePasswordTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        retypePasswordTextField.tag = 2
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else{
            
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    @IBAction func onAdvanceToDetailsClick(_ sender: Any) {
        if(checkInput()){
            performSegue(withIdentifier: "segueRestaurantToDetails", sender: self)
            
        }else{
        advanceToDetailsButton.shake()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let restaurantDetailsViewController = segue.destination as! RegisterRestaurantDetailsViewController
        restaurantDetailsViewController.restaurantEmail = emailTextField.text
        restaurantDetailsViewController.restaurantPasssword = passwordTextField.text
    }
    
    func checkInput () -> Bool {
        if(emailTextField.text!.count <= 0 || passwordTextField.text!.count <= 0 || retypePasswordTextField.text!.count <= 0){
            Toast.showToast(message: "All fields are required!", viewController: self)
            return false
        }
        if(passwordTextField.text != retypePasswordTextField.text){
            Toast.showToast(message: "Passwords do not match!", viewController: self)
            return false
        }
        return true
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
