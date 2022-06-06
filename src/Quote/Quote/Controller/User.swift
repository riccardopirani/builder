
import Foundation
import CoreLocation

struct UserLoginDefault {
    static var Username: String = ""
}

struct UserStruct: Codable {
    var Username: String!
    var IdUtente: Int!
    var Nome: String!
    var Cognome: String!
    var Password: String!

    init(IdUtente: String) {
        self.IdUtente = 0
        self.Nome = ""
        self.Cognome = ""
        self.Password = ""
    }

}

//Enumeratore Marcatura
enum StatoMarcatura: CustomStringConvertible {

    case Ingresso
    case Uscita
    case Arrivo
    case Partenza

    var description: String {
        switch self {
        case .Ingresso: return "Ingresso"
        case .Uscita: return "Uscita"
        case .Arrivo: return "Arrivo"
        case .Partenza: return "Partenza"

        }
    }
}

//Singleton Utente
public class User {

    private var IdUtente: Int = 0
    private static var UserInterno = UserStruct.init(IdUtente: "")

    init() {
    }

    init(IdUtente: Int) {
        self.IdUtente = IdUtente
    }
    func GetIdUtente() -> Int {
        return User.UserInterno.IdUtente
    }
    func SetIdUtente(IdUtente: Int) {
        return User.UserInterno.IdUtente = IdUtente
    }

    func Login(Username: String, Password: String, completion: @escaping (Bool) -> Void) {
        let um = UserModel()
        um.Login(Username: Username, Password: Password, completion: { result in
            UserLoginDefault.Username = Username
            User.UserInterno.Username = Username
            User.UserInterno.Password = Password
            User.UserInterno.IdUtente = result
            SetIdUtenteLogin(Int32(result))
            if(result > 0) {
                completion(true)
            }
            else {
                completion(false)
            }
        })
    }

    func CaricaUtenti(completion: @escaping ([UserStruct]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let rtemp = UserModel()
            rtemp.CaricaRisorse(completion: { result in
                completion(result)
            })
        }

    }

    func Marcatura(Longitudine: Float, Latitudine: Float, Stato: String, completion: @escaping (String) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let rtemp = UserModel()
            var IdUtenteMarcatura: Int = Int(self.GetIdUtente())
            if(self.IdUtente > 0) {
                IdUtenteMarcatura = self.IdUtente
            }

            rtemp.Marcatura(IdUtente: IdUtenteMarcatura, Longitudine: Longitudine, Latitudine: Latitudine, Stato: Stato, completion: { result in
                completion(result)
            })

            self.IdUtente = 0

        }

    }

    func PermessoAccessoPosizione() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            return false
        }
    }

    func LogOut() -> Bool {
        let db = Database()
        return db.removeEntity(EntinyName: "UserLogin")
    }

    //Verifica permesso accesso
    func VerificaPermesso(TipologiaPermesso: String, completion: @escaping (String) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let user = UserModel()
            user.VerificaPermesso(TipologiaPermesso: TipologiaPermesso, completion: { result in
                completion(result)
            })
        }
    }

}




