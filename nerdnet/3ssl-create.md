# Create SSl certificate for the domain christensen.no

This is done on a mac.

NB! as you see i use password JALLA! this is ofcourse not the pw i used.

```bash
brew install certbot
```

Now we can create the certificate using the DNS challenge. We want the certificate for all of the subdomains of christensen.no.

```bash
sudo certbot certonly --manual '--preferred-challenges=dns' --email terje@christensen.no -d '*.christensen.no' -d christensen.no
```

```text
Password:
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for *.christensen.no and christensen.no

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.christensen.no.

with the following value:

JKUfiJ5giJB57puJIAwjRLeJwauYTlIXQO6XJoiPuqw

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.christensen.no.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/christensen.no/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/christensen.no/privkey.pem
This certificate expires on 2024-06-17.
These files will be updated when the certificate renews.

NEXT STEPS:
- This certificate will not be renewed automatically. Autorenewal of --manual certificates requires the use of an authentication hook script (--manual-auth-hook) but one was not provided. To renew this certificate, repeat this same certbot command before the certificate's expiry date.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

Get the pem files:

```bash
sudo cat /etc/letsencrypt/live/christensen.no/fullchain.pem
sudo cat /etc/letsencrypt/live/christensen.no/privkey.pem
```

Save these files in the secrets/cert/christensen folder.

Convert the Certificate to PFX Format

```bash
cd secrets/cert

openssl pkcs12 -export -out christensen.no.pfx -inkey ./christensen/privkey.pem -in ./christensen/fullchain.pem -passout pass:JALLA!
```

check that you have the file:

```bash
ls -l christensen.no.pfx
```

You should get this output:

```text
-rw-------  1 terchris  staff  3104 Mar 19 06:48 christensen.no.pfx
```
