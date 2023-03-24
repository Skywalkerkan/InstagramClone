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
        self.delegate = self
        
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

        
        gorunumuOlustur()
        
    }
    
    func gorunumuOlustur(){
        
        let anaNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(imageLiteralResourceName: "Ana_Ekran_Secili_Degil"),
                                                    seciliIkon: UIImage(imageLiteralResourceName: "Ana_Ekran_Secili"),
                                                    rootViewController: AnaController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let araNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(imageLiteralResourceName: "Ara_Secili_Degil"),
                                                    seciliIkon: UIImage(imageLiteralResourceName: "Ara_Secili"), rootViewController: KullaniciAraController(collectionViewLayout: UICollectionViewLayout()))
        
        let ekleNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(imageLiteralResourceName: "Ekle_Secili_Degil"),
                                                     seciliIkon: UIImage(imageLiteralResourceName: "Ekle_Secili_Degil"))
        
        let begeniNavController = navControllerOlustur(seciliOlmayanIkon: UIImage(imageLiteralResourceName: "Begeni_Secili_Degil"),
                                                       seciliIkon: UIImage(imageLiteralResourceName: "Begeni_Secili"))
       /* let anaController = UIViewController()
        let anaNavController = UINavigationController(rootViewController: anaController)
        anaNavController.tabBarItem.image = UIImage(imageLiteralResourceName: "Ana_Ekran_Secili_Degil")
        anaNavController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "Ana_Ekran_Secili")*/
        
       /* let araController = UIViewController()
        let araNavController = UINavigationController(rootViewController: araController)
        araNavController.tabBarItem.image = UIImage(imageLiteralResourceName: "Ara_Secili_Degil")
        araNavController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "Ara_Secili")*/
        
        let layout = UICollectionViewFlowLayout()
        let kullaniciProfilController = KullaniciProfilController(collectionViewLayout: layout)
        let kullaniciProfilNavVC = UINavigationController(rootViewController: kullaniciProfilController)
        kullaniciProfilNavVC.tabBarItem.image = UIImage(imageLiteralResourceName: "Profil")
        kullaniciProfilNavVC.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "Profil_Secili")
        tabBar.tintColor = .black
        viewControllers = [anaNavController,araNavController, ekleNavController,begeniNavController, kullaniciProfilNavVC]
        
        guard let items =  tabBar.items else{return}
        
        //tab bardaki itemların merkezileştirilmesi
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
        
    }
    
    fileprivate func navControllerOlustur(seciliOlmayanIkon: UIImage, seciliIkon: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        let rootController = rootViewController
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = seciliOlmayanIkon
        navController.tabBarItem.selectedImage = seciliIkon
        return navController
    }
    
}


extension AnaTabBarController: UITabBarControllerDelegate{
    
    //
    
    //Hangi tab barın seçildiğinin delegateı
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //hangi tab barın basıldığını algılıyoruz
        guard let index = viewControllers?.firstIndex(of: viewController) else{return true}
        print("\(index). Butona bastın")
        
        if index == 2{
            let layout = UICollectionViewFlowLayout()
            let fotografSeciciController = FotografSeciciController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: fotografSeciciController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
            return false
        }
        return true
    }
}
