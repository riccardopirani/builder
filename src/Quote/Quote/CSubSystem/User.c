//
//  User.c
//  Quote
//
//  Created by riccardo on 02/05/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

#include "User.h"

/* Max Lenght of String  */
#define MAX 500

//Struttura Rappresentante dell'Utente
struct UserInfo{
    struct UserInfo *next;
    int IdUser;
    char Name[MAX];
    char Surname[MAX];
    char Username[MAX];
    char Passowrd[MAX];
};

//static perchè una volta inizializzato non può più essere cambiata
static struct UserInfo User;

//Funzione che settu il valore dell'id utente al login per accederci da qualunque parte del programma
void SetIdUtenteLogin(int IdUser)
{
    User.IdUser=IdUser;
}

//Funzuone che permette di recuperare il valore dell'id-utente da qualunque parte del programma
int GetIdUtenteLogin()
{
    return User.IdUser;
}



