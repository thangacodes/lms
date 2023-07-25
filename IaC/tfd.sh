#!/bin/bash
echo "The script execution time is: " $(date '+%Y-%m-%d %M:%H:%S')
tfv="terraform validate"
tfd="terraform destroy --auto-approve"
echo "These two commands will be executed based on the user inputs: "
echo ${tfv}
echo ${tfd}
read -p "Please enter what do you want to perform an action:" SELECTION
echo ${SELECTION}
if [[ ${SELECTION} == "tfv" ]];
then
echo "${tfv} in progress..."
elif [[ ${SELECTION} == "tfd" ]];
then
echo "${tfd} in progress..."
else
echo "You've selected wrong option. Please try again with the correct option..."
fi
