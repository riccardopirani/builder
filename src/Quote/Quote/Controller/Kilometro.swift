
import Foundation


struct KilometroStruct: Codable {

    var IdKilometri: Int!
    var TipoMezzo: String!
    var CostoKilometrico: Double!
}

public class Kilometro {

    //Oggetto che rappresenta il Cantiere
    var Cantiere: Cantiere!
    //Parametri del Kilometro
    var TipoMezzo: String!
    var Targa: String!
    var Data: String!
    var Kilometri: Float!
    var CostoKilometrico: Float!
    var DirittoChiamata: Float!
    var IdKilometro: Int?

    //Costruttore

    init(Kilometro: KilometroStruct) {
        self.IdKilometro = Kilometro.IdKilometri
    }

    //Costruttore
    init(SetCantiere: Cantiere, Data: String, TipoMezzo: String, Targa: String, Kilometri: Float, CostoKilometro: Float, DirittoChiamata: Float) {
        self.Cantiere = SetCantiere
        self.Data = Data
        self.TipoMezzo = TipoMezzo
        self.Targa = Targa
        self.Kilometri = Kilometri
        self.CostoKilometrico = CostoKilometro
        self.DirittoChiamata = DirittoChiamata
    }

    init(SetCantiere: Cantiere) {
        self.Cantiere = SetCantiere
    }

    func InserisciKilometro(Rapportino: Bool, completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let kilometromodel = KilometroModel()
            kilometromodel.InserisciKilometri(Rapportino: Rapportino, IdCantiere: self.Cantiere.GetIdCantiere(), IdUtente: Int(GetIdUtenteLogin()), Data: self.Data, TipoMezzo: self.TipoMezzo, Targa: self.Targa, Kilometri: self.Kilometri!, CostoKilometro: self.CostoKilometrico!, DirittoChiamata: self.DirittoChiamata, completion: {
                    result in
                    completion(result)
                })
        }
    }

    func EliminaKilometro(completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let kilmodel = KilometroModel()
            kilmodel.EliminaKilometri(IdDelete: self.IdKilometro!, completion: {
                result in
                completion(result)
            })
        }
    }

    func CaricaKilometriCantiere(completion: @escaping ([KilometroStruct]) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let kilometrotemp = KilometroModel()
            kilometrotemp.CaricaKilometriCantiere(IdCantiere: self.Cantiere.GetIdCantiere(), completion: {
                    result in
                    completion(result)
                })
        }

    }

}
