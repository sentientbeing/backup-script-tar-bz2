# Fanda kdokoli@doma 2014-07-08
# backup script
# 2 positional parameters, 1 optional


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

# test if this script was called with the correct number of parameters
function test_if_number_of_parameters_is_correct() {
	PASSED_NUMBER_OF_PARAM_F="${1}"
	MIN_PARAM_F="${2}"
	MAX_PARAM_F="$((${2}+${3}))"
	if [ "${PASSED_NUMBER_OF_PARAM_F}" -lt "${MIN_PARAM_F}" ]
	then
		exit_with_custom_message_and_code "11"
	elif [ "${PASSED_NUMBER_OF_PARAM_F}" -gt "${MAX_PARAM_F}" ]
	then
		exit_with_custom_message_and_code "12"
	fi
}


#----------- section: essential test: test if this script has syntax errors in it


# test if this script has syntax errors in it
THIS_SCRIPT_FILENAME_F="${0}" # set this variable now, because it is used by the functions called by the function test_last_command_success_or_die_with_custom_exit_code
bash -n "${THIS_SCRIPT_FILENAME_F}"
# test the last command (bash -n "${0}") if this script has syntax errors in it
test_last_command_success_or_die_with_custom_exit_code "${?}" "10"


#----------- section: essential test: test if this script was called with the correct number of parameters


# test if this script was called with the correct number of parameters
test_if_number_of_parameters_is_correct "${#}" "2" "1" # 2 required parameters and 1 optional



#----------- section: define variables

TAR_ARCHIVE_FILENAME_BODY_F="${2}"
DATE_F=$(date +'%F')
TIME_F=$(date +'%H-%M-%S_%Z')
TAR_ARCHIVE_EXTENSION_F="tar.bz2"
TAR_ARCHIVE_FILENAME_F="${TAR_ARCHIVE_FILENAME_BODY_F}.${DATE_F}_${TIME_F}.${TAR_ARCHIVE_EXTENSION_F}"
SOURCE_PATH_F="${1}"
TARGET_BACKUP_DIR_ROOT_F="/home/kdokoli/backup/doma/after-2014-07-07"
TARGET_BACKUP_DIR_F=""
SOURCE_EXCLUDE_PATTERN_F=""
if [ "${#}" -gt "2" ]
then
	SOURCE_EXCLUDE_PATTERN_F="${3}"
fi









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
# TODO: to tar (?) pass --absolute-names or not ?
# tar -cvj -f "${TARGET_PATH_F}" "${TAR_OPTION_EXCLUDE_F}" --absolute-names "${SOURCE_PATH_F}"
echo "running the main command tar :"
if [ -n "${SOURCE_EXCLUDE_PATTERN_F}" ]
then
	set -x
	tar -cvj -f "${TARGET_PATH_F}" --exclude="${SOURCE_EXCLUDE_PATTERN_F}" --absolute-names "${SOURCE_PATH_F}"
else
	set -x
	tar -cvj -f "${TARGET_PATH_F}" --absolute-names "${SOURCE_PATH_F}"
fi
LAST_COMMAND_EXIT_CODE_F="${?}"
set +x
test_last_command_success_or_die_with_custom_exit_code "${LAST_COMMAND_EXIT_CODE_F}" "40"
ls -l "${TARGET_PATH_F}"
test_last_command_success_or_die_with_custom_exit_code "${?}" "45"

exit 0
