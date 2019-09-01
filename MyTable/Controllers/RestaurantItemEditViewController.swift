//
//  RestaurantItemEditViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/27/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantItemEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var itemPriceTextField: UITextField!
    
    @IBOutlet weak var itemQuantityTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var saveChangesBtn: CustomButton!
    
    var placeholderLabel:UILabel!
    
    var itemId:Int!
    var itemName: String!
    var itemPrice: Double!
    var itemQuantity: Int!
    var itemDescription:String!
    var imageURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        setUpInputFields()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpInputFields(){
        itemNameTextField.delegate = self
        itemPriceTextField.delegate = self
        itemQuantityTextField.delegate = self
        descriptionTextView.delegate = self
        
        itemNameTextField.tag = 0
        itemPriceTextField.tag = 1
        itemQuantityTextField.tag = 2
        descriptionTextView.tag = 3
        
        itemNameTextField.textColor = .white
        itemNameTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        itemNameTextField.attributedPlaceholder = NSAttributedString(string: "Item Name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        itemPriceTextField.textColor = .white
        itemPriceTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        itemPriceTextField.attributedPlaceholder = NSAttributedString(string: "Item Price",
                                                                      attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        
        itemQuantityTextField.textColor = .white
        itemQuantityTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        itemQuantityTextField.attributedPlaceholder = NSAttributedString(string: "Quantity",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        
        fillValues()
        
        
    }
    
    func fillValues(){
        itemNameTextField.text = itemName
        itemPriceTextField.text = String(itemPrice!)
        itemQuantityTextField.text = String(itemQuantity!)
        descriptionTextView.text = itemDescription
    }
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            if let nextField = textField.superview?.viewWithTag(3) as? UITextView{
                nextField.becomeFirstResponder()
            } else{
                
                textField.resignFirstResponder()
            }
        }
        
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func onSaveChangesBtnClick(_ sender: Any) {
        if(checkInput()){
            confirmEdit()
            
        }else {
            saveChangesBtn.shake()
        }
    }
    
    func checkInput() -> Bool{
        if(itemNameTextField.text!.count <= 0 || itemPriceTextField.text!.count <= 0 || itemQuantityTextField.text!.count <= 0 || descriptionTextView.text!.count <= 0){
            Toast.showToast(message: "All Fields Are Required!", viewController: self)
            return false
        }
        if(!itemPriceTextField.text!.isDecimal){
            Toast.showToast(message: "Price Accepts Only Numbers!", viewController: self)
            return false
        }
        
        
        if(Double(itemPriceTextField.text!)! < 0){
            Toast.showToast(message: "Price Can't Be Negative!", viewController: self)
            return false
        }
       
        if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: itemQuantityTextField.text!))){
            Toast.showToast(message: "Quantity Accepts Only Numbers!", viewController: self)
            return false
        }
        
        let resultValue = Int(itemQuantityTextField.text!)! - itemQuantity
        
        if(resultValue < 0){
            Toast.showToast(message: "Reduction Of Quantity Is Not Allowed!", viewController: self)
            return false
        }
        
        return true
        
        
    }
    
    func confirmEdit(){
        if(itemName == itemNameTextField.text! && itemDescription == descriptionTextView.text! && itemPrice == Double(itemPriceTextField.text!)){
            addQuantity()
        }else{
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/menu/editItem")!
        
        
        let params = [
            "itemId" : itemId!,
            "itemName" : itemNameTextField.text!,
            "description": descriptionTextView.text!,
            "price": Double(itemPriceTextField.text!)!,
            "menuItemImage": imageURL!
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            if(response.response!.statusCode == 200){
                DispatchQueue.main.async {
                    
                    self.addQuantity()
                }
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.saveChangesBtn.shake()
            }
   
        }
        }
    }
    
    func addQuantity(){
        if(itemQuantity == Int(itemQuantityTextField.text!)){
            self.navigationController?.popToRootViewController(animated: true)
        }else{
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/menu/addQuantity")!
        
        
        let params = [
            "itemId" : itemId!,
            "quantity" : Int(itemQuantityTextField.text!)! - itemQuantity,
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            if(response.response!.statusCode == 200){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.saveChangesBtn.shake()
            }
            
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

extension String {
    var isDecimal: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9","."]
        return Set(self).isSubset(of: nums)
    }
}
