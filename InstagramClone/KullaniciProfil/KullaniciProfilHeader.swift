//
//  KullaniciProfilHeader.swift
//  InstagramClone
//
//  Created by Erkan on 6.03.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class KullaniciProfilHeader: UICollectionViewCell{
    
    
    var gecerliKullanici: Kullanici?{
        didSet{
           // print("Header alanındaki geçerli kullanıcı nesnesine bir değer atandı: ", gecerliKullanici?.kullaniciAdi ?? "")
            guard let url = URL(string: gecerliKullanici?.profilGoruntuUrl ?? "") else{return}
            imgProfil.sd_setImage(with: url, completed: nil)
            lblKullaniciAdi.text = gecerliKullanici?.kullaniciAdi
            
        }
    }
    
    let btnDuzenle: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Profil Düzenle", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        return button
    }()
    
    let lblPaylasim: UILabel = {
       let label = UILabel()
        let attrText = NSMutableAttributedString(string: "10\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attrText.append(NSAttributedString(string: "Paylaşım", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.darkGray]))
        //BİR LABELIN FARKLI YAZILARINI DEĞİŞTİRMEK İÇİN NSMUTABLEATTRİBUTEDSTRİNG KULLANILIYOR
        
        label.attributedText = attrText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let lblTakipçi: UILabel = {
       let label = UILabel()
      //  label.text = "25\nTakipçi"
        let attrText = NSMutableAttributedString(string: "30\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attrText.append(NSAttributedString(string: "Takipçi", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.darkGray]))
        //BİR LABELIN FARKLI YAZILARINI DEĞİŞTİRMEK İÇİN NSMUTABLEATTRİBUTEDSTRİNG KULLANILIYOR
        
        label.attributedText = attrText
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()
    
    let lblTakipEdiyor: UILabel = {
       let label = UILabel()
        //label.text = "20\nTakip"
        let attrText = NSMutableAttributedString(string: "23\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attrText.append(NSAttributedString(string: "Takip Ediyor", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.darkGray]))
        //BİR LABELIN FARKLI YAZILARINI DEĞİŞTİRMEK İÇİN NSMUTABLEATTRİBUTEDSTRİNG KULLANILIYOR
        
        label.attributedText = attrText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    let lblKullaniciAdi: UILabel = {
       let label = UILabel()
        label.text = "Kullanıcı Adı"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        //label.textAlignment = .center
        return label
    }()
    
    let btnGrid: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "Izgara"), for: .normal)
        
        return button
        
    }()
    
    let butonListe: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "Liste"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let buttonYerIsareti: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "Yer_Isareti"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()

    
    let imgProfil: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .yellow
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  backgroundColor = .red
        addSubview(imgProfil)
        let goruntuBoyut: CGFloat = 90
        imgProfil.anchor(top: topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: goruntuBoyut, height: goruntuBoyut)
        imgProfil.layer.cornerRadius = goruntuBoyut / 2
        imgProfil.clipsToBounds = true
        
        
        toolBarOlustur()
        
        addSubview(lblKullaniciAdi)
        lblKullaniciAdi.translatesAutoresizingMaskIntoConstraints = false
        lblKullaniciAdi.anchor(top: imgProfil.bottomAnchor, bottom: btnGrid.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
        
        kullaniciDurumBilgisiGoster()
        addSubview(btnDuzenle)
        btnDuzenle.anchor(top: lblPaylasim.bottomAnchor, bottom: nil, leading: lblPaylasim.leadingAnchor, trailing: lblTakipEdiyor.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 35)
        
        //profilFotoYukle()
    }
    
    fileprivate func kullaniciDurumBilgisiGoster(){
        let stackView = UIStackView(arrangedSubviews: [lblPaylasim,lblTakipçi,lblTakipEdiyor])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor(top: topAnchor, bottom: nil, leading: imgProfil.trailingAnchor, trailing: trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 0, height: 50)
    }

    
    
    fileprivate func toolBarOlustur(){
        
        let ustAyracView = UIView()
        ustAyracView.backgroundColor = UIColor.lightGray
        ustAyracView.translatesAutoresizingMaskIntoConstraints = false
        let altAyracView = UIView()
        altAyracView.backgroundColor = UIColor.lightGray
        altAyracView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [btnGrid,butonListe,buttonYerIsareti])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addSubview(ustAyracView)
        addSubview(altAyracView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        ustAyracView.anchor(top: stackView.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        altAyracView.anchor(top: stackView.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    fileprivate func  profilFotoYukle(){
//        guard let kullaniciID = Auth.auth().currentUser?.uid else{return}
//        Firestore.firestore().collection("Kullanicilar").document(kullaniciID).getDocument { snapshot, error in
//            if let error = error{
//                print("Kullanici verisi getirilirken hata oluştu", error)
//                return
//            }
//
//            guard let kullaniciVerisi = snapshot?.data() else{return}
//
//            guard let profilGoruntuUrl = kullaniciVerisi["ProfilGoruntuURL"] as? String else{return}
//
//            guard let url = URL(string: profilGoruntuUrl) else {return}
//
//            self.imgProfil.sd_setImage(with: url, completed: nil)
//
//           /* URLSession.shared.dataTask(with: url) { data, response, error in
//                if let error = error{
//                    print("İndirilemedi", error)
//                    return
//                }
//                print(data)
//                guard let data = data else {return}
//                let image = UIImage(data: data)
//
//
//                DispatchQueue.main.async {
//                    self.imgProfil.image = image
//                }
//
//            }.resume()*/
//        }
//    }
    
}
