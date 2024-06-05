while true ; do
ultimul_id=$(tail -n +2 utilizatori.csv | cut -d ',' -f 4 | sort -n | tail -n 1)
if [ -z "$ultimul_id" ]; then
    ultimul_id=1000
fi
urmatorul_id=$((ultimul_id + 1))

echo "1.Sign In"
echo "2.Create new user"
echo "3.Delete account(admin)"
echo "4.Exit"
echo "5.Guest"
read varianta

if [ $varianta -eq 4 ]; then
    break
fi

if [ $varianta -eq 1 ]; then
    echo -n "Enter username: "
    read  nume

    if [ "$nume" == "exit" ]; then
        break
    fi

    if [ "$nume" == "Guest" ] || [ "$nume" == "guest" ]; then
        echo ".............................................."
        sleep 1
        echo "Name unavailable."

    elif tail -n +2 utilizatori.csv | cut -d ',' -f 1 | grep -x "$nume" > /dev/null; then
        i=0
        echo "Enter password: "
        read -s parola

        while ! grep -E "^$nume,$parola," utilizatori.csv > /dev/null; do
            i=$((i + 1))
            if [ $i -lt 3 ]; then
                echo "Incorrect password for $nume. $((3 - i)) tries left."
                echo "Try again: "
                read -s parola
            else
                echo "No more tries left."
                break
            fi
        done

        if [ $i -eq 3 ]; then
            break
        fi

        if grep -E "$nume,$parola," utilizatori.csv > /dev/null; then
            ultima_accesare=$(date +"%d-%m-%Y %H:%M:%S")
            fisier_temporar=$(mktemp)

            while IFS=, read -r csv_nume csv_parola csv_mail csv_id csv_last_login csv_data_creare; do
                if [[ "$csv_nume" == "$nume" && "$csv_parola" == "$parola" ]]; then
                    echo "$csv_nume,$csv_parola,$csv_mail,$csv_id,$ultima_accesare,$csv_data_creare" >> "$fisier_temporar"
                else
                    echo "$csv_nume,$csv_parola,$csv_mail,$csv_id,$csv_last_login,$csv_data_creare" >> "$fisier_temporar"
                fi
            done < utilizatori.csv

            mv "$fisier_temporar" utilizatori.csv
            source connected.sh $nume
        fi
    else
        echo "User doesn't exist. Do you want to create it?"
        echo "Y/N"
        read raspuns

        if [ "$raspuns" = "Y" ] || [ "$raspuns" = "y" ]; then
            data_creare=$(date +"%d-%m-%Y")
            echo -ns "Pass: "
            read parola1
            echo -n "Mail: "
            read mail1
            echo "$nume,$parola1,$mail1,$urmatorul_id,never,$data_creare" >> utilizatori.csv
            mkdir -p "/home/your_dir/$nume"
            touch /home/your_dir/$nume/raport.txt
            touch /home/your_dir/$nume/istoric.txt
            echo "Utilizator creat cu succes!"
        fi
    fi
fi

if [ $varianta -eq 2 ]; then
    echo -n "New username: "
    read nume
    if grep -E "$nume," utilizatori.csv > /dev/null; then
        echo "User already exists."
    else
        data_creare=$(date +"%d-%m-%Y")
        echo -ns "Pass:"
        read parola1
        echo -n "Mail:"
        read mail1
        echo "$nume,$parola1,$mail1,$urmatorul_id,never,$data_creare" >> utilizatori.csv
        mkdir -p "/home/your_dir/$nume"
        touch /home/your_dir/$nume/raport.txt
        touch /home/your_dir/$nume/istoric.txt
        echo "Success!"
    fi
fi

if [ $varianta -eq 3 ]; then
    echo "Admin password: "
    read -s p4rola
    o=0
    while [ "$p4rola" != "admin" ]; do
        o=$((o + 1))
        if [ $o -lt 3 ]; then
            echo "Incorrect. $((3 - o)) tries left. "
            read -s p4rola

            if [ "$p4rola" == "back" ] || [ "$p4rola" == "Back" ]; then
            break
            fi

        else
            echo "Out of tries."
            sleep 2
            exit
        fi
    done
    if [ "$p4rola" == "admin" ]; then
        echo "Users:"
        tail -n +2 utilizatori.csv | cut -d ',' -f 1
        echo -n "User you want to delete: "
        read nume

        if tail -n +2 utilizatori.csv | cut -d ',' -f 1 | grep -x "$nume" > /dev/null; then
            if [ "$p4rola" == "admin" ]; then
                echo "Are you sure you want to delete $nume? Y/N"
                read da
                if [ "$da" == "Y" ] || [ "$da" == "y" ]; then
                rm -r /home/your_dir/$nume
                sed -i "/${nume},/d" utilizatori.csv
                echo "User $nume deleted!"
                fi
            fi
        else
        echo "User doesn't exist!"
    fi
    fi
fi

if [ $varianta -eq 5 ]; then
    nume="Guest"
    echo "Connecting to Guest account..."
    sleep 1
    mkdir -p "/home/your_dir/Guest"
    touch /home/your_dir/Guest/raport.txt
    touch /home/your_dir/Guest/istoric.txt
    source connected.sh $nume
    rm -r /home/your_dir/$nume

fi

done
