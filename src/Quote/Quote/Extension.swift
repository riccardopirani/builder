//
//  Extension.swift
//  Quote
//
//  Created by riccardo on 11/04/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit
import UserNotifications

//Classe per funzioni di visualizzazione a dispaly
public class DisplayAction {

    //Costruttore
    init() {

    }

    //Funzione che esegue la notifica interna all'applicazione
    func Notification(ApplicationName: String, Message: String, Title: String) {
        let content = UNMutableNotificationContent()
        content.title = ApplicationName
        content.subtitle = Title
        content.body = Message
        content.sound = UNNotificationSound.default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        let request = UNNotificationRequest(identifier: "Quote", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    //Funzione che esegue l'alert a video
    func Alert(Tipologia: String, Messaggio: String, Tile: String, Object: ViewController) {
        let alertController = UIAlertController(title: Tipologia, message: Messaggio, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: Tile, style: .default, handler: nil)
        alertController.addAction(OKAction)
        Object.self.present(alertController, animated: true, completion: nil)
    }
}

//Classe che estende le funzioni principali di una classe
public class Extend {

    //Costruttore
    init()
    {

    }

    //Funzione che recupera la larghezza di uno schermo
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    //Funzione che recupera l'altezza di uno schermo
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    //Funzione che esegue il cast di una stringa al formato sql-server
    func CastFromDateToString_SqlServer_DateTime_toDate(mydate: String) -> String {
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait()
        var dateconv = ""
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        if let date = dateFormatterGet.date(from: mydate) {
            dateconv = dateFormatterPrint.string(from: date)
        }
        semaphore.signal()
        return dateconv
    }

    //Funzione che esegue il cast di una data a una stirnga per sql-server
    func CastFromDateToString_SqlServer_DateTime(mydate: Date) -> String {
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: mydate)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.000"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        semaphore.signal()
        return myStringafd
    }

    //Esegue il cast di una pausa per il formato di sql-server
    func CastFromDateToString_SqlServer_Pausa(mydate: Date) -> String {
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: mydate)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "HH.mm"
        let myStringafd = formatter.string(from: yourDate!)
        semaphore.signal()
        return myStringafd
    }

    //Genera la stringa Base64 da image

    func CastUImagetoBase64(immagine: UIImage) -> String {
        let logo = immagine
        let imageData: Data = logo.pngData()!
        let base64String = imageData.base64EncodedString()
        return base64String
    }

}

//Estensione Per la conversione di una stringa in un Double
extension String {

    //Cast value to float
    var CastTofloatValue: Float {
        return (self as NSString).floatValue
    }

    //Mutating permette a self di cambiare valore
    mutating func replace(_ originalString: String, with newString: String) {
        self = self.replacingOccurrences(of: originalString, with: newString)
    }

    //Check if value is float
    var CheckIsFloat: Bool {

        guard let myDecimalNumber = Decimal(string: self) else {
            return false
        }

        if(myDecimalNumber <= 0) {
            return false
        }

        return true
    }

}

//Estensione per la UIimage
extension UIImage {
    //Ridimensionamento Immagini
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            let newImage = UIImage(cgImage: context.makeImage()!)
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
}

//Estensione per bottone
extension UIButton {
    enum Position: Int {
        case top, bottom, left, right
    }
    func moveImagewithTitle(imagePadding: CGFloat = 50.0) {
        guard let imageViewWidth = self.imageView?.frame.width else { return }
        guard let titleLabelWidth = self.titleLabel?.intrinsicContentSize.width else { return }
        self.contentHorizontalAlignment = .left
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: imagePadding - imageViewWidth / 2, bottom: 0.0, right: 0.0)
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: (bounds.width - titleLabelWidth) / 2 - imageViewWidth)
    }
    func set(image: UIImage?, title: String, titlePosition: Position, additionalSpacing: CGFloat, state: UIControl.State) {
        imageView?.contentMode = .center
        setImage(image, for: state)
        setTitle(title, for: state)
        titleLabel?.contentMode = .center

        adjust(title: title as NSString, at: titlePosition, with: additionalSpacing)

    }
    func set(image: UIImage?, attributedTitle title: NSAttributedString, at position: Position, width spacing: CGFloat, state: UIControl.State) {
        imageView?.contentMode = .center
        setImage(image, for: state)
        adjust(attributedTitle: title, at: position, with: spacing)
        titleLabel?.contentMode = .center
        setAttributedTitle(title, for: state)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }

    // MARK: Private Methods
    private func adjust(title: NSString, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)

        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])

        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }

    private func adjust(attributedTitle: NSAttributedString, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleSize = attributedTitle.size()

        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }

    private func arrange(titleSize: CGSize, imageRect: CGRect, atPosition position: Position, withSpacing spacing: CGFloat) {
        switch (position) {
        case .top:
            titleEdgeInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: spacing / 2 + titleSize.height, left: -imageRect.width / 2, bottom: 0, right: -imageRect.width / 2)
        case .bottom:
            titleEdgeInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: -imageRect.width / 2, bottom: spacing / 2 + titleSize.height, right: -imageRect.width / 2)
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
        case .right:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
        }
    }
}

//Attraverso questo estensione disabilito la visualizzazione della tastiera quando si clicca in un punto vuoto
extension UIViewController
{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func performSegueToReturnBack() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    //Inizailizzazione View Controller
    func InizializzaView() {
        //Disabilita la modalità schede di ios 13
        self.modalPresentationStyle = .fullScreen
    }
}

//Verifica che una stringa sia intera
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

//Estensione per UiPickerView
extension UIPickerView {
    func pickerTapped(nizer: UITapGestureRecognizer, onPick: @escaping (Int) -> ()) {
        if nizer.state == .ended {
            let rowHeight = self.rowSize(forComponent: 0).height
            let selectedRowFrame = self.bounds.insetBy(dx: 0, dy: (self.frame.height - rowHeight) / 2)

            // check if begin and end tap locations both fall into the row frame:
            if selectedRowFrame.contains(nizer.location(in: self)) &&
                selectedRowFrame.contains(nizer.location(ofTouch: 0, in: self)) {
                onPick(self.selectedRow(inComponent: 0))
            }
        }
    }
}






