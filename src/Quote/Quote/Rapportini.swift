//
//  Rapportini.swift
//  Quote
//
//  Created by riccardo on 04/05/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation

//Sruttura utilizzata per Coder/Encoder di JSON
struct RapportinoStruct: Codable {
    var Note: String
    var Articoli: [ArticoloStruct]
}

struct RapportinoRead: Codable {
    var Data: String
}

/* Rapportini: Questa classe rappresenta il rapportino ( E' un Documento Aziendale nel quale vengono annotati i lavori eseguiti) */

public class Rapportini {

    //Variabile che rappresenta il rapportino generato dal server in formato base64
    private var rapportino_base64: String

    //Impostazione valore default
    init()
    {
        rapportino_base64 = "notset"
    }

    func SetRapportino(rapportino: String)
    {
        rapportino_base64 = rapportino
    }

    func InviaRapportino(Cantiere: Cantiere, Data: String, completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let rtemp = RapportiniModel()
            rtemp.InviaRapportino(IdCantiere: Cantiere.GetIdCantiere(), IdCliente: Cantiere.GetIdCliente(), Data: Data, File: self.rapportino_base64, completion: { result in

                    completion(result)
                })
        }
    }
    func GeneraRapportino(Data: String, Note: String, FirmaPassing: String, Cantiere: Cantiere, completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let rtemp = RapportiniModel()
            rtemp.GeneraRapportino(Data: Data, IdCantiere: Cantiere.GetIdCantiere(), Note: Note, Firma: FirmaPassing, RagioneSociale: Cantiere.GetRagioneSociale(), NomeCantiere: Cantiere.GetNomeCantiere(), completion: { result in

                    self.SetRapportino(rapportino: result)
                    completion(result)
                })
        }

    }

    func VerificaGiorniRapportino(Cantiere: Cantiere, Data: String, completion: @escaping ([RapportinoRead]) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let rtemp = RapportiniModel()

            rtemp.VerificaDateRapportino(IdCantiere: Cantiere.GetIdCantiere(), Data: Data, IdUtente: Int(GetIdUtenteLogin()), completion: {
                    result in
                    completion(result)
                })
        }

    }
}





