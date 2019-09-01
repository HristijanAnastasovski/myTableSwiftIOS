//
//  CustomerCartViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/29/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class CustomerCartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var emptyCartLbl: UILabel!
    var cartItems = [OrderedMenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        //loadCart()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadCart()
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: "cellCartItem", for: indexPath) as! CartItemCollectionViewCell
        
        cell.imageView.downloaded(from: cartItems[indexPath.row].menuImage)
        cell.priceLbl.text = "Price: " + String(cartItems[indexPath.row].price * Double(cartItems[indexPath.row].quantityOrdered)) + "$"
        cell.titleLbl.text = cartItems[indexPath.row].itemName
        cell.amountLbl.text = String(cartItems[indexPath.row].quantityOrdered)
        
        
        cell.OnPlusBtnTapped = {
            cell in
            
            self.addQuantityToItem(id: self.cartItems[indexPath.row].id)
            self.loadCart()
    }
        
        cell.OnMinusBtnTapped = {
            cell in
            
            self.lowerQuantityToItem(id: self.cartItems[indexPath.row].id)
            self.loadCart()
        }
        
        
        return cell
    }
    
    
    @IBAction func emptyCart(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "mycart")
        Toast.showToast(message: "Cart Dismissed", viewController: self)
        cartItems.removeAll()
        checkoutBtn.setTitle("Checkout: 0$", for: .normal)
        emptyCartLbl.isHidden = false
        cartCollectionView.reloadData()
        
        
        
    }
    
    
    @IBAction func onCheckoutBtnClick(_ sender: Any) {
        if(cartItems.count>0){
            performSegue(withIdentifier: "segueCartToCheckout", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueCartToCheckout"){
            let checkoutViewController = segue.destination as! CustomerCheckoutViewController
            checkoutViewController.orderedItems = [OrderedMenuItem]()
            checkoutViewController.orderedItems.append(contentsOf: cartItems)
        }
    }
    
    func loadCart(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "mycart")
        
        if(decoded == nil){
            emptyCartLbl.isHidden = false
            checkoutBtn.setTitle("Checkout: 0$", for: .normal)
            cartItems.removeAll()
            cartCollectionView.reloadData()
        }
        else{
            emptyCartLbl.isHidden = true
        do{
            let decodedCart = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! [OrderedMenuItem]
            cartItems.removeAll()
            var total = 0.0
            
            for item in decodedCart{
                total += Double(item.quantityOrdered) * item.price
                cartItems.append(item)
            }
            
            checkoutBtn.setTitle("Checkout: " + String(total) + "$", for: .normal)
            cartCollectionView.reloadData()
            
        }catch let error {
            print(error)
        }
        }
        
    }
    
    func addQuantityToItem(id:Int){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "mycart")
        var index = -1
        
        do{
            var decodedCart = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! [OrderedMenuItem]
            for i in 0...decodedCart.count{
                if(decodedCart[i].id == id){
                    index = i
                    break
                }
            }
            let item = decodedCart[index]
            if(item.quantityOrdered < 100){
                item.quantityOrdered = item.quantityOrdered + 1
                decodedCart[index] = item
                do{
                    let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: decodedCart, requiringSecureCoding: false)
                    userDefaults.set(encodedData, forKey: "mycart")
                    userDefaults.synchronize()
                    
                }catch let error {
                    print(error)
                }
                
            }
            
        }catch let error {
            print(error)
        }

    }
    
    func lowerQuantityToItem(id:Int){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "mycart")
        var index = -1
        
        do{
            var decodedCart = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! [OrderedMenuItem]
            for i in 0...decodedCart.count{
                if(decodedCart[i].id == id){
                    index = i
                    break
                }
            }
            let item = decodedCart[index]
            if(item.quantityOrdered > 0){
                item.quantityOrdered = item.quantityOrdered - 1
                decodedCart[index] = item
                do{
                    let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: decodedCart, requiringSecureCoding: false)
                    userDefaults.set(encodedData, forKey: "mycart")
                    userDefaults.synchronize()
                    
                }catch let error {
                    print(error)
                }
                
            }
            
        }catch let error {
            print(error)
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
