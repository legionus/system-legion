.PHONY: all clean

all: conf

conf: conf.in
	sed \
	  -e 's#@CURDIR@#$(CURDIR)#g' \
	  -e 's#@HOME@#$(HOME)#g' \
	  $< > $@

clean:
	rm -f conf
