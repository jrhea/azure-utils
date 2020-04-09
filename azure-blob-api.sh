#!/bin/bash

#List the blobs in an Azure storage container.
# \ncomp:list\nrestype:container
# ?comp=list&restype=container

#List the containers in an Azure storage container.
# \ncomp:list
# ?comp=list

#./azure-blob-api.sh -c download jrwaterlossiot data Drive_WaterLeakAlarms_20170606_170606.csv ilXZLG49snUq3aSHtgXFY0qVeRvIM/cAfRjwnTQ3AigdAJrmyOjIH2Tv06jq62ZCM0QhrjYK4vj3n6EeatYTqw==

command=""

usage () { 
  echo "Usage: $0 [-c list] <storage-account-name> <container-name> <access-key>"
  echo "       $0 [-c download] <storage-account-name> <container-name> <blob-name> <access-key>"
}

if [ "$#" -eq 0 ]; then
  usage;
  exit 1;
fi

while getopts c: arg; do
  case $arg in
      c )  command="$OPTARG" ;;    
    [?] )  usage;
           exit 1;;
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

if [ -z "$command" ]; then
  echo "You must include -c option"
  usage;exit 1;
elif [ "$command" == "list" ]; then
  if [ "$#" -ne 3 ]; then
    usage; exit 1;
  fi
  storage_account="$1"
  container_blob_name="$2"
  access_key="$3"
  queryString="?comp=list&restype=container"
  comp_restype=$(echo $queryString | tr '=' ':' | tr '?' '\n' | tr '&' '\n')
  
elif [ "$command" == "download" ]; then
  if [ "$#" -ne 4 ]; then
    usage; exit 1;
  fi
  storage_account="$1"
  container_blob_name="$2/$3"
  access_key="$4"
  queryString=""
  comp_restype=""    
else
  usage; exit 1;
fi


blob_store_url="blob.core.windows.net"
authorization="SharedKey"

request_method="GET"
request_date=$(TZ=GMT LC_ALL=en_US.utf8 date "+%a, %d %h %Y %H:%M:%S %Z")
#request_date="Mon, 18 Apr 2016 05:16:09 GMT"
storage_service_version="2015-04-05"

# HTTP Request headers
x_ms_date_h="x-ms-date:$request_date"
x_ms_version_h="x-ms-version:$storage_service_version"

# Build the signature string
canonicalized_headers="${x_ms_date_h}\n${x_ms_version_h}"
#canonicalized_resource="/${storage_account}/${container_name}"

canonicalized_resource="/${storage_account}/${container_blob_name}"

#string_to_sign="${request_method}\n\n\n\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}\ncomp:list\nrestype:container"
string_to_sign="${request_method}\n\n\n\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}${comp_restype}"


# Decode the Base64 encoded access key, convert to Hex.
decoded_hex_key="$(echo -n $access_key | base64 -d -w0 | xxd -p -c256)"


# Create the HMAC signature for the Authorization header
signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary |  base64 -w0)

authorization_header="Authorization: $authorization $storage_account:$signature"

curl \
  -H "$x_ms_date_h" \
  -H "$x_ms_version_h" \
  -H "$authorization_header" \
  -H "Content-Length: 0"\
     "https://${storage_account}.${blob_store_url}/${container_blob_name}${queryString}"
     
     
#     "https://${storage_account}.${blob_store_url}/${container_name}?comp=list&restype=container"     