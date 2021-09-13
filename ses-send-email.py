# Install required package
# pip install emails [--user ish]

import emails
# Prepare the email
message = emails.html(
    html="<h1>SES TEST</h1>",
    subject="SES TEST",
    mail_from="fromEmail@example.com",
)

# Send the email
r = message.send(
    to="toEmail@example.com", 
    smtp={
        "host": "my-aws-smtp-server", 
        "port": 587, 
        "timeout": 5,
        "user": "ses-smtp-user-iam-access-key-id",
        "password": "ses-smtp-user-iam-secret-access-key",
        "tls": True,
    },
)

# Check if the email was properly sent
assert r.status_code == 250

# Reference:
# https://www.databulle.com/blog/code/python-emails-amazon-ses.html
