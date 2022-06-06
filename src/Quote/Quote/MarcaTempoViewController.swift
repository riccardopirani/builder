//
//  MarcaTempoViewController.swift
//  Quote
//
//  Created by riccardo on 27/06/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import SwiftQRScanner

//ViewController che rappresenta il marcatempo
class MarcaTempoViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    private let mapView: MKMapView = MKMapView()
    private let buttonStartTimeTracking: UIButton = UIButton()
    private let buttonQrCode: UIButton = UIButton()
    private let buttonStopTimeTracking: UIButton = UIButton()
    private let buttonArrivo: UIButton = UIButton()
    private let buttonPartenza: UIButton = UIButton()
    public var locationManager: CLLocationManager!
    private var Longitudine: String = String()
    private var Latitudine: String = String()
    private var u = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        //Configurazione Button QrCode
        let imageQrCode = UIImage(named: "qrcode.png") as UIImage?
        buttonQrCode.frame = CGRect(x: 250, y: 50, width: 100, height: 100)
        buttonQrCode.backgroundColor = UIColor.white
        buttonQrCode.set(image: imageQrCode, attributedTitle: NSAttributedString(string: "QrCode"), at: UIButton.Position(rawValue: 1)!, width: 50, state: UIControl.State.normal)
        buttonQrCode.addTarget(self, action: #selector(LettoreQrCode), for: .touchUpInside)
        buttonQrCode.contentHorizontalAlignment = .center
        self.view.addSubview(buttonQrCode)
        //Configurazione Button Inizio Tracciamento del tempo
        let imageAvvioTracciaturaTempo = UIImage(named: "start.png") as UIImage?
        buttonStartTimeTracking.frame = CGRect(x: 20, y: 50, width: 100, height: 100)
        buttonStartTimeTracking.backgroundColor = UIColor.white
        buttonStartTimeTracking.set(image: imageAvvioTracciaturaTempo, attributedTitle: NSAttributedString(string: "Ingresso"), at: UIButton.Position(rawValue: 1)!, width: 50, state: UIControl.State.normal)
        buttonStartTimeTracking.addTarget(self, action: #selector(AvvioTracciaturaTempo), for: .touchUpInside)
        buttonStartTimeTracking.contentHorizontalAlignment = .center
        self.view.addSubview(buttonStartTimeTracking)
        //Configurazione Button Terminazione Tracciamento del tempo
        let imageStopTracciaturaTempo = UIImage(named: "stop.png") as UIImage?
        buttonStopTimeTracking.frame = CGRect(x: 140, y: 50, width: 100, height: 100)
        buttonStopTimeTracking.backgroundColor = UIColor.white
        buttonStopTimeTracking.set(image: imageStopTracciaturaTempo, attributedTitle: NSAttributedString(string: "Uscita"), at: UIButton.Position(rawValue: 1)!, width: 50, state: UIControl.State.normal)
        buttonStopTimeTracking.addTarget(self, action: #selector(TerminaTracciaturaTempo), for: .touchUpInside)
        buttonStopTimeTracking.contentHorizontalAlignment = .center
        self.view.addSubview(buttonStopTimeTracking)
        //Configurazione Button Partenza
        let imagepartenza = UIImage(named: "partenza.png") as UIImage?
        buttonPartenza.frame = CGRect(x: 200, y: 180, width: 150, height: 120)
        buttonPartenza.backgroundColor = UIColor.white
        buttonPartenza.set(image: imagepartenza, attributedTitle: NSAttributedString(string: "Partenza Cantiere"), at: UIButton.Position(rawValue: 1)!, width: 60, state: UIControl.State.normal)
        buttonPartenza.addTarget(self, action: #selector(funzionePartenza), for: .touchUpInside)
        buttonPartenza.contentHorizontalAlignment = .center
        self.view.addSubview(buttonPartenza)
        //Configurazione Button Arrivo
        let imagearrivo = UIImage(named: "arrivo.png") as UIImage?
        buttonArrivo.frame = CGRect(x: 20, y: 180, width: 140, height: 120)
        buttonArrivo.backgroundColor = UIColor.white
        buttonArrivo.set(image: imagearrivo, attributedTitle: NSAttributedString(string: "Arrivo Cantiere"), at: UIButton.Position(rawValue: 1)!, width: 60, state: UIControl.State.normal)
        buttonArrivo.addTarget(self, action: #selector(funzioneArrivo), for: .touchUpInside)
        buttonArrivo.contentHorizontalAlignment = .center
        self.view.addSubview(buttonArrivo)
        //Creazione della MKMapView
        let leftMargin: CGFloat = 0
        let topMargin: CGFloat = 310
        let mapWidth: CGFloat = view.frame.size.width
        let mapHeight: CGFloat = view.frame.size.height - 260
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        self.view.addSubview(mapView)

        // ---- Accesso alla posizione -----------
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    //Funzione che esegue la marcatura
    func MarcaTempo(Stato: StatoMarcatura) {

        var MessageError = "Errore"
        if(self.u.PermessoAccessoPosizione() == true) {
            self.u.Marcatura(Longitudine: Float(self.Longitudine)!, Latitudine: Float(self.Latitudine)!, Stato: Stato.description, completion: {
                    result in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            if(result != "true")
                            {
                                MessageError = "Errore: " + result
                                let alertController = UIAlertController(title: "Errore", message: MessageError, preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                            else {

                                var Message = ""
                                switch Stato {
                                case .Ingresso: Message = "Ingresso registrato"
                                case .Uscita: Message = "Uscita registrata"
                                case .Arrivo: Message = "Arrivo in cantiere"
                                case .Partenza: Message = "Partenza dal cantiere"

                                }

                                let alertController = UIAlertController(title: "MarcaTempo Aggiornato", message: "" + Message, preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        });
                })

        }
        else {
            let alertController = UIAlertController(title: "Errore", message: "Abilita Acessso a posizione", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }

        self.ChangeButtonColor(color: UIColor.white)

    }
    //Marcatura in Ingresso
    @objc func AvvioTracciaturaTempo(sender: UIButton!) {

        self.MarcaTempo(Stato: StatoMarcatura.Ingresso)
    }

    //Marcatura in Uscita
    @objc func TerminaTracciaturaTempo(sender: UIButton!) {
        self.MarcaTempo(Stato: StatoMarcatura.Uscita)
    }

    //Marcatura in Partenza
    @objc func funzionePartenza(sender: UIButton!) {
        self.MarcaTempo(Stato: StatoMarcatura.Partenza)
    }

    //Marcatura in Arrivo
    @objc func funzioneArrivo(sender: UIButton!) {
        self.MarcaTempo(Stato: StatoMarcatura.Arrivo)
    }

    //Legge codice qrcode per marcatura
    @objc func LettoreQrCode(sender: UIButton!) {
        let scanner = QRCodeScannerController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        Longitudine = "\(locValue.latitude)"
        Latitudine = "\(locValue.longitude)"
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        //Impostare posizione su map
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        mapView.addAnnotation(annotation)
    }
    func ChangeButtonColor(color: UIColor) {

        self.buttonStartTimeTracking.backgroundColor = color
        self.buttonStopTimeTracking.backgroundColor = color
        self.buttonArrivo.backgroundColor = color
        self.buttonPartenza.backgroundColor = color
    }

}



//Estension del marcatempo per eseguire la lettura del Qr-Code
extension MarcaTempoViewController: QRScannerCodeDelegate {

    //Funzione che viene eseguita dopo la lettura del Qr-Code
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")

        //Verifico che il valore del Qr-Code sia un intero e lo associo all'utente del quale verrà effettuata la marcatura
        if((Int(result)) != nil) {
            u = User(IdUtente: Int(result) ?? 0)
            ChangeButtonColor(color: UIColor.red)
        }
        //Nel caso in cui il valore non corrisponda ad un intero visualizzo un messaggio di errore a video
            else {
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Errore", message: "QrCode non valido", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)

                })

        }
    }

    //Funzione che viene eseguita in caso di errore
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }

    //Funzione che viene eseguita se si chiude la view di lettura del qr-code (Prima di effettuare la lettura)
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }


}
