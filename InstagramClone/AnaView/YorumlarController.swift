//
//  YorumlarController.swift
//  InstagramClone
//
//  Created by Erkan on 27.03.2023.
//

import UIKit
import Firebase

class YorumlarController: UICollectionViewController{
    
    var secilenPaylasim: Paylasim?
    let yorumCellID = "yorumCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarController?.tabBar.isHidden = true
       // collectionView.backgroundColor = .cyan
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        navigationItem.title = "Yorumlar"
        collectionView.register(YorumCell.self, forCellWithReuseIdentifier: yorumCellID)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)
        
        yorumlariGetir()
    }
    
    var yorumlar = [Yorum]()
    
    fileprivate func yorumlariGetir(){
        guard let paylasimID = self.secilenPaylasim?.id else{return}
        
        Firestore.firestore().collection("Yorumlar").document(paylasimID).collection("Eklenen_Yorumlar").addSnapshotListener { snapshot, error in
            if let error = error{
                print("Yorumlar getirilirken hata meydana geldi: ", error.localizedDescription)
                return
            }
            snapshot?.documentChanges.forEach({ documentChange in
                let sozlukVerisi = documentChange.document.data()
                guard let kullaniciID = sozlukVerisi["kullaniciID"] as? String else{return}
                Firestore.kullaniciOlustur(kullaniciID: kullaniciID) { kullanici in
                    var yorum = Yorum(kullanici: kullanici, sozlukVerisi: sozlukVerisi)
                  //  yorum.kullanici = kullanici
                    self.yorumlar.append(yorum)
                    self.collectionView.reloadData()
                }
                

            })
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yorumlar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: yorumCellID, for: indexPath) as! YorumCell
        cell.yorum = yorumlar[indexPath.row]
       // cell.textLabel?.text = yorumlar[indexPath.row]
        return cell
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
      //  containerView.backgroundColor = .cyan
        containerView.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let btnYorumGonder = UIButton(type: .system)
        btnYorumGonder.setTitle("Gonder", for: .normal)
        btnYorumGonder.setTitleColor(.black, for: .normal)
        btnYorumGonder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btnYorumGonder.translatesAutoresizingMaskIntoConstraints = false
        btnYorumGonder.addTarget(self, action: #selector(btnYorumGonderPressed), for: .touchUpInside)
        containerView.addSubview(btnYorumGonder)
        btnYorumGonder.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: containerView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 80, height: 0)

        //txtYorum.textAlignment = .center
        
        txtYorum.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(txtYorum)
        txtYorum.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: containerView.safeAreaLayoutGuide.leadingAnchor, trailing: btnYorumGonder.safeAreaLayoutGuide.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        let ayracView = UIView()
        ayracView.backgroundColor = UIColor.rgbConvert(red: 230, green: 230, blue: 230)
        ayracView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ayracView)
        ayracView.anchor(top: containerView.topAnchor, bottom: nil, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.7)
        
        return containerView
    }()
    
    let txtYorum: UITextField = {
        let text = UITextField()
        text.placeholder = "Yorumunuzu girin"
        return text
    }()
    
    @objc fileprivate func btnYorumGonderPressed(){
        if let yorum = txtYorum.text, yorum.isEmpty{
            return // eğer boşsa returnle direk
        }
        print("Paylaşım ıd:", secilenPaylasim?.id)
        print("Yorumlar gönderilecek")
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else{return}
        let paylasimID = self.secilenPaylasim?.id ?? ""  // paylaşımların idsi
        let eklenecekDeger = ["yorumMesaji": txtYorum.text ?? "",
                              "eklenmeTarihi": Date().timeIntervalSince1970,
                              "kullaniciID": gecerliKullaniciID] as [String: Any]
        Firestore.firestore().collection("Yorumlar").document(paylasimID).collection("Eklenen_Yorumlar").document().setData(eklenecekDeger) { error in
            if let error = error{
                print("Yorum eklenirken hata meydana geldi: ", error.localizedDescription)
                return
            }
            print("Yorum başarıyla eklendi")
            self.txtYorum.text = ""
        }
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    

    
}


extension YorumlarController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let geciciCell = YorumCell(frame: frame)  //içeriğe göre büyümesi
        geciciCell.yorum = yorumlar[indexPath.row]
        geciciCell.layoutIfNeeded() // eğer ihtiyaç varsa çalıştır
        
        let hedefBoyut = CGSize(width: view.frame.width, height: 9999)
        let tahminiBoyut = geciciCell.systemLayoutSizeFitting(hedefBoyut) // geçici cell içerisindeki içeriğe göre boyutu ayarlıyor
        
        let yukseklik = max(60, tahminiBoyut.height)
        
        return CGSize(width: view.frame.width, height: yukseklik)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
