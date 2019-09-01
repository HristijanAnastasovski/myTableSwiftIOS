//
//  CustomerUserLoginViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/25/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class CustomerUserLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoLbl: UILabel!
    
    @IBOutlet weak var signInButton: CustomButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var customerUser : CustomerUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        renderLogo()
        setUpTextFields()
        setUpButtons()
        
        // Do any additional setup after loading the view.
    }
    
    func renderLogo(){
        logoLbl.font = UIFont(name:"SnellRoundhand-Black", size: 70.0)
        logoLbl.textColor = .white
        logoLbl.text = "MyTable"
    }
    
    func setUpButtons(){
        registerButton.setTitle("Not a Member? Register For Free", for: .normal)
        registerButton.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        registerButton.tintColor = .white
    }
    
    func setUpTextFields() {
        emailTextField.textColor = .white
        emailTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordTextField.textColor = .white
        passwordTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordTextField.isSecureTextEntry = true
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        
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
    
    
    @IBAction func signInBtnClick(_ sender: Any) {
        if(checkInput()){
            validateUser()
        }else{
            signInButton.shake()
        }
    }
    
    func checkInput() -> Bool{
        if(emailTextField.text!.count <= 0 || passwordTextField.text!.count <= 0){
            Toast.showToast(message: "All fields are required!", viewController: self)
            return false
        }
        
        return true
    }
    
    func validateUser(){
        //let userDefaults = UserDefaults.standard
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/customer/login")!
        
        let params = [
            "email" : emailTextField.text,
            "password" : passwordTextField.text
        ]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                let customerUser = try! JSONDecoder().decode(CustomerUser.self, from: response.data!)
                
                
                DispatchQueue.main.async{
                    self.customerUser = customerUser
                    self.saveLoggedInCustomerUser()
                }
                
                
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.signInButton.shake()
            }
            
            
            
        }
        
    }
    
    func saveLoggedInCustomerUser(){
        if(customerUser != nil){
            let userDefaults = UserDefaults.standard
            do{
                let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: customerUser!, requiringSecureCoding: false)
                userDefaults.set(encodedData, forKey: "customerUser")
                userDefaults.synchronize()
            }catch let error {
                print(error)
            }
            performSegue(withIdentifier: "segueCustomerLoginToMainMenu", sender: self)
            
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
