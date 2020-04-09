# upload.py

### Description

The upload python module uses a SAS token to upload files to Azure blob storage.

### Installation

Install miniconda software and create an environment with 

* python 3.4
* requests

### Usage 

Log onto Azure and generate a SAS token.  Edit the upload.py file and enter the corresponding values into the token_dict variable.  Then use the module as follows:

```python
import upload
upload.upload_to_azure('<local file name>', '<blob name>', 'container name>')
```

# aad.js

### Description

Javascript code to authenticate with Azure Active Directory

### Installation

N/A

### Usage 

In order to get an APP ID, register you web app here:

  https://apps.dev.microsoft.com
  
Here is an example of how to authenticate using aad.js.  

```html
<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta charset="UTF-8">
        <script src="https://secure.aadcdn.microsoftonline-p.com/lib/1.0.14/js/adal.min.js"></script>
        <script src="aad.js"></script>

    </head>
    <body>
        <script>
          var user = aad.authenticate('<APP_ID>',window.location,'usaa.com');
          if(user) {
              console.log(user.profile.given_name+' '+user.profile.family_name);
          }
          else
          {
             console.log("user is undefined");
          }
        </script>
    </body>
</html>
```

*NOTE:* see the example subdirectory for more code samples

### Graph API Endpoints
#### Current User
Basic Info: https://graph.microsoft.com/v1.0/me/

Manager: https://graph.microsoft.com/v1.0/me/manager

Direct Reports: https://graph.microsoft.com/v1.0/me/directReports

Group Membership: https://graph.microsoft.com/v1.0/me/memberOf

#### Groups
All Groups: https://graph.microsoft.com/v1.0/groups

Group Members https://graph.microsoft.com/v1.0/groups/GROUP_ID/members

*NOTE:* Find GROUP_ID by querying the All Groups or Group Membership endpoint


