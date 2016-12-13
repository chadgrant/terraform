!
! crypto setup
crypto isakmp identity address
crypto ikev1 policy 1
  encryption aes
  authentication pre-share
  group 2
  lifetime 28800
  hash sha
exit

!
! tunnel setup
group-policy filter internal
group-policy filter attributes
vpn-filter none
vpn-tunnel-protocol ikev1

!
! tunnel 1
tunnel-group ${tunnel1_ip} type ipsec-l2l
tunnel-group ${tunnel1_ip} general-attributes
  ikev1 pre-shared-key ${tunnel1_key}
  isakmp keepalive threshold 10 retry 3
exit
tunnel-group ${tunnel1_ip} ipsec-attributes
  default-group-policy filter
exit

!
! tunnel 2
tunnel-group ${tunnel2_ip} type ipsec-l2l
tunnel-group ${tunnel2_ip} general-attributes
  ikev1 pre-shared-key ${tunnel2_key}
  isakmp keepalive threshold 10 retry 3
exit
tunnel-group ${tunnel2_ip} ipsec-attributes
  default-group-policy filter
exit

!
! acl setup
${remote_acls}
nat (inside,outside) source static obj-SrcNet obj-SrcNet destination static obj-amzn obj-amzn
icmp permit any outside
sysopt connection tcpmss 1387

!
! ipsec
crypto ipsec ikev1 transform-set transform-amzn esp-aes esp-sha-hmac
crypto ipsec security-association replay window-size 128
crypto ipsec df-bit clear-df outside

!
! crypto map
crypto map outside_map 6 match address acl-amzn
crypto map outside_map 6 set pfs
crypto map outside_map 6 set peer ${tunnel1_ip} ${tunnel2_ip}
crypto map outside_map 6 set ikev1 transform-set ESP-AES-128-SHA
crypto map outside_map 6 set security-association lifetime seconds 3600

!
! sla config
sla monitor 1
  type echo protocol ipIcmpEcho ${sla_host_ip} interface outside
  frequency 5
exit
sla monitor schedule 1 life forever start-time now
