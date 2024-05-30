numar1=$(shuf -i 1-6 -n 1)
numar2=$(shuf -i 1-6 -n 1)
rezult=$((numar1 + numar2))
echo "PC:"
sleep 1
echo "Die 1: $numar1"
echo "Die 2: $numar2"

sleep 0.5
echo -e "\nUser:"
sleep 1
numar3=$(shuf -i 1-6 -n 1)
numar4=$(shuf -i 1-6 -n 1)
echo "Die 1: $numar3"
echo "Die 2: $numar4"
rez=$((numar3 + numar4))
echo " Waiting for result..."

sleep 1
if [ $rezult -lt $rez ]; then
echo "You won!"
elif [ $rezult -eq $rez ]; then
echo "Tie!"
else
echo "You lost!"
fi
