# This command wil get the hostname 
HOSTNAME=$(hostname) 
echo "Hostname: $HOSTNAME"

#The upcoming command is used to display the OS and it's version.
#The command below will print the OS name.
OSName=$(uname -s)   

#This command below is to print the OS version.
OSVersion=$(lsb_release -d | grep Description | awk '{print $2, $3, $4}')
echo "OS: $OSName #OSVerdion"

#This line of command os to get the system uptime.
UPTIME=$(uptime ) 
echo "Uptime: $UPTIME"

echo ""


#This line of command is used to get the information abou CPU model and processor
echo "Hardware Information"
echo "--------------------"

#Ths line of command is used to display CPU processor and vendor.
CPUVendor=$(lscpu | grep "Vendor ID:" | awk '{print $3}') 
echo "cpuprocessor: $CPUVendor"

#This command below is used to display model of CPU.
CPUMODEL=$(lscpu | grep "Model name:" | awk -F': ' '{print $2}') 
echo "cpumodel: $CPUMODEL"

#This is will current CPU speed (in MHz).
CPUCURRENTSPEED=$(cat /proc/cpuinfo | grep -m 1 "cpu MHz")
echo "$CPUCURRENTSPEED"

#This will get the maximum speed of CPU (in MHz).
CPUMAXSPEED=$(sudo dmidecode -t processor | grep -m 1 "Max Speed") 
echo "$CPUMAXSPEED"

#The command below is used for calculating RAM Size.
RAMSIZE=$(cat /proc/meminfo | grep MemTotal) 
echo "$RAMSIZE"


#This command is used to fin out the name, model and size of the disk.
Disks=$(lsblk -o NAME,MODEL,SIZE | grep '^sd') 
echo "Disks Info is: $Disks"


#This line of code displays the model and manufacturer of the video card.
VIDEOCARD=$( lspci | grep -i vga) 
echo "video card is: $VIDEOCARD"

echo ""
echo ""

echo "Network Information"
echo "------------------"


#To find the fully qualified domain of the system, this command is used.
FQDN=$(hostname --fqdn) 
echo "FQDN is:- $FQDN"


#This command is used to display host ip address of the machine.
HOSTADDRESS=$(hostname -I | awk '{print $1'} ) 
echo "Host address is: $HOSTADDRESS"


#The code below is used to find out the default gateway ip address.
GATEWAYIP=$(ip route | grep default | awk '{print $3}')
echo "Gateway ip is: $GATEWAYIP"


#This code determines the DNS server IP address.
DNSSERVERIP=$(cat /etc/resolv.conf | grep 'nameserver' | awk '{print $2}') 
echo "DNS Server IP is: $DNSSERVERIP"


echo ""


#This code is to make and find model for network card.
INTERFACENAME=$(lspci | grep -i ethernet) 
echo "Interface Name:- $INTERFACENAME" 


#This extracts the info of ip address in CIDR format.
IPINCIDR=$(ip -o -f inet addr show | awk '{print $4}') 
echo "Ip address in CIDR format is:- $IPINCIDR"


echo ""

echo "System Status"
echo "-------------"


#This command find the list of users logged in the system.
USERSLOGGEDIN=$(users) 
echo "The list of users loggd in is:- $USERSLOGGEDIN"


#This code find out the free disk space available. 
DISKSPACE=$(df -h --output=source,avail | grep -v '^Filesystem')
echo "Free disk space are:- $DISKSPACE"


#This code is used to counts the total process used in the system.
PROCESSCOUNT=$( ps -ef | wc -l) 
echo "The totalprocess count is:- $PROCESSCOUNT"


#This is to calculate the load average.
LOADAVERAGE=$(uptime | awk -F 'load average: ' '{print $2}')
echo "The Load averages are:- $LOADAVERAGE"


#To find the free space in the system, this line of command is used.
MEMORYALLOCATION=$(free | awk '/^Mem:/ {print $4}') 
echo "The free memory in the system is:- $MEMORYALLOCATION"


#This list all the active listening ports.
PORTSLISTENING=$( sudo netstat -tunlp|grep LISTEN | awk '/^(tcp|udp)/ {print $4}' | awk -F: '{print $NF}')
echo "The numbers of ports listening are:- $PORTSLISTENING"


#This helps to recognize the status of the firewall.
UFWRULES=$(sudo ufw status) 
echo "The UFW $UFWRULES"
