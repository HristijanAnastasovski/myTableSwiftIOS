//
//  RestaurantEditViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 8/26/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit

class RestaurantEditViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var restaurantNameLbl: UILabel!
    
    @IBOutlet weak var restaurantAddressLbl: UILabel!
    
    @IBOutlet weak var billingAccountLbl: UILabel!
    
    @IBOutlet weak var editInfoBtn: CustomButton!
    
    @IBOutlet weak var changePasswordBtn: CustomButton!
    
    var restaurantUser:RestaurantUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.3, alpha: 1)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        getInitialUserData()
        if(restaurantUser != nil){
            imageView.downloaded(from: restaurantUser.restaurantLogo)
            initializeLabels()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueRestaurantToPassword"){
            let passwordViewController = segue.destination as! RestaurantPasswordChangeViewController
            passwordViewController.restaurantUser = restaurantUser
        }
        if(segue.identifier == "segueRestaurantEditToLogo"){
            let logoViewController = segue.destination as! RestaurantEditLogoViewController
            logoViewController.restaurantUser = restaurantUser
            
        }
        if(segue.identifier == "segueRestaurantToEditInfo"){
            let infoViewController = segue.destination as! RestaurantEditInfoViewController
            infoViewController.restaurantUser = restaurantUser
            
        }
    }
    
    @IBAction func onEditInfoBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "segueRestaurantToEditInfo", sender: self)
    }
    
    
    @IBAction func onChangePasswordBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "segueRestaurantToPassword", sender: self)
    }
    
    @IBAction func onLogoClick(_ sender: Any) {
        performSegue(withIdentifier: "segueRestaurantEditToLogo", sender: self)
    }
    
    func getInitialUserData(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "restaurantUser")
        if(decoded != nil){
            do{
                let decodedRestaurantUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as! RestaurantUser
                restaurantUser = decodedRestaurantUser
                
            }catch let error {
                print(error)
            }
        } else {
            Toast.showToast(message: "Error with loading the user data", viewController: self)
        }
    }
    
    func initializeLabels(){
        restaurantNameLbl.textColor = .white
        restaurantNameLbl.text = "Restaurant: " + restaurantUser.restaurantName
        
        restaurantAddressLbl.textColor = .white
        restaurantAddressLbl.text = "Address: " + restaurantUser.restaurantAddress
        
        billingAccountLbl.textColor = .white
        billingAccountLbl.text = "Billing Number: " + String(restaurantUser.billingAccountNumber)
    }
    
    @IBAction func onSignOutClick(_ sender: Any){
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "restaurantUser")
        userDefaults.synchronize()
        performSegue(withIdentifier: "segueRestaurantSignOut", sender: self)
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
