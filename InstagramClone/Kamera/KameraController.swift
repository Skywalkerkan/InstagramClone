//
//  KameraController.swift
//  InstagramClone
//
//  Created by Erkan on 27.03.2023.
//

import UIKit
import AVFoundation

class KameraController: UIViewController{
    
    
    let btnGeri: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "Ok_Sag").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(btnGeriPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc fileprivate func btnGeriPressed(){
        dismiss(animated: true)
    }
    
    let btnFotografCek: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "Fotograf_Cek").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(btnFotografCekPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc fileprivate func btnFotografCekPressed(){
        print("Foto çektin")
        let ayarlar = AVCapturePhotoSettings()
        cikti.capturePhoto(with: ayarlar, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        fotografAl()
        gorunumuDuzenle()
    }
    
    fileprivate func gorunumuDuzenle(){
        view.addSubview(btnFotografCek)
        view.addSubview(btnGeri)
        btnFotografCek.anchor(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: -25, paddingLeft: 0, paddingRight: 0, width: 80, height: 80)
        btnFotografCek.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnGeri.anchor(top: view.topAnchor, bottom: nil, leading: nil, trailing: view.trailingAnchor, paddingTop: 25, paddingBottom: 0, paddingLeft: 0, paddingRight: -15, width: 50, height: 50)
    }
    
    let cikti = AVCapturePhotoOutput()
    
    fileprivate func fotografAl(){
        let captureSession = AVCaptureSession()
        guard let cihaz = AVCaptureDevice.default(for: AVMediaType.video) else{return} // videoyu oluşturuyoruz
        do{
            let giris = try AVCaptureDeviceInput(device: cihaz)
            if captureSession.canAddInput(giris){
                captureSession.addInput(giris)
            }
        }catch let error{
            print("Kameraya erişilemiyor", error.localizedDescription)
        }
        
        
        if captureSession.canAddOutput(cikti){
            captureSession.addOutput(cikti)
        }
        
        let onizleme = AVCaptureVideoPreviewLayer(session: captureSession)
        onizleme.frame = view.frame
        view.layer.addSublayer(onizleme)
        captureSession.startRunning()
    }
}

extension KameraController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("hafızaya alındı")
        guard let imageData = photo.fileDataRepresentation() else{return}
        let goruntuOnizleme = UIImage(data: imageData)
        let imgGoruntuOnizleme = UIImageView(image: goruntuOnizleme)
        view.addSubview(imgGoruntuOnizleme)
        imgGoruntuOnizleme.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
}

