all: mcedit.c param.h keys.h sytnx.h config.h def.h color.h
	gfortran -o cellgen.exe cellGen.f90 welcome.f90 scriptmaker.f90 viewer.f90 term.f90
	$(CC) -o mcedit.exe mcedit.c -Os -s -Wall -Wextra -pedantic -std=c99 -fno-unwind-tables -fno-asynchronous-unwind-tables
gen:
		./cellgen.exe
edit:
		chmod + mceditsct.sh
		./mceditsct.sh
clean:
	rm *.exe *.bmp *.inp rm *.eps *.out
.PHONY: clean