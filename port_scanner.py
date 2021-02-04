#!/usr/bin/env python
import nmap
import optparse
import socket
import subprocess


def get_arguments():
    parser = optparse.OptionParser()
    # Handling Command-line Arguments
    parser.add_option("-t", "--target", dest="target", help="Target IP")
    (options, arguments) = parser.parse_args()
    if not options.target:
        #Code to handle error
        parser.error("[-] Please specify an target, use --help for more info.")
    return options

options = get_arguments()
nm = nmap.PortScanner()
tar = options.target
# Add Banner

def isOpen(ip, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:

        s.connect((ip, int(port)))
        s.shutdown(2)
        return True
    except:
        return False

# COMMAND = "ping " + format(tar) + " -w 5 | grep 'received' | cut -d ',' -f 2 | cut -d ' ' -f 2 | sed -n 1p"
# rr = (subprocess.call(COMMAND, shell=True))
output = subprocess.check_output("ping " + format(tar) + " -w 5 | grep 'received' | cut -d ',' -f 2 | cut -d ' ' -f 2 | sed -n 1,1p", shell=True)
n = str(5)
if n in str(output):
    for port in range(1, 65535):
        try:
            service = socket.getservbyport(port)
            r = isOpen(tar, port)
            if r == True:
                print ("Port " + format(port) + " is open " + service)
        except:
            continue
    nm = nmap.PortScanner()
    machine = nm.scan(format(tar), arguments='-O')
    try:
        os = machine['scan'][format(tar)]['osmatch'][0]['osclass'][0]['osfamily']
        print ('OS:' + os)
    except IndexError:
        print ("error")
        exit()
    except KeyError:
        print ("error")
        exit()

else:
    print ("error")
    exit()




