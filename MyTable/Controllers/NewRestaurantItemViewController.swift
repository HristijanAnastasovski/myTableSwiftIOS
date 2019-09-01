//
//  NewRestaurantItemViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/27/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class NewRestaurantItemViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var itemPriceTextField: UITextField!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var addImageBtn: CustomButton!
    
    var placeholderLabel : UILabel!
    
    
    @IBOutlet weak var addItemWithoutImageBtn: CustomButton!
    
    var restaurantId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        addLabelToDescription()
        setUpInputFields()
        // Do any additional setup after loading the view.
    }
    
    func setUpInputFields(){
        itemNameTextField.delegate = self
        itemPriceTextField.delegate = self
        quantityTextField.delegate = self
        descriptionTextView.delegate = self
    
        itemNameTextField.tag = 0
        itemPriceTextField.tag = 1
        quantityTextField.tag = 2
        descriptionTextView.tag = 3
        
        itemNameTextField.textColor = .white
        itemNameTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        itemNameTextField.attributedPlaceholder = NSAttributedString(string: "New Item Name",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        itemPriceTextField.textColor = .white
        itemPriceTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        itemPriceTextField.attributedPlaceholder = NSAttributedString(string: "New Item Price",
                                                                     attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        
        quantityTextField.textColor = .white
        quantityTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        quantityTextField.attributedPlaceholder = NSAttributedString(string: "Quantity of New Item",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        
        
        
    
    
    }
    
    func addLabelToDescription(){
        descriptionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Ingredients..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (descriptionTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        descriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
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
    
    
    @IBAction func onAddImageBtnClick(_ sender: Any) {
        if(checkInput()){
            performSegue(withIdentifier: "segueNewItemToPicture", sender: self)
        }else {
            addImageBtn.shake()
        }
    }
    
    
    @IBAction func onAddItemWithoutImageBtnClick(_ sender: Any) {
        if(checkInput()){
            addItemWithoutImage()
        }else {
            addItemWithoutImageBtn.shake()
        }
    }
    
    func checkInput() -> Bool {
        if(itemNameTextField.text!.count <= 0 || itemPriceTextField.text!.count <= 0 || quantityTextField.text!.count <= 0 || descriptionTextView.text!.count <= 0){
            Toast.showToast(message: "All Fields Are Required!", viewController: self)
            return false
        }
        if(!itemPriceTextField.text!.isDecimal){
            Toast.showToast(message: "Price Accepts Only Numbers!", viewController: self)
            return false
        }
        if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: quantityTextField.text!))){
            Toast.showToast(message: "Quantity Accepts Only Numbers!", viewController: self)
            return false
        }
        return true
        
    }
    
    func addItemWithoutImage(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/menu/addItem")!
        
        let defaultImage = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1280px-No_image_3x4.svg.png"
        
        if(restaurantId == nil){
            initializeRestaurantId()
        }
        
        let params = [
            "itemName" : itemNameTextField.text!,
            "description" : descriptionTextView.text!,
            "price": Double(itemPriceTextField.text!)!,
            "quantity": Int(quantityTextField.text!)!,
            "restaurantId": self.restaurantId!,
            "menuItemImage": defaultImage
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.navigationController?.popToRootViewController( animated: true )
                })
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.addItemWithoutImageBtn.shake()
            }
            
            
            
        }
        
    }
    
    func initializeRestaurantId(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "restaurantUser")
        if(decoded != nil){
            do{
                let decodedRestaurantUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! RestaurantUser
                self.restaurantId = decodedRestaurantUser.id
                
            }catch let error {
                print(error)
            }
        } else {
            Toast.showToast(message: "Error with loading the user data", viewController: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newRestaurantItemViewController = segue.destination as! NewRestaurantItemPictureViewController
        newRestaurantItemViewController.itemName = itemNameTextField.text
        newRestaurantItemViewController.itemPrice = Double(itemPriceTextField.text!)
        newRestaurantItemViewController.itemQuantity = Int(quantityTextField.text!)
        newRestaurantItemViewController.ingredients = descriptionTextView.text
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
