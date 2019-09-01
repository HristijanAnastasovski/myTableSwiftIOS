//
//  RestaurantOrdersViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/26/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantOrdersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var ordersCollectionView: UICollectionView!
    
    var orders = [Order]()
    var selectedOrder : Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        ordersCollectionView.delegate = self
        ordersCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        initializeOrders()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ordersCollectionView.dequeueReusableCell(withReuseIdentifier: "restaurantOrderCell", for: indexPath) as! RestaurantOrderCollectionViewCell
        
        cell.orderNumberLbl.text = "Order #" + String(orders[indexPath.row].id)
        cell.orderedByLbl.text = orders[indexPath.row].customer.firstName + " " + orders[indexPath.row].customer.lastName
    
        cell.contactLbl.text = orders[indexPath.row].customer.email
        
        let dateString = orders[indexPath.row].dateTime.replacingOccurrences(of: "T", with: " at ")
        let resultDate = dateString.dropLast(3)
        
        cell.dateLbl.text = String(resultDate)
        cell.numberOfSeatsLbl.text = String(orders[indexPath.row].numberOfSeats)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedOrder = orders[indexPath.row]
        performSegue(withIdentifier: "segueRestaurantOrderToOrderedItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueRestaurantOrderToOrderedItems"){
            let orderedItemsViewController = segue.destination as! RestaurantOrderedItemsViewController
            orderedItemsViewController.selectedItemId = selectedOrder.id
        }
    }
    func initializeOrders(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "restaurantUser")
        if(decoded != nil){
            do{
                let decodedRestaurantUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! RestaurantUser
                loadOrders(id: decodedRestaurantUser.id)
                
            }catch let error {
                print(error)
            }
        } else {
            Toast.showToast(message: "Error with loading the user data", viewController: self)
        }
    }
    
    func loadOrders(id: Int){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/order/allRestaurantOrders/"+String(id))!
        
        AF.request(searchUrl).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                let loadedOrders = try! JSONDecoder().decode([Order].self, from: response.data!)
                
                DispatchQueue.main.async{
                    self.orders.removeAll()
                    self.orders.append(contentsOf: loadedOrders.reversed())
                    self.ordersCollectionView.reloadData()
                }
                
                
            }else {
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
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
