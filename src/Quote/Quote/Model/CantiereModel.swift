//
//  CantiereModel.swift
//  Quote
//
//  Created by riccardo on 26/03/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation

//Classe che rappresenta i Cantieri
class CantiereModel {

    //Costruttore
    init() {

    }

    //Funzione di Ricerca di un Cantiere
    func RicercaCantiere(NomeCantiere: String, completion: @escaping ([CantiereStruct]) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["NomeCantiere": "" + NomeCantiere, "IdUtente": GetIdUtenteLogin()]
        jsonrequest.GetArray(Tipo: "Cantiere", Router: "/cantieri/ricerca", ValueArray: jsonarray, completion: { result in
            completion(result as! [CantiereStruct])
        })
    }

    //Funzione di creazione di un cantiere
    func AggiornaCantiere(IdCantiere: Int, DescrizioneEstesa: String, Stato: String, completion: @escaping (Bool) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["DescrizioneEstesa": DescrizioneEstesa, "Stato": Stato, "IdCantiere": IdCantiere]
        jsonrequest.GetSingleValue(Router: "/cantieri/aggiornacantiere", ValueArray: jsonarray, completion: { result in
            completion(result)
        })

    }

    //Funzione di creazione di un cantiere a consutivo
    func CreazioneCantiere(IdCliente: Int, NomeCantiere: String, completion: @escaping ([CantiereStruct]) -> ())
    {
        DispatchQueue.main.async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["NomeCantiere": NomeCantiere, "IdCliente": IdCliente, "IdUtente": GetIdUtenteLogin()]
            jsonrequest.GetArray(Tipo: "Cantiere", Router: "/cantieri/generacantiere", ValueArray: jsonarray, completion: { result in
                completion(result as! [CantiereStruct])
            })
        }

    }

    //Funzione per la creazione di un cantiere a preventivo
    func CreazioneCantierePreventivo(PreventivoPassed: Preventivo, completion: @escaping ([CantiereStruct]) -> ())
    {
        DispatchQueue.main.async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdPreventivo": PreventivoPassed.GetIdPreventivo(), "Tipo": "Preventivo", "IdFiliale:": "", "NomeCantiere": PreventivoPassed.GetRiferimentoInterno(), "IdCliente": PreventivoPassed.GetIdCliente(), "IdUtente": GetIdUtenteLogin()]
            jsonrequest.GetArray(Tipo: "Cantiere", Router: "/cantieri/generacantiere", ValueArray: jsonarray, completion: { result in
                completion(result as! [CantiereStruct])
            })

        }

    }
}
