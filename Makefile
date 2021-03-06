


.NOTPARALLEL:
 
default: build/make.inc all 

all: serial mpi  smp mpiandsmp  eos spacegroup stateinfo stateconvert species

build/make.inc:
	perl ./setup.pl
	
include build/make.inc

serial:
	cd build/serial; $(MAKE) 

mpi:
	cd build/mpi; $(MAKE) 

smp:
	cd build/smp; $(MAKE)
	
debug:
	cd build/debug; $(MAKE)

mpiandsmp:
	cd build/mpiandsmp; $(MAKE)

test::
	cd test/; $(MAKE) 
	
testsum::
	cd test/; $(MAKE) summary
	
doc:  spacegroupdoc stateconvertdoc stateinfodoc inputdoc excitingfuncdoc
	
excitingfuncdoc::
	$(MAKE) -f build/Make.common doc
	
spacegroupdoc::
	cd src/spacegroup; $(MAKE) doc;\
	mv spacegroup.pdf ../../docs/spacegroup
 
inputdoc::
	cd docs/exciting/;\
	xsltproc --stringparam importancelevels "essential expert" ../../xml/schematolatex.xsl ../../xml/excitinginput.xsd >excitinginput.tex;\
	pdflatex excitinginput.tex;\
	pdflatex excitinginput.tex
	
stateconvertdoc::
	cd src/stateconvert; $(MAKE) doc;\
	mv stateconvert.pdf ../../docs/stateconvert
 
stateinfodoc::
	cd src/stateinfo; $(MAKE) doc;\
	mv stateinfo.pdf ../../docs/stateinfo
 
eos::
	cd src/eos; $(MAKE)
	
spacegroup::
	cd src/spacegroup; $(MAKE)

stateinfo::
	cd src/stateinfo; $(MAKE)
  
stateconvert::
	cd src/stateconvert; $(MAKE)  
	
species::libs
	cd src/species; $(MAKE)

libs:
	cd build/serial; $(MAKE) libs

debian:all doc
	cd debian &&   bash makepackage.sh

clean:

	cd build/serial; $(MAKE) clean cleanlibs
	cd build/mpi; $(MAKE) clean cleanlibs
	cd build/smp; $(MAKE) clean cleanlibs
	cd build/debug; $(MAKE) clean cleanlibs
	cd build/mpiandsmp; $(MAKE) clean cleanlibs
	cd test/build ;$(MAKE) clean cleanlibs
	cd src/eos; $(MAKE) clean
	cd src/spacegroup; $(MAKE) clean
	cd src/species; $(MAKE) clean
	cd src/vdwdf; $(MAKE) clean
	cd src/stateinfo; $(MAKE) clean
	cd src/stateconvert; $(MAKE) clean
	rm -f *.o *.mod *~ fort.* ifc* *.gcno *.exe exdg.*
	rm -f bin/exciting?*
	rm -f interfaces/*
	rm -f docs/exciting/*
	rm -f docs/spacegroup/*
	rm -rf debian/debian/usr
	rm -f src/leblaiklib/*.o src/leblaiklib/*.a

libxcclean:
	cd src/libXC && make clean 

tgz::doc libxcclean
	tar  --exclude-from=".gitignore" -C"../" -c -v  -f ../exciting.tar  ./exciting
	tar   -C"../" -r -v  -f ../exciting.tar   ./exciting/.git/HEAD  ./exciting/.git/refs ./exciting/.git/packed-refs \
	./exciting/test/test02/reference/
	gzip  -f --best ../exciting.tar 
	du -h ../exciting.tar.gz 
	
tidy:
	cd build/serial;\
	$(MAKE) -f ../Make.common tidy 

vdwdf:
	cd src/vdwdf
	$(MAKE)
