OPENSCAD_LIBDIR ?= $$HOME/.local/share/OpenSCAD/libraries

default:
	@echo "Run:"
	@echo "\tmake [OPENSCAD_LIBDIR=OpenScadLibraryDir] install"
	@echo "\t\t OPENSCAD_LIBDIR defaults to $$HOME/.local/share/OpenSCAD/libraries"
	@echo "Be sure of your permission if you specified somewhere else."
	@true

install:
	mkdir -p $(OPENSCAD_LIBDIR)
	cp -rp src/nhf $(OPENSCAD_LIBDIR)/
