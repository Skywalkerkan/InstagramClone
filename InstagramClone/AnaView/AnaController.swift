//
//  AnaController.swift
//  InstagramClone
//
//  Created by Erkan on 23.03.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class AnaController: UICollectionViewController{
    
    let hucreID = "hucreID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(AnaPaylasimCell.self, forCellWithReuseIdentifier: hucreID)
        butonlariOlustur()
        kullaniciyiGetir() // kullaniciyi getirin içinde paylaşımlari getir var
        //kullaniciyiGetir(kullaniciID: "GI8WlsVTQZcMykphHa0ZyaIAtjj1") // başka bir kullanıcının
       /* Firestore.kullaniciOlustur(kullaniciID: "GI8WlsVTQZcMykphHa0ZyaIAtjj1"){ kullanici in
            self.paylasimlariGetir(kullanici: kullanici)
        }*/
        takipEdilenKIDDegerleriGetir()
    }
    
    
    fileprivate func takipEdilenKIDDegerleriGetir(){
        guard let kID = Auth.auth().currentUser?.uid else{return}
        
        Firestore.firestore().collection("TakipEdiyor").document(kID).addSnapshotListener { documentSnapshot, error in
            if let error = error{
                print("paylaşımlar getirlirkenHata meydana geldi", error.localizedDescription)
                return
            }
            guard let paylasimSozlukVerisi = documentSnapshot?.data() else{return}
            paylasimSozlukVerisi.forEach { key, value in
                Firestore.kullaniciOlustur(kullaniciID: key) { kullanici in
                    self.paylasimlariGetir(kullanici: kullanici)   // her bir kullanıcıya ait takip ettiği IDleri alıp
                }                                                  // O ID lere göre paylaşımları getiriyoruz
            }
        }
    }
    
    var paylasimlar = [Paylasim]()
    
    fileprivate func paylasimlariGetir(kullanici: Kullanici){
       // paylasimlar.removeAll()  birden fazla kullanıcıdan geleceği için sıkıntı olacaktır
       // guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else{return}
       // guard let gecerliKullanici = gecerliKullanici else {return}
        Firestore.firestore().collection("Paylasimlar").document(kullanici.kullaniciID)
            .collection("Fotograf_Paylasimlari").order(by: "PaylasimTarihi", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error{
                    print("Paylaşımlar getirilirken ahta oluştu", error.localizedDescription)
                }
                querySnapshot?.documentChanges.forEach({ degisiklik in
                    if degisiklik.type == .added{
                        let paylasimVerisi = degisiklik.document.data()
                        let paylasim = Paylasim(kullanici: kullanici, sozlukVerisi: paylasimVerisi)
                        self.paylasimlar.append(paylasim)
                    }
                })
                self.paylasimlar.reverse()
                self.paylasimlar.sort { p1, p2 -> Bool in
                    return p1.paylasimTarihi.dateValue().compare(p2.paylasimTarihi.dateValue()) == .orderedDescending
                }
                self.collectionView.reloadData()
            }
    }
    
    fileprivate func butonlariOlustur(){
        navigationItem.titleView = UIImageView(image: UIImage(imageLiteralResourceName: "Logo_Instagram2")) // navigationitemdaki resimi ayarladık
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paylasimlar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! AnaPaylasimCell
        cell.paylasim = paylasimlar[indexPath.row]
       // cell.backgroundColor = .blue
        return cell
    }
    
    var gecerliKullanici: Kullanici?
    
    fileprivate func kullaniciyiGetir(kullaniciID: String = ""){
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else{return}
        let kID = kullaniciID == "" ? gecerliKullaniciID : kullaniciID  // kullaniciID  boş bir değere eşitse gecerliKID kıde aktarılacak
        Firestore.firestore().collection("Kullanicilar").document(kID).getDocument { snapshot, error in
            if let error = error{
                print("kullanici bilgileri getirilemedi \(error)")
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else {return}
            self.gecerliKullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            guard let kullanici = self.gecerliKullanici else{return}
            self.paylasimlariGetir(kullanici: kullanici)
        }
    }
    
}



extension AnaController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var yukseklik : CGFloat = 55
        yukseklik += view.frame.width // ingpaylasim foto yüksekliği için ekledik
        yukseklik += 50
        yukseklik += 70 // mesaj alanı 
        return CGSize(width: view.frame.width, height: yukseklik)
    }
}
