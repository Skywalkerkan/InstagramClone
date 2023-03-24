//
//  KayitOlController.swift
//  InstagramClone
//
//  Created by Erkan on 4.03.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD
import FirebaseFirestore

class KayitOlController: UIViewController {

    let btnFotograf: UIButton = {
        let button = UIButton(type: .contactAdd)
        //button.backgroundColor = .yellow
        button.setImage(UIImage(imageLiteralResourceName: "Fotograf_Sec").withRenderingMode(.alwaysOriginal), for: .normal)
        //autolayout için gerekli kısıtları kabul etsin diye false yaptık
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(btnFotoEklePressed), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func btnFotoEklePressed(){
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        present(imgPickerController, animated: true, completion: nil)
    }
    
    
    let txtEmail : UITextField = {
        let text = UITextField()
        text.backgroundColor = UIColor(white: 0, alpha: 0.05)
        text.placeholder = "Email adresini giriniz"
        text.translatesAutoresizingMaskIntoConstraints = false
        //text.backgroundColor = .white
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 16)
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return text
    }()
    
    // eğer tüm yerlerde bir şeyler varsa backgroundu değiştirme
    @objc fileprivate func veriDegisimi(){
        let formGecerlimi = (txtEmail.text?.count ?? 0) > 0 && (txtKullaniciAdi.text?.count ?? 0) > 0 && (txtParola.text?.count ?? 0) > 0
        if formGecerlimi{
            btnKayitOl.backgroundColor = UIColor.rgbConvert(red: 20, green: 155, blue: 235)
            btnKayitOl.isEnabled = true
        }else{
            btnKayitOl.backgroundColor = UIColor.rgbConvert(red: 150, green: 205, blue: 245)
            btnKayitOl.isEnabled = false
        }
    }
    
    let txtKullaniciAdi : UITextField = {
        let text = UITextField()
        text.backgroundColor = UIColor(white: 0, alpha: 0.05)
        text.placeholder = "Kullanıcı adınız"
        text.translatesAutoresizingMaskIntoConstraints = false
        //text.backgroundColor = .white
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 16)
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        
        
        return text
    }()
    
    let txtParola : UITextField = {
        let text = UITextField()
        text.backgroundColor = UIColor(white: 0, alpha: 0.05)
        text.placeholder = "Parolanız"
        text.isSecureTextEntry = true
        text.translatesAutoresizingMaskIntoConstraints = false
        //text.backgroundColor = .white
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 16)
        text.autocorrectionType = .no
        text.autocapitalizationType = .none
        text.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        
        return text
    }()
    
    let btnKayitOl : UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Kayıt Ol", for: .normal)
        //button.backgroundColor = UIColor(red: 150/255, green: 205/255, blue: 245/255, alpha: 1)
        button.backgroundColor = UIColor.rgbConvert(red: 150, green: 205, blue: 245)
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(btnkayitOlPressed), for: .touchUpInside)
        button.isEnabled = false
        
        return button
        
    }()
    var image: UIImage = {
        let image = UIImage()
        return image
    }()
    
    @objc func btnkayitOlPressed(){
       // print("Kayita basildi")
       // let email = "deneme@hotmail.com"
       // let password = "123456"
        
        guard let email = txtEmail.text else{return}
        guard let password = txtParola.text else{return}
        guard let kullaniciAdi = txtKullaniciAdi.text else{return}
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Kaydınız gerçekleşiyor"
        hud.show(in: self.view)
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { sonuc, hata in
            if let hata = hata{
                print("Kullanıcı kayıt olurken hata meydana geldi: \(hata)")
                hud.dismiss(animated: true)
                return
            }
            
            //Görüntünün Storage'a Upload edilmesi
            guard let kaydolanKullaniciID = sonuc?.user.uid else{return}
            
            let goruntuAdi = UUID().uuidString //rastgele bir string değer verecek
            let ref = Storage.storage().reference(withPath: "/ProfilFotograflari/\(goruntuAdi)")
          //  let goruntuData = self.btnFotograf.imageView?.image?.jpegData(compressionQuality: 0.6) ?? Data()
            let goruntuData = self.image.jpegData(compressionQuality: 0.6) ?? Data()
            print(self.btnFotograf.imageView?.image)
            print("-------", goruntuData)
            ref.putData(goruntuData, metadata: nil) { _, error in
                if let error = error{
                    print("foto kaydedilemedi", error)
                    return
                }
                
                print("goruntu başarıyla upload edildi")
                
                //Görüntünün download edilmesi
                ref.downloadURL { url, error in
                    if let error = error{
                        print("Görüntünün URL ADRESİ ALINAMADI", error)
                    }
                    print("Upload edilen URL adresi \(url?.absoluteString ?? "Link Yok")")
                    
                    let eklenecekVeri = ["KullaniciAdi" : kullaniciAdi,
                                         "KullaniciID" : kaydolanKullaniciID,
                                         "ProfilGoruntuURL" : url?.absoluteString ?? ""]
                    //Kullanilar kolesiyonu içinde kaydolan kullanıcı ID dökümanı olacak
                    Firestore.firestore().collection("Kullanicilar").document(kaydolanKullaniciID).setData(eklenecekVeri) { error in
                        if let error = error{
                            print("Kullanic verileri kaydedilemedi")
                            return
                        }
                        print("Başarı brom")
                        hud.dismiss(animated: true)
                        self.gorunumuDuzelt()
                        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                        
                        guard let anaTabBarController = keyWindow?.rootViewController as? AnaTabBarController else{return}
                        anaTabBarController.gorunumuOlustur() // KullaniciProfilContorllera gideriz
                        self.dismiss(animated: true) // oturum açma ekranı kapanacak
                        
                        
                    }
                }
            }
            
            print("Kullanıcı kaydı başarıyla gerçekleşti:", sonuc?.user.uid)

        }
    }
    
    fileprivate func gorunumuDuzelt(){
        self.btnFotograf.setImage(UIImage(imageLiteralResourceName: "Fotograf_Sec"), for: .normal)
        self.btnFotograf.layer.borderColor = UIColor.clear.cgColor
        self.btnFotograf.layer.borderWidth = 0
        self.txtEmail.text = ""
        self.txtKullaniciAdi.text = ""
        self.txtParola.text = ""
        let basariliHud = JGProgressHUD(style: .light)
        basariliHud.textLabel.text = "Kayıt işlemi başarılı"
        basariliHud.show(in: self.view)
        basariliHud.dismiss(afterDelay: 2)
    }
    
    let btnHesabimVar : UIButton = {
        let button = UIButton(type: .system)
        let attrText = NSMutableAttributedString(string: "Zaten bir hesabın var mı? ", attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray])
        attrText.append(NSAttributedString(string: "Kayıt Ol", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.systemBlue]))
        button.setAttributedTitle(attrText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
       // button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(oturumAcVC), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func oturumAcVC(){
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(btnHesabimVar)
        btnHesabimVar.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        view.addSubview(btnFotograf)
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        //isactive i true yaparak belirtilen ksııtın uygulanmasını sağladık
       // btnFotograf.widthAnchor.constraint(equalToConstant: 150).isActive = true
       // btnFotograf.heightAnchor.constraint(equalToConstant: 150).isActive = true
        btnFotograf.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       // btnFotograf.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
        btnFotograf.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 150, height: 150)
        
        
        //view.addSubview(txtEmail)
        
        girisAlanlariOlustur()

        

        
        
//        //frame özelliği bir nesneyi hemen konumlandırmak için kullanılır kalıcıdır.
//        btnFotograf.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
//        //buton ekranın merkezinde görülecek
//        btnFotograf.center = view.center
    }
    
    
    fileprivate func girisAlanlariOlustur(){
        
        
        let maviView = UIView()
        maviView.backgroundColor = .blue
        
        let stackView = UIStackView(arrangedSubviews: [txtEmail, txtKullaniciAdi, txtParola, btnKayitOl])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually // tüm viewlere eşit olarak paylaş
        stackView.axis = .vertical // dikey olarak görüntüle
        stackView.spacing = 15
        view.addSubview(stackView)
        
//        NSLayoutConstraint.activate([
//            //stackView.topAnchor.constraint(equalTo: btnFotograf.bottomAnchor, constant: 30),
//            //soldan boşluk
//            //stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
//            //sağ boşluk
//            //stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
//            //stackView.heightAnchor.constraint(equalToConstant: 230)
//        ])
        
        stackView.anchor(top: btnFotograf.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 45, paddingRight: -45, width: 0, height: 230)
    }
    
    
    
    
    

}


extension UIView{
    
    func anchor(top: NSLayoutYAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat,
                paddingBottom: CGFloat,
                paddingLeft: CGFloat,
                paddingRight: CGFloat,
                width: CGFloat,
                height: CGFloat
    ){
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let leading = leading{
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        if let trailing = trailing{
            self.trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
        }
        if width != 0{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
}


extension KayitOlController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // didcancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imgChosen = info[.originalImage] as? UIImage
                                                        //her zaman original
        print(imgChosen)
        image = imgChosen ?? UIImage()
        print(image)
        //btnFotograf.setImage(imgChosen?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.btnFotograf.setImage(imgChosen?.withRenderingMode(.alwaysOriginal), for: .normal)
       // self.btnFotograf.imageView?.image =
        btnFotograf.layer.cornerRadius = btnFotograf.frame.width / 2
        btnFotograf.layer.masksToBounds = true // sınırları kırp gösterme
        btnFotograf.layer.borderWidth = 5
        btnFotograf.layer.borderColor = UIColor.darkGray.cgColor
        print(self.btnFotograf.imageView?.image as Any)
        print("aaaaa")
        
        dismiss(animated: true)
    }
}
