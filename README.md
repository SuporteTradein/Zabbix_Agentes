# Zabbix_Agentes
Script para instalação do agente Zabbix em todas as versão suportadas de Linux


Visão geral
Para instalação de um Zabbix-agent em Linux, execute os passos a seguir:

Faça o download do script via git.
git clone https://github.com/SuporteTradein/Zabbix_Agentes
Caso não consiga efetuar o download do script, ele esta anexado ao final do tutorial.
Execute o script de instalação informando a função, distro, versão e  IP do proxy.
bash Zabbix_Agentes/zbx_agnt_linux.sh install rhel 7 192.168.0.100
Obs. No caso de CentOs, Red Hat ou Oracle Linux use rhel
Obs. informar nome da distro totalmente em minúsculo.

        Abaixo distros e versões suportadas
SO Distro	SO Version
Debian	 9 - 8 - 7
Ubuntu	18 - 16 - 14
CentOs	7 - 6
Red Hat EL
7 - 6
Oracle Linux	7 - 6
Para confirmar a instalação execute o comando e veja se o agente está em execução.
ps aux | grep zabbix_agentd
