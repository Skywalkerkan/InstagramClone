//
//  AnaPaylasimCell.swift
//  InstagramClone
//
//  Created by Erkan on 23.03.2023.
//

import UIKit

protocol AnaPaylasimCellDelegate{
    func yorumaBasildi(paylasim: Paylasim)  // hangi paylaşım yorumuna basıldı
}


class AnaPaylasimCell: UICollectionViewCell{
    
    var delegate: AnaPaylasimCellDelegate?
    var paylasim: Paylasim?{
        didSet{
            guard let url = paylasim?.paylasimGoruntuUrl, let goruntuUrl = URL(string: url) else{return}
            imgPaylasimFoto.sd_setImage(with: goruntuUrl, completed: nil)
            //lblKullaniciAdi.text = "Test kullanıcı adı"
            lblKullaniciAdi.text = paylasim?.kullanici.kullaniciAdi

            guard let pUrl = paylasim?.kullanici.profilGoruntuUrl, let profilGoruntuURl = URL(string: pUrl) else{return}
            imgKullaniciProfilFoto.sd_setImage(with: profilGoruntuURl, completed: nil)
            //lblPaylasimMesaj.text = paylasim?.mesaj  // böyle yaptığımızda yazılar beyaz fontta oluyor görünmüyor
            
            attrPaylasimMesajiOlustur()
        }
    }
    
    fileprivate func attrPaylasimMesajiOlustur(){
        guard let paylasim = self.paylasim else{return}
        
        let attrText = NSMutableAttributedString(string: paylasim.kullanici.kullaniciAdi, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSAttributedString(string: " \(paylasim.mesaj ?? "Veri Yok")", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        attrText.append(NSAttributedString(string: "\n\n", attributes: [.font: UIFont.systemFont(ofSize: 4)]))
        let paylasimZaman = paylasim.paylasimTarihi.dateValue()
        attrText.append(NSAttributedString(string: paylasimZaman.zamanOnceHesap(), attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.gray]))
        lblPaylasimMesaj.attributedText = attrText
    }
    
    let lblPaylasimMesaj: UILabel = {
       let label = UILabel()
        //label.text = "Paylaşım mesajı"
      //  label.backgroundColor = .green

 
       // label.attributedText = attrText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let btnBookMark: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(imageLiteralResourceName: "Yer_Isareti").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnBegen : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "Begeni_Secili_Degil").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var btnYorum: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "Yorum").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(btnYorumYapPressed), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func btnYorumYapPressed(){
        print("Yorumlar listelenecek")
        guard let paylasim = self.paylasim else{return}
        delegate?.yorumaBasildi(paylasim: paylasim)
    }
    
    let btnGonder: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "Gonder").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnSecenekler : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let lblKullaniciAdi : UILabel = {
       let label = UILabel()
        label.text = "Kullanıcı Adı"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgPaylasimFoto: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    let imgKullaniciProfilFoto: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemPink
        return image
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // backgroundColor = .gray
        addSubview(imgPaylasimFoto)
        addSubview(imgKullaniciProfilFoto)
        addSubview(lblKullaniciAdi)
        addSubview(btnSecenekler)
       // addSubview(btnBegen)
       // addSubview(btnYorum)
       // addSubview(btnGonder)
        
        imgKullaniciProfilFoto.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        imgKullaniciProfilFoto.layer.cornerRadius = 40 / 2
        lblKullaniciAdi.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: imgKullaniciProfilFoto.trailingAnchor, trailing: btnSecenekler.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        btnSecenekler.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 45, height: 0)
        imgPaylasimFoto.anchor(top: imgKullaniciProfilFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        _ = imgPaylasimFoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
      //  btnBegen.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 2, paddingRight: 0, width: 30, height: 0)
        
        etkilesimButonlariOlustur()
        
    }
    
    fileprivate func etkilesimButonlariOlustur(){
        let stackView = UIStackView(arrangedSubviews: [btnBegen,btnYorum,btnGonder])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 120, height: 50)
        
        addSubview(btnBookMark)
        
        btnBookMark.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 40, height: 50)
        
        addSubview(lblPaylasimMesaj)
        lblPaylasimMesaj.anchor(top: btnBegen.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
