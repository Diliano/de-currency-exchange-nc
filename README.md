# AWS-Powered Password Manager

In this sprint, you will create a simple command-line application to store and retrieve passwords. The passwords will be stored in [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/). Accessing your AWS account (with your Access Key Id and Secret Key) will be considered sufficient authorisation to retrieve the passwords.

The application should allow you to:
 - store a user id and password as a secret in `secretsmanager`
 - list all the stored secret
 - retrieve a secret - the resulting user id and password should not be printed out but should be stored as environment variables.
 - delete a secret.

The basic workflow should look like this:
```bash
awsume sandbox # or whatever means you use to authenticate
[Sandbox]
python password_manager.py
> Please specify [e]ntry, [r]etrieval, [d]eletion, [l]isting or e[x]it:
y
> Invalid input. Please specify [e]ntry, [r]etrieval, [d]eletion, [l]isting or e[x]it:
l
> 0 password(s) available
> Please specify [e]ntry, [r]etrieval or [l]isting:
e
> Secret identifier: 
Missile_Launch_Codes
> UserId:
bidenj
> Password:
Pa55word
> Secret saved.
> Please specify [e]ntry, [r]etrieval, [d]eletion, [l]isting or e[x]it:
l
> 1 secret(s) available
  Missile_Launch_Codes
> Please specify [e]ntry, [r]etrieval, [d]eletion, [l]isting or e[x]it:
r
> Specify secret to retrieve:
Missile_Launch_Codes
> UserId stored in CURRENT_USER_ID environment variable.
> Password stored in CURRENT_PASSWORD environment variable.
> Please specify [e]ntry, [r]etrieval, [d]eletion, [l]isting or e[x]it:
d
> Specify secret to delete:
Missile_Launch_Codes
> Deleted
> Please specify [e]ntry, [r]etrieval, [d]eletion, [l]isting or e[x]it:
x
> Thank you. Goodbye.

# In the shell:
echo ${CURRENT_USER_ID}
bidenj 
echo ${CURRENT_PASSWORD}
pa55word
```

 - Ensure that your code is thoroughly unit-tested. Use mocks if you need to. (Use of the `moto` library to mock `secretsmanager` is encouraged but not required.)
 - Ensure that you use `try...except` to manage potential errors.

 There are many enhancements you could make. Feel free to increase the sophistication of the interface.
 
