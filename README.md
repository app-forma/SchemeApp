SchemeApp
=========

Git:


&rarr; Öppna terminalen och skriv: <b>git clone https://github.com/rickardz/SchemeApp/</b>

&rarr; Ta dig till din ssh katalog: <b>cd ~/.ssh/</b> skapa sedan en ny ssh nyckel: <b>ssh-keygen -t rsa -C "your-email-address"</b>

När du blir tillfrågad vilken fil den ska sparas i skriver du: <b>id_rickardz</b> och sen enter.
Sen promptas du om ett lösenord, här skriver du: <b>rickardz123</b>
Efter detta bör terminalen logga att nyckeln är sparad.

&rarr; Logga sedan in på vårt gemensamma konto på github, användarnamn: rickardz, lösen: rickardz123.
   Tryck sedan på settings uppe i högra hörnet och sedan på SSH Keys. Tryck på Add SSH Key, döp nyckeln till
   ditt namn och gå sedan tillbaka till terminalen. Skriv <b>nano ~/.ssh/id_rickardz.pub</b>, kopiera sedan
   strängen och klistra in den i Key rutan på github. OBS strängen ska börja med "ssh". Tryck sedan Add Key.

&rarr; Skapa en config fil i din ssh-mapp om du inte redan har en(du borde ha en): <b>nano ~/.ssh/config</b>
   Här ligger din andra nyckel för ditt egna gitkonto. Tryck ner dig till en ny rad och skriv in detta:

<b>      Host github-rickardz<br>
	       User rickardz<br>
	       HostName github.com<br>
	       PreferredAuthentications publickey<br>
	       IdentityFile ~/.ssh/id_rickardz</b>

Spara med ctrl+O.

&rarr; Gå nu tillbaka till SchemeApp katalogen i terminalen. Nu behöver vi koppla vår nyckel från config-filen till
   vår repository på git:

   <b>git remote add rickardz git@github-rickardz:rickardz/SchemeApp.git</b>

&rarr; Testa nu att det funkar genom att öppna upp README.md och skriv "ditt namn was here" på en ny rad och spara.
   Gå tillbaka till terminale och skriv: <b>git add .</b> &larr; glöm inte punkten. Skriv sedan: <b>git commit -m 'ditt namns first commit'</b>
   Avsluta sedan med att skriva: <b>git push rickardz master</b>

erik was here
mackan was here