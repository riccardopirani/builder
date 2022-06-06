//
//  RapportiniModel.swift
//  Quote
//
//  Created by riccardo on 04/05/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation

//Classe che rappresenta il Rapportino
class RapportiniModel {

    //Costruttore
    init() {
    }

    //Verifica date del rapportino
    func VerificaDateRapportino(IdCantiere: Int, Data: String, IdUtente: Int, completion: @escaping ([RapportinoRead]) -> ()) {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["IdUtente": IdUtente, "Data": Data, "IdCantiere": IdCantiere]
        jsonrequest.GetArray(Tipo: "RapportinoRead", Router: "/rapportini/verificagenerazionerapportini", ValueArray: jsonarray, completion: { result in
            completion(result as! [RapportinoRead])
        })
    }

    //Invio del rapportino per email
    func InviaRapportino(IdCantiere: Int, IdCliente: Int, Data: String, File: String, completion: @escaping (String) -> ()) {

        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["IdUtente": GetIdUtenteLogin(), "Data": Data, "IdCantiere": IdCantiere, "File": "" + File, "IdCliente": IdCliente]
        jsonrequest.GetSingleString(Router: "/rapportini/inviarapportino", ValueArray: jsonarray, completion: { result in
            completion(result)
        })
    }

    //Funzione per la generazione del rapportino che ritorna una stringa base 64 rappresentante il rapportino
    func GeneraRapportino(Data: String, IdCantiere: Int, Note: String, Firma: String, RagioneSociale: String, NomeCantiere: String, completion: @escaping (String) -> ())
    {

        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["IdUtente": GetIdUtenteLogin(), "Data": Data, "IdCantiere": IdCantiere, "Note": "" + Note, "Firma": "" + Firma, "RagioneSociale": "" + RagioneSociale, "NomeCantiere": "" + NomeCantiere]
        jsonrequest.GetSingleString(Router: "/rapportini/generarapportino", ValueArray: jsonarray, completion: { result in
            completion(result)
        })
    }


}

