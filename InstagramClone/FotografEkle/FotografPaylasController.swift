//
//  FotografPaylasController.swift
//  InstagramClone
//
//  Created by Erkan on 23.03.2023.
//

import UIKit
import JGProgressHUD
import Firebase
import FirebaseFirestore

class FotografPaylasController: UIViewController{
    
    var secilenFotograf: UIImage?{
        didSet{
            self.imgPaylasim.image = secilenFotograf
        }
    }
    
    let txtMesaj: UITextView = {
       let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 15)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    
    let imgPaylasim: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .blue
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
   
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.rgbConvert(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Paylaş", style: .plain, target: self, action: #selector(btnPaylasPressed))
        fotografMesajAlanlariniOlustur()
        
    }
    
    fileprivate func fotografMesajAlanlariniOlustur(){
        let paylasimView = UIView()
        paylasimView.translatesAutoresizingMaskIntoConstraints = false
        paylasimView.backgroundColor = .white
        view.addSubview(paylasimView)
        paylasimView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 120)
        view.addSubview(imgPaylasim)
        imgPaylasim.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: paylasimView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 85, height: 0)
        view.addSubview(txtMesaj)
        txtMesaj.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: imgPaylasim.trailingAnchor, trailing: paylasimView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc fileprivate func btnPaylasPressed(){
        
        //SÜREKLİ PAYLAŞILMASINI ENGELLİYOR
        navigationItem.rightBarButtonItem?.isEnabled = false
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Paylaşım Yükleniyor"
        hud.show(in: self.view)
        
        let fotografAdi = UUID().uuidString
        guard let paylasimFotograf = secilenFotograf else{return}
        let fotografData = paylasimFotograf.jpegData(compressionQuality: 0.8) ?? Data()
        
        let ref = Storage.storage().reference(withPath: "/Paylasimlar/\(fotografAdi)")
        ref.putData(fotografData, metadata: nil) { _, error in
            if let error = error{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Fotoğraf kaydedilemedi \(error)")
                hud.textLabel.text = "Fotoğraf yüklenemedi"
                hud.dismiss(afterDelay: 1, animated: true)
                return
            }
            print("Paylaşım fotoğrafı başarıyla upload edildi")
            ref.downloadURL { url, error in
                hud.textLabel.text = "Paylaşım yüklendi..."
                hud.dismiss(afterDelay: 2)
                if let error = error{
                    print("Url alınamadı \(error)")
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
                print("Upload edilen Fotoğrafın url adresi \(url?.absoluteString)")
                
                if let url = url{
                    self.paylasimKaydet(goruntuUrl: url.absoluteString)
                }
            }
        }
    }
    
    static let guncelleNotification = Notification.Name("PaylasimlariGuncelle")
    
    fileprivate func paylasimKaydet(goruntuUrl: String){
        guard let paylasimFotograf = secilenFotograf else{return}
        guard let paylasimMesaj = txtMesaj.text, paylasimMesaj.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {return}
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else{return}
        
        let eklenecekData = ["KullaniciID": gecerliKullaniciID,
                             "PaylasimlGoruntuUrl": goruntuUrl,
                             "Mesaj": paylasimMesaj,
                             "GoruntuGenislik": paylasimFotograf.size.width,
                             "GoruntuYukseklik": paylasimFotograf.size.height,
                             "PaylasimTarihi": Timestamp(date: Date())
        ] as [String : Any]
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID).collection("Fotograf_Paylasimlari")
            .addDocument(data: eklenecekData, completion: { error in
            if let error = error{
                print("Paylaşım Kaydedilirken hata meydana geldi \(error)")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            print("Paylaşım başarılya kaydedildi ve paylaşım döküman ID: \(ref?.documentID)")
            self.dismiss(animated: true)
            //    let guncelleNotification = Notification.Name("PaylasimlariGuncelle")
                NotificationCenter.default.post(name: FotografPaylasController.guncelleNotification, object: nil)  //Fotoğraf paylas controllerda tetikleyip refresh controllerı ana controllerda çalıştırdık
        })
    }
    
}
