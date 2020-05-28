CREATE OR REPLACE PACKAGE Projet_Package AS

FUNCTION NBEQUIPEPROJET(F_IdProj INTEGER) RETURN NUMBER;
PROCEDURE MAJINTERVENANTS(P_IdProj NUMBER, P_Nbre NUMBER);
PROCEDURE AJOUTPROSPECTION(P_IdProj NUMBER, P_IdProspect INTEGER);
PROCEDURE PRESENCEREUNION(P_IdReu INTEGER);
PROCEDURE PRESENCEPROJETREUNION(P_IdProj INT);
PROCEDURE PROJETINFO;
END Projet_Package;
/

CREATE OR REPLACE PACKAGE BODY Projet_Package AS


FUNCTION NBEQUIPEPROJET(F_IdProj INTEGER) RETURN NUMBER IS
nbProspect INTEGER:= 0;
BEGIN

SELECT COUNT(Id_Pro) INTO nbProspect FROM INVESTISSEMENT WHERE Id_Projet = F_IdProj;

RETURN nbProspect;

END NBEQUIPEPROJET;



PROCEDURE MAJINTERVENANTS(P_IdProj NUMBER, P_Nbre NUMBER) IS
TSQL VARCHAR2(150):= '';
nbInter INTEGER:= 0;

BEGIN

SELECT NbIntervenant INTO nbInter FROM Projet WHERE Id_Projet = P_IdProj; 
IF nbInter + P_Nbre < 0 THEN
    DBMS_OUTPUT.PUT_LINE('Le nombre d''intervenants du projet ' || P_IdProj ||' ne doit pas être négatif !! ');
ELSIF(P_Nbre >= 0) THEN
    TSQL:= 'UPDATE Projet SET NbIntervenant = NbIntervenant + ' || P_Nbre || ' WHERE  Id_Projet =' || P_IdProj;
    EXECUTE IMMEDIATE TSQL;
ELSIF(P_Nbre < 0 AND NBEQUIPEPROJET(P_IdProj) <= nbInter + P_Nbre) THEN
        TSQL:= 'UPDATE Projet SET NbIntervenant = NbIntervenant + ' || P_Nbre || ' WHERE  Id_Projet =' || P_IdProj;
        EXECUTE IMMEDIATE TSQL;
ELSE 
    DBMS_OUTPUT.PUT_LINE('Le nombre de prospecteur du projet ' || P_IdProj|| ' est supérieur au nombre d''intervenants voulu');
END IF;

END MAJINTERVENANTS;


PROCEDURE AJOUTPROSPECTION(P_IdProj NUMBER, P_IdProspect INTEGER) IS

TSQL VARCHAR2(150) := '';
nbInter INTEGER := 0;

BEGIN

SELECT NbIntervenant INTO nbInter FROM Projet WHERE Id_Projet = P_IdProj; 

IF(NBEQUIPEPROJET(P_IdProj) < nbInter) THEN
    EXECUTE IMMEDIATE 'INSERT INTO  Investissement (DateAdhesion, Id_Projet, Id_Pro) VALUES(:1, :2, :3)' USING SYSDATE, P_IdProj, P_IdProspect; 
END IF;

END AJOUTPROSPECTION;


PROCEDURE PRESENCEREUNION(P_IdReu INTEGER) IS

CURSOR C_PRES IS SELECT P.Prenom_Pro, P.Nom_Pro
FROM Invitation I INNER JOIN Prospecteur P ON I.Id_Pro = P.Id_Pro
WHERE I.Id_Reunion = P_IdReu AND I.Participation = 1 ORDER BY P.Nom_Pro, P.Prenom_Pro;

BEGIN

FOR tuple IN C_PRES LOOP
    DBMS_OUTPUT.PUT_LINE(tuple.Prenom_Pro ||' '|| tuple.Nom_Pro);
END LOOP;

END PRESENCEREUNION;


PROCEDURE PRESENCEPROJETREUNION(P_IdProj INT) IS

CURSOR C_REUPROJ IS SELECT R.Id_Reunion
FROM Reunion R WHERE R.Id_Projet = P_IdProj;

BEGIN

FOR tuple in C_REUPROJ LOOP
    DBMS_OUTPUT.PUT_LINE('Reunion : ' || tuple.Id_Reunion);
    BEGIN PRESENCEREUNION(tuple.Id_Reunion);
    END;
END LOOP;

END PRESENCEPROJETREUNION;

PROCEDURE PROJETINFO IS

CURSOR C_PROJ IS SELECT Id_Projet, Libelle_Projet FROM Projet;

BEGIN

FOR tuple in C_PROJ LOOP
    DBMS_OUTPUT.PUT_LINE(NBEQUIPEPROJET(tuple.Id_Projet) || ' personnes dans le projet ' || tuple.Libelle_Projet);

END LOOP;

END PROJETINFO;

END Projet_Package;
/


REM ************************************************
REM Affichage du nombre de prospecteurs du projet 2
SELECT * FROM INVESTISSEMENT;
SELECT Projet_Package.NBEQUIPEPROJET(2) FROM DUAL;

REM ************************************************
REM Mise à jour du nombre d''intervenants du projet 2
SELECT * FROM PROJET;
EXEC Projet_Package.MAJINTERVENANTS(2,5);
SELECT * FROM PROJET;

REM ************************************************
REM Ajout du prospecteur 3 pour le projet 2
SELECT * FROM INVESTISSEMENT;
EXEC Projet_Package.AJOUTPROSPECTION(2,3);
SELECT * FROM INVESTISSEMENT;

REM ************************************************
REM Affichage des prospecteurs présents à la réunion 3
SELECT * FROM INVITATION;
EXEC Projet_Package.PRESENCEREUNION(3);

REM ************************************************
REM Affichage des prospecteurs présents aux réunions du projet 2
SELECT * FROM REUNION;
SELECT * FROM INVITATION;
EXEC Projet_Package.PRESENCEPROJETREUNION(2);

REM ************************************************
REM Affichage des projets et du nombre de prospecteurs y participant
SELECT * FROM PROJET;
SELECT * FROM INVESTISSEMENT;
EXEC Projet_Package.PROJETINFO();