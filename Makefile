
HC = ghc --make -outputdir build -Wall

hub-gen.exe: 
	mkdir -p libexec
	$(HC) -o libexec/hub-gen.exe hub-gen.hs

clean:
	rm -rf libexec/hub-gen.exe build tmp rpmbuild/{SPECS,RPMS,SRPMS,BUILD,BUILDROOT}
