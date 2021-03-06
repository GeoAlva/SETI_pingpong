#!/bin/bash

set -e
## PLOT TCP
TCPhead=$(head -n 1 ../data/tcp_throughput.dat)
TCPtail=$(tail -n 1 ../data/tcp_throughput.dat)

read TCP_N1 TCP_TN1 <<< $TCPhead

read TCP_N2 TCP_TN2 <<< $TCPtail

TCP_DN1=$(echo "scale=9 ; $TCP_N1/$TCP_TN1" | bc)
TCP_DN2=$(echo "scale=9 ; $TCP_N2/$TCP_TN2" | bc)

TCP_L0=$(echo "scale=9 ; ($TCP_DN1*$TCP_N2 - $TCP_DN2*$TCP_N1)/($TCP_N2-$TCP_N1)" | bc)
TCP_B=$(echo "scale=9 ; ($TCP_N2-$TCP_N1)/($TCP_DN2-$TCP_DN1)" | bc)

gnuplot <<-eNDgNUPLOTcOMMAND
	set term png size 900, 700
	set output "../data/TCP_Latency-bandwith.png"
	set logscale x 2
	set logscale y 10
	set xlabel "msg size (B)"
	set ylabel "throughput (KB/s)"
    lbf(x)=x/($TCP_L0+x/$TCP_B)
    plot lbf(x) title "Latency-Bandwidth model with L=$TCP_L0 and B=$TCP_B" with linespoints, \
    "../data/tcp_throughput.dat" using 1:2 title "TCP Throughput" with linespoints
	clear
eNDgNUPLOTcOMMAND


##PLOT UDP

UDPhead=$(head -n 1 ../data/udp_throughput.dat)
UDPtail=$(tail -n 1 ../data/udp_throughput.dat)

read UDP_N1 UDP_TN1 <<< $UDPhead

read -r UDP_N2 UDP_TN2 <<< $UDPtail

UDP_DN1=$(echo "scale=9 ; $UDP_N1/$UDP_TN1" | bc)
UDP_DN2=$(echo "scale=9 ; $UDP_N2/$UDP_TN2" | bc)

UDP_L0=$(echo "scale=9 ; ($UDP_DN1*$UDP_N2 - $UDP_DN2*$UDP_N1)/($UDP_N2-$UDP_N1)" | bc)
UDP_B=$(echo "scale=9 ; ($UDP_N2-$UDP_N1)/($UDP_DN2-$UDP_DN1)" | bc)

gnuplot <<-eNDgNUPLOTcOMMAND
	set term png size 900, 700
	set output "../data/UDP_Latency-bandwith.png"
	set logscale x 2
	set logscale y 10
	set xlabel "msg size (B)"
	set ylabel "throughput (KB/s)"
    lbf(x)=x/($UDP_L0+x/$UDP_B)
    plot lbf(x) title "Latency-Bandwidth model with L=$UDP_L0 and B=$UDP_B" with linespoints, \
    "../data/udp_throughput.dat" using 1:2 title "UDP Throughput" with linespoints
	clear
eNDgNUPLOTcOMMAND