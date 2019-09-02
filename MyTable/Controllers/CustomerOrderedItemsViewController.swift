//
//  CustomerOrderedItemsViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 9/2/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire


class CustomerOrderedItemsViewController: UIViewController {
    
    var selectedItemId: Int!
    var restaurant: RestaurantUser!
    
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var orderedItemsLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var checkLocationBtn: CustomButton!
    
    var orderedItems = [OrderedItemsView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        orderLbl.text = "Order #" + String(selectedItemId)
        loadOrderedItems()
        // Do any additional setup after loading the view.
    }
    
    func setUpLabels(){
        var total = 0.0
        for item in orderedItems{
            let string = String(item.quantity) + " X "
            let string2 = string + item.itemName + "\n"
            orderedItemsLbl.text!.append(contentsOf: string2)
            total = total + (item.price * Double(item.quantity))
        }
        totalPriceLbl.text = "Total Price: " + String(total) + "$"
        
    }
    
    func loadOrderedItems(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/order/getOrderedItems/"+String(selectedItemId))!
        
        AF.request(searchUrl).responseJSON { response in
            if(response.response!.statusCode == 200){
                let orderedItems = try! JSONDecoder().decode([OrderedItemsView].self, from: response.data!)
                
                DispatchQueue.main.async{
                    self.orderedItems.removeAll()
                    self.orderedItems.append(contentsOf: orderedItems)
                    self.setUpLabels()
                }
                
                
            }else {
                let error = try! JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                Toast.showToast(message: error.message, viewController: self)
            }
            
        }
    }
    
    @IBAction func onCheckLocationBtnClick(_ sender: Any){
        performSegue(withIdentifier: "segueOrderToMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueOrderToMap"){
            let mapViewController = segue.destination as! MapViewController
            mapViewController.restaurant = self.restaurant
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
