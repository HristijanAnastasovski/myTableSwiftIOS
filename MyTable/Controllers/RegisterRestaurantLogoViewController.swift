//
//  RegisterRestaurantLogoViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/26/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RegisterRestaurantLogoViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    
    
    @IBOutlet weak var noLogoLbl: UILabel!
    
   
    @IBOutlet weak var checkUrlBtn: CustomButton!
    
    @IBOutlet weak var registerRestaurantBtn: CustomButton!
    
    var restaurantEmail: String!
    var restaurantPassword: String!
    var restaurantName: String!
    var restaurantAddress: String!
    var restaurantBilling: Int!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    var restaurantUser : RestaurantUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        setUpTextField()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpTextField(){
        urlTextField.textColor = .white
        urlTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        urlTextField.attributedPlaceholder = NSAttributedString(string: "Restaurant's Logo URL",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        urlTextField.delegate = self
        urlTextField.tag = 0
    }
   
    @IBAction func onCheckUrlClick(_ sender: Any) {
        if(urlTextField.text!.count <= 0){
            Toast.showToast(message: "All fields are required", viewController: self)
            checkUrlBtn.shake()
        }else{
            logoImageView.downloaded(from: urlTextField.text!)
            self.noLogoLbl.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                if(self.logoImageView.image == nil){
                    Toast.showToast(message: "Couldn't load logo from URL", viewController: self)
                    self.noLogoLbl.isHidden = false
                }
            })
            
            
        }
    }
    
    @IBAction func registerRestaurantBtnClick(_ sender: Any) {
        if(urlTextField.text!.count <= 0){
            Toast.showToast(message: "All fields are required", viewController: self)
            registerRestaurantBtn.shake()
        } else if(self.logoImageView.image == nil) {
            Toast.showToast(message: "Selected URL is not valid", viewController: self)
            registerRestaurantBtn.shake()
        } else {
            registerRestaurant()
        
        }
        
        
    }
    
    func registerRestaurant(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/register")!
        
        
        let params = [
            "restaurantName" : restaurantName!,
            "restaurantAddress" : restaurantAddress!,
            "restaurantEmail": restaurantEmail!,
            "restaurantPassword": restaurantPassword!,
            "restaurantLogo": urlTextField.text!,
            "billingAccount": restaurantBilling!
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
                self.registerRestaurantBtn.shake()
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
            performSegue(withIdentifier: "segueRestaurantLogoToMainMenu", sender: self)
            
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImageView {
    static let cache = NSCache<NSString, UIImage>()
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {  // for
        
        
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                UIImageView.cache.setObject(image, forKey: url.absoluteString as NSString)
                self.image = image
                print("Image downloaded")
            
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        
        let image = UIImageView.cache.object(forKey: link as NSString)
        if(image != nil){
            DispatchQueue.main.async() {
                self.image = image
                print("Image loaded from cache")
                
            }
        }else{
        guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)}
    }
}
