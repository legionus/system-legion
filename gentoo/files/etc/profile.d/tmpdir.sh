# If TMPDIR is not defined or is not a writable directory,
# set it to ~/tmp if the latter is a writable directory.

if [ -z "$TMPDIR" ] || [ ! -d "$TMPDIR" -o ! -w "$TMPDIR" ]; then
	if [ -d "$HOME/tmp" -a -w "$HOME/tmp" ]; then
		export TMPDIR="$HOME/tmp"
	elif [ -d "/tmp" -a -w "/tmp" ]; then
		export TMPDIR="/tmp"
	fi
fi
