REM Création des séquences
DROP SEQUENCE SeqCommune;
CREATE SEQUENCE SeqCommune;
DROP SEQUENCE SeqPro;
CREATE SEQUENCE SeqPro;
DROP SEQUENCE SeqReunion;
CREATE SEQUENCE SeqReunion;
DROP SEQUENCE SeqProjet;
CREATE SEQUENCE SeqProjet;

PURGE RECYCLEBIN;

REM Suppression des tables
DROP TABLE Commune CASCADE CONSTRAINT PURGE;
DROP TABLE Prospecteur CASCADE CONSTRAINT PURGE;
DROP TABLE Reunion CASCADE CONSTRAINT PURGE;
DROP TABLE Projet CASCADE CONSTRAINT PURGE;
DROP TABLE Investissement CASCADE CONSTRAINT PURGE;
DROP TABLE Invitation CASCADE CONSTRAINT PURGE;

REM Création des tables
CREATE TABLE Commune(
    Id_Commune INTEGER,
    Nom_Commune VARCHAR(30) CONSTRAINT NN_NCommune NOT NULL,
    CP_Commune CHAR(5) CONSTRAINT NN_CPCommune NOT NULL, 
    CONSTRAINT UC_Commune UNIQUE(Nom_Commune, CP_Commune)
);

CREATE TABLE Prospecteur(
    Id_Pro INTEGER CONSTRAINT NN_IdPro NOT NULL,
    Nom_Pro VARCHAR(20) CONSTRAINT NN_NomPro NOT NULL,
    Prenom_Pro VARCHAR(15) CONSTRAINT NN_PrePro NOT NULL,
    Adresse_Pro VARCHAR(30) CONSTRAINT NN_AdrPro NOT NULL,
    Tel_Pro CHAR(10),
    Mail_Pro VARCHAR(30),
    Id_Commune INTEGER CONSTRAINT NN_IdCommune NOT NULL,
    CONSTRAINT UC_Prospecteur UNIQUE(Nom_Pro, Prenom_Pro)
);

CREATE TABLE Reunion(
    Id_Reunion INTEGER CONSTRAINT NN_IdReu NOT NULL,
    Theme_Reunion VARCHAR(30) CONSTRAINT NN_ThemeReu NOT NULL,
    Id_Projet INTEGER CONSTRAINT NN_IdPrjReu NOT NULL
);

CREATE TABLE Projet(
    Id_Projet INTEGER,
    Libelle_Projet VARCHAR(20) CONSTRAINT NN_Libelle NOT NULL,
    NbIntervenant INTEGER, 
    CoutPlace NUMBER(9,2),
    CONSTRAINT UC_Libelle UNIQUE (Libelle_Projet)
);

CREATE TABLE Investissement(
    DateAdhesion DATE CONSTRAINT NN_DateAdhesion NOT NULL,
    Id_Projet INTEGER CONSTRAINT NN_IdPrjInvest NOT NULL,
    Id_Pro INTEGER CONSTRAINT NN_IdProInvest NOT NULL
);

CREATE TABLE Invitation(
    Participation NUMBER(1) DEFAULT 0,
    Id_Pro INTEGER CONSTRAINT NN_IdProInvit NOT NULL,
    Id_Reunion INTEGER CONSTRAINT NN_IdReuInvit NOT NULL
);

-- ajout de la contrainte clé primaire 
ALTER TABLE Commune ADD CONSTRAINT PK_QA_Commune PRIMARY KEY(Id_Commune);
ALTER TABLE Prospecteur ADD CONSTRAINT PK_QA_Prospecteur PRIMARY KEY(Id_Pro);
ALTER TABLE Reunion ADD CONSTRAINT PK_QA_Reunion PRIMARY KEY(Id_Reunion);
ALTER TABLE Projet ADD CONSTRAINT PK_QA_Projet PRIMARY KEY(Id_Projet);
ALTER TABLE Investissement ADD CONSTRAINT PK_QA_Invest PRIMARY KEY(Id_Projet, Id_Pro);
ALTER TABLE Invitation ADD CONSTRAINT PK_QA_Invit PRIMARY KEY(Id_Pro, Id_Reunion);


-- ajout des foreign key 
ALTER TABLE Prospecteur ADD CONSTRAINT FK_QA_Prospecteur_Id_Commune FOREIGN KEY(Id_Commune) REFERENCES Commune(Id_Commune);
ALTER TABLE Investissement ADD CONSTRAINT FK_QA_Investissement_Id_Pro FOREIGN KEY(Id_Pro) REFERENCES Prospecteur(Id_Pro);
ALTER TABLE Investissement ADD CONSTRAINT FK_QA_Investissement_Id_Projet FOREIGN KEY(Id_Projet) REFERENCES Projet(Id_Projet);
ALTER TABLE Reunion ADD CONSTRAINT FK_QA_Reunion_Id_Projet FOREIGN KEY(Id_Projet) REFERENCES Projet(Id_Projet);
ALTER TABLE Invitation ADD CONSTRAINT FK_QA_Invitation_Id_Pro FOREIGN KEY(Id_Pro) REFERENCES Prospecteur(Id_Pro);
ALTER TABLE Invitation ADD CONSTRAINT FK_QA_Invitation_Id_Reunion FOREIGN KEY(Id_Reunion) REFERENCES Reunion(Id_Reunion);


ALTER TABLE Projet ADD CONSTRAINT Projet_NbrIntervenant_CK CHECK(NbIntervenant >= 0);
ALTER TABLE Projet ADD CONSTRAINT Projet_CoutPlace_CK CHECK(CoutPlace >= 0);
ALTER TABLE Invitation ADD CONSTRAINT Participation_CoutPlace_CK CHECK(Participation = 0 OR Participation = 1);


REM Insertion des données
INSERT INTO Commune(Id_Commune, Nom_Commune, CP_Commune) VALUES (SeqCommune.nextval, 'Paris', '75013');
INSERT INTO Commune(Id_Commune, Nom_Commune, CP_Commune) VALUES (SeqCommune.nextval, 'Saint-Denis', '93200');
INSERT INTO Commune(Id_Commune, Nom_Commune, CP_Commune) VALUES (SeqCommune.nextval, 'Longues sur Mer', '14040');
INSERT INTO Commune(Id_Commune, Nom_Commune, CP_Commune) VALUES (SeqCommune.nextval, 'Anthony', '92200');
INSERT INTO Commune(Id_Commune, Nom_Commune, CP_Commune) VALUES (SeqCommune.nextval, 'Corbreuse', '91300');


INSERT INTO Prospecteur( Id_Pro, Nom_Pro , Prenom_Pro, Adresse_Pro, Tel_Pro, Mail_Pro, Id_Commune) 
VALUES(seqPro.nextval, 'Valant', 'Pierre', '13 rue de la pierre', '0645784135', '', 1);
INSERT INTO Prospecteur( Id_Pro, Nom_Pro , Prenom_Pro, Adresse_Pro, Tel_Pro, Mail_Pro, Id_Commune) 
VALUES(seqPro.nextval, 'Passini', 'Jacques', '3 chemin du Home', '0787548970', 'jacques.75@gmail.com', 2);
INSERT INTO Prospecteur( Id_Pro, Nom_Pro , Prenom_Pro, Adresse_Pro, Tel_Pro, Mail_Pro, Id_Commune) 
VALUES(seqPro.nextval, 'Armandi', 'Maëlle', '45 avenue Henri Martin', '0645789452', 'arm.ma@hotmail.fr', 3);
INSERT INTO Prospecteur( Id_Pro, Nom_Pro , Prenom_Pro, Adresse_Pro, Tel_Pro, Mail_Pro, Id_Commune) 
VALUES(seqPro.nextval, 'Larcoux', 'Edouard', '45 rue de la liberté', '', 'larcoux@yaooh.com', 4);
INSERT INTO Prospecteur( Id_Pro, Nom_Pro , Prenom_Pro, Adresse_Pro, Tel_Pro, Mail_Pro, Id_Commune) 
VALUES(seqPro.nextval, 'Mesrine', 'Bernard', '125 boulevard de la ferté', '', 'mser.bernard@outlook.com', 4);
INSERT INTO Prospecteur( Id_Pro, Nom_Pro , Prenom_Pro, Adresse_Pro, Tel_Pro, Mail_Pro, Id_Commune) 
VALUES(seqPro.nextval, 'Dessange', 'Jean', '458 rue de tyrannie', '', 'larcoux@yaooh.com', 2);


INSERT INTO Projet(Id_Projet, Libelle_Projet, NbIntervenant, CoutPlace) VALUES (SeqProjet.nextval, 'Icy Kube', 2, 45.50);
INSERT INTO Projet(Id_Projet, Libelle_Projet, NbIntervenant, CoutPlace) VALUES (SeqProjet.nextval, 'DevTeam', 1, 70.30);
INSERT INTO Projet(Id_Projet, Libelle_Projet, NbIntervenant, CoutPlace) VALUES (SeqProjet.nextval, 'Tooty', 8, 155.65);
INSERT INTO Projet(Id_Projet, Libelle_Projet, NbIntervenant, CoutPlace) VALUES (SeqProjet.nextval, 'Mobiüs', 10, 125);
INSERT INTO Projet(Id_Projet, Libelle_Projet, NbIntervenant, CoutPlace) VALUES (SeqProjet.nextval, 'Sky Project', 12, 80.99);

INSERT INTO Reunion(Id_Reunion, Theme_Reunion, Id_Projet) VALUES (SeqReunion.nextval, 'Brainstorming', 1);
INSERT INTO Reunion(Id_Reunion, Theme_Reunion, Id_Projet) VALUES (SeqReunion.nextval, 'Brainstorming', 2);
INSERT INTO Reunion(Id_Reunion, Theme_Reunion, Id_Projet) VALUES (SeqReunion.nextval, 'Conception', 2);
INSERT INTO Reunion(Id_Reunion, Theme_Reunion, Id_Projet) VALUES (SeqReunion.nextval, 'Développement', 3);

INSERT INTO Investissement(DateAdhesion, Id_Projet, Id_Pro) VALUES (TO_DATE('13/05/2020', 'DD-MM-YYYY'), 1, 1);
INSERT INTO Investissement(DateAdhesion, Id_Projet, Id_Pro) VALUES (TO_DATE('01/05/2020', 'DD-MM-YYYY'), 3, 2);
INSERT INTO Investissement(DateAdhesion, Id_Projet, Id_Pro) VALUES (TO_DATE('13/05/2020', 'DD-MM-YYYY'), 2, 1);
INSERT INTO Investissement(DateAdhesion, Id_Projet, Id_Pro) VALUES (TO_DATE('24/06/2020', 'DD-MM-YYYY'), 1, 2);
INSERT INTO Investissement(DateAdhesion, Id_Projet, Id_Pro) VALUES (TO_DATE('06/05/2020', 'DD-MM-YYYY'), 4, 3);


INSERT INTO Invitation (Participation, Id_Pro, Id_Reunion) VALUES(1, 1, 1);
INSERT INTO Invitation (Participation, Id_Pro, Id_Reunion) VALUES(0, 4, 2);
INSERT INTO Invitation (Participation, Id_Pro, Id_Reunion) VALUES(1, 3, 2);
INSERT INTO Invitation (Participation, Id_Pro, Id_Reunion) VALUES(1, 2, 3);
INSERT INTO Invitation (Participation, Id_Pro, Id_Reunion) VALUES(1, 1, 3);

