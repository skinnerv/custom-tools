!/bin/bash
#
#
#This is checking if the user and group are existing on the machine
# user="kali"
# group="bluetooth"
# group="test"
read user
read group
ue=0
ge=0
#check if user is existing
if grep -q "^$user" /etc/passwd;
then
    ue=0
else
    ue=1
fi 
#check if group is existing
if grep -q "$group" /etc/group;
then
    ge=0
else
    ge=1
fi 

if [ $ue -eq 0 ] && [ $ge -eq 0 ]; then
    # echo "Both are zero."
    if groups $user | grep -q $group; then
        echo "Membership valid!"
    else
        echo "Membership invalid but available to join."
    fi
elif [ $ue -eq 0 ] || [ $ge -eq 0 ]; then
    echo "One exists, one does not. You figure out which."
elif [ $ue -eq 1 ] && [ $ge -eq 1 ]; then
    echo "Both are not found - why are you even asking me this?"
fi
