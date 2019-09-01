//
//  CustomerChangePasswordViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 9/1/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire


class CustomerChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordFieldText: UITextField!
    @IBOutlet weak var retypePasswordFieldText: UITextField!
    @IBOutlet weak var changePasswordBtn: CustomButton!
    
    var customer: CustomerUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        setUpTextFields()
        // Do any additional setup after loading the view.
    }
    
    func setUpTextFields(){
        passwordFieldText.delegate = self
        passwordFieldText.tag = 0
        passwordFieldText.textColor = .white
        passwordFieldText.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        passwordFieldText.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        retypePasswordFieldText.delegate = self
        retypePasswordFieldText.tag = 1
        retypePasswordFieldText.textColor = .white
        retypePasswordFieldText.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        retypePasswordFieldText.attributedPlaceholder = NSAttributedString(string: "Re-type New Password",
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
    
    
    
    @IBAction func onPasswordChangeBtnClick(_ sender: Any){
        if(checkInput()){
            changePassword()
        }else{
            changePasswordBtn.shake()
        }
        
    }
    
    func checkInput()->Bool{
        if(passwordFieldText.text!.count <= 0 || retypePasswordFieldText.text!.count <= 0){
            Toast.showToast(message: "All Fields Are Required!", viewController: self)
            return false
            
        }
        if(passwordFieldText.text! != retypePasswordFieldText.text!){
            Toast.showToast(message: "Passwords Do Not Match!", viewController: self)
            return false
        }
        return true
    }
    
    func changePassword(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/customer/changePassword")!
        
        
        let params = [
            "id" : customer.id,
            "newPassword" : passwordFieldText.text!,
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            
            if(response.response!.statusCode == 200){
                Toast.showToast(message: "Password Successfully Changed!", viewController: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.changePasswordBtn.shake()
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
