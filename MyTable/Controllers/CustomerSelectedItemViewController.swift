//
//  CustomerSelectedItemViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/29/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class CustomerSelectedItemViewController: UIViewController {

    var selectedItem: MenuItem!
    
    var selectedRestaurant: RestaurantUser!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var itemNameLbl: UILabel!
    
    @IBOutlet weak var itemDescriptionLbl: UILabel!
    
    @IBOutlet weak var quantityAmountLbl: UILabel!
    

    
    @IBOutlet weak var btnUp: UIButton!
    
    @IBOutlet weak var btnDown: UIButton!
    
    @IBOutlet weak var addToCartBtn: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLabels()
    }
    
    func initializeLabels(){
        quantityAmountLbl.text = "0"
        imageView.downloaded(from: selectedItem.menuImage)
        itemNameLbl.text = "Item: " + selectedItem.itemName + " (" + String(selectedItem.price) + "$)"
        itemDescriptionLbl.text = "Description: " + selectedItem.itemShortDescription

    }
    
    @IBAction func onUpBtnClick(_ sender: Any) {
        if(Int(quantityAmountLbl.text!)! < 100 ){
            quantityAmountLbl.text = String(Int(quantityAmountLbl.text!)! + 1)
        }
    }
    
    @IBAction func onDownBtnClick(_ sender: Any) {
        if(Int(quantityAmountLbl.text!)! > 0 ){
            quantityAmountLbl.text = String(Int(quantityAmountLbl.text!)! - 1)
        }
    }
    
    @IBAction func onAddToCartBtnClick(_ sender: Any) {
        if(Int(quantityAmountLbl.text!)! > 0){
            addItemToCart()
        }
    }
    
    func addItemToCart(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "mycart")
        var sameRestaurant = true
        var itemPresentIndex = -1
        let orderedItem = OrderedMenuItem(id: selectedItem.id, itemName: selectedItem.itemName, itemShortDescription: selectedItem.itemShortDescription, price: selectedItem.price, quantity: Int(quantityAmountLbl.text!)!, menuImage: selectedItem.menuImage, restaurantId: selectedRestaurant.id)
        
        if(decoded == nil){
            //var cartDictionary = [Int:OrderedMenuItem]()
            var cartArray = [OrderedMenuItem]()
            //cartDictionary[orderedItem.id] = orderedItem
            cartArray.append(orderedItem)
            do{
                let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: cartArray, requiringSecureCoding: false)
                userDefaults.set(encodedData, forKey: "mycart")
                userDefaults.synchronize()
            }catch let error {
                print(error)
            }
        
        }else{
            do{
                var decodedCart = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! [OrderedMenuItem]
                for item in decodedCart {
                    if(item.restaurantId != orderedItem.restaurantId){
                        sameRestaurant = false
                        break
                    }
                }
                if(sameRestaurant){
                    for i in 0...decodedCart.count-1{
                        if(decodedCart[i].id == orderedItem.id){
                            itemPresentIndex = i
                            break
                        }
                    }
                    
                    if(itemPresentIndex >= 0){
                        let existingItem = decodedCart[itemPresentIndex]
                        existingItem.quantityOrdered = existingItem.quantityOrdered + Int(quantityAmountLbl.text!)!
                       // decodedCart[itemPresentIndex] = existingItem
                        decodedCart[itemPresentIndex] = existingItem
                    }else{
                        decodedCart.append(orderedItem)
                    }
                    
                }else{
                    decodedCart = [OrderedMenuItem]()
                    decodedCart.append(orderedItem)
                }
                
                do{
                    let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: decodedCart, requiringSecureCoding: false)
                    userDefaults.set(encodedData, forKey: "mycart")
                    userDefaults.synchronize()
                }catch let error {
                    print(error)
                }
            }catch let error {
                print(error)
            }
        }
        Toast.showToast(message: "Item Added To Cart", viewController: self)
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
