//
//  KullaniciProfilController.swift
//  InstagramClone
//
//  Created by Erkan on 6.03.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class KullaniciProfilController: UICollectionViewController{
    
    let paylasimHucreID = "paylasimHucreID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = " Kullanıcı Profili"
        
        
        kullaniciyiGetir()
        collectionView.register(KullaniciProfilHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: paylasimHucreID)
        btnOturumKapatOlustur()
    }
    
    fileprivate func btnOturumKapatOlustur(){                                                                   //buttonları her zaman orijinal rengini alması
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "Ayarlar").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(oturumKapat))
    }
    
    @objc fileprivate func oturumKapat(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel)
        let oturumuKapatAction = UIAlertAction(title: "Oturumu kapat", style: .destructive) { _ in
            print("Oturum kapatılacak kodları buraya yaz")
            guard let _ = Auth.auth().currentUser?.uid else{return}
            do{
                try Auth.auth().signOut()
            }catch let oturumuKapatmaError{
                print("Oturum kapatılırken hata meydana geldi: ", oturumuKapatmaError)
            }
        }
        alertController.addAction(oturumuKapatAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //sectionlar arası boşluk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    //hücreler arası boşluk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 5)/3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let paylasimCell = collectionView.dequeueReusableCell(withReuseIdentifier: "paylasimHucreID", for: indexPath)
        paylasimCell.backgroundColor = .blue
        return paylasimCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! KullaniciProfilHeader
        header.gecerliKullanici = gecerliKullanici
       // header.backgroundColor = .green
        return header
    }
    
    var gecerliKullanici: Kullanici?
    
    
    fileprivate func kullaniciyiGetir(){
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Kullanicilar").document(gecerliKullaniciID).getDocument { snapshot, error in
            if let error = error{
                print("Kullanici bilgileri getirilemedi \(error.localizedDescription)")
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else {return}
           // let kullaniciAdi = kullaniciVerisi["KullaniciAdi"] as? String
            self.gecerliKullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            //HEADER ALANI YENİLENECEK
            self.collectionView.reloadData()
            self.navigationItem.title = self.gecerliKullanici?.kullaniciAdi
//            print("Kullanıcı ID: \(gecerliKullaniciID)")
//            print("Kullanıcı Adı: ", self. ?? "")
//            print(kullaniciVerisi)
        }
    }

    
}


extension KullaniciProfilController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
