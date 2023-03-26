//
//  KullaniciAraController.swift
//  InstagramClone
//
//  Created by Erkan on 24.03.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class KullaniciAraController: UICollectionViewController, UISearchBarDelegate{
    
    lazy var searchBar: UISearchBar = {
     let bar = UISearchBar()
        bar.placeholder = "Kullanıcı adını giriniz..."
        bar.searchTextField.autocapitalizationType = .none
        bar.searchTextField.autocorrectionType = .no
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgbConvert(red: 230, green: 230, blue: 230) //search bar arka plan
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.delegate = self
        return bar
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filtrelenmisKullanicilar = kullanicilar
        }else{

            self.filtrelenmisKullanicilar = self.kullanicilar.filter({ kullanici in
                return kullanici.kullaniciAdi.lowercased().contains(searchText.lowercased()) // searchTexteki değer kullanicinin adını içeriyorsa verileri getir
            })
        }
        self.collectionView.reloadData()
    }
    
    let hucreIDs = "hucreIDs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.backgroundColor = .white
        
        
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: -10, width: 0, height: 0)
        
        collectionView.register(KullaniciAraCell.self, forCellWithReuseIdentifier: hucreIDs)
        
        collectionView.alwaysBounceVertical = true // dikey olarak sürüklenebilir olmasını sağlıyor
        collectionView.keyboardDismissMode = .onDrag // sürüklemede klavye ortaddan kalkıyor
        
        kullanicilariGetir()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    var filtrelenmisKullanicilar = [Kullanici]()
    var kullanicilar = [Kullanici]()
    
    fileprivate func kullanicilariGetir(){
        Firestore.firestore().collection("Kullanicilar").getDocuments { (querySnapshot, error) in
            if let error = error{
                print("Kullanıcılar getiirlirken hata meydana geldi \(error)")
            }
            querySnapshot?.documentChanges.forEach({ degisiklik in
                if degisiklik.type == .added{
                    let kullanici = Kullanici(kullaniciVerisi: degisiklik.document.data()) // her bir kullanicinin kullanıcı adını alıyoruz
                    if kullanici.kullaniciID != Auth.auth().currentUser?.uid{
                        self.kullanicilar.append(kullanici) // kullanıcıya kendisini göstermiyoruz
                    }
                    
                }
                    
                
            })
            self.kullanicilar.sort { k1, k2 -> Bool in
                return k1.kullaniciAdi.compare(k2.kullaniciAdi) == .orderedAscending // ALFABETİK OLARAK GETİR
            }
            self.filtrelenmisKullanicilar = self.kullanicilar
            self.collectionView.reloadData()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtrelenmisKullanicilar.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hucreIDs, for: indexPath) as! KullaniciAraCell
        cell.kullanici = filtrelenmisKullanicilar[indexPath.row]
        print("aaaa")
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let kullanici = filtrelenmisKullanicilar[indexPath.row]
        let kullaniciProfilController = KullaniciProfilController(collectionViewLayout: UICollectionViewFlowLayout())
        kullaniciProfilController.navigationController?.navigationBar.isHidden = true
        searchBar.isHidden = true
        searchBar.resignFirstResponder() // diğer yere giderken klavyeyi kapatıyor
        kullaniciProfilController.kullaniciID = kullanici.kullaniciID
        navigationController?.pushViewController(kullaniciProfilController, animated: true)
    }
    
    
}

extension KullaniciAraController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
}
