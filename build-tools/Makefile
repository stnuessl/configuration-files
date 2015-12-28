#
# The MIT License (MIT)
#
# Copyright (c) <2015> Steffen Nüssle
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

CC 		:= /usr/bin/gcc
CXX		:= /usr/bin/g++


#
# Set name of the binary
#
BIN		:= 

ifndef BIN
$(error "No binary name specified")
endif

#
# Specify all source files
#
SRC 		:= $(shell find -iname *.c)


ifndef SRC
$(error "No source files specified")
endif

#
# 'VPATH' is needed for the pattern rule %.o: %.c to work
# Generate it from $(SRC)
#
EMPTY		:=
SPACE		:= $(EMPTY) $(EMPTY)
VPATH 		:= $(subst $(SPACE),:,$(sort $(dir $(SRC))))


#
# Paths for the build-, objects- and dependency-directories
#
BUILDDIR	:= build
OBJDIR 		:= $(BUILDDIR)/objs
DEPDIR		:= $(BUILDDIR)/deps
TARGET 		:= $(BUILDDIR)/$(BIN)
DIRS		:= $(BUILDDIR) $(OBJDIR) $(DEPDIR)

#
# Set installation directory used in 'make install'
#
INSTALL_DIR	:= /usr/local/bin/

#
# Generate all object and dependency files from $(SRC)
#
OBJS		:= $(addprefix $(OBJDIR)/,$(notdir $(patsubst %.c,%.o,$(SRC))))
DEPS		:= $(addprefix $(DEPDIR)/,$(notdir $(patsubst %.c,%.d,$(SRC))))

#
# Add additional preprocessor definitions
#
DEFS		:= \
#		-D_GNU_SOURCE						\
#		-DNDEBUG						\

#
# Add additional include paths
#
INCLUDE		:= \
# 		-I./						\

#
# Add used libraries which are configurable with pkg-config
#
PKGCONF		:= \
# 		gstreamer-1.0						\
# 		gstreamer-pbutils-1.0					\
# 		libcurl							\
# 		libxml-2.0						\

#
# Set non-pkg-configurable libraries flags 
#
LIBS		:= \
# 		-pthread						\
# 		-lm							\

#
# Set linker flags, here: 'rpath' for libraries in non-standard directories
#
LDFLAGS		:= \
# 		-Wl,-rpath,/usr/local/lib

LDLIBS		:= $(LIBS)

ifdef PKGCONF
LDLIBS += $(shell pkg-config --libs --cflags $(sort $(PKGCONF)))
endif
		
CPPFLAGS	= \
		$(DEFS)							\
		$(INCLUDE)						\
		-MMD -MF $(DEPDIR)/$(notdir $(patsubst %.o,%.d,$@)) 	\
		-MT $@ 							\

#
# Set additional compiler flags
#
CFLAGS  	:= \
		-std=c11 						\
		-O2 							\
		-Wall							\
		-Wextra 						\
		-Werror 						\
		-Wpedantic						\
# 		-g3							\
# 		-std=c++14						\
# 		-fno-omit-frame-pointer 				\
# 		-Weffc++						\
#		-fpic							\
#		-shared							\

CXXFLAGS	:= \
		-std=c++14						\
		-Weffc++						\


all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $(CPPFLAGS) $(CFLAGS) $^ $(LDFLAGS) $(LDLIBS)

-include $(DEPS)

$(OBJDIR)/%.o: %.c
	$(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) $< $(LDFLAGS) $(LDLIBS)

$(OBJS): | $(DIRS)

$(DIRS):
	mkdir -p $(DIRS)

clean:
	rm -rf $(TARGET) $(DIRS) 

install: $(TARGET)
	cp $(TARGET) $(INSTALL_DIR)

uninstall:
	rm -f $(INSTALL_DIR)$(BIN)

.PHONY: clean uninstall
.SILENT: clean
