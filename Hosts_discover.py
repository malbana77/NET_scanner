#!/bin/python3

import scapy.all as scapy
import argparse
from mac_vendor_lookup import MacLookup
import os


def get_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--target", dest="target", help="Target IP / IP range")
    parser.add_argument("-o", "--output", dest="output", help="Save the result in text file", action='store_true')
    options = parser.parse_args()
    if not options.target:
        parser.error("[-] Please specify an IP address, use --help for more info.")
    return options

def scan(ip):

    arp_req = scapy.ARP(pdst=ip)
    broadcast = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")
    arp_arp_broad = broadcast/arp_req
    answered_list = scapy.srp(arp_arp_broad, timeout=1, verbose=False)[0]
    clients_list = []
    for element in answered_list:
        os = (MacLookup().lookup(format(element[1].hwsrc)))
        clients_dect = {"ip": element[1].psrc, "mac": element[1].hwsrc, "OS": os }
        clients_list.append(clients_dect)
    return clients_list

def print_result(result_list):
	print ("IP\t\t\tMac address\t\tVendor\n------------------------------------------------------------------")
	if os.path.exists('hosts.txt'):
		os.remove('hosts.txt')
	for client in result_list:
		print (client["ip"] + "\t\t" + client["mac"] + "\t" + client["OS"])
		if options.output == True :
			outfile = open('hosts.txt', 'a')
			ip = client["ip"]
			outfile.write(ip + "\n")


options = get_arguments()
scan_result = scan(options.target)
print_result(scan_result)
