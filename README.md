# Bash-User-Manager
Bash script that is capable of managing a database of users, found or created in a csv file.

## Software used for the project
- Linux Bash

## About the project
My classmate and I teamed up for this Operating Systems class project, spending hours on end working together on Discord. We had to dive into learning Bash from scratch in just three months, which was a real challenge. But with lots of teamwork and long coding sessions, we pulled it off, and we’re very proud of how our project turned out! It was a very fulfilling experience.

## How to run the project
### 1. Install all the files on a Linux OS, or use WSL on windows; (Install all of them in the same folder);
### 2. Look in every .sh file and replace "your_dir" with the path where you installed the files;
### 3. Allow all .sh files permission to execute with the *chmod* command. Run `main.sh` using the *source* command.

## Things you should know
- All existent users can be found in `utilizatori.csv`;
- The **Guest** account has limited access and the folder is deleted on logout;
- Password for deleting users is '*admin*'. If you type '*back*' it brings you back to the menu;
- After you logged into an account, use command '*helpme*' to see custom commands we created (and maybe create your own custom commands). Also, you can use basic linux commands normally while logged in, as this simulates a terminal;
- Don't delete files `history.txt` and `raport.txt`.
