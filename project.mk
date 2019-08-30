TARGET := $(shell basename $(SUB_DIRECTORY))
TARGET_PATH := $(SUB_DIRECTORY:src/%=%)
$(TARGET)_BIN := $(BIN_DIR)/$(TARGET)
ALL_TARGETS += $($(TARGET)_BIN)

DEPS_ORIG := $(shell go list -f {{.Deps}} $(TARGET_PATH))
# Remove left square brace.
DEPS_TEMP := $(subst [,,$(DEPS_ORIG))
# Remove right square brace.
DEPS := $(subst ],,$(DEPS_TEMP))

# Find all go files in current project direcotry.
$(TARGET)_SRC := $(shell find $(SUB_DIRECTORY) $(NAME_PATTERN))
$(TARGET)_SRC += $(ALL_DEP_SRC)

# Build release binary.
$($(TARGET)_BIN): LOCAL_TARGET_PATH := $(TARGET_PATH)
$($(TARGET)_BIN): $($(TARGET)_SRC)
ifeq "$(DEBUG)" "1"
	go build -gcflags "-N -l" -o $@ $(LOCAL_TARGET_PATH)
else
	go install $(LOCAL_TARGET_PATH)
endif
