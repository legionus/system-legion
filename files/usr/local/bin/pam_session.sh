#!/bin/bash -efu

# Ensure that only one instance is running on the host.
exec < $0
flock 0

arr=()
readarray -d: -t arr <<< $(getent passwd "$PAM_USER") ||:

user_uid=${arr[2]}
user_home=${arr[5]}

sessions=0
[ ! -s "/run/user/$user_uid/count" ] ||
	read -r sessions < "/run/user/$user_uid/count"

case "$PAM_TYPE" in
	open_session)
		if [ "$sessions" -eq 0 ]; then
			mkdir -m 700 -p "/run/user/$user_uid"
			echo 0 > "/run/user/$user_uid/count"
			chown -R --reference="$user_home" "/run/user/$user_uid" ||:
			# mount -t tmpfs tmpfs "/run/user/$user_uid" \
			#	-o rw,nosuid,nodev,seclabel,mode=700,uid=$user_uid,gid=$user_uid
		fi
		sessions=$(( $sessions + 1 ))
		echo $sessions > "/run/user/$user_uid/count"
		;;
	close_session)
		if [ "$sessions" -gt 0 ]; then
			sessions=$(( $sessions - 1 ))
			if [ "$sessions" -eq 0 ]; then
				rm -vrf "/run/user/$user_uid"
				# umount "/run/user/$user_uid"
			else
				echo $sessions > "/run/user/$user_uid/count"
			fi
		fi
		;;
esac
