#!/usr/bin/env python
import email
from imapclient import IMAPClient
import sys

IMAPSERVER = 'outlook.office365.com'
USER = 'jorge.tokunaga@mejoredu.gob.mx'
PASSWORD = sys.argv[1]
#FOLDERS=['INBOX', 'INBOX/SOC']
FOLDERS=['INBOX']

with IMAPClient(IMAPSERVER, use_uid=True) as client:
    client.login(USER, PASSWORD)
    for folder in FOLDERS:
        client.select_folder(folder, readonly=True)
        messages = client.search(['UNSEEN'])
#        print(folder,len(messages))
        if int(len(messages)) > 0:
            print(len(messages))
        else:
            print("")