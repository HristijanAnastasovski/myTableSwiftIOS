//
//  CustomerRestaurantsViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/29/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class CustomerRestaurantsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var restaurants = [RestaurantUser]()
    var selectedRestaurant: RestaurantUser!
   
    @IBOutlet weak var restaurantsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        restaurantsCollectionView.delegate = self
        restaurantsCollectionView.dataSource = self
        initializeRestaurants()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCustomerRestaurants", for: indexPath) as! CustomerRestaurantsCollectionViewCell
        cell.imageView.downloaded(from: restaurants[indexPath.row].restaurantLogo)
        cell.restaurantNameLbl.text = restaurants[indexPath.row].restaurantName
        cell.restaurantAddressLbl.text = restaurants[indexPath.row].restaurantAddress
        
        return cell
    }
    
    //segueCustomerRestaurantsToMenu
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRestaurant = restaurants[indexPath.row]
        performSegue(withIdentifier: "segueCustomerRestaurantsToMenu", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueCustomerRestaurantsToMenu")
        {
            let restaurantMenuViewController = segue.destination as! CustomerRestaurantItemsViewController
            restaurantMenuViewController.selectedRestaurant = selectedRestaurant
        }
    }
    
    func initializeRestaurants(){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/allRestaurants")!
        
        AF.request(searchUrl).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                let restaurantsList = try! JSONDecoder().decode([RestaurantUser].self, from: response.data!)
                
                DispatchQueue.main.async{
                    self.restaurants.removeAll()
                    self.restaurants.append(contentsOf: restaurantsList)
                    self.restaurantsCollectionView.reloadData()
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
