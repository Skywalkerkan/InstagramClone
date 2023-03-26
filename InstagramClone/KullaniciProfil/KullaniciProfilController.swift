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
    
    var kullaniciID: String?
    
    let paylasimHucreID = "paylasimHucreID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = " Kullanıcı Profili"
        
        
        kullaniciyiGetir()
        collectionView.register(KullaniciProfilHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(KullaniciPaylasimFotoCell.self, forCellWithReuseIdentifier: paylasimHucreID)
        btnOturumKapatOlustur()
       // paylasimlariGetirFS()
    }
    var paylasimlar = [Paylasim]()
    fileprivate func paylasimlariGetirFS(){
       
        //guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else{return}                                                              //eski olanlar önde yeni olanlar arkada gelecek
        guard let gecerliKullanici = gecerliKullanici else{return}
        guard let gecerliKullaniciID = self.gecerliKullanici?.kullaniciID else{return}
        Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID).collection("Fotograf_Paylasimlari").order(by: "PaylasimTarihi", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error{
                    print("Paylaşımlar getirilirken hata meydana geldi: \(error)")
                    return
                }
                            //Suan dökümanın icindeki değişiklik
                querySnapshot?.documentChanges.forEach({ degisiklik in
                    if degisiklik.type == .added{ // yeni eklenmiş mi
                        let paylasimVerisi = degisiklik.document.data() // Döküman verisine eriştikl
                        let paylasim = Paylasim(kullanici: gecerliKullanici, sozlukVerisi: paylasimVerisi)
                        self.paylasimlar.append(paylasim)
                        //print("Fotoğraf: \(paylasim.paylasimGoruntuUrl ?? "Veri Yok")")
                        //let paylasimGoruntuURL = paylasimVerisi["PaylasimlGoruntuUrl"] as? String
                       // print(paylasimGoruntuURL)
                    }
                })
                //Tüm paylaşımlar paylasimlar dizisine aktarıldı
                self.paylasimlar.reverse() // teker teker paylasimlari ters cevirerek yeni paylaşım ekledigimizdeki sorunu çözüyor
                self.collectionView.reloadData()
            }
        
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
                //Oturum kaapatılıyor
                try Auth.auth().signOut()
                let oturumAcController = OturumAcContorller()
                let navController = UINavigationController(rootViewController: oturumAcController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
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
        return paylasimlar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let paylasimCell = collectionView.dequeueReusableCell(withReuseIdentifier: "paylasimHucreID", for: indexPath) as! KullaniciPaylasimFotoCell
        //paylasimCell.backgroundColor = .blue
        paylasimCell.paylasim = paylasimlar[indexPath.row] // Her bir paylaşımı atadık
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
       // guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else {return}
        let gecerliKullaniciID = kullaniciID ?? Auth.auth().currentUser?.uid ?? ""  // eğer gönderdiğimiz bir kullanıcı ıd değeri varsa onu yoksa oturumu acan kullanıcı ıd kullanılacak
                                                                                                                //profil arama yeri için
        
        Firestore.firestore().collection("Kullanicilar").document(gecerliKullaniciID).getDocument { snapshot, error in
            if let error = error{
                print("Kullanici bilgileri getirilemedi \(error.localizedDescription)")
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else {return}
           // let kullaniciAdi = kullaniciVerisi["KullaniciAdi"] as? String
            self.gecerliKullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            //HEADER ALANI YENİLENECEK
            //self.collectionView.reloadData()
            self.paylasimlariGetirFS() //38 472 2 kere çağırıldığı için viewdidload yerine burada çağırıldı
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
