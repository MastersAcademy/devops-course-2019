 
#!/bin/bash
if [[ "$EUID" -ne 0 ]] # EUID 0 - root for the current process
then
	echo "Please run as root";
	exit 0;
fi

app=`pacman -Q | grep -c "^nginx\s"`; # for Arch
# app=`apt list --installed | grep -c nginx`; # for Ubuntu
		# grep -c return a count of matching lines for input file.
		# If Nginx is installed, then the number of lines
		# where it is mentioned is returned. (1 or more)

if [[ $app -eq 0 ]]
then
	echo "Nginx web server is not install.";
else
	echo `nginx -v`;
	echo -e "\033[31;4mRemove\033[0m Nginx...";

	pacman -R nginx; # for Arch
	# apt remove nginx*; # for Ubuntu
fi
exit 0;