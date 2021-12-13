.PHONY: all clean

all: conf

conf: conf.in
	sed -e 's|@CURDIR@|$(CURDIR)|' $< > $@

clean:
	rm -f conf
