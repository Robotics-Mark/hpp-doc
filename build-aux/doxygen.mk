#                                                                -*-Automake-*-
# Copyright (C) 2009 by Thomas Moulard, AIST, CNRS, INRIA.
# This file is part of the roboptim.
#
# roboptim is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Additional permission under section 7 of the GNU General Public
# License, version 3 ("GPLv3"):
#
# If you convey this file as part of a work that contains a
# configuration script generated by Autoconf, you may do so under
# terms of your choice.
#
# roboptim is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with roboptim.  If not, see <http://www.gnu.org/licenses/>.

# ------ #
# README #
# ------ #
#
# This mk file contains Doxygen generation rules.
#
# To use this mk file, include init.mk and this file into
# your Makefile.am. You must also provide a Doxyfile.extra
# that may be used to override default Doxygen configuration
# defined in build-aux/doxygen/Doxyfile.
#
# WARNING: This file uses GNU Make extension!

# ---- #
# TODO #
# ---- #
#
# It is possible to avoid using GNU Make extension by avoiding
# the use of patterns in Doxyfile and listing sources files instead.
# For instance, the project could generate a ``doxygen.dep'' file
# in each build directory of directories containing source files
# (see SOURCES variable). I.e.:
# doxygen.dep: Makefile
#	echo "DOXYGEN_INPUT = \"$(DOXYGEN_INPUT) $(SOURCES)\"" > $@
#
# ...and then it might be possible to include all these file in the Makefile.am
# including this file. The INPUT field of Doxyfile would be then generated
# automatically and it would be trivial to handle dependencies.
#
# P.S.: this is a general idea and not a perfect implementation, one problem
# is that doxygen.dep file will have to contain absolute paths
# and not relative as it is usually the case in Automake.

# Define Doxygen directory.
doxygendocdir = $(htmldir)/doxygen-html

# Distributed files.
EXTRA_DIST += 						\
	$(top_srcdir)/build-aux/doxygen/Doxyfile.in	\
	$(top_srcdir)/build-aux/doxygen/doxygen.css	\
	$(top_srcdir)/build-aux/doxygen/doxygen-deps.sh \
	$(top_srcdir)/build-aux/doxygen/footer.html	\
	$(top_srcdir)/build-aux/doxygen/header.html	\
	$(top_srcdir)/build-aux/doxygen/header.tex	\
	$(top_srcdir)/build-aux/doxygen/style.rtf	\
	$(top_srcdir)/build-aux/doxygen/style.tex	\
	$(top_srcdir)/build-aux/doxygen/tabs.css

EXTRA_DIST += 						\
	Doxyfile.extra.in

# Files to be removed by cleaning rule.
CLEANFILES +=				\
	$(PACKAGE_TARNAME).doxytag 	\
	Doxyfile			\
	Doxyfile.extra			\
	doxygen.log			\
	config.log

DOXYGEN_DEPS = $(shell \
	$(top_srcdir)/build-aux/doxygen/doxygen-deps.sh Doxyfile)

# Additional files that will be copied into doxygendocdir.
DOXYGEN_EXTRA =

# Targets rebuilt unconditionally.
.PHONY: doc				\
	html				\
	install-doxygen-html		\
	uninstall-doxygen-html		\
	install-doxygen-html-local	\
	uninstall-doxygen-html-local

# Rules.
doc: html
html-local: doxygen-html

@PACKAGE_TARNAME@.doxytag: Doxyfile 				\
			   $(DOXYGEN_DEPS) $(DOXYGEN_EXTRA)	\
			   $(top_builddir)/config.status
	@if test -d doxygen-html ; then 	\
	  rm -rf doxygen-html/; 		\
	fi
	@$(DOXYGEN) "$<"
	@if ! test "x$(DOXYGEN_EXTRA)" = x; then	\
	 chmod u+w $(DOXYGEN_EXTRA);		\
	 cp -prf $(DOXYGEN_EXTRA) doxygen-html;		\
	fi

doxygen-html: @PACKAGE_TARNAME@.doxytag

# Doxygen generation rules.
Doxyfile.extra: Doxyfile.extra.in		\
	        $(top_builddir)/config.status
	$(top_builddir)/config.status --file="$@":"$<"

Doxyfile: $(top_srcdir)/build-aux/doxygen/Doxyfile.in 	\
	  $(top_builddir)/config.status			\
	  Doxyfile.extra
	@$(top_builddir)/config.status --file="$@":"$<" \
	&& sed -i -e 's/^#.*//' -e '/^$$/d' "$@"	\
	&& cat Doxyfile.extra >> "$@"

# Clean rule.
clean-local:
	@rm -rf doxygen-html/

# Install rules.
install-data-local: install-doxygen-html
install-doxygen-html: html-local install-doxygen-html-local
	@if ! test -d "$(DESTDIR)$(htmldir)"; then \
	  $(mkinstalldirs) "$(DESTDIR)$(htmldir)"; \
	fi
	@cp -prf doxygen-html/ "$(DESTDIR)$(htmldir)"
	@$(INSTALL_DATA) $(PACKAGE_TARNAME).doxytag \
	 "$(DESTDIR)$(doxygendocdir)"

# Uninstall rules.
uninstall-local: uninstall-doxygen-html
uninstall-doxygen-html: uninstall-doxygen-html-local
	rm -rf "$(DESTDIR)$(htmldir)"