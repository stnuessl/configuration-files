#
# The MIT License (MIT)
#
# Copyright (c) 2021  Steffen Nuessle
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

#CC			:= /usr/bin/clang
#CC			:= /usr/bin/gcc
#CXX		:= /usr/bin/clang++
#CXX		:= /usr/bin/g++

#
# Show / suppress compiler invocations. 
# Set 'SUPP :=' to show them.
# Set 'SUPP := @' to suppress compiler invocations.
#
SUPP		:=

#
# Set name of the binary
#
BIN			:=

ifndef BIN
$(error No binary name specified)
endif

VERSION_MAJOR	:= 0
VERSION_MINOR	:= 1
VERSION_PATCH	:= 0

#
# Use the current unix time as the build timestamp.
#
UNIX_TIME	:= $(shell date --utc +"%s")

#
# Specify all source files. The paths should be relative to this file.
#
SRC			:= \
		$(shell find src/ -iname "*.c")

# 
# Optional: This variable is used by the 'format' and 'tags' targets 
# which are not necessary to build the target.
#
HDR			:= \
		$(shell find src/ -iname "*.h")

ifndef SRC
$(error No source files specified)
endif


#
# Uncomment if 'VPATH' is needed. 'VPATH' is a list of directories in which
# make searches for source files.
#
EMPTY		:=
SPACE		:= $(EMPTY) $(EMPTY)
# VPATH 	:= $(subst $(SPACE),:,$(sort $(dir $(SRC))))

RELPATHS	:= $(filter ../%, $(SRC))
ifdef RELPATHS

NAMES		:= $(notdir $(RELPATHS))
UNIQUE		:= $(sort $(notdir $(RELPATHS)))

#
# Check for duplicate file names (not regarding directories).
#
ifneq ($(words $(NAMES)),$(words $(UNIQUE)))
DUPS		:= $(shell printf "$(NAMES)" | tr -s " " "\n" | sort | uniq -d)
DIRS		:= $(dir $(filter %$(DUPS), $(SRC)))
$(error Detected name duplicates in relative paths [ $(DUPS) ] - [ $(DIRS) ])
endif

#
# Only use file name as the source location and add the relative path to 'VPATH'
# This prevents object files to reside in paths like 'build/src/../relative/' or
# even worse 'build/src/../../relative' which would be a path outside of
# the specified build directory
#
SRC			:= $(filter-out ../%, $(SRC)) $(notdir $(RELPATHS))
VPATH		:= $(subst $(SPACE),:, $(dir $(RELPATHS)))
endif


#
# Paths for the build-, objects- and dependency-directories
#
BUILD_DIR	:= build
TARGET		:= $(strip $(BUILD_DIR))/$(strip $(BIN))

#
# Set installation directory used in 'make install'
#
INSTALL_DIR	:= /usr/local/bin

#
# Define all object and dependency files from $(SRC) and get
# a list of all inhabited directories. 'AUX' is used to prevent file paths
# like build/objs/./srcdir/
#
AUX			:= $(patsubst ./%, %, $(SRC))
C_SRC		:= $(filter %.c, $(AUX))
CXX_SRC		:= $(filter %.cpp, $(AUX))
C_OBJS		:= $(addprefix $(BUILD_DIR)/, $(patsubst %.c, %.o, $(C_SRC)))
CXX_OBJS	:= $(addprefix $(BUILD_DIR)/, $(patsubst %.cpp, %.o, $(CXX_SRC)))
OBJS		:= $(C_OBJS) $(CXX_OBJS)
DIRS		:= $(BUILD_DIR) $(sort $(dir $(OBJS)))

#
# Define dependency and JSON compilation database files.
#
DEPS		:= $(patsubst %.o, %.d, $(OBJS))
JSON		:= $(patsubst %.o, %.json, $(OBJS))

#
# Add additional include paths
#
INCLUDES	:= \

#
# Add used libraries which are configurable with pkg-config
#
PKGCONF		:= \
#		cairo \
#		freetype2 \
#		wayland-client \
#		xcb \
#		xcb-keysyms \
#		xkbcommon \
# 		gstreamer-1.0 \
# 		gstreamer-pbutils-1.0 \
# 		libcurl \
# 		libxml-2.0 \

#
# Set non-pkg-configurable libraries flags 
#
LIBS		:= \
# 		-lm \
#		-lstdc++fs \

#
# Set linker flags, here: 'rpath' for libraries in non-standard directories
# If '-shared' is specified: '-fpic' or '-fPIC' should be set here 
# as in the CFLAGS / CXXFLAGS
#
LDFLAGS		:= \
#		-fPIC \
#		-fpic \
# 		-pthread \
#		-shared \
# 		-Wl,-rpath,/usr/local/lib \
# 		-Wl,--start-group \
# 		-Wl,--end-group \

LDLIBS		:= $(LIBS)

#
# Set the preprocessor flags and also generate a dependency 
# file "$(DEPS)" for each processed translation unit.
#
CPPFLAGS	= \
		$(INCLUDES) \
		-MMD \
		-MF $(patsubst %.o, %.d, $@) \
		-MT $@  \
		-D_GNU_SOURCE \
		-DCOPYRIGHT_YEAR=\"$(shell date --date "@$(UNIX_TIME)" +"%Y")\"

#
# If clang is used, generate a compilation database for each
# processed translation unit.
#
ifeq (clang, $(findstring clang, $(CC) $(CXX)))
CPPFLAGS	+= -MJ $(patsubst %.o, %.json, $@)
endif


#
# Set compiler flags that you want to be present for every make invocation.
# Specific flags for release and debug builds can be added later on
# with target-specific variable values.
#
CFLAGS		:= \
		-std=c11 \
		-Wall \
		-Wextra \
		-pedantic \
		-fstack-protector-strong \
		-fno-plt \
#		-Werror \
#		-fpic \
#		-fno-omit-frame-pointer \


CXXFLAGS	:= \
		-std=c++17 \
		-Wall \
		-Wextra \
		-pedantic \
		-fstack-protector-strong \
		-fno-plt \
#		-Werror \
#		-fpic \
#		-Weffc++ \
#		-fvisibility-inlines-hidden \
#		-fno-rtti \
#		-fno-omit-frame-pointer \

#
# Check if specified pkg-config libraries are available and abort
# if they are not.
#
ifdef PKGCONF

ifneq ($(shell pkg-config --exists $(PKGCONF) && printf $$?), 0)
ALL_PKGS 	:= $(shell pkg-config --list-all | cut -f1 -d " ")
OK_PKGS		:= $(sort $(filter $(PKGCONF), $(ALL_PKGS)))
$(error Missing pkg-config libraries: [ $(filter-out $(OK_PKGS), $(PKGCONF)) ])
endif

CFLAGS		+= $(shell pkg-config --cflags $(PKGCONF))
CXXFLAGS	+= $(shell pkg-config --cflags $(PKGCONF))
LDLIBS		+= $(shell pkg-config --libs $(PKGCONF))
endif

#
# Append extra arguments passed on the command-line
#
CPPFLAGS	+= $(EXTRA_CPPFLAGS)
CFLAGS		+= $(EXTRA_CFLAGS)
CXXFLAGS	+= $(EXTRA_CXXFLAGS)
LDFLAGS		+= $(EXTRA_LDFLAGS)

#
# Setting terminal colors
#

ifneq ($(MAKEFILE_COLOR), 0)

RED			:= \e[1;31m
GREEN		:= \e[1;32m
YELLOW		:= \e[1;33m
BLUE		:= \e[1;34m
MAGENTA		:= \e[1;35m
CYAN		:= \e[1;36m
RESET		:= \e[0m

endif

#
# Get the MD5 hash value of a file passed as an argument.
#
checksum	= $$(sha256sum $(1) | cut -f1 -d " ")


#
# Note that if "-flto" is specified you may want to pass the optimization
# flags used for compiling to the linker (as done below).
#
all: release

release: CPPFLAGS	+= -DNDEBUG
release: CFLAGS		+= -O2 -flto -fdata-sections -ffunction-sections
release: CXXFLAGS	+= -O2 -flto -fdata-sections -ffunction-sections
release: LDFLAGS	+= -O2 -flto -Wl,--gc-sections
release: $(TARGET)

debug: CPPFLAGS		+=
debug: CFLAGS		+= -Og -g2
debug: CXXFLAGS		+= -Og -g2
debug: $(TARGET)

syntax-check: CFLAGS	+= -fsyntax-only
syntax-check: CXXFLAGS	+= -fsyntax-only
syntax-check: $(OBJS)


$(TARGET): $(OBJS)
	@printf "$(YELLOW)Linking [ $@ ]$(RESET)\n"
#	$(SUPP)$(CC) -o $@ $^ $(LDFLAGS) $(LDLIBS)
#	$(SUPP)$(CXX) -o $@ $^ $(LDFLAGS) $(LDLIBS)
	@printf "$(GREEN)Built target [ $@ ]: $(call checksum, $@)$(RESET)\n"

-include $(DEPS)

$(BUILD_DIR)/%.o: %.c
	@printf "$(BLUE)Building: $@$(RESET)\n"
#	$(SUPP)$(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) $<

$(BUILD_DIR)/%.o: %.cpp
	@printf "$(BLUE)Building: $@$(RESET)\n"
#	$(SUPP)$(CXX) -c -o $@ $(CPPFLAGS) $(CXXFLAGS) $<

$(OBJS): | $(DIRS)

$(DIRS):
	mkdir -p $@

compile_commands.json: $(OBJS)
	sed -e '1s/^/[/' -e '$$s/,\s*$$/]/' $(JSON) | json_pp > $@

clean:
	rm -rf $(BUILD_DIR)

format:
	clang-format -i $(HDR) $(SRC)

tags: $(HDR) $(SRC)
	ctags -f tags $^

install: $(TARGET)
	cp $(TARGET) $(INSTALL_DIR)

uninstall:
	rm -f $(INSTALL_DIR)/$(BIN)

.PHONY: \
	all \
	clean \
	debug \
	format \
	install \
	release \
	syntax-check \
	uninstall

.SILENT: \
	clean \
	compile_commands.json \
	format \
	tags \
	$(DIRS)

