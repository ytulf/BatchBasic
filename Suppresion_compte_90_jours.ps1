# Script pour automatiser la désactivation des comptes AD dont la dernière connexion > 90 jours
# Auteur : Thomas SAVIO

# Force le type d'exécution
Set-ExecutionPolicy Unrestricted

# Importe le module AD
Import-Module ActiveDirectory
$LockedAccount = Search-ADAccount -UsersOnly -AccountInactive -TimeSpan 90.00:00:00 -SearchBase "OU=Users,DC=Domaine,DC=Local" | Where {$_.enabled}

$LockedAccount | Set-ADUser

$smtpServer = "mail.domaine.local"
$from = "DisableADAccount <powershell@domaine.local>"
$to = "Helpdesk <helpdesk@domaine.local>"
$subject = "[INFO] Comptes AD last logon > 90 jours"
$body = "
<html>
  <head></head>
     <body>
        <p>Bonjour,<br />
           Les comptes suivants sont désactivé à cause d'une inactivité de plus de 90 jours<br />:
           $LockedAccount
        </p>
      </body>
</html>"

Send-MailMessage -smtpserver $smtpserver -from $from -to $to -subject $subject -body $body -bodyasHTML -priority High
