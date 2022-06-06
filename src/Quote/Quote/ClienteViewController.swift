//
//  ClienteViewController.swift
//  Quote
//
//  Created by riccardo on 31/08/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//


import UIKit

class ClienteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    private var filteredData: [ClienteStruct] = []
    private var ClienteTableView: UITableView!
    private var mySearchBar: UISearchBar!
    public var stato: ModalitaCliente = ModalitaCliente.Ricerca

    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.gray
        //Recupero le dimensioni della barra di stato e del display
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + 10
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        var height: CGFloat = 0
        height = ((displayHeight - (2 * barHeight) + 6))
        //Configurazione Table-View
        ClienteTableView = UITableView(frame: CGRect(x: 0, y: ((2 * barHeight) + barHeight + 6), width: displayWidth, height: height))
        ClienteTableView.register(CustomTableViewCellArticolo.self, forCellReuseIdentifier: "MyCell")
        ClienteTableView.dataSource = self
        ClienteTableView.delegate = self
        ClienteTableView.tableFooterView = UIView()
        ClienteTableView.rowHeight = 130
        //Configurazione Barra di Ricerca
        mySearchBar = UISearchBar(frame: CGRect(x: 0, y: barHeight + 6, width: displayWidth, height: (2 * barHeight)))
        mySearchBar.delegate = self
        mySearchBar.placeholder = "Cerca clienti"
        self.ClienteTableView.layer.borderWidth = 2.0;
        self.view.addSubview(ClienteTableView)
        self.view.addSubview(mySearchBar)
        //Implemento la sparizione della tastiera:
        ClienteTableView.keyboardDismissMode = .onDrag
        //Configurazione UIButton Inserimento Cliente
        let imageinserimentoCliente = UIImage(named: "add-button.png") as UIImage?
        let buttonInserimentoCliente = UIButton()
        buttonInserimentoCliente.frame = CGRect(x: self.view.frame.width - 90, y: self.view.frame.height - 200, width: 80, height: 80)
        buttonInserimentoCliente.layer.cornerRadius = 0.5 * buttonInserimentoCliente.bounds.size.width
        buttonInserimentoCliente.backgroundColor = UIColor.gray
        buttonInserimentoCliente.setImage(imageinserimentoCliente, for: .normal)
        buttonInserimentoCliente.setTitle("", for: .normal)
        buttonInserimentoCliente.addTarget(self, action: #selector(CreazioneCliente), for: .touchUpInside)
        self.view.addSubview(buttonInserimentoCliente)
        if(stato == ModalitaCliente.Inserisci) {
            buttonInserimentoCliente.isHidden = true

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    //Bottone per creazione Cliente
    @objc func CreazioneCliente(sender: UIButton!) {
        let NuovoClienteView = ModificaClienteViewController()
        self.present(NuovoClienteView, animated: true, completion: nil)
    }


    //Funzione sulla selezione della riga
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let ragioneSociale = filteredData[indexPath.row].RagioneSociale
        let idCliente = filteredData[indexPath.row].IdCliente
        let c = Cliente(RagioneSociale: ragioneSociale!, IdCliente: idCliente!, Citta: filteredData[indexPath.row].Citta, Indirizzo: filteredData[indexPath.row].Indirizzo)
        if(stato == ModalitaCliente.Inserisci)
        {
            let viewCreazioneCantiere = CreazioneCantiereViewController()
            viewCreazioneCantiere.c = c
            viewCreazioneCantiere.InizializzaView()
            self.present(viewCreazioneCantiere, animated: true, completion: nil)
        }
        else if(stato == ModalitaCliente.Ricerca)
        {
            let viewModificaCliente = ModificaClienteViewController()
            viewModificaCliente.clientetemp = c
            viewModificaCliente.Stato = "Modifica"
            viewModificaCliente.InizializzaView()
            self.present(viewModificaCliente, animated: true, completion: nil)
        }
    }

    //Conta il Numero di Cantieri nel UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredData.count
    }

    //Configurazione TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        ClienteTableView.beginUpdates()
        let cell = ClienteTableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCellArticolo
        cell.labCodArt.text = "Ragione Sociale: \(filteredData[indexPath.row].RagioneSociale!)"
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.masksToBounds = true
        cell.labDescrizione.text = "Indirizzo: \(filteredData[indexPath.row].Indirizzo!)"
        cell.labPrezzo.text = ""
        ClienteTableView.endUpdates()
        return cell
    }

    //Questo Metodo Aggiorna i Dati basati sulla textbox di ricerca
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //Imposto un ritardo sull'esecuzione della ricerca dei cantieri
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                let ctemp = Cliente()
                ctemp.Ricerca(TestoRicerca: searchText, completion: { result in
                    self.filteredData.removeAll()
                    self.filteredData = result
                    DispatchQueue.main.async {
                        self.ClienteTableView.reloadData()
                    }
                });
            });
    }

    //Funzione di elminazione delle UiTableViewCell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { /*Istruzione diversa da eliminazione*/ return }
        //Eliminaizone  row
        let cdelete = Cliente(RagioneSociale: filteredData[indexPath.row].RagioneSociale, IdCliente: filteredData[indexPath.row].IdCliente, Citta: filteredData[indexPath.row].Citta, Indirizzo: filteredData[indexPath.row].Indirizzo)

        cdelete.Elimina(completion: { result in


            if(result == true)
            {
                DispatchQueue.main.sync {
                    self.filteredData.remove(at: indexPath.row)
                    self.ClienteTableView.reloadData()
                }
            }
            else
            {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Errore", message: "Eliminazione Cliente non riuscita", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })

    }
}

