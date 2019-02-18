REM ******************************************
REM ***** Script de création utilisateur *****
REM *****        Active Directory        *****
REM *****        par SAVIO Thomas        *****
REM ******************************************
REM ---------------------------------------------------
@ECHO OFF
TITLE Script Creation Utilisateur Active Directory
SET VER=1.10
SET DOM=%USERDNSDOMAIN%
SET PDC=frmanad.%DOM%
SET PWD=P@ssw0rd.

:BEG
CLS
ECHO *******************************************
ECHO *** Création dynamique d'un utilisateur ***
ECHO ***                                     ***
ECHO ***          Version : %VER%            ***
ECHO *******************************************
ECHO(
SET /P LN=Nom de l'utilisateur : 
SET /P FN=Prénom de l'utilisateur : 
SET /P TEL=Téléphone personnel : 
SET USER=%FN%.%LN%
SET MAIL=%USER%@%DOM%
REM ========================= Vérification que l'utilisateur n'existe pas déjà =========================
DSQUERY user -name "%USER%" | DSGET user 1>nul 2>&1
IF %ERRORLEVEL% EQU 0 (
ECHO(
ECHO *** Erreur : Utilisateur déja éxistant ! Appuyez sur une touche et corrigez votre saisie ...
PAUSE >nul
CLS
GOTO BEG
)

REM ========== Création des OU en fonction du Site et du Service d'affectation de l'utilisateur et vérification incohérences ==========
:OU
REM ========================= Site de Travail =========================
ECHO(
ECHO C: Angoulême
ECHO M: Bordeaux
ECHO S: Limoges
ECHO P: Périgueux
ECHO B: Brive-La-Gaillarde
CHOICE /C CMSPB /N /M "Selectionnez le Site de travail : "
SET V=%ERRORLEVEL%
FOR /F "tokens=%V%" %%i IN ("Angoulême Bordeaux Limoges Périgueux Brive-La-Gaillarde") DO (SET SITE=%%i)

REM ========================= Service de Travail =========================
ECHO(
ECHO B: Secrétaire
ECHO S: Direction
ECHO C: Compta
ECHO D: Standardiste
ECHO T: Technicien
ECHO R: Commerciaux
ECHO A: Responsables
CHOICE /C BSCDTRA /N /M "Sélectionnez le Service : "
SET S=%ERRORLEVEL%
FOR /F "tokens=%S%" %%i IN ("Secrétaire Direction Compta Standardiste Technicien Commerciaux Responsables") DO (SET SERV=%%i)

REM ========================= Création OU et vérification =========================
SET OU=OU=User_%SITE%,OU=Site-%SITE%,OU=Groupe séquence,DC=btssio,DC=com
DSGET OU %OU% >nul
IF %ERRORLEVEL% NEQ 0 (
CLS
ECHO %OU%
ECHO *** Erreur OU inexistante ! Appuyez sur une touche et corrigez votre saisie ...
PAUSE >nul
GOTO OU
)

REM ========================= Attribution des chemins de profils et documents =========================
SET HD=\\%PDC%\Documents\%SITE%\%SERV%\%USER%
IF %SERV%==Secrétaire (
SET PROFIL=\\%PDC%\Profils$\%SITE%\%SERV%\%USER%
) ELSE (
IF %SERV%==Direction (
SET PROFIL=\\%PDC%\Profils$\%SITE%\%SERV%\%USER%
) ELSE (
IF %SERV%==Compta (
SET PROFIL=\\%PDC%\Profils$\%SITE%\%SERV%\%USER%
) ELSE (
IF %SERV%==Standardiste (
SET PROFIL=\\%PDC%\Profils$\%SITE%\%SERV%\%USER%
) ELSE (
IF %SERV%==Technicien (
SET PROFIL=\\%PDC%\Profils$\%SITE%\%SERV%\%USER%
) ELSE (
IF %SERV%==Commerciaux (
SET PROFIL=\\%PDC%\Profils$\%SITE%\%SERV%\%USER%
) ELSE (
IF %SERV%==Responsables (
SET PROFIL=\\%PDC%\Profils$\%SITE%\%SERV%\%USER%
) ELSE (
SET PROFIL=Local
)
)

REM ========================= Résumé infos Utilisateur et Confirmation =========================
CLS
ECHO **********************************
ECHO *** Renseignements Utilisateur ***
ECHO **********************************
ECHO(
ECHO Nom :            %LN%
ECHO Prénom :        %FN%
ECHO Téléphone personnel :    %TEL%
ECHO MAIL :            %MAIL%
ECHO Service :        %SERV%
ECHO Site de travail :    %SITE%
ECHO(
ECHO Compte :        %USER%
ECHO Profil :        %PROFIL%
ECHO Dossier Documents :    %HD%
ECHO(
ECHO Unit‚ Organisation :    %OU%
ECHO Domaine :        %DOM%
ECHO(
CHOICE /C ONA /N /M "Merci de confirmer l'exactitude des Informations (O)ui (N)on (A)nnuler :"
IF %ERRORLEVEL%==2 GOTO BEG
IF %ERRORLEVEL%==3 GOTO END

REM ========================= CREATION DU FICHIER LOG =========================
:LOG
SET LP=\\%PDC%\log$\Utilisateurs\%SITE%.%SERV%.%USER%.log

ECHO ###################### LOG CREATION Utilisateur %USER% ######################>%LP%
ECHO(>>%LP%
ECHO Date :            %DATE% %TIME%>>%LP%
ECHO Script :        %~dp0%~nx0>>%LP%
ECHO Version :        %VER%>>%LP%
ECHO Créateur :        %USERNAME%>>%LP%
ECHO Depuis le Poste :    %COMPUTERNAME%>>%LP%
ECHO(>>%LP%
ECHO ######################################## INFOS UTILISATEUR ########################################>>%LP%
ECHO(>>%LP%
ECHO Nom :        %LN%>>%LP%
ECHO Prénom :    %FN%>>%LP%
ECHO Tel :        %TEL%>>%LP%
ECHO Email :        %MAIL%>>%LP%
ECHO Site :        %SITE%>>%LP%
ECHO Service :    %SERV%>>%LP%
ECHO(>>%LP%
ECHO Login :        %USER%>>%LP%
ECHO Password :    %PWD%>>%LP%
ECHO OU :        %OU%>>%LP%
ECHO Profil :    %PROFIL%>>%LP%
ECHO Documents :    %HD%>>%LP%
ECHO(>>%LP%
ECHO ######################################## RESULTATS ########################################>>%LP%
ECHO(>>%LP%

REM ========== COMMANDES CREATION REEL UTILISATEUR avec log des résultats des commandes ==========
ECHO *** Création Répertoire %HD%>>%LP%
MKDIR %HD% 1>>%LP% 2>>&1
ECHO(>>%LP%

ECHO *** Attribut caché répertoire %HD%>>%LP%
ATTRIB +H %HD% 1>>%LP% 2>>&1
ECHO(>>%LP%

ECHO *** Suppression des héritages parents %HD%>>%LP%
ICACLS %HD% /inheritance:d 1>>%LP% 2>>&1
ECHO(>>%LP%

ECHO *** Suppression des droits de sécurité Utilisateurs pour %HD%>>%LP%
ICACLS %HD% /remove:g Utilisateurs 1>>%LP% 2>>&1
ECHO(>>%LP%

ECHO *** Création Utilisateur "CN=%USER%,%OU%">>%LP%
IF %PROFIL%==Local (
DSADD user "CN=%USER%,%OU%" -samid "%USER%" -upn %MAIL% -fn %FN% -ln %LN% -display "%FN% %LN%" -hometel "%TEL%" -email %MAIL% -dept %SERV% -company %SITE% -hmdir %HD% -pwd %PWD% -canchpwd yes -mustchpwd yes -disabled no 1>>%LP% 2>>&1
) ELSE (
DSADD user "CN=%USER%,%OU%" -samid "%USER%" -upn %MAIL% -fn %FN% -ln %LN% -display "%FN% %LN%" -hometel "%TEL%" -email %MAIL% -dept %SERV% -company %SITE% -profile %PROFIL% -hmdir %HD% -pwd %PWD% -canchpwd yes -mustchpwd yes -disabled no 1>>%LP% 2>>&1
)

ECHO(>>%LP%
ECHO(>>%LP%
ECHO *** Ajout au groupe %SERV%>>%LP%
DSMOD group "CN=%SERV%,OU=Groupes,DC=skynet,DC=t2si" -addmbr "CN=%USER%,%OU%" 1>>%LP% 2>>&1
ECHO(>>%LP%
ECHO(>>%LP%
ECHO *** Ajout au groupe %SITE%>>%LP%
DSMOD group "CN=%SITE%,OU=Groupes,DC=skynet,DC=t2si" -addmbr "CN=%USER%,%OU%" 1>>%LP% 2>>&1
ECHO(>>%LP%
ECHO(>>%LP%

ECHO *** Ajout des droits de sécurité pour %USER% sur %HD%>>%LP%
ICACLS %HD% /grant:r SKYNET1\%USER%:(F) 1>>%LP% 2>>&1
ECHO(>>%LP%
ECHO *** Suppression des droits de sécurité pour %USERNAME% sur %HD%>>%LP%
ICACLS %HD% /remove:g %USERNAME% 1>>%LP% 2>>&1
ECHO(>>%LP%

REM *** Modification des droits de sécurité Lecture & Exécution sur le fichier log
ICACLS %LP% /inheritance:d 1>>nul 2>>&1
ICACLS %LP% /remove:g %USERNAME% 1>>nul 2>>&1
ICACLS %LP% /grant:r Utilisateurs:(RX) 1>>nul 2>>&1

CLS
ECHO Cr‚ation utilisateur %FN% %LN% termin‚
ECHO Fichier log : %LP%
ECHO(
ECHO(
CHOICE /M "Voulez-vous ajouter un autre utilisateur "
IF %ERRORLEVEL%==1 GOTO BEG

:END
