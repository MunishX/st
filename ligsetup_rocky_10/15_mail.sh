### Postfix Setup
echo "Postfix setup starting..."
sleep 5 

yum -y remove exim

yum install sudo sed postfix -y
sudo sed -i "s/^inet_protocols.*/inet_protocols = ipv4/" /etc/postfix/main.cf
sudo postconf -e 'smtp_tls_security_level = may'
sudo postconf -e 'smtpd_tls_security_level = may'
systemctl start postfix
systemctl enable postfix
systemctl status postfix --no-pager
###

echo ""
echo " PostFix SETUP Configured Successfully..."
echo ""
echo ""
echo "if need to change hostname, run: hostnamectl set-hostname test10.fastserver.me "
echo "set A record"
echo "set SPF record / update server ip in spf record"
echo "set reverse IP Host at Network"
echo ""
echo " Then visit http://$(hostname)/host/PHPMailer/src/test.php"
echo ""

