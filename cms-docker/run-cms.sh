#!/bin/sh

# prevent repeated DB Initialization by checking whether Admin exists
python3 -c '
import logging
logging.disable(logging.INFO)

from cms.db import SessionGen, Admin

with SessionGen() as session:
    try:
        if session.query(Admin).all():
            exit(1)
    except:
        exit(0)
exit(1)
'

if [ $? -eq 0 ]; then
    cmsInitDB
    cmsAddAdmin $CMS_ADMIN_USERNAME -p $CMS_ADMIN_PASSWORD
fi

supervisord
