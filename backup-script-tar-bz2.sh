# Fanda kdokoli@doma 2014-07-08
# backup script
# 2 positional parameters


#----------- section: define essential functions, defining means no harm no command run:


function exit_with_custom_message_and_code() {
	echo "Error. Script ${THIS_SCRIPT_FILENAME_F} says: Error, Exit code: ${1}"
	exit "${1}"
}



function test_last_command_success_or_die_with_custom_exit_code() {
	if [ "${1}" -ne "0" ]
	then
		exit_with_custom_message_and_code "${2}"
	fi
	return 0
}

#----------- section: essential test: test if this script has syntax errors in it


# test if this script has syntax errors in it
bash -n "${0}"
# test the last command (bash -n "${0}") if this script has syntax errors in it
test_last_command_success_or_die_with_custom_exit_code "${?}" "10"


#----------- section: essential test: test if this script was called with the correct number of parameters


# test if this script was called with the correct number of parameters
if [ "${#}" -ne "2" ]
then
	TMP_EXIT_CODE_1_F="15"
	echo "Error. Script ${0} says: Error, Exit code: ${TMP_EXIT_CODE_1_F}"
	exit "${TMP_EXIT_CODE_1_F}"
fi



#----------- section: define variables

THIS_SCRIPT_FILENAME_F="${0}"
TAR_ARCHIVE_FILENAME_BODY_F="${2}"
DATE_F=$(date +'%F')
TIME_F=$(date +'%H-%M-%S_%Z')
TAR_ARCHIVE_EXTENSION_F="tar.bz2"
TAR_ARCHIVE_FILENAME_F="${TAR_ARCHIVE_FILENAME_BODY_F}.${DATE_F}_${TIME_F}.${TAR_ARCHIVE_EXTENSION_F}"
SOURCE_PATH_F="${1}"
TARGET_BACKUP_DIR_ROOT_F="/home/kdokoli/backup/doma/after-2014-07-07"
TARGET_BACKUP_DIR_F=""











#----------- section: set and test variables and funtions


# set a yet nonexistent directory path
#                  steps: 1. 2. ...
# 1. set a yet nonexistent directory path
N_F=1
while [ -d "${TARGET_BACKUP_DIR_ROOT_F}/${DATE_F}.${N_F}" ]
do
	N_F=$(echo "${N_F} + 1" | bc)
done

# 2. test if ${N_F} is an integer
if [[ ${N_F} =~ ^[0-9]+$ ]]
then
	TARGET_BACKUP_DIR_F="${TARGET_BACKUP_DIR_ROOT_F}/${DATE_F}.${N_F}"
else
	#echo "${N_F}" #uncomment to debug
	exit_with_custom_message_and_code "20"
fi

# 3. test if a target directory name is ok
if [ -z "${TARGET_BACKUP_DIR_F}" ]
then
	#echo "${TARGET_BACKUP_DIR_F}" #uncomment to debug
	exit_with_custom_message_and_code "25"
fi

# 4. test if a target directory exists and terminate if it does
if [ -d "${TARGET_BACKUP_DIR_F}" ]
then
	exit_with_custom_message_and_code "26"
fi

# set the final path
TARGET_PATH_F="${TARGET_BACKUP_DIR_F}/${TAR_ARCHIVE_FILENAME_F}"




#----------- section: do commands


mkdir --verbose "${TARGET_BACKUP_DIR_F}"
test_last_command_success_or_die_with_custom_exit_code "${?}" "30"
cd "${TARGET_BACKUP_DIR_F}"
test_last_command_success_or_die_with_custom_exit_code "${?}" "35"
tar cvjf "${TARGET_PATH_F}" "${SOURCE_PATH_F}"
test_last_command_success_or_die_with_custom_exit_code "${?}" "40"
ls -l "${TARGET_PATH_F}"
test_last_command_success_or_die_with_custom_exit_code "${?}" "45"

exit 0
