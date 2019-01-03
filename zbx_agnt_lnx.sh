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
#########################

function Config(){
	mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf-bkp
	touch -c /etc/zabbix/zabbix_agentd.conf
	echo "PidFile=/var/run/zabbix/zabbix_agentd.pid" >> /etc/zabbix/zabbix_agentd.conf
	echo "LogFile=/var/log/zabbix/zabbix_agentd.log" >> /etc/zabbix/zabbix_agentd.conf
	echo "LogFileSize=0" >> /etc/zabbix/zabbix_agentd.conf
	echo "EnableRemoteCommands=1" >> /etc/zabbix/zabbix_agentd.conf
	echo "Server=$PROXY_IP" >> /etc/zabbix/zabbix_agentd.conf
	echo "Hostname=$host" >> /etc/zabbix/zabbix_agentd.conf
	echo "Timeout=30" >> /etc/zabbix/zabbix_agentd.conf
	echo "AllowRoot=1" >> /etc/zabbix/zabbix_agentd.conf
	echo "Include=/etc/zabbix/zabbix_agentd.d/*.conf" >> /etc/zabbix/zabbix_agentd.conf
	ehco "UserParameters=zbx_upd[*],/etc/zabbix/scripts/zbx_agnt_lnx.sh update $DISTRO $VERSÃO" >> /etc/zabbix/zabbix_agentd.conf

	echo "Iniciando serviço zabbix_agent"
	systemctl restart zabbix-agent
	systemctl enable zabbix-agent
}

function Debian(){

	if test	$VERSAO = "9" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-2+stretch_all.deb
			dpkg -i zabbix-release_3.4-1+stretch_all.deb
			apt update
			apt install zabbix-agent
	elif test $VERSAO = "8" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-2+jessie_all.deb
			dpkg -i zabbix-release_4.0-2+jessie_all.deb
			apt update
			apt install zabbix-agent
	elif test $VERSAO = "7" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+wheezy_all.deb
			dpkg -i zabbix-release_3.4-1+wheezy_all.deb
			apt update
			apt install zabbix-agent
		else
			echo "VERSAO NAO SUPORTADA. [9/8/7]?"
		fi

	Config
}

function RHEL(){

	if test $VERSAO = "7" 2>/dev/null
		then
			rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
			yum install zabbix-agent
	elif test $VERSAO= "6" 2>/dev/null
		then
			rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/6/x86_64/zabbix-release-4.0-1.el6.noarch.rpm 
			yum install zabbix-agent
		else
			echo "VERSAO NAO SUPORTADA. [7/6]?"
	fi

	Config
}

function Ubuntu(){

	if test	$VERSAO = "18" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+bionic_all.deb
			dpkg -i zabbix-release_4.0-2+bionic_all.deb
			apt update
			apt install zabbix-agent
	elif test $VERSAO = "16" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+xenial_all.deb
			dpkg -i zabbix-release_4.0-2+xenial_all.deb
			apt update
			apt install zabbix-agent
	elif test $VERSAO = "14" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+trusty_all.deb
			dpkg -i zabbix-release_4.0-2+trusty_all.deb
			apt update
			apt install zabbix-agent
		else 
			echo "VERSAO NAO SUPORTADA. [18/16/14]?"
	fi

	Config
}

function install(){
	if test $DISTRO = debian 2>/dev/null
		then
			Debian
	elif test $DISTRO = ubuntu 2>/dev/null
		then
			Ubuntu
	elif test  $DISTRO = rhel 2>/dev/null
		then
			RHEL
	else
		echo "DISTRO NAO SUPORTADA. [Debian/Ubuntu/RHEL]?"
	fi

}

function update(){
	if test $DISTRO = debian 2>/dev/null
	then
		if test	$VERSAO = "9" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-2+stretch_all.deb
			dpkg -i zabbix-release_4.0-2+stretch_all.deb
			apt update
			apt upgrade zabbix-agent -y
	elif test $VERSAO = "8" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-2+jessie_all.deb
			dpkg -i zabbix-release_4.0-2+jessie_all.deb
			apt update
			apt upgrade zabbix-agent -y
	elif test $VERSAO = "7" 2>/dev/null
		then
			wget https://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+wheezy_all.deb
			dpkg -i zabbix-release_3.4-1+wheezy_all.deb
			apt update
			apt upgrade zabbix-agent -y
	else
		echo "VERSAO NAO SUPORTADA. [9/8/7]?"
		fi
	elif test $DISTRO = ubuntu 2>/dev/null
		then
			if test	$VERSAO = "18" 2>/dev/null
			then
				wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+bionic_all.deb
				dpkg -i zabbix-release_4.0-2+bionic_all.deb
				apt update
				apt upgrade zabbix-agent -y
		elif test $VERSAO = "16" 2>/dev/null
			then
				wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+xenial_all.deb
				dpkg -i zabbix-release_4.0-2+xenial_all.deb
				apt update
				apt upgrade zabbix-agent -y
		elif test $VERSAO = "14" 2>/dev/null
			then
				wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+trusty_all.deb
				dpkg -i zabbix-release_4.0-2+trusty_all.deb
				apt update
				apt upgrade zabbix-agent -y
		else 
			echo "VERSAO NAO SUPORTADA. [18/16/14]?"
		fi
	elif test  $DISTRO = rhel 2>/dev/null
		then
			if test $VERSAO = "7" 2>/dev/null
			then
				rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
				yum update
				yum -y upgrade zabbix-agent
		elif test $VERSAO= "6" 2>/dev/null
			then
				rpm -i https://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-4.0-2.el6.noarch.rpm 
				yum update
				yum -y upgrade zabbix-agent
			else
				echo "VERSAO NAO SUPORTADA. [7/6]?"
		fi
	else
		echo "DISTRO NAO SUPORTADA. [Debian/Ubuntu/RHEL]?"
	fi

}

function upgrade(){
	if test $DISTRO = debian 2>/dev/null
		then
			apt upgrade zabbix-agent -y
	elif test $DISTRO = ubuntu 2>/dev/null
		then
			apt upgrade zabbix-agent -y
	elif test  $DISTRO = rhel 2>/dev/null
		then
			yum -y upgrade zabbix-agent 
	else
		echo "DISTRO NAO SUPORTADA. [Debian/Ubuntu/RHEL]?"
	fi
}

if test $FUNCTION = "install"
	then
		install
elif test $FUNCTION = "update"
	then
		update
elif test $FUNCTION = "upgrade"
	then
		update
else 
	echo "Função não suportada. [install/update/upgrade]?"
fi
