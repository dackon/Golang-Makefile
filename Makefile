SUB_DIRECTORY = $(patsubst %/project.mk,%, \
	$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

SUB_LIB_DIRECTORY = $(patsubst %/library.mk,%, \
	$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

ALL_DEP_SRC = $(shell srcfiles=;\
	for i in $(GOPATH_DIRS);\
	do\
		for j in $(DEPS);\
		do\
			dir="$$i/src/$$j";\
			if [ -d "$$dir" ];\
			then\
				files=`find $$dir $(NAME_PATTERN) 2>/dev/null`;\
				if [ -n "$$files" ];\
				then\
					srcfiles="$$srcfiles $$files";\
				fi;\
			fi;\
		done;\
	done;\
echo "$$srcfiles")

# Parameter for 'find'.
NAME_PATTERN :=-maxdepth 1 -type f -name "*.go" -a ! -name "*_test.go" \
-o -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.cc" \
-o -name "*.hpp" -o -name "*.hxx"

# Split GOPATH variable.
GOPATH_DIRS := $(subst :, , $(GOPATH))

RM := rm -rf

PRJ_DIR := .
MY_REPO := $(PRJ_DIR)/src
ALL_TARGETS :=
ALL_LIB_TARGETS :=
BIN_DIR := $(PRJ_DIR)/bin

ifeq "$(MAKECMDGOALS)" "release"
	DEBUG := 0
else
	DEBUG := 1
endif

OS_NAME := $(shell go env GOOS)
ARCH_NAME := $(shell go env GOARCH)
PKG_DIR := $(PRJ_DIR)/pkg/$(OS_NAME)_$(ARCH_NAME)

ALL_PRJ_MK := $(foreach i,$(MY_REPO),$(shell find $(i) -name project.mk))
ALL_LIB_MK := $(foreach i,$(MY_REPO),$(shell find $(i) -name library.mk))

.PHONY: all
all:

include $(ALL_LIB_MK) $(ALL_PRJ_MK)

all: $(ALL_LIB_TARGETS) $(ALL_TARGETS)

.PHONY: release
release: $(ALL_LIB_TARGETS) $(ALL_TARGETS)

.PHONY: clean
clean:
	@$(RM) $(ALL_TARGETS) $(ALL_LIB_TARGETS)
	@find . -type f -name *~ -exec rm -rf {} \;
