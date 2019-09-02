//
//  RegisterCustomerViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 9/2/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RegisterCustomerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoLbl:UILabel!
    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var retypePasswordTextField:UITextField!
    @IBOutlet weak var registerButton:CustomButton!
    
    var customer:CustomerUser!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        renderLogo()
        setUpTextFields()
        // Do any additional setup after loading the view.
    }
    
    func renderLogo(){
        logoLbl.font = UIFont(name:"SnellRoundhand-Black", size: 70.0)
        logoLbl.textColor = .white
        logoLbl.text = "MyTable"
    }
    
    func setUpTextFields(){
        firstNameTextField.delegate = self
        firstNameTextField.tag = 0
        firstNameTextField.textColor = .white
        firstNameTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        lastNameTextField.delegate = self
        lastNameTextField.tag = 1
        lastNameTextField.textColor = .white
        lastNameTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        emailTextField.delegate = self
        emailTextField.tag = 2
        emailTextField.textColor = .white
        emailTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordTextField.delegate = self
        passwordTextField.tag = 3
        passwordTextField.textColor = .white
        passwordTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        retypePasswordTextField.delegate = self
        retypePasswordTextField.tag = 4
        retypePasswordTextField.textColor = .white
        retypePasswordTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        retypePasswordTextField.attributedPlaceholder = NSAttributedString(string: "Re-type Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
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
    
    @IBAction func onRegisterBtnClick(_ sender:Any){
        if(checkInput()){
            registerUser()
        }else{
            registerButton.shake()
        }
    }
    
    func checkInput() -> Bool {
        if(firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || retypePasswordTextField.text!.isEmpty){
            Toast.showToast(message: "All Fields Are Required!", viewController: self)
            return false
        }
        if(passwordTextField.text! != retypePasswordTextField.text!){
            Toast.showToast(message: "Passwords Do Not Match!", viewController: self)
            return false
        }
        return true
    }
    
    func registerUser(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/customer/register")!
        
        
        let params = [
            "firstName" : firstNameTextField.text!,
            "lastName" : lastNameTextField.text!,
            "email" : emailTextField.text!,
            "password" : passwordTextField
                .text!,
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            if(response.response!.statusCode == 200){
                let newUser = try! JSONDecoder().decode(CustomerUser.self, from: response.data!)
                DispatchQueue.main.async{
                    self.customer = newUser
                    self.saveUser()
                }
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.registerButton.shake()
            }
            
        }
    }
    
    func saveUser(){
        if(customer != nil){
            let userDefaults = UserDefaults.standard
            
            do{
                let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: customer!, requiringSecureCoding: false)
                userDefaults.set(encodedData, forKey: "customerUser")
                userDefaults.set(nil, forKey: "mycart")
                userDefaults.synchronize()
            }catch let error {
                print(error)
            }
            
            performSegue(withIdentifier: "segueRegisterCustomerToMenu", sender: self)
            
            
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
