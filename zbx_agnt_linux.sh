#!/bin/bash
########DEBUG ZONE#######
#trap read DEBUG		#
#set -x 				#
#########################

########VARIAVEIS########
FUNCTION=$1
DISTRO=$2
VERSAO=$3
PROXY_IP=$4
host=$(hostname)
NET="0"
#########################

function Config(){
	mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf-bkp
	touch -c /etc/zabbix/zabbix_agentd.conf
	echo "PidFile=/var/run/zabbix/zabbix_agentd.pid" >> /etc/zabbix/zabbix_agentd.conf
	echo "LogFile=/var/log/zabbix/zabbix_agentd.log" >> /etc/zabbix/zabbix_agentd.conf
	echo "LogFileSize=0" >> /etc/zabbix/zabbix_agentd.conf
	echo "Server=$PROXY_IP" >> /etc/zabbix/zabbix_agentd.conf
	echo "Hostname=$host" >> /etc/zabbix/zabbix_agentd.conf
	echo "Timeout=30" >> /etc/zabbix/zabbix_agentd.conf
	echo "AllowRoot=1" >> /etc/zabbix/zabbix_agentd.conf
	echo "Include=/etc/zabbix/zabbix_agentd.d/*.conf" >> /etc/zabbix/zabbix_agentd.conf
	echo "UserParameter=zbx_upd[*],/etc/zabbix/scripts/zbx_agnt_lnx.sh update $DISTRO $VERSAO" >> /etc/zabbix/zabbix_agentd.conf

	echo "Iniciando serviço zabbix_agent"
	systemctl restart zabbix-agent
	systemctl enable zabbix-agent
}

function DebianOnline(){

	if test	$VERSAO = "12" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian12_all.deb
			dpkg -i zabbix-release_6.4-1+debian12_all.deb
			apt update
			apt install zabbix-agent
	elif test $VERSAO = "11" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian11_all.deb
			dpkg -i zabbix-release_6.4-1+debian11_all.deb
			apt update
			apt install zabbix-agent
	elif test $VERSAO = "10" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian10_all.deb
			dpkg -i zabbix-release_6.4-1+debian10_all.deb
			apt update
			apt install zabbix-agent
    elif test $VERSAO = "9" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian9_all.deb
			dpkg -i zabbix-release_6.4-1+debian9_all.deb
			apt update
			apt install zabbix-agent
		else
			echo "VERSAO NAO SUPORTADA. [12/11/10/9]?"
		fi

	Config
}

function RHELOnline(){

	if test $VERSAO = "7" 2>/dev/null
		then
			rpm -i https://repo.zabbix.com/zabbix/6.4/rhel/7/x86_64/zabbix-release-6.4-1.el7.noarch.rpm
			yum install zabbix-agent
	elif test $VERSAO = "6" 2>/dev/null
		then
			rpm -i https://repo.zabbix.com/zabbix/6.4/rhel/6/x86_64/zabbix-release-6.4-1.el6.noarch.rpm
			yum install zabbix-agent
	elif test $VERSAO = "8" 2>/dev/null
		then
			rpm -i https://repo.zabbix.com/zabbix/6.4/rhel/8/x86_64/zabbix-release-6.4-1.el8.noarch.rpm
			yum install zabbix-agent
    elif test $VERSAO = "9" 2>/dev/null
		then
			rpm -i https://repo.zabbix.com/zabbix/6.4/rhel/9/x86_64/zabbix-release-6.4-1.el9.noarch.rpm
			yum install zabbix-agent
		else
			echo "VERSAO NAO SUPORTADA. [9/8/7/6]?"
	fi

	Config
}

function UbuntuOnline(){

	if test	$VERSAO = "18" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu18.04_all.deb
			dpkg -i zabbix-release_6.4-1+ubuntu18.04_all.deb
			apt update
			apt install zabbix-agent
	elif test $VERSAO = "16" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu16.04_all.deb
			dpkg -i zabbix-release_6.4-1+ubuntu16.04_all.deb
			apt update
			apt install zabbix-agent
	elif test $VERSAO = "14" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu14.04_all.deb
			dpkg -i zabbix-release_6.4-1+ubuntu14.04_all.deb
			apt update
			apt install zabbix-agent
	elif test $VERSAO = "20" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu20.04_all.deb
			dpkg -i zabbix-release_6.4-1+ubuntu20.04_all.deb
			apt update
			apt install zabbix-
    elif test $VERSAO = "20" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
			dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
			apt update
			apt install zabbix-agent
		else 
			echo "VERSAO NAO SUPORTADA. [22/20/18/16/14]?"
	fi

	Config
}

function install(){
	if test $DISTRO = debian 2>/dev/null
		then
			if test $NET = "0"
			then
				DebianOnline
			fi
	elif test $DISTRO = ubuntu 2>/dev/null
		then
			if test $NET = "0"
			then
				UbuntuOnline
			fi
	elif test  $DISTRO = rhel 2>/dev/null
		then
			if test $NET = "0"
			then
				RHELOnline
			fi
	else
		echo "DISTRO NAO SUPORTADA. [Debian/Ubuntu/RHEL]?"
	fi

}

function updateOnline(){
	if test $DISTRO = debian 2>/dev/null
	then
		if test	$VERSAO = "9" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release-6.4-1+stretch_all.deb
			dpkg -i zabbix-release-6.4-1+stretch_all.deb
			apt update
			apt upgrade zabbix-agent -y
	elif test $VERSAO = "8" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release-6.4-1+jessie_all.deb
			dpkg -i zabbix-release-6.4-1+jessie_all.deb
			apt update
			apt upgrade zabbix-agent -y
	elif test $VERSAO = "10" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release-6.4-1+buster_all.deb
			dpkg -i zabbix-release-6.4-1+buster_all.deb
			apt update
			apt upgrade zabbix-agent -y
	else
		echo "VERSAO NAO SUPORTADA. [10/9/8]?"
		fi
	elif test $DISTRO = ubuntu 2>/dev/null
		then
			if test	$VERSAO = "18" 2>/dev/null
			then
				wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release-6.4-1+bionic_all.deb
				dpkg -i zabbix-release-6.4-1+bionic_all.deb
				apt update
				apt upgrade zabbix-agent -y
		elif test $VERSAO = "16" 2>/dev/null
			then
				wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release-6.4-1+xenial_all.deb
				dpkg -i zabbix-release-6.4-1+xenial_all.deb
				apt update
				apt upgrade zabbix-agent -y
		elif test $VERSAO = "14" 2>/dev/null
			then
				wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release-6.4-1+trusty_all.deb
				dpkg -i zabbix-release-6.4-1+trusty_all.deb
				apt update
				apt upgrade zabbix-agent -y
		elif test $VERSAO = "20" 2>/dev/null
			then
				wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release-6.4-1+focal_all.deb
				dpkg -i zabbix-release-6.4-1+focal_all.deb
				apt update
				apt upgrade zabbix-agent
		else 
			echo "VERSAO NAO SUPORTADA. [20/18/16/14]?"
		fi
	elif test  $DISTRO = rhel 2>/dev/null
		then
			if test $VERSAO = "7" 2>/dev/null
			then
				rpm -i https://repo.zabbix.com/zabbix/6.4/rhel/7/x86_64/zabbix-release-6.4-1.el7.noarch.rpm
				yum update
				yum -y upgrade zabbix-agent
		elif test $VERSAO= "6" 2>/dev/null
			then
				rpm -i https://repo.zabbix.com/zabbix/6.4/rhel/6/x86_64/zabbix-release-6.4-1.el6.noarch.rpm
				yum update
				yum -y upgrade zabbix-agent
		elif test $VERSAO= "8" 2>/dev/null
			then
				rpm -i https://repo.zabbix.com/zabbix/6.4/rhel/8/x86_64/zabbix-release-6.4-1.el8.noarch.rpm
				yum install zabbix-agent
				yum -y upgrade zabbix-agent
		else
			echo "VERSAO NAO SUPORTADA. [8/7/6]?"
		fi
	else
		echo "DISTRO NAO SUPORTADA. [Debian/Ubuntu/RHEL]?"
	fi

}

if test $FUNCTION = "install"
	then
		install
elif test $FUNCTION = "update"
	then
		if test $NET = "0"
		then
			updateOnline
		else
			echo "Não foi possivel acessar a internet para baixar os repositorios mais atualizados, utilizando o cache do proxy."
			sleep 5
			updateOffline
		fi
elif test $FUNCTION = "upgrade"
	then
		upgrade
else 
	echo "Função não suportada. [install/update/upgrade]?"
fi
