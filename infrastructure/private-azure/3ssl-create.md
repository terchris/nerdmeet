# Create SSl certificate for the domain arezibo.no


NB! as you see i use password JALLA! this is ofcourse not the pw i used.

```bash
brew install certbot
```

Now we can create the certificate using the DNS challenge. We want the certificate for all of the subdomains of arezibo.no.

```bash
sudo certbot certonly --manual '--preferred-challenges=dns' --email terje@arezibo.no -d '*.arezibo.no' -d arezibo.no
```

```text
Password:
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.3-September-21-2022.pdf. You must
agree in order to register with the ACME server. Do you agree?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing, once your first certificate is successfully issued, to
share your email address with the Electronic Frontier Foundation, a founding
partner of the Let's Encrypt project and the non-profit organization that
develops Certbot? We'd like to send you email about our work encrypting the web,
EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: yes
Account registered.
Requesting a certificate for *.arezibo.no and arezibo.no

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.arezibo.no.

with the following value:

ln9aalQE16Ny1EVC_JzUHDXSHtpPgHDvihhlTjSNWr4

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.arezibo.no.

with the following value:

9CDmmNB5vB2jUALjPYzy4wdidAs1wApVa8RVk2FPlRs

(This must be set up in addition to the previous challenges; do not remove,
replace, or undo the previous challenge tasks yet. Note that you might be
asked to create multiple distinct TXT records with the same name. This is
permitted by DNS standards.)

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.arezibo.no.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/arezibo.no/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/arezibo.no/privkey.pem
This certificate expires on 2024-06-13.
These files will be updated when the certificate renews.

NEXT STEPS:
- This certificate will not be renewed automatically. Autorenewal of --manual certificates requires the use of an authentication hook script (--manual-auth-hook) but one was not provided. To renew this certificate, repeat this same certbot command before the certificate's expiry date.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

```

Convert the Certificate to PFX Format

```bash
cd secrets

openssl pkcs12 -export -out arezibo.no.pfx -inkey privkey.pem -in fullchain.pem -passout pass:JALLA!
```

check that you have the file:

```bash
ls -l arezibo.no.pfx
```

You should get this output:

```text
-rw-------  1 terchris  staff  3088 Mar 15 18:17 arezibo.no.pfx
```
