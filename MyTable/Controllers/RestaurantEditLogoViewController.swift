//
//  RestaurantEditLogoViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/28/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantEditLogoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var checkUrlBtn: CustomButton!
    
    @IBOutlet weak var confirmBtn: CustomButton!
    
    var restaurantUser: RestaurantUser!
    
    var editedUser: RestaurantUser!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        imageView.downloaded(from: restaurantUser.restaurantLogo)
        setUpTextField()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpTextField(){
        urlTextField.delegate = self
        urlTextField.tag = 0
        urlTextField.textColor = .white
        urlTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        urlTextField.attributedPlaceholder = NSAttributedString(string: "Logo URL",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        urlTextField.text = restaurantUser.restaurantLogo
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
    
    
    @IBAction func onCheckUrlBtnClickk(_ sender: Any) {
        if(urlTextField.text!.count <= 0){
            Toast.showToast(message: "All fields are required", viewController: self)
            checkUrlBtn.shake()
        }else{
            imageView.image = nil
            imageView.downloaded(from: urlTextField.text!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                if(self.imageView.image == nil){
                    Toast.showToast(message: "Couldn't load logo from URL", viewController: self)
                    self.urlTextField.text = self.restaurantUser.restaurantLogo
                    self.imageView.downloaded(from: self.restaurantUser.restaurantLogo)
                }
            })
            
            
        }
        
    }
    
    @IBAction func onConfirmClick(_ sender: Any) {
        if(urlTextField.text!.count <= 0){
            Toast.showToast(message: "All fields are required", viewController: self)
            confirmBtn.shake()
        }else if(imageView.image == nil){
            Toast.showToast(message: "Selected URL is not valid", viewController: self)
            confirmBtn.shake()
        }else if(urlTextField.text == restaurantUser.restaurantLogo){
            self.navigationController?.popToRootViewController(animated: true)
        }
        else{
            imageView.image = nil
            imageView.downloaded(from: urlTextField.text!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                if(self.imageView.image == nil){
                    Toast.showToast(message: "Couldn't load logo from URL", viewController: self)
                    self.urlTextField.text = self.restaurantUser.restaurantLogo
                    self.imageView.downloaded(from: self.restaurantUser.restaurantLogo)
                }else{
                    self.confirmEdit()
                }
            })
            
           
        }
    }
    
    func confirmEdit(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/edit")!
        
        print(urlTextField.text!)
        
        let params = [
            "restaurantId" : restaurantUser.id,
            "restaurantName" : restaurantUser.restaurantName,
            "restaurantAddress": restaurantUser.restaurantAddress,
            "restaurantLogo": urlTextField.text!,
            "billingAccount": restaurantUser.billingAccountNumber
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
                self.confirmBtn.shake()
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
