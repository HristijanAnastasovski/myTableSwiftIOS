//
//  NewRestaurantItemPictureViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/27/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class NewRestaurantItemPictureViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var noImageLbl: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var checkUrlBtn: CustomButton!
    
    @IBOutlet weak var addItemBtn: CustomButton!
    
    var itemName:String!
    var itemPrice:Double!
    var itemQuantity:Int!
    var ingredients:String!
    var restaurantId:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        setUpTextField()

        // Do any additional setup after loading the view.
    }
    
    
    func setUpTextField(){
        urlTextField.delegate = self
        urlTextField.tag = 0
        urlTextField.textColor = .white
        urlTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        urlTextField.attributedPlaceholder = NSAttributedString(string: "Image URL",
                                                                      attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
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
    
    
    @IBAction func onCheckUrlBtnClick(_ sender: Any) {
        if(urlTextField.text!.count <= 0){
            Toast.showToast(message: "All fields are required", viewController: self)
            checkUrlBtn.shake()
        }else {
            imageView.downloaded(from: urlTextField.text!)
            self.noImageLbl.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                if(self.imageView.image == nil){
                    Toast.showToast(message: "Couldn't load image from URL", viewController: self)
                    self.checkUrlBtn.shake()
                    self.noImageLbl.isHidden = false
                }
            })
        }
    }
    

    @IBAction func onAddItemBtnClick(_ sender: Any) {
        if(self.imageView.image == nil){
            Toast.showToast(message: "No Image Selected", viewController: self)
            addItemBtn.shake()
        } else {
            addNewItemToMenu()
        }
    }
    
    func addNewItemToMenu(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/menu/addItem")!
        
        if(restaurantId == nil){
            initializeRestaurantId()
        }
        
        let params = [
            "itemName" : itemName!,
            "description" : ingredients!,
            "price": itemPrice!,
            "quantity": itemQuantity!,
            "restaurantId": self.restaurantId!,
            "menuItemImage": urlTextField.text!
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
                self.addItemBtn.shake()
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
