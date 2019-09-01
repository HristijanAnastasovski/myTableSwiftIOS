//
//  RestaurantEditInfoViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/28/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantEditInfoViewController: UIViewController, UITextFieldDelegate {
   
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var restaurantAddressTextField: UITextField!
    @IBOutlet weak var restaurantBillingTextField: UITextField!
    
    
    @IBOutlet weak var saveBtn: CustomButton!
    
    
    var editedUser:RestaurantUser!
    var restaurantUser: RestaurantUser!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        setUpTextFields()
        fillValues()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSaveBtnClick(_ sender: Any) {
        if(checkInput()){
            confirmEdit()
        }else{
            saveBtn.shake()
        }
    }
    
    
    
    func setUpTextFields(){
        restaurantNameTextField.delegate = self
        restaurantNameTextField.tag = 0
        restaurantNameTextField.textColor = .white
        restaurantNameTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        restaurantNameTextField.attributedPlaceholder = NSAttributedString(string: "Restaurant Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        restaurantAddressTextField.delegate = self
        restaurantAddressTextField.tag = 1
        restaurantAddressTextField.textColor = .white
        restaurantAddressTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        restaurantAddressTextField.attributedPlaceholder = NSAttributedString(string: "Restaurant Address",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        restaurantBillingTextField.delegate = self
        restaurantBillingTextField.tag = 2
        restaurantBillingTextField.textColor = .white
        restaurantBillingTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        restaurantBillingTextField.attributedPlaceholder = NSAttributedString(string: "Billing Account",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    
    }
    
    func fillValues(){
        restaurantNameTextField.text = restaurantUser.restaurantName
        restaurantAddressTextField.text = restaurantUser.restaurantAddress
        restaurantBillingTextField.text = String(restaurantUser.billingAccountNumber)
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
    
    func checkInput()->Bool{
        if(restaurantNameTextField.text!.count <= 0 || restaurantAddressTextField.text!.count <= 0 || restaurantBillingTextField.text!.count <= 0){
            Toast.showToast(message: "All Fields Are Required!", viewController: self)
            return false
        }
        if(!restaurantBillingTextField.text!.isDecimal){
            Toast.showToast(message: "Billing Field Accepts Only Numbers!", viewController: self)
            return false
        }
        return true
    }
    
    
    func confirmEdit(){
        if(restaurantUser.restaurantName == restaurantNameTextField.text! && restaurantUser.restaurantAddress == restaurantAddressTextField.text! && restaurantUser.billingAccountNumber == Int(restaurantBillingTextField.text!)){
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }else{
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/edit")!
        
        
        let params = [
            "restaurantId" : restaurantUser.id,
            "restaurantName" : restaurantNameTextField.text!,
            "restaurantAddress": restaurantAddressTextField.text!,
            "restaurantLogo": restaurantUser.restaurantLogo,
            "billingAccount": Int(restaurantBillingTextField.text!)!
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                let user = try! JSONDecoder().decode(RestaurantUser.self, from: response.data!)
                DispatchQueue.main.async {
                    self.editedUser = user
                    self.saveEditedUser()
                }
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.saveBtn.shake()
            }
            
            }
        }
    }
    
    
    func saveEditedUser(){
        if(editedUser != nil){
            let userDefaults = UserDefaults.standard
            do{
                let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: editedUser!, requiringSecureCoding: false)
                userDefaults.set(encodedData, forKey: "restaurantUser")
                userDefaults.synchronize()
            }catch let error {
                print(error)
            }
            
            
            self.navigationController?.popToRootViewController(animated: true)
            
            
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
