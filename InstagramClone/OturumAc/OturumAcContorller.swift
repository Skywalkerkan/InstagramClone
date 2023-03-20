//
//  OturumAcContorller.swift
//  InstagramClone
//
//  Created by Erkan on 20.03.2023.
//

import Foundation
import UIKit

class OturumAcContorller: UIViewController{
    
    let txtEmail: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Email adresini giriniz..."
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        return txt
    }()
    
    let txtParola: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Parolanız"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        return txt
    }()
    
    let btnGirisYap: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap", for: .normal)
        button.backgroundColor = UIColor.rgbConvert(red: 150, green: 205, blue: 245)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    let logoView : UIView = {
        let view = UIView()
        let imgLogo = UIImageView(image: UIImage(imageLiteralResourceName: "Logo_Instagram"))
        //imgLogo.backgroundColor = .blue
        view.addSubview(imgLogo)
        imgLogo.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 50)
        imgLogo.contentMode = .scaleAspectFill
        imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imgLogo.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgbConvert(red: 0, green: 120, blue: 175)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnKayitOl: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Henüz bir hesabınız yok mu? Kayıt Olun", for: .normal)
        
        let attrText = NSMutableAttributedString(string: "Henüz bir hesabınız yok mu? ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray])
        
        attrText.append(NSAttributedString(string: "Kayıt Ol", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.systemBlue]))
        
        button.setAttributedTitle(attrText, for: .normal)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(btnkayitOlPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc fileprivate func btnkayitOlPressed(){
        print("Kayıt ol sayfasına gidildi")
        let kayitOlVC = KayitOlController()
        navigationController?.pushViewController(kayitOlVC, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent        //USTTEKİ SAAT ŞARJ GİBİ ŞEYLERİN CONTENTİ
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(btnKayitOl)
        view.addSubview(logoView)
        
        logoView.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
        btnKayitOl.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        girisGorunumuOlustur()
    }
    
    fileprivate func girisGorunumuOlustur(){
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtParola,btnGirisYap])
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 30, paddingBottom: 0, paddingLeft: 30, paddingRight: -30, width: 0, height: 200)
       
    }
}
