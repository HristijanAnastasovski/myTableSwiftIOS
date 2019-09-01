//
//  RestaurantItemEditImageViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/27/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantItemEditImageViewController: UIViewController, UITextFieldDelegate {

    var itemId:Int!
    var imageURL: String!
    var itemName: String!
    var itemPrice: Double!
    var itemDescription:String!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var checkUrlBtn: CustomButton!
    
    @IBOutlet weak var confirmBtn: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        imageView.downloaded(from: imageURL)
        setUpTextField()
        

        // Do any additional setup after loading the view.
    }
    
    func setUpTextField(){
        urlTextField.delegate = self
        urlTextField.tag = 0
        urlTextField.textColor = .white
        urlTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        urlTextField.attributedPlaceholder = NSAttributedString(string: "Image URL",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        urlTextField.text = imageURL
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
        }else{
            imageView.image = nil
            imageView.downloaded(from: urlTextField.text!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                if(self.imageView.image == nil){
                    Toast.showToast(message: "Couldn't load image from URL", viewController: self)
                    self.urlTextField.text = self.imageURL
                    self.imageView.downloaded(from: self.imageURL)
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
        }else{
            imageView.image = nil
            imageView.downloaded(from: urlTextField.text!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                if(self.imageView.image == nil){
                    Toast.showToast(message: "Couldn't load image from URL", viewController: self)
                    self.urlTextField.text = self.imageURL
                    self.imageView.downloaded(from: self.imageURL)
                }else{
                    self.confirmEdit()
                }
            })
            
        }
    }
    
    func confirmEdit(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/menu/editItem")!
        
        
        let params = [
            "itemId" : itemId!,
            "itemName" : itemName!,
            "description": itemDescription!,
            "price": itemPrice!,
            "menuItemImage": urlTextField.text!
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            if(response.response!.statusCode == 200){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.confirmBtn.shake()
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
