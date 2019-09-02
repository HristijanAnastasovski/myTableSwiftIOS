//
//  CustomerRestaurantItemsViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/29/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class CustomerRestaurantItemsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var selectedRestaurant: RestaurantUser!
    var restaurantItems = [MenuItem]()
    var selectedItem: MenuItem!
    
    @IBOutlet weak var restaurantItemsCollectionView: UICollectionView!
    
    @IBOutlet weak var noItemsInRestaurantLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedRestaurant.restaurantName
        restaurantItemsCollectionView.delegate = self
        restaurantItemsCollectionView.dataSource = self
        
        restaurantItems.removeAll()
        noItemsInRestaurantLbl.isHidden = false
        loadMenu()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCustomerRestaurantItem", for: indexPath) as! CustomerRestaurantMenuCollectionViewCell
        cell.imageView.downloaded(from: restaurantItems[indexPath.row].menuImage)
        cell.itemName.text = restaurantItems[indexPath.row].itemName + " (" + String(restaurantItems[indexPath.row].price) + "$)"
        cell.itemDesc.text = restaurantItems[indexPath.row].itemShortDescription
        
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    //segueCustomerRestaurantsToMenu
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = restaurantItems[indexPath.row]
        performSegue(withIdentifier: "segueCustomerMenuToItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueCustomerMenuToItem")
        {
            let selectedItemViewController = segue.destination as! CustomerSelectedItemViewController
            selectedItemViewController.selectedItem = selectedItem
            selectedItemViewController.selectedRestaurant = selectedRestaurant
        }
    }
    
    func loadMenu(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/menu/" + String(selectedRestaurant.id))!
        
        AF.request(searchUrl).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                let menuItems = try! JSONDecoder().decode([MenuItem].self, from: response.data!)
                
                DispatchQueue.main.async{
                    self.restaurantItems.append(contentsOf: menuItems)
                    if(self.restaurantItems.count > 0){
                        self.noItemsInRestaurantLbl.isHidden = true
                    }
                    self.restaurantItemsCollectionView.reloadData()
                    
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
