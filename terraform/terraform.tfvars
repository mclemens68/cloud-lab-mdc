# Modify the below variables to correspond to your local setup.

# This could be anything unique, but recommend to use your se account handle.
# It will be used as your unique aws provider, as well as in
# things like Azure resource group names, etc...
se_account  = "se15"

# You'll want to register a unique domain in route53 and enter that name here.
# Terraform is setup to pull this from your personal aws account. 
domain      = "clemenslabs.com"

# Should only need to modify this if you want to use a different SSH keyfile name
# in the ~/.ssh directory.
# Make sure you use an rsa key as Azure vm's don't support ed25519 keys yet
sshkey      = "id_rsa"

# Delete the last 2 entries and replace with the public IP addresses of
# your home network or anywhere else where you'll want to access the public
# VM's. Note when on the road you can always get in if on the Illumio VPN.
# Don't add more than 6 CIDR blocks to this list or you'll run into AWS SG limitations.
admin_cidr_list = [
# "63.251.234.64/28" # The first 4 CIDR blocks are Illumio HQ
# "67.207.111.16/29" # uncomment if needed
# "12.169.99.40/29"
# "142.215.161.228/30"
  "142.215.23.80/28", # Illumio VPN
  "73.51.167.180/32", # Home IP
  "172.58.120.0/21"   # Home IP #2
]