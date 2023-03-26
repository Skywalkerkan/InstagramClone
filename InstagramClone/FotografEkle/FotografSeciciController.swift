//
//  FotografSeciciController.swift
//  InstagramClone
//
//  Created by Erkan on 23.03.2023.
//

import Foundation
import UIKit
import Photos

class FotografSeciciController: UICollectionViewController{
    
    let hucreID = "hucreID"
    let headerID = "headerID"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        butonlariEkle()
        collectionView.register(FotografSeciciCell.self, forCellWithReuseIdentifier: hucreID)
        collectionView.register(FotografSeciciHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        fotograflariGetir()
    }
    
   
    var fotograflar : [UIImage] = []
    var secilenFotograf: UIImage?
    var assetler = [PHAsset]()
    
    fileprivate func fotografGetirmeSecenekOlustur() ->PHFetchOptions{
        let getirmeSecenekler = PHFetchOptions()
        getirmeSecenekler.fetchLimit = 40 // TOPLAMDA 10 FOTOĞRAF GETİR
        let siralamaAyari = NSSortDescriptor(key: "creationDate", ascending: false)
        getirmeSecenekler.sortDescriptors = [siralamaAyari]  //FOTOĞRAFLARIN SIRALAMASI YENİDEN ESKİYE DOĞRU GELİYOR
        return getirmeSecenekler
    }
    
    
    
    
    fileprivate func fotograflariGetir(){

        
        let fotograflar = PHAsset.fetchAssets(with: .image, options: fotografGetirmeSecenekOlustur())
        
        
        DispatchQueue.global(qos: .background).async {
            fotograflar.enumerateObjects { asset, sayi, durmaNoktasi in
                
                //asset içinde tüm fotoğrafların bilgileri yer alıyor
                //sayi: kaçıncı fotoğraf getiriliyor. 0dan başlar 9 a kadar gider
                //durma noktasi: fotoğraf getirilirken durulan noktanın adresini tutar.
                
                let imageManager = PHImageManager.default()
                let goruntuBoyut = CGSize(width: 200, height: 200) // Kücük olan fotoğrafların kalitesini düşürerek zamandan tasarruf edyioruz
                let secenekler = PHImageRequestOptions()
                secenekler.isSynchronous = true // SENKRONLI BİR ŞEKİLDE GETİRİYOR
                imageManager.requestImage(for: asset, targetSize: goruntuBoyut, contentMode: .aspectFit, options: secenekler) { goruntu, goruntuBilgileri in
                    if let fotograf = goruntu{
                        self.assetler.append(asset) // kücük görüntünün adresini elde ediyoruz
                        self.fotograflar.append(fotograf)
                        print("\(fotograflar.count) tane fotoğraf getirildi")
                        
                        if self.secilenFotograf == nil{
                            self.secilenFotograf = goruntu
                        }
                    }
                    if sayi == fotograflar.count - 1{
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }

    }
    
    //COLLECTION VİEWİN CONSTRAİNTİ GİBİ BİR ŞEY
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
    }
    
    //HEADERIN OLUŞMASINI TETİKLEYECEK VE BOYUT ATAMASI YAPACAK METHOD
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    var header: FotografSeciciHeader?
    
    
    //HEADERIN OLUŞTURULMASINDA BOYUT ATAMASI YAPMADAN TETİKLENMEZ
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! FotografSeciciHeader
       // header.imgHeader.image = secilenFotograf
        
        self.header = header
        header.imgHeader.image = secilenFotograf
        
        if let secilenFotograf = secilenFotograf{
            if let index = self.fotograflar.firstIndex(of: secilenFotograf){
                let secilenAsset = self.assetler[index]
                
                let fotoManager = PHImageManager.default()
                let boyut = CGSize(width: 1000, height: 1000)
                fotoManager.requestImage(for: secilenAsset, targetSize: boyut, contentMode: .default, options: nil) { foto, bilgi in
                    header.imgHeader.image = foto
                }
            }
        }
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fotograflar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! FotografSeciciCell
        cell.imgFotograf.image = fotograflar[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        secilenFotograf = fotograflar[indexPath.row]
        collectionView.reloadData()
        let indexUst = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexUst, at: .bottom, animated: true) //Bir fotoğraf seçildiğinde en üstteki headera gidilmesini sağlıyor
    }
    
    
    
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    fileprivate func butonlariEkle(){
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "İptal Et", style: .plain, target: self, action: #selector(btnCancelPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sonraki", style: .plain, target: self, action: #selector(btnSonrakiPressed))
    }
    
    
    @objc func btnSonrakiPressed(){
        let fotoPaylasContorller = FotografPaylasController()
        fotoPaylasContorller.secilenFotograf = header?.imgHeader.image
        navigationController?.pushViewController(fotoPaylasContorller, animated: true)
    }
    @objc func btnCancelPressed(){
        dismiss(animated: true)
    }
    
}
//Üstteki saalerin oldugu yer status bar
extension UINavigationController{
    open override var childForStatusBarHidden: UIViewController?{
        return self.topViewController
    }
}


//Bir satırda kaç tane cell olacağının extensionu
extension FotografSeciciController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-6) / 4
        return CGSize(width: width, height: width)
    }
    
    // Satırlar arasındaki boşluk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    //sağlı sollu boşluklar
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
