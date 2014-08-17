# Fanda kdokoli@doma 2014-07-08


#----------- section: define variables

THIS_SCRIPT_FILENAME_F="$0"
TAR_ARCHIVE_FILENAME_BODY_F="${2}"
DATE_F=$(date +'%F')
TIME_F=$(date +'%H-%M-%S_%Z')
TAR_ARCHIVE_EXTENSION_F="tar.bz2"
TAR_ARCHIVE_FILENAME_F="${TAR_ARCHIVE_FILENAME_BODY_F}.${DATE_F}_${TIME_F}.${TAR_ARCHIVE_EXTENSION_F}"
SOURCE_PATH_F="${1}"
TARGET_BACKUP_DIR_ROOT_F="/home/kdokoli/backup/doma/after-2014-07-07"
TARGET_BACKUP_DIR_F=""



function test_last_command_success_or_die_with_custom_exit_code() {
	if [ ! "${1}" -eq "0" ]
	then
		echo "Error. Script ${THIS_SCRIPT_FILENAME_F} says: Error, Exit code: ${2}"
		exit "${2}"
	fi
	return 0
}








#----------- section: set and test variables and funtions

# test if this script has syntax errors in it
bash -n "$0"
test_last_command_success_or_die_with_custom_exit_code "$?" "10"

# set a yet nonexistent directory path
N_F=1
while [ -d "TARGET_BACKUP_DIR_ROOT_F/${DATE_F}.${N_F}" ]
do
	N_F=$(echo "${N_F} + 1" | bc)
done

# test if an integer
if [ ${N_F} =~ '^[0-9]+$' ]
then
	TARGET_BACKUP_DIR_F="${TARGET_BACKUP_DIR_ROOT_F}/${DATE_F}.${N_F}"
else
	exit 11
fi

# test if a target directory name is ok
if [ -n "${TARGET_BACKUP_DIR_F}" -a ! -d "${TARGET_BACKUP_DIR_F}" ]
then
	exit 12
fi

# set the final path
TARGET_PATH_F="${TARGET_BACKUP_DIR_F}/${TAR_ARCHIVE_FILENAME_F}"




#----------- section: do commands


mkdir --verbose "${TARGET_BACKUP_DIR_F}"
test_last_command_success_or_die_with_custom_exit_code "$?" "13"
cd "${TARGET_BACKUP_DIR_F}"
test_last_command_success_or_die_with_custom_exit_code "$?" "14"
tar cvfj "${SOURCE_PATH_F}" "${TARGET_PATH_F}"
test_last_command_success_or_die_with_custom_exit_code "$?" "15"


exit 0
