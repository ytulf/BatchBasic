REM ***************************************
REM *** Batch de sauvegarde de fichier  ***
REM ***************************************

@echo off
XCOPY c:\Repertoire1 \\serveurfichiers\sauvegarde\%username% /D /E /H /I /R /Y

REM /D:j-m-a  Copie les fichiers modifiés à partir de la date spécifiée. Si aucune date n'est donnée, copie uniquement les fichiers dont l'heure source est plus récente que l'heure de destination
REM /E        Copie les répertoires et sous répertoires
REM /H        Copie les fichiers cachés et les fichiers systèmes
REM /I        Si la destination n'existe pas et que plus d'un fichier est copié, on considère la destination comme devant être un répertoire
REM /R        Remplace les fichiers en lecture seule
REM /Y        Supprime la demande de confirmation de remplacement de fichiers de destination existants

REM Pause
