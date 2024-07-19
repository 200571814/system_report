# Installing and starting services
install_and_start_service() {
  local service_name=$1
  if ! dpkg -l | grep -qw $service_name; then
    echo "Installing $service_name..."
    apt-get install -y $service_name
    echo "$service_name installed."
  else
    echo "$service_name is already installed."
  fi

  echo "Ensuring $service_name is running..."
  systemctl start $service_name
  systemctl enable $service_name
  echo "$service_name is running."
}

# Configuring netplan
configure_netplan() {
    NETPLAN_FILE="/etc/netplan/00-installer-config.yaml"
    IP_ADDRESS="192.168.16.21/24"

    echo "Checking netplan configuration..."
    if ! grep -q "$IP_ADDRESS" "$NETPLAN_FILE"; then
        echo "Configuring netplan..."
        sed -i "/addresses:/c\          addresses: [$IP_ADDRESS]" $NETPLAN_FILE
        netplan apply
    fi
}

# Updating /etc/hosts
update_hosts() {
    HOSTS_FILE="/etc/hosts"
    IP_ADDRESS="192.168.16.21"
    HOSTNAME="server1"

    echo "Updating /etc/hosts..."
    sed -i "/$HOSTNAME/d" $HOSTS_FILE
    echo "$IP_ADDRESS $HOSTNAME" >> $HOSTS_FILE
}

# Configuring ufw firewall
configure_firewall() {
  echo "Configuring ufw firewall..."
  ufw allow from 192.168.16.0/24 to any port 22 proto tcp
  ufw allow 80/tcp
  ufw allow 3128/tcp
  ufw --force enable
  echo "ufw firewall configured."
}

# Creating user accounts
create_users() {
    USERS=("dennis" "aubrey" "captain" "snibbles" "brownie" "scooter" "sandy" "perrier" "cindy" "tiger" "yoda")
    DENNIS_SSH_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm"

    for user in "${USERS[@]}"; do
        if ! id -u "$user" &>/dev/null; then
            echo "Creating user $user..."
            useradd -m -s /bin/bash $user
        fi
        mkdir -p /home/$user/.ssh
        ssh-keygen -t rsa -b 2048 -f /home/$user/.ssh/id_rsa -N ''
        ssh-keygen -t ed25519 -f /home/$user/.ssh/id_ed25519 -N ''
        cat /home/$user/.ssh/id_rsa.pub >> /home/$user/.ssh/authorized_keys
        cat /home/$user/.ssh/id_ed25519.pub >> /home/$user/.ssh/authorized_keys
        if [ "$user" == "dennis" ]; then
            echo $DENNIS_SSH_KEY >> /home/dennis/.ssh/authorized_keys
            usermod -aG sudo dennis
        fi
        chown -R $user:$user /home/$user/.ssh
        chmod 600 /home/$user/.ssh/authorized_keys
    done
}

# Executing main script.
check_install "apache2"
check_install "squid"
configure_netplan
update_hosts
configure_firewall
create_users

echo "Completation of configuration."
