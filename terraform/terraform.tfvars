se_account  = "se15"
domain      = "clemenslabs.com"
admin_cidr_list = [
# "63.251.234.64/28" # The first 4 CIDR blocks are Illumio HQ
# "67.207.111.16/29" # uncomment if needed
# "12.169.99.40/29"
# "142.215.161.228/30"
  "142.215.23.80/28", # Illumio VPN
  "73.51.167.180/32", # Home IP
  "172.58.120.0/21"   # Home IP #2
]