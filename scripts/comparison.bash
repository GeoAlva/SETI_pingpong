#! /bin/bash

set -e

r1=$(head -n 1 ../data/tcp_throughput.dat)

r2=$(tail -n 1 ../data/tcp_throughput.dat)

arrIN=(${r1/' '/ })
n1=${arrIN[0]}
t1=${arrIN[1]} 


arrIN=(${r2/' '/ })
n2=${arrIN[0]} 
t2=${arrIN[1]}


d1=$(echo "scale = 9; $n1/$t1 " | bc)
d2=$(echo "scale = 9; $n2/$t2 " | bc)


B=$(echo "scale = 9; ($n2-$n1)/($d2-$d1) " | bc)
echo $B

L0=$(echo "scale = 9; ($d1*$n2-$d2*$n1)/($n2-$n1)" | bc)
echo $L0


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