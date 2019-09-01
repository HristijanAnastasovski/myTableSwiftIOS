//
//  RestaurantPasswordChangeViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/28/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantPasswordChangeViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var retypeNewPasswordTextField: UITextField!
    
    @IBOutlet weak var changePasswordBtn: CustomButton!
    
    var restaurantUser: RestaurantUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        setUpTextFields()

        // Do any additional setup after loading the view.
    }
    
    func setUpTextFields(){
        
        newPasswordTextField.delegate = self
        retypeNewPasswordTextField.delegate = self
        
        newPasswordTextField.tag = 0
        retypeNewPasswordTextField.tag = 1
        
        newPasswordTextField.textColor = .white
        newPasswordTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        retypeNewPasswordTextField.textColor = .white
        retypeNewPasswordTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        retypeNewPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Re-Type New Password",
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
    
    @IBAction func onChangePasswordBtnClick(_ sender: Any) {
        if(checkInput()){
            changePassword()
        }
        else{
            changePasswordBtn.shake()
        }
    }
    
    func changePassword(){
            let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/changePassword")!
            
            
            let params = [
                "restaurantId" : restaurantUser.id,
                "newPassword" : newPasswordTextField.text!,
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
    func checkInput()->Bool{
        if(newPasswordTextField.text!.count <= 0 || retypeNewPasswordTextField.text!.count <= 0){
            Toast.showToast(message: "All Fields Are Required!", viewController: self)
            return false
            
        }
        if(newPasswordTextField.text! != retypeNewPasswordTextField.text!){
            Toast.showToast(message: "Passwords Do Not Match!", viewController: self)
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


