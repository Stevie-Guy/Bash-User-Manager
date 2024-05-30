nume=$1
tree | tail -n 1 > /home/your_dir/$nume/raport.txt
echo -n "User size: " >> /home/your_dir/$nume/raport.txt
du -sh | sed 's/  .//' >> /home/your_dir/$nume/raport.txt


