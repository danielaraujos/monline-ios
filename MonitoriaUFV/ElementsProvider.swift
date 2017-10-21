//
//  ElementsProvider.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 02/10/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//


import UIKit

class ElementsProvider  : NSObject  {
    
    private static let _instance = ElementsProvider();
    
    static var Instance: ElementsProvider{
        return _instance
    }
    
    /*
     Função responsavel por converter cores de String para Hexadecimal
     */
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func carregarImagemNoCache(_ urlString: String) {
        self.image = nil
        //Verifica antes de baixar, o cache da imagem
        if let imagemCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imagemCache
            return
        }
        //Baixa a imagem
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            //Encontrou um erro
            if error != nil {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async(execute: {
                if let baixarImagem = UIImage(data: data!) {
                    imageCache.setObject(baixarImagem, forKey: urlString as AnyObject)
                    self.image = baixarImagem
                }
            })
        }).resume()
    }
}




