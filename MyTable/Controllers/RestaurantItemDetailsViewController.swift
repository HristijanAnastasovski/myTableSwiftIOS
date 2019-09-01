//
//  RestaurantItemEditViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/27/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var itemNameLbl: UILabel!
    
    @IBOutlet weak var itemPriceLbl: UILabel!
    
    @IBOutlet weak var itemQuantityLbl: UILabel!
    
    @IBOutlet weak var itemDescriptionLbl: UILabel!
    
    @IBOutlet weak var deleteBtn: CustomButton!
    
    @IBOutlet weak var editBtn: CustomButton!
    
    
    var itemId:Int!
    var imageURL: String!
    var itemName: String!
    var itemPrice: Double!
    var itemQuantity: Int!
    var itemDescription:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        setStartingValues()
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func setStartingValues(){
        imageView.downloaded(from: imageURL)
        itemNameLbl.text = "Name: " + itemName
        itemPriceLbl.text = "Price: " + String(itemPrice!)+"$"
        itemQuantityLbl.text = "Quantity: " + String(itemQuantity)
        itemDescriptionLbl.text = "Description: " + itemDescription
    }
    
    @IBAction func onEditBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "segueItemDetailsToEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueItemDetailsToEdit"){
            let restaurantItemEditViewController =  segue.destination as! RestaurantItemEditViewController
            restaurantItemEditViewController.itemId = itemId
            restaurantItemEditViewController.itemName = itemName
            restaurantItemEditViewController.itemPrice = itemPrice
            restaurantItemEditViewController.itemQuantity = itemQuantity
            restaurantItemEditViewController.itemDescription = itemDescription
            restaurantItemEditViewController.imageURL = imageURL
            
        }
        if(segue.identifier == "segueDetailsToPicture"){
            let restaurantEditImageViewController = segue.destination as! RestaurantItemEditImageViewController
            restaurantEditImageViewController.itemId = itemId
            restaurantEditImageViewController.itemName = itemName
            restaurantEditImageViewController.itemPrice = itemPrice
            restaurantEditImageViewController.itemDescription = itemDescription
            restaurantEditImageViewController.imageURL = imageURL
        }
    }
    
    @IBAction func onDeleteBtnClick(_ sender: Any) {
        deleteItem()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.navigationController?.popToRootViewController( animated: true )
        })
    }
    
    func deleteItem(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/menu/deleteItem")!
       
        
        let params = [
            "id" : itemId
            ]
        
        AF.request(searchUrl, method: .post, parameters: params).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigationController?.popToRootViewController( animated: true )
                })
            }
            else{
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
                self.deleteBtn.shake()
            }
            
            
            
        }
    }
    
    @IBAction func onImgClick(_ sender: Any) {
        performSegue(withIdentifier: "segueDetailsToPicture", sender: self)
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
