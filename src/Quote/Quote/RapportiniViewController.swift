//
//  SettingViewController.swift
//  Quote
//
//  Created by riccardo on 20/03/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit


class RapportiniViewController: UIViewController, RapportinoDelegate
{
    //Oggetti Interni
    private var CantiereInterno: Cantiere
    private var rapportino = Rapportini()
    //private var ButtonInviaRapportino: UIButton!
    private var labelNote: UILabel!
    private var labelData: UILabel!
    private var RapportinoImage: UIWebView = UIWebView()
    private var TextViewNote: UITextView = UITextView()
    private var DataPicker: UIDatePicker = UIDatePicker()
    private var FirmaBase64: String = String()
    let buttonFirma: UIButton = UIButton()
    let buttonGeneraRapportino: UIButton = UIButton()
    let buttonReturn: UIButton = UIButton()
    private var RapportiniInfo: [String] = []
    var Modalita: String = "CreazioneRapportino"
    //Funzione Delegate per l'inserimento della firma nel rapportino
    func popupFirmaSelected(value: String) {
        self.FirmaBase64 = value
    }

    init(Cantiere: Cantiere) {
        self.CantiereInterno = Cantiere
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        self.tabBarItem.title = "Rapportini"
        //UiDatePicker e UiLabel Data
        labelData = UILabel(frame: CGRect(x: 15, y: 84, width: 80, height: 21))
        labelData.text = "Data: "
        labelData.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        self.view.addSubview(labelData)
        self.DataPicker.frame = CGRect(x: (self.view.frame.width / 2) - 100, y: 60, width: 230, height: 60)
        self.DataPicker.timeZone = NSTimeZone.local
        self.DataPicker.backgroundColor = UIColor.white
        self.DataPicker.datePickerMode = UIDatePicker.Mode.date
        self.view.addSubview(DataPicker)
        //UiLabel e UiTextView Note
        labelNote = UILabel(frame: CGRect(x: 15, y: 110, width: 100, height: 21))
        labelNote.text = "Note: "
        labelNote.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        self.view.addSubview(labelNote)
        self.TextViewNote = UITextView(frame: CGRect(x: 15, y: 140, width: self.view.frame.width - 50, height: 75))
        self.automaticallyAdjustsScrollViewInsets = false
        TextViewNote.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        TextViewNote.textAlignment = NSTextAlignment.justified
        TextViewNote.textColor = UIColor.blue
        TextViewNote.backgroundColor = UIColor.lightGray
        self.view.addSubview(TextViewNote)
        //ImageView Rapportino
        RapportinoImage.frame = CGRect(x: 0, y: 300, width: self.view.frame.width, height: self.view.frame.height - 300)
        RapportinoImage.loadRequest(NSURLRequest(url: NSURL(string: "")! as URL) as URLRequest)
        RapportinoImage.scalesPageToFit = true
        RapportinoImage.delegate = self as? UIWebViewDelegate
        self.view.addSubview(RapportinoImage)
        //Bottone per generare Rapportini
        let imageGeneraRapportino = UIImage(named: "generatepdf.png") as UIImage?

        buttonGeneraRapportino.frame = CGRect(x: (self.view.frame.width / 2) - 130, y: 230, width: 60, height: 60)
        buttonGeneraRapportino.backgroundColor = UIColor.white
        buttonGeneraRapportino.setImage(imageGeneraRapportino, for: .normal)
        buttonGeneraRapportino.setTitle("GeneratePDF", for: .normal)
        buttonGeneraRapportino.addTarget(self, action: #selector(GeneraRapportinobuttonAction), for: .touchUpInside)
        self.view.addSubview(buttonGeneraRapportino)
        //Bottone per tornare a schermata principale
        let ImageReturn = UIImage(named: "return.png") as UIImage?

        buttonReturn.frame = CGRect(x: (self.view.frame.width / 2) + 120, y: 230, width: 60, height: 60)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("Go Home", for: .normal)
        buttonReturn.addTarget(self, action: #selector(ReturnToHomebuttonAction), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        //Bottone andare in view firma
        let ImageFirma = UIImage(named: "sign.png") as UIImage?

        buttonFirma.frame = CGRect(x: (self.view.frame.width / 2), y: 230, width: 60, height: 60)
        buttonFirma.backgroundColor = UIColor.white
        buttonFirma.setImage(ImageFirma, for: .normal)
        buttonFirma.setTitle("Go Home", for: .normal)
        buttonFirma.addTarget(self, action: #selector(FirmabuttonAction), for: .touchUpInside)
        self.view.addSubview(buttonFirma)

        //Carico le date dei rapportini
        VisualizzaDateRapportini()
        DataPicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    /*Questa funzione carica le date in cui devono ancora essere fatti i rapportini e
     si visualizzazo nel UIDatePicker della data*/
    func VisualizzaDateRapportini() {
        //Caricamento Date
        let date = getDate()
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                let rtemp = Rapportini()
                rtemp.VerificaGiorniRapportino(Cantiere: self.CantiereInterno, Data: date, completion: { result in
                    self.RapportiniInfo.removeAll()
                    //Visualizzazione
                    let ex: Extend = Extend()
                    for item in result {
                        print("Elemento numero \(item.Data)")
                        let dateconv = ex.CastFromDateToString_SqlServer_DateTime_toDate(mydate: item.Data)
                        self.RapportiniInfo.append(dateconv)
                    }
                    //Aggiornamento DataPicker
                    self.datachangeupdate(self.DataPicker)
                });
            });

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Bottone per generare rapportini
    @objc func FirmabuttonAction(sender: UIButton!) {
        let FirmaView = FirmaViewController()
        FirmaView.delegate = self
        FirmaView.InizializzaView()
        self.present(FirmaView, animated: true)

    }

    //Get-DataConv
    func getDate() -> String {
        let ex: Extend = Extend()
        let date = ex.CastFromDateToString_SqlServer_DateTime(mydate: DataPicker.date)
        return date
    }

    //Bottone per generare rapportini
    @objc func GeneraRapportinobuttonAction(sender: UIButton!)
    {
        let date = getDate()

        if(Modalita == "CreazioneRapportino")
        {

            if(TextViewNote.text.count > 0 && self.FirmaBase64.count > 0) {

                rapportino.GeneraRapportino(Data: date, Note: TextViewNote.text!, FirmaPassing: FirmaBase64, Cantiere: CantiereInterno, completion: { result in

                    DispatchQueue.main.async
                    {
                        //Se il rapporto non viene generato correttamente visualizzo un UIAlertController
                        if(result == "false") {
                            DispatchQueue.main.async
                            {
                                let alertController = UIAlertController(title: "Errore", message: "Generazione Rapportino non riuscita !", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true, completion: nil)
                            }

                        }
                        else {

                            if let decodeData = Data(base64Encoded: result, options: .ignoreUnknownCharacters) {
                                self.RapportinoImage.load(decodeData, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: URL(fileURLWithPath: ""))
                                self.buttonFirma.isHidden = true
                                self.TextViewNote.isHidden = true
                                self.DataPicker.isHidden = true
                                self.labelData.isHidden = true
                                self.labelNote.isHidden = true
                                self.Modalita = "InvioRapportino"
                                self.buttonGeneraRapportino.setImage(UIImage(named: "sendemail.png"), for: .normal)
                            }
                        }
                    }
                });
            }

            else
            {
                DispatchQueue.main.async
                {
                    let alertController = UIAlertController(title: "Errore", message: "Controlla di aver compilato tutti i campi !", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

        else if(Modalita == "InvioRapportino")
        {

            rapportino.InviaRapportino(Cantiere: CantiereInterno, Data: date, completion: { result in
                DispatchQueue.main.async
                {
                    if(result == "true") {
                        self.buttonFirma.isHidden = false
                        self.TextViewNote.isHidden = false
                        self.DataPicker.isHidden = false
                        self.labelData.isHidden = false
                        self.labelNote.isHidden = false
                        self.TextViewNote.text = ""
                        self.FirmaBase64 = String()
                        self.Modalita = "CreazioneRapportino"
                        self.buttonGeneraRapportino.setImage(UIImage(named: "generatepdf.png"), for: .normal)
                        self.RapportinoImage.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
                    }
                    else {
                        let alertController = UIAlertController(title: "Errore", message: "Il rapportino non è stato inviato correttamente", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)


                    }
                }
            });

        }
    }
    
    //Bottone per tornare alla schermata precedente
    @objc func ReturnToHomebuttonAction(sender: UIButton!) {
        let CantiereSelezionato = GestioneCantieriViewController(CantiereSet: CantiereInterno)
        CantiereSelezionato.InizializzaView()
        self.present(CantiereSelezionato, animated: true, completion: nil)
    }

    func datachangeupdate(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
            var date = "\(year)-\(month)-\(day) 00:00:00"
            let ex: Extend = Extend()
            date = ex.CastFromDateToString_SqlServer_DateTime_toDate(mydate: date)
            if RapportiniInfo.contains(date) {
                print("yes")
                DataPicker.backgroundColor = UIColor.red
            }
            else {
                DataPicker.backgroundColor = UIColor.white
            }
        }

    }
    @objc func dateChanged(_ sender: UIDatePicker) {
        datachangeupdate(sender)
    }


}

