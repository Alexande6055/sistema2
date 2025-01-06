#!/bin/bash

# Configuración de red
configure_network() {
  echo "Configurando red..."
  nmcli con mod ens33 ipv4.addresses 192.168.56.2/24
  nmcli con mod ens33 ipv4.gateway 192.168.56.1
  nmcli con mod ens33 ipv4.dns "8.8.8.8,8.8.4.4"
  nmcli con mod ens33 ipv4.method manual
  nmcli con up ens33
  echo "Red configurada con éxito."
}

# Gestión de usuarios
create_users() {
  echo "Creando usuarios..."
  # Usuario developer con acceso solo a red interna
  useradd -m -s /bin/bash developer
  mkdir -p /home/developer
  chmod 700 /home/developer
  echo "Configurando acceso a red interna para developer..."
  echo "iptables -A OUTPUT -p all -d 192.168.56.0/24 -j ACCEPT" >> /etc/iptables/rules.v4
  echo "iptables -A OUTPUT -p all -d 0.0.0.0/0 -j DROP" >> /etc/iptables/rules.v4

  # Usuario tester con pruebas internas (sin acceso a internet)
  useradd -m -s /bin/bash tester
  mkdir -p /home/tester
  chmod 700 /home/tester
  echo "Configurando acceso limitado a internet para tester..."
  echo "iptables -A OUTPUT -p icmp -d 192.168.56.0/24 -j ACCEPT" >> /etc/iptables/rules.v4
  echo "iptables -A OUTPUT -p all -j DROP" >> /etc/iptables/rules.v4

  echo "Usuarios creados con éxito."
}

# Automatizar pruebas de red
create_network_test_script() {
  echo "Creando script de pruebas de red..."
  cat <<EOL > /home/admin/network_test.sh
#!/bin/bash
ping -c 4 8.8.8.8 > /home/admin/network_tests.log
EOL
  chmod +x /home/admin/network_test.sh
  echo "Script de pruebas creado con éxito."
}

# Generar reporte
generate_report() {
  echo "Generando reporte..."
  cat <<EOL > /home/admin/network_report.txt
Reporte de Configuración de Red y Usuarios

Configuración de Red:
$(nmcli dev show ens33 | grep -E 'IP4.ADDRESS|IP4.GATEWAY|IP4.DNS')

Usuarios y Permisos:
$(cat /etc/passwd | grep -E 'developer|tester')

Resultados de Pruebas de Red:
$(cat /home/admin/network_tests.log)
EOL
  echo "Reporte generado con éxito."
}

# Configurar tarea cron
setup_cron_job() {
  echo "Configurando tarea cron..."
  crontab -l > temp_cron
  echo "0 * * * * /home/admin/network_test.sh" >> temp_cron
  crontab temp_cron
  rm temp_cron
  echo "Tarea cron configurada con éxito."
}

# Ejecución de funciones
configure_network
create_users
create_network_test_script
setup_cron_job
generate_report

echo "Script completado con éxito."
