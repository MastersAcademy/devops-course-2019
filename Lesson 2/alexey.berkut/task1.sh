 
#!/bin/bash
if [[ "$EUID" -ne 0 ]] # root check
then
	echo "Please run as root";
	exit 0;
fi

apt list --installed | grep -q nginx;

if [[ $? != 0 ]]
then
	echo "Nginx web server is not install.";
else
	echo `nginx -v`;
	echo -e "\033[31;4mRemove\033[0m Nginx...";
	apt remove -y nginx*;
fi
exit 0;
