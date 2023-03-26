//
//  KullaniciAraCell.swift
//  InstagramClone
//
//  Created by Erkan on 25.03.2023.
//

import UIKit
import SDWebImage

class KullaniciAraCell: UICollectionViewCell{
    
    var kullanici : Kullanici?{
        didSet{
            labelKullanici.text = kullanici?.kullaniciAdi
            guard let url = kullanici?.profilGoruntuUrl, let profilFotoUrl = URL(string: url) else{return}
            
            imageKullaniciProfil.sd_setImage(with: profilFotoUrl)
        }
    }
    
    let labelKullanici: UILabel = {
       let label = UILabel()
        label.text = "Kullanici Adi"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageKullaniciProfil: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .yellow
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imageKullaniciProfil)
        addSubview(labelKullanici)
        
        imageKullaniciProfil.layer.cornerRadius = 55 / 2
        imageKullaniciProfil.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 55, height: 55)
        imageKullaniciProfil.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true // y ekseninde ortaladık
        
        labelKullanici.anchor(top: topAnchor, bottom: bottomAnchor, leading: imageKullaniciProfil.trailingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        
        let ayracView = UIView()
        ayracView.backgroundColor = UIColor(white: 0, alpha: 0.45)
        addSubview(ayracView)
        ayracView.translatesAutoresizingMaskIntoConstraints = false
        ayracView.anchor(top: nil, bottom: bottomAnchor, leading: labelKullanici.leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.45)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
