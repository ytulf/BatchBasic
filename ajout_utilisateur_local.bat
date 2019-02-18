
@ECHO OFF
REM Chemins de base pour les profils et Répertoire Utilisateurs
REM Modifiez ces Variables si vous souhaitez les stockés ailleurs
SET PROFILS=C:\Users
SET BASE=C:\Users

REM Prise de Renseignements Utilisateur à créer

:BEG
CLS
ECHO *******************************
ECHO **     Infos Utilisateur     **
ECHO *******************************
ECHO(
SET /P PRE=Entrez le Prénom : 
SET /P NOM=Entrez le Nom : 
SET /P COM=Commentaire : 
SET /P MDP=Mot de passe : 
CHOICE /N /M "L'utilisateur pourra t'il changer son mot de passe ? (o/n)"
FOR /F "tokens=%ERRORLEVEL%" %%P IN ("YES NO") DO SET CHPWD=%%P
CHOICE /N /M "Activer le compte ? (o/n)"
FOR /F "tokens=%ERRORLEVEL%" %%A IN ("YES NO") DO SET ACT=%%A
CHOICE /N /M "Souhaitez vous restreindre l'accés sur des créneaux horaires ? (o/n)"
IF %ERRORLEVEL%==2 (
SET TIMES=ALL
) ELSE (
ECHO(
ECHO Entrez les restrictions comme suivant :
ECHO Jour=M T W Th F Sa Su
ECHO Heure=heures entiere avec séparation 1h entiere
ECHO JourDebut-JourFin,Heure:Debut-Heure:Fin
ECHO Jour1,Heure:Debut-Heure:Fin;Jour2,Heure:Debut-Heure:Fin;...
ECHO(
SET /P TIMES=Restrictions : 
)

REM Définition des Variables

SET NC=%PRE% %NOM%
SET USER=%PRE%.%NOM%
SET PROF=%PROFILS%\%USER%
SET HD=%BASE%\%USER%

REM Affichage des informations pour Vérification

CLS
ECHO *******************************************
ECHO **   Confirmation Création Utilisateur   **
ECHO *******************************************
ECHO(
ECHO Nom Complet :        %NC%
ECHO Utilisateur :        %USER%
ECHO Mot de passe :        %MDP%
ECHO Peut changer PWD :    %CHPWD%
ECHO Commentaires :        %COM%
ECHO Compte actif :        %ACT%
ECHO Chemin Profil :        %PROF%
ECHO Dossier de base :    %HD%
ECHO Restrictions :        %TIMES%
ECHO(
CHOICE /C ONA /N /M "Informations Correctes ? (O)ui (N)on (A)nnuler : "
IF %ERRORLEVEL%==2 GOTO BEG
IF %ERRORLEVEL%==3 GOTO END
REM Création Utilisateur

net user %USER% %MDP% /add /fullname:"%NC%" /comment:"%COM%" /active:%ACT% /passworchg:%CHPWD% /homedir:"%HD%" /profilepath:"%PROF%" /times:%TIMES%
net localgroup Invit‚s %USER% /add
net localgroup Utilisateurs %USER% /delete
CLS
ECHO ***** Cr‚ation de %NC% : OK *****
ECHO(
CHOICE /N /M "Voulez vous créer un autre utilisateur ? (O)ui/(N)on : "
IF %ERRORLEVEL%==1 GOTO BEG
:END
