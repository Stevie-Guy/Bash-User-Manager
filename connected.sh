Verde="\e[1;32m"
Albastru="\e[1;34m"
Galben="\e[1;33m"
Rosu="\e[1;31m"
Alb="\e[1;97m"
reset="\e[0m"

nume=$1
culoareuser="$Alb"
if [ -d "/home/your_dir/$nume" ]; then
    cd "/home/your_dir/$nume"
    echo "You entered /$nume directory!"
    logged_in_users=()
    while IFS= read -r line; do
        logged_in_users+=("$(echo "$line" | sed 's/ .*//')")
    done < <(who)
    logged_in_users+=($nume)

    while true; do
        (/home/your_dir/raport.sh $nume &)
        (sleep 1 &)
        director_curent=$(pwd)

        if [ "$nume" == "Guest" ]; then
            permis="/home/your_dir/Guest"
            echo -ne "${culoareuser}($nume@linux)[Guest]:${reset}"
            interzis=0
            if [[ "$director_curent" != "$permis" && "$director_curent" != $permis/* ]]; then
                interzis=1
            fi
        else
            echo -ne "${culoareuser}($nume@linux)[$director_curent]:${reset}"
        fi

        echo -ne "${Alb}"
        read comanda
        echo $comanda >> /home/your_dir/$nume/istoric.txt
        echo -ne "${reset}"
        director_curent=$(pwd)

        if [ "$comanda" == "helpme" ]; then
            /home/your_dir/ajutor.sh

        elif [ $interzis -eq 1 ]; then
            echo "Can't access this directory."
            cd /home/your_dir/Guest
            sleep 1

        elif [ "$comanda" == "cat" ]; then
            echo "cat"

        elif [ "$comanda" == "raport" ]; then
            cat /home/your_dir/$nume/raport.txt

        elif [ "$comanda" == "dogsay" ]; then
            /home/your_dir/dogsay.sh

        elif [ "$comanda" == "catsay" ]; then
            /home/your_dir/catsay.sh

        elif [ "$comanda" == "istoric" ]; then
            cat /home/your_dir/$nume/istoric.txt

        elif [ "$comanda" == "istoric -c" ]; then
            : > istoric.txt

        elif [ "$comanda" == "dice" ]; then
            /home/your_dir/dice.sh

        elif [ "$comanda" == "whoismyfather" ]; then
            /home/your_dir/father.sh $nume

        elif [ "$comanda" == "sudo" ]; then
            /home/your_dir/sud0.sh

        elif [ "$comanda" == "culoare" ]; then
            echo "Pick a color:"
            echo "1.Default"
            echo "2.Green"
            echo "3.Blue"
            echo "4.Red"
            echo "5.Yellow"
            echo "6.White"
            read color
            if [ $color -eq 1 ]; then
            culoareuser="$reset"
            elif [ $color -eq 2 ]; then
            culoareuser="$Verde"
            elif [ $color -eq 3 ]; then
            culoareuser="$Albastru"
            elif [ $color -eq 4 ]; then
            culoareuser="$Rosu"
            elif [ $color -eq 5 ]; then
            culoareuser="$Galben"
            elif [ $color -eq 6 ]; then
            culoareuser="$Alb"
            fi

        elif [ "$comanda" == "chpass" ] && [ "$nume" != "Guest" ]; then
            echo -n "Enter current password: "
            read parolaactuala
            if grep -E "$nume,$parolaactuala," /home/your_dir/utilizatori.csv > /dev/null; then
                echo -n "New password: "
                read nouaparola
                sed -i "s/$nume,$parolaactuala/$nume,$nouaparola/" /home/your_dir/utilizatori.csv
                echo "Password changed!"
            else
                echo "Password doesn't match!"
            fi

        elif [ "$comanda" == "whoami" ]; then
            gasit=$(tail -n +2 "/home/your_dir/utilizatori.csv" | grep -w "$nume")
            id=$(echo "$gasit" | cut -d ',' -f 4)
            data_creare=$(echo "$gasit" | cut -d ',' -f 6)
            echo "Name: $nume   ID:#$id   Created at: $data_creare"

        elif [ "$comanda" == "delete" ]; then
            echo "Are you sure you want to delete $nume? (Y/N)"
            read raspuns
            if [ "$raspuns" == "Y" ] || [ "$raspuns" == "y" ]; then
                sed -i "/${nume},/d" /home/your_dir/utilizatori.csv
                for ((l = 1; l <= "${#logged_in_users[@]}"; l++)); do
                if [ "${logged_in_users[$l]}" = "$nume" ]; then
                unset logged_in_users[$l]
                fi
                done
                cd /home/your_dir
                rm -r /home/your_dir/$nume
                echo "User $nume deleted."
                sleep 1
                break
            fi

        elif [ "$comanda" == "logout" ] || [ "$comanda" == "exit" ]; then
            for ((l = 1; l <= "${#logged_in_users[@]}"; l++)); do
            if [ "${logged_in_users[$l]}" = "$nume" ]; then
            unset logged_in_users[$l]
            fi
            done
            cd /home/your_dir
            break

        else
            eval $comanda
        fi

  done

else
  echo "Directory /home/your_dir/$nume doesn't exist."
fi

