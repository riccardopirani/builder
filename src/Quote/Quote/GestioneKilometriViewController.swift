//
//  GestioneKilometriViewController.swift
//  Quote
//
//  Created by riccardo on 02/05/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

/*

   In questo file l'unica  variabile pubblica è quella
   che rappresenta l'oggetto Cantiere che dovrà essere inzializzato
   obbligatoriamente!


 */

import UIKit

class GestioneKilometriViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //Oggetti Pubblici
    public var CantiereInterno: Cantiere!
    //Oggetti Privati
    private var Estensioni: Extend = Extend()
    private let datePicker: UIDatePicker = UIDatePicker()
    private var labelDataINFO: UILabel = UILabel()
    private var labelRapportino: UILabel = UILabel()
    private var labelTipoMezzoINFO: UILabel = UILabel()
    private var SwitchRapportino: UISwitch = UISwitch()
    private var TextFieldTipoMezzo: UITextField = UITextField()
    private var labelTargaINFO: UILabel = UILabel()
    private var TextFieldTarga: UITextField = UITextField()
    private var labelKilometriINFO: UILabel = UILabel()
    private var TextFieldKilometri: UITextField = UITextField()
    private var labelCostoINFO: UILabel = UILabel()
    private var TextFieldCosto: UITextField = UITextField()
    private var labelDirittoChiamataINFO: UILabel = UILabel()
    private var TextFieldDirittoChiamata: UITextField = UITextField()
    private var KilometriTableView: UITableView!
    private var KilometriCantiereLoad: [KilometroStruct] = []
    private var Rapportino: Bool = false

    override func viewDidLoad() {

        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Gestione Kilometri"
        //Configurazione Label INFO Data
        labelDataINFO = UILabel(frame: CGRect(x: 20, y: 50, width: 100, height: 80))
        labelDataINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelDataINFO.text = "Data: "
        self.view.addSubview(labelDataINFO)
        //Configurazione DataPicker
        self.datePicker.frame = CGRect(x: 70, y: 50, width: 250, height: 80)
        self.datePicker.timeZone = NSTimeZone.local
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePicker.Mode.date;
        self.view.addSubview(datePicker)
        //Configurazione Label INFO e TextFiled  TipoMezzo
        labelTipoMezzoINFO = UILabel(frame: CGRect(x: 20, y: 130, width: 100, height: 18))
        labelTipoMezzoINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelTipoMezzoINFO.text = "Tipo Mezzo:"
        self.view.addSubview(labelTipoMezzoINFO)
        TextFieldTipoMezzo = UITextField(frame: CGRect(x: 120, y: 130, width: 170, height: 18))
        TextFieldTipoMezzo.backgroundColor = UIColor.lightGray
        TextFieldTipoMezzo.text = ""
        self.view.addSubview(TextFieldTipoMezzo)
        //Configurazione Label INFO e TextFiled  Targa
        labelTargaINFO = UILabel(frame: CGRect(x: 20, y: 170, width: 100, height: 18))
        labelTargaINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelTargaINFO.text = "Targa"
        self.view.addSubview(labelTargaINFO)
        TextFieldTarga = UITextField(frame: CGRect(x: 120, y: 170, width: 170, height: 18))
        TextFieldTarga.backgroundColor = UIColor.lightGray
        TextFieldTarga.text = ""
        self.view.addSubview(TextFieldTarga)
        //Configurazione Label INFO e TextFiled  Kilometri
        labelKilometriINFO = UILabel(frame: CGRect(x: 20, y: 220, width: 100, height: 18))
        labelKilometriINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelKilometriINFO.text = "Kilometri:"
        self.view.addSubview(labelKilometriINFO)
        TextFieldKilometri = UITextField(frame: CGRect(x: 120, y: 220, width: 170, height: 18))
        TextFieldKilometri.backgroundColor = UIColor.lightGray
        TextFieldKilometri.text = ""
        self.view.addSubview(TextFieldKilometri)
        //Configurazione Label INFO e TextFiled  Costo
        labelCostoINFO = UILabel(frame: CGRect(x: 20, y: 270, width: 100, height: 18))
        labelCostoINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelCostoINFO.text = "Costo:"
        self.view.addSubview(labelCostoINFO)
        TextFieldCosto = UITextField(frame: CGRect(x: 120, y: 270, width: 170, height: 18))
        TextFieldCosto.backgroundColor = UIColor.lightGray
        TextFieldCosto.text = "0.60"
        self.view.addSubview(TextFieldCosto)
        //Configurazione Label INFO e TextFiled  Diritto Chiamata
        labelDirittoChiamataINFO = UILabel(frame: CGRect(x: 20, y: 320, width: 100, height: 18))
        labelDirittoChiamataINFO.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelDirittoChiamataINFO.text = "D.C. :"
        self.view.addSubview(labelDirittoChiamataINFO)
        TextFieldDirittoChiamata = UITextField(frame: CGRect(x: 120, y: 320, width: 170, height: 18))
        TextFieldDirittoChiamata.backgroundColor = UIColor.lightGray
        TextFieldDirittoChiamata.text = ""
        self.view.addSubview(TextFieldDirittoChiamata)
        //Configurazione Bottone per Inserimento Articolo in Database
        let ImageInserimento = UIImage(named: "inserisci.png") as UIImage?
        let buttonInserimentoKilometro = UIButton()
        buttonInserimentoKilometro.frame = CGRect(x: 250, y: 360, width: 80, height: 80)
        buttonInserimentoKilometro.backgroundColor = UIColor.white
        buttonInserimentoKilometro.setImage(ImageInserimento, for: .normal)
        buttonInserimentoKilometro.set(image: ImageInserimento, attributedTitle: NSAttributedString(string: "Inserisci"), at: UIButton.Position(rawValue: 1)!, width: 30, state: UIControl.State.normal)
        buttonInserimentoKilometro.addTarget(self, action: #selector(InserisciKilometro), for: .touchUpInside)
        self.view.addSubview(buttonInserimentoKilometro)
        // ---- Configurazione Bottone Ritorno a Schermata precedente
        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn = UIButton()
        buttonReturn.frame = CGRect(x: 120, y: 380, width: 80, height: 80)
        buttonReturn.backgroundColor = UIColor.white
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("", for: .normal)
        buttonReturn.addTarget(self, action: #selector(Return), for: .touchUpInside)
        self.view.addSubview(buttonReturn)
        /* Configurazione TableView  */
        let displayWidth: CGFloat = self.view.frame.width
        KilometriTableView = UITableView(frame: CGRect(x: 0, y: 460, width: displayWidth, height: self.view.frame.height - 460))
        KilometriTableView.register(CustomTableViewCellArticolo.self, forCellReuseIdentifier: "MyCell")
        KilometriTableView.dataSource = self
        KilometriTableView.delegate = self
        KilometriTableView.tableFooterView = UIView()
        KilometriTableView.rowHeight = 80
        KilometriTableView.layer.borderWidth = 2.0
        self.view.addSubview(KilometriTableView)
        //Switch Kilometri
        SwitchRapportino = UISwitch(frame: CGRect(x: 60, y: 380, width: 0, height: 0))
        SwitchRapportino.setOn(false, animated: true)
        SwitchRapportino.addTarget(self, action: #selector(RisorseUmaneViewController.switchValueDidChange(sender:)), for: .valueChanged)
        self.view.addSubview(SwitchRapportino)
        //UILabel Kilometri
        labelRapportino = UILabel(frame: CGRect(x: 60, y: 360, width: 200, height: 21))
        labelRapportino.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        labelRapportino.text = "Rapportino: "
        self.view.addSubview(labelRapportino)
        /* carico gli aritcoli del cantiere */
        CaricaKilometriCantiere()
        SwitchRapportino.isHidden = false
        labelRapportino.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func Return(sender: UIButton!) {
        let CantiereSelezionato = GestioneCantieriViewController(CantiereSet: CantiereInterno!)
        self.present(CantiereSelezionato, animated: true, completion: nil)
    }

    @objc func InserisciKilometro(sender: UIButton!)
    {
        //Verifica che i campi siano compilati
        let Data: String = Estensioni.CastFromDateToString_SqlServer_DateTime(mydate: datePicker.date)

        if((TextFieldCosto.text?.CheckIsFloat)! == true && (TextFieldKilometri.text?.CheckIsFloat)! == true && TextFieldDirittoChiamata.text?.CheckIsFloat == true && (TextFieldTipoMezzo.text?.count)! > 0 && (TextFieldTarga.text?.count)! > 0)
        {
            let TipoMezzo: String = TextFieldTipoMezzo.text!
            let Targa: String = TextFieldTarga.text!

            let Costo: Float = (TextFieldCosto.text! as NSString).floatValue
            let Kilometri: Float = (TextFieldKilometri.text! as NSString).floatValue
            let DirittoChiamata: Float = (TextFieldDirittoChiamata.text! as NSString).floatValue

            let KilometriTemp: Kilometro = Kilometro(SetCantiere: self.CantiereInterno, Data: Data, TipoMezzo: TipoMezzo, Targa: Targa, Kilometri: Kilometri, CostoKilometro: Costo, DirittoChiamata: DirittoChiamata)

            KilometriTemp.InserisciKilometro(Rapportino: Rapportino, completion: { result in

                if(result == true)
                {
                    self.CaricaKilometriCantiere()
                }
                else {
                    print("Errore nell'inserimento")
                }
            })
        }
        else
        {
            let alertController = UIAlertController(title: "Errore", message: "Verifica di aver compilato correttamente i campi!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KilometriCantiereLoad.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        KilometriTableView.beginUpdates()
        let cell = KilometriTableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCellArticolo
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.masksToBounds = true
        cell.labCodArt.text = "Tipo Mezzo: \(KilometriCantiereLoad[indexPath.row].TipoMezzo!) "
        cell.labDescrizione.text = "Costo: \(KilometriCantiereLoad[indexPath.row].CostoKilometrico!) "
        cell.labPrezzo.text = ""
        KilometriTableView.endUpdates()
        return cell
    }

    func CaricaKilometriCantiere() {
        let ktemp = Kilometro(SetCantiere: CantiereInterno)
        ktemp.CaricaKilometriCantiere(completion: { result in
            self.KilometriCantiereLoad.removeAll()
            self.KilometriCantiereLoad = result
            DispatchQueue.main.async {
                self.KilometriTableView.reloadData()
            }
        });
    }

    @objc func switchValueDidChange(sender: UISwitch!)
    {
        if (sender.isOn == true) {
            Rapportino = true
        }
        else {
            Rapportino = false
        }
    }

    //Abilita la possbilità di editare UiTableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //Funzione di elminazione delle UiTableViewCell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { /*Istruzione diversa da eliminazione*/ return }
        //Eliminazione di row
        let kilometrodelete = Kilometro(Kilometro: KilometriCantiereLoad[indexPath.row])

        kilometrodelete.EliminaKilometro(completion: { result in

            if(result == true)
            {
                self.CaricaKilometriCantiere()

            }
            else
            { let alertController = UIAlertController(title: "Errore", message: "Eliminazione Kilometro non riuscita", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })

    }

}
