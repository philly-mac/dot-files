#!/usr/bin/env ruby

#Set variables
def cmd
  @cmd ||= "/usr/sbin/iptables"
end

def vpn_ips
  @vpn_ips ||= ['217.174.251.141']
end

def lan
  @lan ||= '192.168.0.0/24'
end

def vpn_port
  @vpn_port ||= '1149'
end

def flush
  # Flush rules
  system "#{cmd} -F"
  system "#{cmd} -X"
end

def my_servers
  @my_servers ||= [
    "109.74.195.164",
    "178.79.177.241"
  ]
end

def stopped_blocked_ports
  @stopped_blocked_ports ||= [
    '80', '22', '3000:3100',
    '8000:8100'
  ]
end

def start
  flush

  #Default policies and define chains
  system "#{cmd} -P OUTPUT DROP"
  system "#{cmd} -P INPUT DROP"
  system "#{cmd} -P FORWARD DROP"

  # Allow input from LAN and tun0 ONLY
  system "#{cmd} -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"
  system "#{cmd} -A INPUT -i lo -j ACCEPT"
  system "#{cmd} -A INPUT -i tun+ -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT"
  system "#{cmd} -A INPUT -s #{lan} -j ACCEPT"

  vpn_ips.each do |vpn_ip|
    system "#{cmd} -A INPUT -s #{vpn_ip} -j ACCEPT"
  end

  my_servers.each do |my_server|
    system "#{cmd} -A INPUT -s #{my_server} -j ACCEPT"
  end

  system "#{cmd} -A INPUT -j DROP"

  # Allow output to lo, LAN tunX and vpn ips
  system "#{cmd} -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"
  system "#{cmd} -A OUTPUT -o lo -j ACCEPT"
  system "#{cmd} -A OUTPUT -d #{lan} -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT"

  vpn_ips.each do |vpn_ip|
    system "#{cmd} -A OUTPUT -d #{vpn_ip} -j ACCEPT"
  end

  my_servers.each do |my_server|
    system "#{cmd} -A OUTPUT -d #{my_server} -j ACCEPT"
  end

  system "#{cmd} -A OUTPUT -o tun+ -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT"
  system "#{cmd} -A OUTPUT -j DROP"
end

def stop
  flush

  #Default policies and define chains
  system "#{cmd} -P OUTPUT ACCEPT"
  system "#{cmd} -P INPUT ACCEPT"
  system "#{cmd} -P FORWARD DROP"

  # Allow input from LAN and tun0 ONLY
  system "#{cmd} -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"

  stopped_blocked_ports.each do |stopped_blocked_port|
    system "#{cmd} -A INPUT -p tcp --dport #{stopped_blocked_port} -j DROP"
  end

  system "#{cmd} -A INPUT -j ACCEPT"
end

start if /^start$/i =~ ARGV[0].strip
stop if /^stop$/i =~ ARGV[0].strip

system "/usr/sbin/rc.d save iptables"

exit 0