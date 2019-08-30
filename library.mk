TARGET := $(shell basename $(SUB_LIB_DIRECTORY))
TARGET_PATH := $(SUB_LIB_DIRECTORY:src/%=%)
$(TARGET)_LIB := $(PKG_DIR)/$(TARGET_PATH).a
ALL_LIB_TARGETS += $($(TARGET)_LIB)

DEPS_ORIG := $(shell go list -f {{.Deps}} $(TARGET_PATH))
# Remove left square brace.
DEPS_TEMP := $(subst [,,$(DEPS_ORIG))
# Remove right square brace.
DEPS := $(subst ],,$(DEPS_TEMP))

# Find all go files in current project direcotry.
$(TARGET)_SRC := $(shell find $(SUB_LIB_DIRECTORY) $(NAME_PATTERN))
$(TARGET)_SRC += $(ALL_DEP_SRC)

# Build target.
$($(TARGET)_LIB): LOCAL_TARGET_PATH := $(TARGET_PATH)
$($(TARGET)_LIB): $($(TARGET)_SRC)
ifeq "$(DEBUG)" "1"
	go build -gcflags "-N -l" -o $@ $(LOCAL_TARGET_PATH)
else
	go install $(LOCAL_TARGET_PATH)
endif
