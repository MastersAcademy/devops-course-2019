#!/bin/bash

progr_name='nginx'

echo "Check for current user rights";
if [[ $(id -u) -ne 0 ]]
  then
    echo "Please run as root"
    exit 0;
  else 
    echo "Start executing tasks" 
fi
echo ""
echo ""
echo "------------------------"
echo "task 1";
echo "------------------------"
echo ""
echo ""
echo "Install \"aptitude\" - program for package management";

apt install --assume-yes aptitude

#create list array of all installed programms in system
readarray -t list < <( aptitude -F' * %p -> %d ' --no-gui --disable-columns search '?and(~i,!?section(libs), !?section(kernel), !?section(devel))')

#alt way for print all elements from array
#printf '%s\n' "${list[@]}"

echo""
echo "All installed programms in system:";
echo ""
IFS=$'\n'; echo "${list[*]}" 
echo""
cmd=$(printf '%s\n' "${list[@]}" | grep $progr_name );
if [ $? = 0 ]
then
  echo "nginx installed in system";
  nginx -v
  echo "deleting from system";
  nginx -s stop
  apt-get --purge --assume-yes remove nginx*
  if [ $? -eq "0" ]
  then
    echo "nginx fully deleted;"
  else
    echo "oops, something went wrong. Contact with your operations team."
    exit 0;
  fi  
else
  echo ""	
  echo "nginx not installed in system";
fi
echo"";
echo"";
echo "------------------------"
echo "task 2"
echo "------------------------"
echo"";
echo"";
echo "Istallation of nginx v 1.14.2"
echo "";
apt-get install --assume-yes curl gnupg2 ca-certificates lsb-release;
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list;
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -;
apt-key fingerprint ABF5BD827BD9BF62
apt update
apt-get install --assume-yes nginx=1.14.2*
if [ $? = 0 ]
  then
    echo "current installed version";
    nginx -v;
   else
    echo "contact with your operations team";
    exit 0;
fi
echo"";
echo "configuration nginx";
echo"";
mkdir /etc/nginx/sites-available /etc/nginx/sites-enabled
cp /etc/nginx/nginx.conf /etc/nginx/backup_nginx.conf
sed -i '$ d' /etc/nginx/nginx.conf && echo -e "    include /etc/nginx/sites-enabled/\*.conf;\n}">> /etc/nginx/nginx.conf
cp /etc/nginx/conf.d/default.conf  /etc/nginx/conf.d/backup_default.conf	
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/;
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/;
echo "";
echo "start nginx service";
echo "";
service nginx start
echo "Request to nginx ";
echo "";
curl 'http://127.0.0.1' -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)'
echo "";
echo "";
echo "------------------------"
echo "task 3"
echo "------------------------"
echo "";
echo "";
echo ""
ngX_master_PID=`ps aux | grep "[n]ginx: master" | awk '{print $2}'`;
ngX_numb_of_proc=`ps aux | grep "[n]ginx: worker" | grep -c "[0-9]"`;

if [ $ngX_numb_of_proc != 0 ]
then
	echo "Nginx master process PID: $ngX_master_PID";
	echo -e "Nginx worker process count: \e[31m\e[5m \e[107m $ngX_numb_of_proc \e[25m\e[28m\e[49m\e[0m";
else
	echo "service nginx stopped";
fi

exit 0;
