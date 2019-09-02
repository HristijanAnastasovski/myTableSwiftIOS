//
//  RestaurantMainMenuViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/26/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantMainMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
    @IBOutlet weak var mainMenuCollectionView: UICollectionView!
    
    var menu = [MenuItem]()
    
    var selectedMenuItem: MenuItem!
    
    @IBOutlet weak var emptyMenu: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        mainMenuCollectionView.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        self.mainMenuCollectionView.delegate = self
        self.mainMenuCollectionView.dataSource = self
        
        //initializeMenu()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        menu.removeAll()
        emptyMenu.isHidden = false
        initializeMenu()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainMenuCollectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! RestaurantMenuCollectionViewCell
        
        cell.imageView.downloaded(from: menu[indexPath.row].menuImage)
        cell.foodTitleLbl.text = menu[indexPath.row].itemName + " (" + String(menu[indexPath.row].price) + "$)"
        cell.IngredientsLbl.text = menu[indexPath.row].itemShortDescription
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMenuItem = menu[indexPath.row]
        performSegue(withIdentifier: "segueRestaurantMainMenuToDetails", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueRestaurantMainMenuToDetails"){
            let restaurantItemDetailsViewController = segue.destination as! RestaurantItemDetailsViewController
            restaurantItemDetailsViewController.itemId = selectedMenuItem.id
            restaurantItemDetailsViewController.itemName = selectedMenuItem.itemName
            restaurantItemDetailsViewController.imageURL = selectedMenuItem.menuImage
            restaurantItemDetailsViewController.itemDescription = selectedMenuItem.itemShortDescription
            restaurantItemDetailsViewController.itemPrice = selectedMenuItem.price
            restaurantItemDetailsViewController.itemQuantity = selectedMenuItem.quantity
        }
    }
    
    func initializeMenu(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "restaurantUser")
        if(decoded != nil){
        do{
            let decodedRestaurantUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! RestaurantUser
            loadMenu(id: decodedRestaurantUser.id)
            
        }catch let error {
            print(error)
        }
        } else {
            Toast.showToast(message: "Error with loading the user data", viewController: self)
        }
    }
    
    func loadMenu(id: Int){
        let searchUrl = URL(string: "http://ec2-18-194-249-203.eu-central-1.compute.amazonaws.com:8080/restaurant/menu/"+String(id))!
        
        AF.request(searchUrl).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            if(response.response!.statusCode == 200){
                let menuItems = try! JSONDecoder().decode([MenuItem].self, from: response.data!)
                
                DispatchQueue.main.async{
                    self.menu.append(contentsOf: menuItems)
                    if(self.menu.count > 0){
                        self.emptyMenu.isHidden = true
                    }
                     self.mainMenuCollectionView.reloadData()
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
