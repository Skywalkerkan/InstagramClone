//
//  AnaTabBarController.swift
//  InstagramClone
//
//  Created by Erkan on 6.03.2023.
//

import Foundation
import UIKit
import Firebase
class AnaTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .green
        
        
        if Auth.auth().currentUser == nil{
            //oturumu açan herhangi bir kullanıcı yok
            print("oturumu açan herhangi bir kullanıcı yok")
            DispatchQueue.main.async { // MAİN THREADDE YAPILMASI GEREKİYOR YOKSA GÖRÜLMEZ MAİN THREADDE HER ŞEY SIRAYLA YAPILIR
                let oturumAcVC = OturumAcContorller()
               // oturumAcVC.modalPresentationStyle = .fullScreen
                let navController = UINavigationController(rootViewController: oturumAcVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }
        let layout = UICollectionViewFlowLayout()
        let kullaniciProfilController = KullaniciProfilController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: kullaniciProfilController)
        navController.tabBarItem.image = UIImage(imageLiteralResourceName: "Profil")
        navController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "Profil_Secili")
        tabBar.tintColor = .black
        viewControllers = [navController,UIViewController()]
        
        
        
    }
    
}
