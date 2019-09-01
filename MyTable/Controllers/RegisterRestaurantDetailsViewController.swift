//
//  RegisterRestaurantDetailsViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/25/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class RegisterRestaurantDetailsViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var restaurantNameFieldText: UITextField!
    
    @IBOutlet weak var restaurantAddressFieldText: UITextField!
    
    @IBOutlet weak var restaurantBillingFieldText: UITextField!
    
    @IBOutlet weak var addRestaurantLogoBtn: CustomButton!
    
    @IBOutlet weak var registerWithoutLogoBtn: CustomButton!
    
    var restaurantEmail : String!
    var restaurantPasssword : String!
    
    var restaurantUser: RestaurantUser!
    
    
    
    @IBOutlet weak var logoLbl: UILabel!
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
        restaurantNameFieldText.textColor = .white
        restaurantNameFieldText.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        restaurantNameFieldText.attributedPlaceholder = NSAttributedString(string: "Restaurant Name",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        restaurantAddressFieldText.textColor = .white
        restaurantAddressFieldText.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        restaurantAddressFieldText.attributedPlaceholder = NSAttributedString(string: "Restaurant Address",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        restaurantBillingFieldText.textColor = .white
        restaurantBillingFieldText.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        restaurantBillingFieldText.attributedPlaceholder = NSAttributedString(string: "Restaurant Billing Account Number",
                                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        restaurantNameFieldText.delegate = self
        restaurantAddressFieldText.delegate = self
        restaurantBillingFieldText.delegate = self
        
        restaurantNameFieldText.tag = 0
        restaurantAddressFieldText.tag = 1
        restaurantBillingFieldText.tag = 2
        
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
    
    @IBAction func onAddRestaurantLogoBtnClick(_ sender: Any) {
        if(checkInput()){
            performSegue(withIdentifier: "segueRestaurantDetailsToLogo", sender: self)
        }
        else{
            addRestaurantLogoBtn.shake()
        }
        
    }
    
    @IBAction func onRegisterWithoutLogoClick(_ sender: Any) {
        if(checkInput()){
            registerUserWithDefaultLogo()
        }
        else{
            registerWithoutLogoBtn.shake()
        }
    }
    
    func checkInput() -> Bool {
        if(restaurantNameFieldText.text!.count <= 0 || restaurantAddressFieldText.text!.count <= 0 || restaurantBillingFieldText.text!.count <= 0){
            Toast.showToast(message: "All fields are required!", viewController: self)
            return false
        }
        if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: restaurantBillingFieldText.text!)))
        {
            Toast.showToast(message: "Billing field accepts only numbers!", viewController: self)
            return false
        }
        return true
    }
    
   
    
    
    func registerUserWithDefaultLogo(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/register")!
        
        let defaultLogo = "https://forextradingbonus.com/wp-content/img/2016/06/no-logo.png"
        
        let params = [
            "restaurantName" : restaurantNameFieldText.text!,
            "restaurantAddress" : restaurantAddressFieldText.text!,
            "restaurantEmail": restaurantEmail!,
            "restaurantPassword": restaurantPasssword!,
            "restaurantLogo": defaultLogo,
            "billingAccount": Int(restaurantBillingFieldText.text!)!
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                let restaurantUser = try! JSONDecoder().decode(RestaurantUser.self, from: response.data!)
                print(restaurantUser.restaurantName)
                
                DispatchQueue.main.async{
                    self.restaurantUser = restaurantUser
                    self.saveRegisteredRestaurantUser()
                }
                
                
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.registerWithoutLogoBtn.shake()
            }
            
            
            
        }
    }
    
    func saveRegisteredRestaurantUser(){
        if(restaurantUser != nil){
            let userDefaults = UserDefaults.standard
            do{
                let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: restaurantUser, requiringSecureCoding: false)
                userDefaults.set(encodedData, forKey: "restaurantUser")
                userDefaults.synchronize()
            }catch let error {
                print(error)
            }
            performSegue(withIdentifier: "segueRestaurantDetailsToMainMenu", sender: self)
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueRestaurantDetailsToLogo"){
            let registerRestaurantLogoViewController = segue.destination as! RegisterRestaurantLogoViewController
            registerRestaurantLogoViewController.restaurantEmail = self.restaurantEmail
            registerRestaurantLogoViewController.restaurantPassword = self.restaurantPasssword
            registerRestaurantLogoViewController.restaurantName = restaurantNameFieldText.text
            registerRestaurantLogoViewController.restaurantAddress = restaurantAddressFieldText.text
            registerRestaurantLogoViewController.restaurantBilling = Int(restaurantBillingFieldText.text!)
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
