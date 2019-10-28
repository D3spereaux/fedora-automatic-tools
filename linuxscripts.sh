#!/bin/bash
#Create and modify by D3spere@ux
#This tool uses for Exercises LPI (Linux Professional Institute) or person who working in Fedora distro field.

#########################################################4####################################################

#Global Variables (GV)
		BLUE='\033[1;34m'
		RED='\033[1;31m'
		YELLOW='\033[1;33m'
		NC='\033[0m'
		BLINK='\033[5m'

		PAKTC="${BLINK}${YELLOW}Press ${RED}ANY KEY${YELLOW} to continue...${NC}"
		PAKTGB="${BLINK}${YELLOW}Press ${RED}ANY KEY${YELLOW} to go back...${NC}"
#Code to read from keyboard without return
		READAK="read -s -n 1"
		
#########################################################4####################################################

#Export GV
		export BLUE
		export RED
		export YELLOW
		export NC
		export BLINK
		
		export PAKTC
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
           #           | |     | |   |   \| |  | |   | |    /  _  \             #
           #           | |___  | |   | |\   |  | |___| |   / /   \ \            #
           #           |_____| |_|   |_| \__|  |_______|  /_/     \_\           #
           #           By D3spere@ux                                            #
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
	#Get data from user (IP - Gateway - DNS)
		echo -e "${BLUE} Input IP information: ${NC}"
		echo
        echo -e -n "${YELLOW}   [+] Static IP: ${NC}"   
            read staticip
        echo -e -n "${YELLOW}   [+] Gateway  : ${NC}"
			read gateway
		echo -e -n "${YELLOW}   [+] DNS-1    : ${NC}"
			read dns1
		echo -e -n "${YELLOW}   [+] DNS-2    : ${NC}"
			read dns2
			echo
	#Confirm data from user
		f_confirmdata() {	
			echo -e -n "${YELLOW}Please confirm again [YES/NO]: ${NC}"
				read confirmdata
				echo
			case $confirmdata in
				yes|Yes|YES|y|Y)
			#Backup ifcfg-ens33
					echo
					cp -a /etc/sysconfig/network-scripts/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-ens33.bk
			#Config files
					echo "
					TYPE=Ethernet
					DEVICE=ens33
					NAME=ens33
					BOOTPROTO=static
					IPADDR=$staticip
					PREFIX=24
					GATEWAY=$gateway
					DNS1=$dns1
					DNS2=$dns2
					ONBOOT=YES" > /etc/sysconfig/network-scripts/ifcfg-ens33

					clear
					echo
					echo -e "${YELLOW}${BLINK}Backing up & Assigning the Static IP ...$NC"
			#Restart network services
					systemctl restart network.service
					ifconfig ens33
					cat /etc/resolv.conf
					clear
			#Check ping
					echo
					echo -e -n "${RED}${BLINK}CHECKING...${NC}"
						echo
						echo
						if ping -q -c 1 -W 1 google.com >/dev/null; then
							echo
							clear
							echo
							echo -e "${YELLOW}Alright, Your Local IP: ${BLUE}$staticip ${YELLOW}- Gateway: ${BLUE}$gateway ${NC}"
							else
							clear
							echo
							echo -e "${RED}FAILED!!!${NC}"
							echo
							echo -e "${YELLOW}Please check your network connection and try again.${NC}"
							fi
								;;
				no|No|NO|n|N)
					echo -e "${BLUE}Alright, slow down. Let's try again!${NC}"
					sleep 2
					f_setip
					;;
				*)
					echo -e "${RED}${BLINK} *** Invalid Entry *** ${NC}"
					echo
					echo -e "${YELLOW}Please input: 'YES' or 'NO'${NC}"
					sleep 2
					clear
				#Show data for user again
					echo
					echo -e "${BLUE}Your Input: ${NC}"
					echo
					echo -e "${YELLOW}[+] Static IP: $staticip${NC}"
					echo -e "${YELLOW}[+] Gateway  : $gateway${NC}"
					echo -e "${YELLOW}[+] DNS-1    : $dns1${NC}"
					echo -e "${YELLOW}[+] DNS-2    : $dns2${NC}"
					echo
					f_confirmdata
					;;
					esac
			}
			f_confirmdata
			echo
			echo
			echo -e "$PAKTGB"
			echo
			read $READAK
	}

##############################################################################################################

#Exercise 2: Connect Putty on Windows
f_putty() {
		clear
		echo
		echo -e "${YELLOW}  Follow the instructions below to connect to Linux Server (SSH) in Windows Environment via PuTTY:${NC}"
		echo
		echo -e "${BLUE} [+] Step 1: ${YELLOW}Download PuTTY${BLUE}(https://www.putty.org)${YELLOW}, use key combination (Windows + R) and type: ${BLUE}putty${YELLOW}.${NC}"
		echo -e "${BLUE} [+] Step 2: ${YELLOW}Input the target IP (SSH) and click Open.${NC}"
		echo -e "${BLUE} [+] Step 3: ${YELLOW}Click 'Yes' if you see the notice then log-in your account.${NC}"
		echo
		echo
		echo -e "$PAKTGB"
		read $READAK
	}
	
##############################################################################################################

#Exercise 3: Config Hostname
f_hostname() {
		clear
		echo
		echo -e -n "${YELLOW}Input new hostname: ${NC}"
		read hostname
		hostnamectl set-hostname $hostname
		clear
		echo
		echo -e "${YELLOW}Here is your new hostname: ${NC}"
		echo
		hostname
		echo
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################

#Exercise 4: Create New User and add sudo
f_newuser() {
		clear
	#Single User
		echo
		echo -e "${BLUE} Input New User Information: ${NC}"
		echo
		echo -e -n "${YELLOW}   [+] Enter Fullname: ${NC}"
		read fullname
		echo -e -n "${YELLOW}   [+] Enter Username: ${NC}"
		read username
		echo -e -n "${YELLOW}   [+] New Password  : ${NC}"
		read password
		useradd -m $username -c "$fullname"
		echo "$username:$password" | chpasswd
		echo
		echo
		echo -e "$PAKTC"
		read $READAK		
		clear
	#Ask for sudoer privilege
		f_answersudo () {
			echo
			echo -e -n "${YELLOW}Do you want to add user ${BLUE}'$username'${YELLOW} to group sudoers(wheel)? [YES/NO]: ${NC}"
				read answersudo
				echo
				clear
				echo
			case $answersudo in
				yes|Yes|YES|y|Y)
					echo -e "${YELLOW}Here is user ${BLUE}'$username'${YELLOW} information details: ${NC}"
					echo
					usermod -aG wheel $username; id $username; grep "$username" /etc/passwd
					echo
					echo -e "${YELLOW}Welldone, added user ${BLUE}'$username'${YELLOW} to group sudoers(wheel) successfully!${NC}"
					;;
				no|No|NO|n|N)
					echo -e "${YELLOW}Welldone, created user ${BLUE}'$username'${YELLOW} successfully!${NC}"
					;;
				*)
					echo -e "${RED}${BLINK} *** Invalid Entry *** ${NC}"
					echo
					echo -e "${YELLOW}Please input: 'YES' or 'NO'${NC}"
					sleep 2
					clear
					f_answersudo
					;;
					esac
			}
			f_answersudo
	#Multi Users
			echo
			echo
			echo -e "$PAKTGB"
			read $READAK
	}
	
##############################################################################################################

#Exercise 5: Config Timedate
f_timedate() {
		clear
		echo
		echo -e -n "${YELLOW}Input Date (Example: 2019-10-23): ${NC}"
		read date
		echo -e -n "${YELLOW}Input Time (Example: 19:30:50)  : ${NC}"
		read time
		timedatectl set-ntp false
		timedatectl set-local-rtc 0
		timedatectl set-time $date
		timedatectl set-time $time
		timedatectl set-timezone Asia/Ho_Chi_Minh
		clear
		echo
		echo -e "${YELLOW}Here is your new time & date status: ${NC}"
		echo
		date
		echo
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################	

#Exercise 6: Create new Logical Volume Management (LVM)	
f_newlvm() {
		clear
		echo
		echo -e "${BLUE}Your disk information:${NC}"
		echo
		fdisk -l | grep "/dev/s" #Check disk device information
		echo
		echo -e "${YELLOW}*Make sure you was added ${BLUE}a new Hard Disk ${YELLOW}and located it done (fdisk -l). ${NC}"
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
		echo
		echo -e "${YELLOW}Here is the disk ${BLUE}(/dev/$newdisk)${YELLOW} partitions details:${NC}"
		echo
		fdisk -l | grep "/dev/$newdisk"
		echo
	#Identified the new disk info
		echo -e -n "${YELLOW}[+] Input the disk partition to create LVM (Example: ${BLUE}sdb1${YELLOW}): ${NC}"
		read diskinfo
	#Create Physical Volume
		pvcreate /dev/$diskinfo
		echo
	#Create Volume Group
		echo -e -n "${YELLOW}[+] Input the volume group name (Example: ${BLUE}VGDATA${YELLOW}): ${NC}"
		read vgdata
		vgcreate $vgdata /dev/$diskinfo
		echo
	#Create Logical Volume
		echo -e -n "${YELLOW}[+] Input the logical volume name (Example: ${BLUE}LVDATA${YELLOW}): ${NC}"
		read lvdata
		echo
		echo -e -n "${YELLOW}[+] Input the logical volume space (Example: ${BLUE}25%,50%,...${YELLOW}): ${NC}"
		read lvspace
		lvcreate -n $lvdata -l ${lvspace}FREE $vgdata
	#Config after
		mkfs.xfs /dev/$vgdata/$lvdata
		mkdir /files
		echo "/dev/$vgdata/$lvdata /files xfs defaults 1 2" >> /etc/fstab
		mount -a
		clear
		echo
		echo -e "${YELLOW}Here is the new Logical Volume Managent (LVM) information: ${NC}"
		echo
	#Check data correctly
		df -h /dev/mapper/$vgdata-$lvdata
		echo
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################
	
#Exercise 7: Config firewalld to allow user access to server through protocols (http,ftp,...)
f_openservice() {
		clear
	#Check install Firewalld
		echo
		echo -e "${YELLOW}${BLINK}[+] Installing ${BLUE}Firewalld${YELLOW}... ${NC}"
		echo
		yum install -y -q dnf
		dnf install -y -q firewalld; dnf update -y -q firewalld
		clear
	#Add single service
		echo
		echo -e -n "${YELLOW}Input service to enable (Example: ${BLUE}'http' ${YELLOW}or ${BLUE}'ftp'${YELLOW}): ${NC}"
		read service
		firewall-cmd --add-service=$service --permanent; firewall-cmd --reload
	#Restart firewalld
		clear
		echo
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
	#Install Basic Web Server & Elinks package
		echo
		echo -e "${YELLOW}${BLINK}[+] Installing ${BLUE}"Basic Web Server"${YELLOW} and ${BLUE}Elinks${YELLOW}...${NC}"
		echo
		yum install -y -q dnf
		dnf groupinstall -y -q "Basic Web Server";dnf groupupdate -y -q "Basic Web Server"
		dnf install -y -q elinks; dnf update -y -q elinks
		clear
	#Backup file httpd.conf && Create Basic Index.html
		echo
		echo -e "${YELLOW}Back up file httpd.conf & Create Index.html ${BLUE}(/var/www/html/index.html)${YELLOW}.${NC}"
		cp -a /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bk
		echo
		echo -e -n "${YELLOW}Input data to index file (Example: ${BLUE}Hello World!${YELLOW}): ${NC}"
		read web_data
		echo "$web_data" > /var/www/html/index.html
	#Restart httpd service
		systemctl start httpd; systemctl enable httpd; systemctl restart httpd
		clear
		echo -e "${YELLOW}Alright, 2 ways to see the result: ${NC}"
		echo
		echo -e "${YELLOW}+ Open new tab and type: ${BLUE}elinks http://localhost. ${NC}"
		echo -e "${YELLOW}+ Open Web Browser and redirect to: ${BLUE}http://localhost. ${NC}"
		echo
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################

#Exercise 9: Install and config FTP Anonymous Drop Box with a shared folder.
f_anon_dropbox() {
		clear
	#Install VSFTPD package
		echo
		echo -e "${YELLOW}${BLINK}[+] Installing ${BLUE}VSFTPD${YELLOW}...${NC}"
		echo
		yum install -y -q dnf
		dnf install -y -q vsftpd; dnf update -y -q vsftpd
		echo
		clear
	#Config Firewalld to add FTP service
		echo
		echo -e "${YELLOW}[+] Add ${BLUE}FTP ${YELLOW}service from Firewalld.${NC}"
		firewall-cmd --zone=public --permanent --add-service=ftp
		firewall-cmd --reload
		echo
	#Create a rule for firewall to allow FTP traffic on Port 21
		echo -e "${YELLOW}[+] Enable Port ${BLUE}21${YELLOW}.${NC}"
		firewall-cmd --zone=public --permanent --add-port=21/tcp
		firewall-cmd --reload
		echo
	#Check the FTP service and port was added
		echo -e "${YELLOW}[+] Check lists current services running.${NC}"
		firewall-cmd --list-services | grep "ftp"
		firewall-cmd --list-ports | grep "21"
		echo
	#Create backup vsftpd.conf file (.bk)
		echo -e "${YELLOW}[+] Create backup ${BLUE}vsftpd.conf ${YELLOW}file.${NC}"
		cp -a /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bk
		echo
	#Create Uploads Folder
		echo -e "${YELLOW}[+] The FTP Server uses the directory (/var/ftp) as the default document root.${NC}"
		echo -e "${YELLOW}    Create a sub-directory with the name ${BLUE}'uploads' ${YELLOW}(/var/ftp/uploads).${NC}"
		rm -rf /var/ftp/uploads; mkdir /var/ftp/uploads
		echo
	#Give permissions for Shared Folder | -rwx-wx---
		echo -e "${YELLOW}[+] Set permission (Users can write, but they can't read them). ${NC}"
		chmod 0730 /var/ftp/uploads
		echo
	#Set the group owner to group FTP
		chgrp ftp /var/ftp/uploads
		echo -e "${YELLOW}[+] Set the group owner to ${BLUE}'FTP'${YELLOW}. ${NC}"
		echo
	#Edit file vsftpd.conf
		echo "#Set up FTP Anonymous Drop Box
			anon_umask=077
			anon_upload_enable=YES
			anon_mkdir_write_enable=YES
			chown_uploads=YES
			chown_username=root" >> /etc/vsftpd/vsftpd.conf
	#Restart VSFTPD service
		echo -e "${YELLOW}[+] VSFTPD service status:${NC}"
		echo
		systemctl enable vsftpd; systemctl start vsftpd; systemctl restart vsftpd; systemctl status vsftpd
	#Config Semanage
		semanage fcontext -a -t public_content_rw_t "/var/ftp/uploads(/.*)?"
		restorecon -Rv /var/ftp/uploads
	#Enable ftpd_anon_write
		setsebool -P ftpd_anon_write on
		echo
		echo
		echo -e "$PAKTC"
		read $READAK
		clear
	#Test the result
		echo
		echo -e "${YELLOW}   Follow the instructions below to make sure everything is set up correctly:${NC}"
		echo
		echo -e "${YELLOW}	[+] Step 1: Log-in another server and type:${BLUE} yum install -y lftp${YELLOW}.${NC}"
		echo -e "${YELLOW}	[+] Step 2: Then type: ${BLUE}lftp (FTP Server IP)${YELLOW} - Example: lftp 192.168.1.10.${NC}"
		echo -e "${YELLOW}	[+] Step 3: After connect to FTP Server, type: ${BLUE}ls${YELLOW}.${NC}"
		echo -e "${YELLOW}	[+] Step 4: Then type: ${BLUE}cd uploads/; put /etc/hosts${YELLOW}.${NC}"
		echo -e "${YELLOW}	[+] Step 5: Back to FTP Server, type: ${BLUE}ll /var/ftp/uploads/${YELLOW}.${NC}"
		echo -e "${YELLOW}	[+] Step 6: If you see the information the same with this ${BLUE}(-rw-------. 1 root ftp 204 Oct 26 17:31 hosts)${YELLOW}.${NC}"
		echo -e "${YELLOW}	            Congratulations! Everything working perfectly. (If not, un-install VSFTPD and try again)${NC}"
		echo -e "${YELLOW}	[+] Step 7: To check FTP Server log details, type: ${BLUE}cat /var/log/xferlog${YELLOW}.${NC}"
		echo
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
	#Check Application installed or not yet
		rpm -qa | grep "$application"
	#Check for no answer
		if [[ -z $application ]]; then
			f_error
			echo -e "${YELLOW}Please input correctly what you need to find.${NC}"
			exit 0
		fi 
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################
	
#Check the Internect connecting
f_checkinternet() {
		clear
		echo
		echo -e -n "${YELLOW}Checking the network connection, please wait... ${NC}"
		if ping -q -c 1 -W 1 google.com >/dev/null; then
		echo
	#Check Local IP
		clear
		local_ip=$(ifconfig | grep -w inet | awk '{print $2}')	
		echo
		echo -e "${YELLOW}Here is your IP information details: ${NC}"
		echo
		echo -e -n "${YELLOW}[+] Local IP:${NC}"
		echo
		echo -e "${BLUE}$local_ip${NC}"
		echo
	#Check Gateway
		gateway=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
		echo -e -n "${YELLOW}[+] Gateway: ${BLUE}$gateway${NC}"
		echo
	#Check Public IP
		echo
		public_ip=$(wget -qO - https://api.ipify.org)
		echo -e -n "${YELLOW}[+] Public IP: ${BLUE}$public_ip${NC}"
		echo
		else
			clear
			echo
			echo -e "${RED}FAILED!!! ${NC}"
			echo
			echo -e "${YELLOW}Please check your network connection and try again...${NC}"
		fi
		echo
		echo
		echo -e "$PAKTGB"
		read $READAK
	}

##############################################################################################################

#Building Menu:
f_main(){
	clear
	f_banner
	#Main Menu:
                echo -e "${BLUE}       BASICS${NC}                                 ${BLUE}ADVANCED${NC}                          ${BLUE}OTHERS${NC}"
                echo
                echo -e "${YELLOW}1.  Config IP                       10.  Manage Apache Services          90.  Update CentOS"
                echo -e          "2.  Connect Putty                   11.  Config DNS (Unbound)            91.  Search Software"
                echo -e          "3.  Config Hostname                 12.  Config DNS (Bind)               92.  Check IP"
                echo -e          "4.  Create New User                 13.  Create Basic Shell              93.  Exit"
                echo -e          "5.  Config Timedate                 14.  "
                echo -e          "6.  Create New LVM                  15.  "
                echo -e          "7.  Enable Services (Firewalld)     16.  "
                echo -e          "8.  Create Web Server               17.  "
                echo -e          "9.  Create FTP Anonymous Drop Box   18.  "${NC}
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
		9) f_anon_dropbox;;
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