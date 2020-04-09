import requests

token_dict = {'sv': '<enter value>',
              'ss': '<enter value>',
              'srt': '<enter value>',
              'sp': '<enter value>',
              'se': '<enter value>',
              'st': '<enter value>',
              'spr': '<enter value>',
              'sig': '<enter value>'}

def upload_to_azure(file_name, blob_name, container_name='pdfs'):
	"""Upload file to azure blob."""

	headers = {'x-ms-blob-type': 'BlockBlob'}

	# Url with SAS Token
	url = (
    	'https://rkdvehicleimageanalysis.blob.core.windows.net'
    	'/{container_name}'
    	'/{blob_name}'
    	'?sv={sv}'
    	'&ss={ss}'
    	'&srt={srt}'
    	'&sp={sp}'
    	'&se={se}'
    	'&st={st}'
    	'&spr={spr}'
    	'&sig={sig}'
	).format(container_name=container_name,
	         blob_name=blob_name,
	         **token_dict)

	with open(file_name, 'rb') as file_handle:
		data = file_handle.read()

	requests.put(url, headers=headers, data=data)