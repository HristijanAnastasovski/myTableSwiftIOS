//
//  CustomerCheckoutViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/30/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class CustomerCheckoutViewController: UIViewController, UITextFieldDelegate {

    var orderedItems = [OrderedMenuItem]()
    @IBOutlet weak var numberOfSeatsTextField: UITextField!
    @IBOutlet weak var billingTextField: UITextField!
    @IBOutlet weak var dateTextFIeld: UITextField!
    @IBOutlet weak var confirmBtn: CustomButton!
    @IBOutlet weak var cvvTextFIeld: UITextField!
    var year: Int!
    var month: Int!
    var day: Int!
    var hour: Int!
    var minutes: Int!
    
    var customer: CustomerUser!
    
    var datePicker: UIDatePicker?
    
    var createdOrder: Order!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        setUpTextFields()

        // Do any additional setup after loading the view.
    }
    
    func setUpTextFields(){
        numberOfSeatsTextField.delegate = self
        numberOfSeatsTextField.tag = 0
        numberOfSeatsTextField.textColor = .white
        numberOfSeatsTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        numberOfSeatsTextField.attributedPlaceholder = NSAttributedString(string: "Number of Seats Needed",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        billingTextField.delegate = self
        billingTextField.tag = 1
        billingTextField.textColor = .white
        billingTextField.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        billingTextField.attributedPlaceholder = NSAttributedString(string: "Credit Card Number",
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        cvvTextFIeld.delegate = self
        cvvTextFIeld.tag = 2
        cvvTextFIeld.textColor = .white
        cvvTextFIeld.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        cvvTextFIeld.attributedPlaceholder = NSAttributedString(string: "CVV",
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
    
        
        dateTextFIeld.delegate = self
        dateTextFIeld.tag = 3
        dateTextFIeld.textColor = .white
        dateTextFIeld.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.3, alpha: 1)
        dateTextFIeld.attributedPlaceholder = NSAttributedString(string: "Date and Time of Arrival",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTextFIeld.inputView = datePicker
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateTextFIeld.text = dateFormatter.string(from: datePicker.date)
        
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
    
    @IBAction func onConfirmBtnClick(_ sender: Any) {
        if(checkInput()){
            loadTextFieldValues()
            loadUserDetails()
            createEmptyOrder()
        }else{
            confirmBtn.shake()
        }
        
       

    }
    
    func createEmptyOrder(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/order/createEmpty")!
        
        
        let params = [
            "customerId" : customer.id,
            "restaurantId" : orderedItems[0].restaurantId,
            "numberOfSeats": Int(numberOfSeatsTextField.text!)!,
            "year": year!,
            "month": month!,
            "dayOfMonth": day!,
            "hour": hour!,
            "minute": minutes!
            ] as [String : Any]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                let order = try! JSONDecoder().decode(Order.self, from: response.data!)
                DispatchQueue.main.async {
                    self.createdOrder = order
                    self.fillEmptyOrder()
                }
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.confirmBtn.shake()
            }
            
        }
    }
    
    func fillEmptyOrder(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/order/addItem")!
        var numberOfAddedItems = 0
        for item in orderedItems{
            let params = [
                "orderId" : createdOrder.id,
                "itemId" : item.id,
                "quantity": item.quantityOrdered,
                ] as [String : Any]
            AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
                if(response.response!.statusCode == 200){
                    DispatchQueue.main.async {
                        numberOfAddedItems += 1
                        if(numberOfAddedItems == self.orderedItems.count){
                            let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/order/confirm")!
                            let params = [
                                "orderId" : self.createdOrder.id,
                                "creditCardNumber" : Int(self.billingTextField.text!)!,
                                "CVV": Int(self.cvvTextFIeld.text!)!,
                                ] as [String : Any]
                            AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
                                if(response.response!.statusCode == 200){
                                    DispatchQueue.main.async {
                                        self.confirmOrder()
                                    }
                                }
                                else{
                                    let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                                    Toast.showToast(message: error.message, viewController: self)
                                    self.dismissOrder()
                                    self.confirmBtn.shake()
                                }
                                
                            }
                        }
                        
                    }
                } else{
                    let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                    Toast.showToast(message: error.message, viewController: self)
                    self.dismissOrder()
                    self.confirmBtn.shake()
                }
            }
 
        }
        
    }
    
    
  
    func dismissOrder(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/order/removeOrder")!
        let params = [
            "orderId" : createdOrder.id
            ] as [String : Any]
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            if(response.response!.statusCode != 200){
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.confirmBtn.shake()
            }
           
            
        }
        
    }
    
    
    
    func confirmOrder(){
        Toast.showToast(message: "Order delivered!", viewController: self)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "mycart")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        
        
    }
    
    func loadTextFieldValues(){
        let dateAndTime = dateTextFIeld.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDate = dateFormatter.date(from: dateAndTime!)
        
        dateFormatter.dateFormat = "yyyy"
        year = Int(dateFormatter.string(from: formattedDate!))
        dateFormatter.dateFormat = "MM"
        month = Int(dateFormatter.string(from: formattedDate!))
        dateFormatter.dateFormat = "dd"
        day = Int(dateFormatter.string(from: formattedDate!))
        dateFormatter.dateFormat = "HH"
        hour = Int(dateFormatter.string(from: formattedDate!))
        dateFormatter.dateFormat = "mm"
        minutes = Int(dateFormatter.string(from: formattedDate!))
        
    }
    
    func loadUserDetails(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "customerUser")
        if(decoded != nil){
            do{
                let decodedCustomerUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! CustomerUser
                customer = decodedCustomerUser
                
            }catch let error {
                print(error)
            }
        } else {
            Toast.showToast(message: "Error with loading the user data", viewController: self)
        }
    }
    
    func checkInput() -> Bool{
        if(numberOfSeatsTextField.text!.count <= 0 || dateTextFIeld.text!.count <= 0){
            Toast.showToast(message: "All Fields Are Required!", viewController: self)
            return false
        }
        
        if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: numberOfSeatsTextField.text!))){
            Toast.showToast(message: "Seats Accepts Only Numbers!", viewController: self)
            return false
        }
        
        if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: billingTextField.text!))){
            Toast.showToast(message: "CC Field Accepts Only Numbers!", viewController: self)
            return false
        }
        
        if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: cvvTextFIeld.text!)) || cvvTextFIeld.text!.count != 3){
            Toast.showToast(message: "CVV must be a 3 digit number!", viewController: self)
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
