#!/bin/bash
echo "The script execution time is: " $(date '+%Y-%m-%d %M:%H:%S')
tfa="terraform apply --auto-approve"
tfd="terraform destroy --auto-approve"
echo "These two commands will be executed based on the user inputs: "
echo ${tfa}
echo ${tfd}
read -p "Please enter what do you want to perform an action:" SELECTION
echo ${SELECTION}
if [[ ${SELECTION} == "tfa" ]];
then
echo "${tfa} in progress..."
${tfa}
elif [[ ${SELECTION} == "tfd" ]];
then
echo "${tfd} in progress..."
${tfd}
else
echo "You've selected wrong option. Please try again with the correct option..."
fi
