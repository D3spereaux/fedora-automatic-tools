#!/bin/bash
#Create and modify by Brian Dao (D3spere@ux)
#This tool uses for Exercises LPI (Linux Professional Institute)
#JK-ENR-HA-670

#########################################################4####################################################

#Global variables
	    BLUE='\033[1;34m'
		RED='\033[1;31m'
		YELLOW='\033[1;33m'
		NC='\033[0m'
		BLINK='\033[5m'

		PAKTGB="${BLINK}${YELLOW}Press ${RED}ANY KEY${YELLOW} to go back... ${NC}"
		#code to read from keyboard without return
		READAK="read -n 1"
		
#########################################################4####################################################

#Export
	    export BLUE
		export RED
		export YELLOW
		export NC
		export BLINK
		
		export PAKTGB
		export READAK
		
##############################################################################################################

#Banner Setup
f_banner(){
        echo
        echo -e "${YELLOW}
           ######################################################################
           #            _       _     _    _    _     _    __     __            #
           #           | |     | |   | \  | |  | |   | |   \ \   / /            #
           #           | |     | |   |  \ | |  | |   | |    \ \_/ /             #
           #           | |     | |   |   \| |  | |   | |    / ___ \             #
           #           | |___  | |   | |\   |  | |___| |   / /   \ \            #
           #           |_____| |_|   |_| \__|  |_______|  /_/     \_\           #
           #            By D3spere@ux                                           #
           #                                                                    #
           ###################################################################### ${NC}"   
        echo
        echo
       }
	export -f f_banner

##############################################################################################################

#Invalid Input Function
f_error() {
		echo
		echo -e "${RED}${BLINK} *** Invalid choice or entry *** ${NC}"
		echo
		exit
	}
		export -f f_error
		
##############################################################################################################

#Exercise 1: Setup Static IP 
f_setip () {
		clear
		f_banner
        echo -e -n "${YELLOW}Static IP: ${NC}"   
                read staticip
        echo -e -n "${YELLOW}Gateway: ${NC}"
                read gateway
    #Backup Hostname
        echo "Backing up & Assigning the Static IP ..."
                echo ""
                cp /etc/sysconfig/network-scripts/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-ens33.bk

    #Config files
        echo "
        TYPE=Ethernet
        DEVICE=ens33
        NAME=ens33
        BOOTPROTO=static
        IPADDR=$staticip
        PREFIX=24
        GATEWAY=$gateway
        DNS1=8.8.8.8
        DNS2=8.8.4.4
        ONBOOT=YES" > /etc/sysconfig/network-scripts/ifcfg-ens33

        clear
                echo -e "${YELLOW}Backing up & Assigning the Static IP ...$NC"
        echo
    #Restart network services
        systemctl restart network.service
        ifconfig ens33
        cat /etc/resolv.conf
        echo ""

    #Check ping
        if ping -q -c 1 -W 1 google.com >/dev/null; then
                                echo -e "${YELLOW}Alright, Your IP: ${BLUE}$staticip ${YELLOW}- Gateway: ${BLUE}$gateway ${NC}"
                                echo
                                echo -e "$PAKTGB"
                                read $READAK
                        else
								echo
                                echo -e "${YELLOW}Please check your network connection and try again...${NC}"
                                echo
                                echo -e "$PAKTGB"
                                read $READAK
                        fi
	}

##############################################################################################################

#Exercise 2: Connect Putty
f_putty() {
		clear
		f_banner
		echo -e "${BLUE}Step 1: ${YELLOW}Open PuTTY (Windows + R) and type: putty${NC}"
		echo -e "${BLUE}Step 2: ${YELLOW}Input the target IP (SSH) and click Open${NC}"
		echo -e "${BLUE}Step 3: ${YELLOW}Click 'Yes' if you see the notice then log-in your account${NC}"
		echo
		echo -e "$PAKTGB"
		read $READAK
	}
	
##############################################################################################################

#Exercise 3: Config Hostname
f_hostname() {
		clear
		f_banner
		echo -e -n "${YELLOW}Input new hostname: ${NC}"
		read hostname
		hostnamectl set-hostname $hostname
		clear
		hostnamectl status
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################

#Exercise 4: Create New User and add sudo
f_newuser() {
		clear
		f_banner
	#Single User
		echo -e -n "${YELLOW}Enter Fullname: ${NC}"
		read fullname
		echo -e -n "${YELLOW}Enter Username: ${NC}"
		read username
		echo -e -n "${YELLOW}New Password: ${NC}"
		read password
		useradd -m $username -c "$fullname"
		echo "$username:$password" | chpasswd
		clear
	#Ask for sudoer
		f_answersudo () {
			echo -e -n "${YELLOW}Can '$username' uses sudo (YES/NO)? ${NC}"
				read answersudo
				echo
			case $answersudo in
				yes|Yes|YES|y|Y)
					usermod -aG wheel $username; id $username; grep "$username" /etc/passwd
					echo
					echo -e "${YELLOW}Welldone, added user '$username' to group wheel(sudo) successfully!${NC}"
					;;
				no|No|NO|n|N)
					echo
					echo -e "${YELLOW}Welldone, created user '$username' successfully!${NC}"
					;;
				*)
					echo
					echo -e "${RED}${BLINK} *** Invalid choice or entry *** ${NC}"
					echo
					echo -e "${YELLOW}Please enter again: 'YES' or 'NO'${NC}"
					sleep 1.5
					clear
					f_answersudo
					;;
					esac
		}
		f_answersudo
	#Multi Users
			echo
			echo -e "$PAKTGB"
			read $READAK
	}
	
##############################################################################################################

#Exercise 5: Config Timedate
f_timedate() {
		clear
		f_banner
		echo -e -n "${YELLOW}Input Date (Example:2019-10-23): ${NC}"
		read date
		echo -e -n "${YELLOW}Input Time (EXample:19:30:50): ${NC}"
		read time
		timedatectl set-ntp false
		timedatectl set-local-rtc 0
		timedatectl set-time $date
		timedatectl set-time $time
		timedatectl set-timezone Asia/Ho_Chi_Minh
		clear
		timedatectl status
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################	

#Exercise 6: Create new Logical Volume Management (LVM)	
f_newlvm() {
		clear
		f_banner
		echo -e "${BLUE}Your disk information:${NC}"
		echo
		fdisk -l | grep "/dev/s" #Check disk device information
		echo
		echo -e -n "${YELLOW}Make sure you was added ${BLUE}a new Hard Disk ${YELLOW}and located it done (fdisk -l). ${NC}"
		echo
		echo -e -n "${YELLOW}Enter disk name (Example: sdb): ${NC}"
		read newdisk
		echo -e -n "${YELLOW}Enter disk space (Example: +100M): ${NC}"
		read space
	#Create partition and set to Linux LVM (8e)
		echo "n
		p


		$space
		t

		8e
		w" | fdisk /dev/$newdisk
	#Show partition
		clear
		fdisk -l | grep "/dev/$newdisk"
		echo
	#Identified the new disk info
		echo -e -n "${YELLOW}Enter the disk detail just created (Example: sdb1): ${NC}"
		read diskinfo
	#Create Physical Volume
		pvcreate /dev/$diskinfo
	#Create Volume Group
		echo -e -n "${YELLOW}Enter volume group name (Example: VGDATA): ${NC}"
		read vgdata
		vgcreate $vgdata /dev/$diskinfo
	#Create Logical Volume
		echo -e -n "${YELLOW}Enter logical volume name (Example: LVDATA): ${NC}"
		read lvdata
		echo -e -n "${YELLOW}Enter logical volume space (Example: 25%,50%,...): ${NC}"
		read lvspace
		lvcreate -n $lvdata -l ${lvspace}FREE $vgdata
	#Config after
		mkfs.xfs /dev/$vgdata/$lvdata
		mkdir /files
		echo "/dev/$vgdata/$lvdata /files xfs defaults 1 2" >> /etc/fstab
		mount -a
		clear
		df -h /dev/mapper/$vgdata-$lvdata #Check data correctly
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################
	
#Exercise 7: Config firewalld to allow user access to server through protocols (http,ftp,...)
f_openservice() {
		clear
		f_banner
	#Check install Firewalld
		yum install -y firewalld
		clear
	#Add single service
		echo -e -n "${YELLOW}Enter service: ${NC}"
		read service
		firewall-cmd --add-service=$service --permanent; firewall-cmd --reload
	#Restart firewalld
		clear
		echo -e "${YELLOW}Firewalld.service status:${NC}"
		echo		
		systemctl enable firewalld; systemctl restart firewalld; systemctl status firewalld;
		echo
	#Checking services added
		echo -e "${YELLOW}Lists your current services running:${NC}"
		echo
		firewall-cmd --list-services; firewall-cmd --list-ports
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################	
	
#Exercise 8: Install and config Basic Web Server
f_webserver() {
		clear
		f_banner
	#Check the Internet
		
	#Install Basic Web Server & Elinks package
		yum groupinstall -y "Basic Web Server"
		yum install -y elinks
	#Backup file httpd.conf
		clear
		echo -e "${YELLOW}Backing up file httpd.conf... ${NC}"
		cp -a /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bk
		echo
	#Create Basic Index.html
		echo -e "${YELLOW}Creating Index.html... ${NC}"
		echo
		echo -e -n "${YELLOW}Input data to index file (Example: Hello World!): ${NC}"
		read web_data
		echo "$web_data" > /var/www/html/index.html
	#Restart httpd service
		systemctl start httpd; systemctl enable httpd; systemctl restart httpd
		clear
		echo -e "${YELLOW}Alright, this is 2 ways to see the result: ${NC}"
		echo
		echo -e "${YELLOW}+ Open new tab and type: ${BLUE}elinks http://localhost. ${NC}"
		echo -e "${YELLOW}+ Open Web Browser and redirect to: ${BLUE}http://localhost. ${NC}"
		echo
		echo -e "$PAKTGB"
		read $READAK
	}
	
##############################################################################################################

#Searching Software/Application	
f_search() {
		clear
		f_banner
	#Identified Application	
		echo -e -n "${YELLOW}Input your Application: ${NC}"
		read application
	#Check for no answer
		if [[ -z $application ]]; then
			f_error
			echo -e "${YELLOW}Please input correctly what you need to find.${NC}"
			exit 0
		fi
		echo 
		rpm -qa | grep $application
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################
	
#Check the Internect connecting
f_checkinternet() {
		clear
		f_banner
		echo -e -n "${YELLOW}Checking the network connection, please wait... ${NC}"
		if ping -q -c 1 -W 1 google.com >/dev/null; then
		echo
	#Check Local IP
		clear
		local_ip=$(ifconfig | grep -w inet | awk '{print $2}')	
		echo
		echo -e -n "${YELLOW}Local IP:${NC}"
		echo
		echo -e "${BLUE}$local_ip${NC}"
		echo
	#Check Gateway
		gateway=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
		echo -e -n "${YELLOW}Gateway: ${BLUE}$gateway${NC}"
		echo
		echo
	#Check Public IP
		public_ip=$(wget -qO - https://api.ipify.org)
		echo -e -n "${YELLOW}Public IP: ${BLUE}$public_ip${NC}"
		echo
		else
			clear
			echo
			echo -e "${YELLOW}Please check your network connection and try again...${NC}"
		fi
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################

#Exercise 9: Install and config FTP server
f_ftpserver() {
		clear
		f_banner
		
	}
##############################################################################################################

#Building Menu:
f_main(){
	clear
	f_banner
	#Main Menu:
                echo -e "${BLUE}  EXERCISES LINUX 1${NC}                    ${BLUE}EXERCISES LINUX 2${NC}                    ${BLUE}OTHERS${NC}"
                echo
                echo -e "${YELLOW}1.  Config IP                       10.  Manage Apache Services          90.  Update CentOS"
                echo -e          "2.  Connect Putty                   11.  Config DNS (Unbound)            91.  Search Software"
                echo -e          "3.  Config Hostname                 12.  Config DNS (Bind)               92.  Check IP"
                echo -e          "4.  Create New User                 13.  Create Basic Shell              93.  Exit"
                echo -e          "5.  Config Timedate                 14.  "
                echo -e          "6.  Create New LVM                  15.  "
                echo -e          "7.  Open Services                   16.  "
                echo -e          "8.  Create Web Server               17.  "
                echo -e          "9.  Config FTP Server               18.  "${NC}
                echo
				
	echo -e -n "${BLUE}Your Choice: "${NC}
		read choice

		case $choice in
		1) f_setip;;
		2) f_putty;;
		3) f_hostname;;
		4) f_newuser;;
		5) f_timedate;;
		6) f_newlvm;;
		7) f_openservice;;
		8) f_webserver;;
		9) f_ftpserver;;
		10) f_apache;;
		11) f_dns_unbound;;
		12) f_dns_bind;;
		13) f_basicshell;;
		14) f_test;;
		15) f_test;;
		16) f_test;;
		17) f_test;;
		18) f_test;;
		90) f_update;;
		91) f_search;;
		92) f_checkinternet;;
		93) clear && exit;;
		*) f_error;;
		esac
	}

	export -f f_main

##############################################################################################################

while true; do f_main; done