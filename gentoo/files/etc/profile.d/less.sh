if [ -z "$LESS" ]; then
	export LESS=-MM
fi

if [ -z "$LESSKEY" -a ! -f "$HOME/.less" ]; then
	export LESSKEY=/etc/.less
fi

if [ -z "$LESSOPEN" -a -x /usr/share/less/lesspipe.sh ]; then
	export LESSOPEN="|/usr/share/less/lesspipe.sh %s"
fi
