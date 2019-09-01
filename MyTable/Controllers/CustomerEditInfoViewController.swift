//
//  CustomerEditInfoViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 9/1/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class CustomerEditInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var saveChangesBtn: CustomButton!
    
    var customer: CustomerUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        setUpTextFields()
        
    }
    
    func setUpTextFields(){
        firstNameTextField.delegate = self
        firstNameTextField.tag = 0
        firstNameTextField.textColor = .white
        firstNameTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        firstNameTextField.text = customer.firstName
        
        lastNameTextField.delegate = self
        lastNameTextField.tag = 1
        lastNameTextField.textColor = .white
        lastNameTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        lastNameTextField.text = customer.lastName
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
    
    @IBAction func onSaveChangesBtnClick(_ sender: Any){
        if(checkInput()){
            if(firstNameTextField.text! == customer.firstName && lastNameTextField.text! == customer.lastName){
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                changeCustomer()
      
            }
        }else{
            saveChangesBtn.shake()
        }
    }
    
    func checkInput()->Bool{
        if(firstNameTextField.text!.count <= 0 || lastNameTextField.text!.count <= 0){
            Toast.showToast(message: "All Fields Are Required!", viewController: self)
            return false
        }
        return true
    }
    
    func changeCustomer(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/customer/edit")!

        
        let params = [
            "id" : customer.id,
            "firstName" : firstNameTextField.text!,
            "lastName": lastNameTextField.text!
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in

            if(response.response!.statusCode == 200){
                let user = try! JSONDecoder().decode(CustomerUser.self, from: response.data!)
                DispatchQueue.main.async {
                    self.customer = user
                    self.saveChanges()
                }
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.saveChangesBtn.shake()
            }
            
        }
    }
    
    func saveChanges(){
        if(customer != nil){
            let userDefaults = UserDefaults.standard
            do{
                let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: customer!, requiringSecureCoding: false)
                userDefaults.set(encodedData, forKey: "customerUser")
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
