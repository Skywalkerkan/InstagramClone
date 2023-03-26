//
//  Uzanti+Firestore.swift
//  InstagramClone
//
//  Created by Erkan on 26.03.2023.
//

import Firebase

extension Firestore{
        // ID DEGERI ELİMİZDE OLAN KULLANICIYA AİT PAYLAŞIMLARI GETİRME
    static func kullaniciOlustur(kullaniciID: String = "", completion: @escaping(Kullanici) -> Void){
        var kID = ""
        if kullaniciID == ""{
            guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else{return}
            kID = gecerliKullaniciID
        }else{
            kID = kullaniciID
        }
        Firestore.firestore().collection("Kullanicilar").document(kID).getDocument { snapshsot, error in
            if let error = error{
                print("Kullanıcı bilgileri getirilemedi", error.localizedDescription)
            }
            guard let kullaniciVerisi = snapshsot?.data() else{return}
            let kullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            completion(kullanici)
        }
    }
    
}
