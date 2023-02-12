# For debuggin
.SUFFIXES:
%:: SCCS/s.%
%:: RCS/%
%:: RCS/%,v
%:: %,v
%:: s.%

define \n


endef

F = gfortran
AR = ar rc
INSTALL = install

# Options for development
F_FLAGS = -cpp -ggdb -pedantic -Wall

# The base directories
OBJ_DIR = obj
SRC_DIR = src
TEST_DIR = test
LIB_DIR = lib
BUILD_DIR = build
INCLUDE_DIR = include
INSTALL_DIR_LIB = $(ROOT_DIR)/usr/lib
INSTALL_DIR_HEADER = $(ROOT_DIR)/usr/include

# The nested directories
TEST_SRC_DIR = $(addprefix $(TEST_DIR)/, src)
TEST_BIN_DIR = $(addprefix $(TEST_DIR)/, bin)
BUILD_OBJ_DIR = $(addprefix $(BUILD_DIR)/, obj)
BUILD_LIB_DIR = $(addprefix $(BUILD_DIR)/, lib)

# The dependencies 
OBJS = $(addprefix $(OBJ_DIR)/, assert.o)

# The libraries
LIBS = $(addprefix $(LIB_DIR)/, libassert.a)

# The tests
TESTS = $(addprefix $(TEST_BIN_DIR)/, test_assert.out)

# Build all
all: $(OBJ_DIR) $(LIB_DIR) $(TEST_BIN_DIR) $(OBJS) $(LIBS) $(TESTS)

# Build the directories
$(OBJ_DIR):
	@echo Creating: $@
	@mkdir -p $@

$(LIB_DIR):
	@echo Creating: $@
	@mkdir -p $@

$(TEST_BIN_DIR):
	@echo Creating: $@
	@mkdir -p $@

# To Build the objects in the bebug mode
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90
	@echo Compiling: $< -o $@
	@$(F) $(F_FLAGS) -c $< -o $@
	@mv $(basename $(notdir $<)).mod $(OBJ_DIR)/

# To Build the lib
$(LIB_DIR)/lib%.a: $(OBJ_DIR)/%.o
	@echo Archiving: $^ -o $@
	@$(AR) $@ $^
	@ranlib $@

# To Build the objects in the bebug mode
$(TEST_BIN_DIR)/test_%.out: $(TEST_SRC_DIR)/test_%.f90 $(LIB_DIR)/lib%.a $(INCLUDE_DIR)/%f.h
	@echo Compiling: $^ -o $@
	@$(F) $(F_FLAGS) -I$(OBJ_DIR) $^ -o $@

# Remove all the compiled things
clean:
	@echo Cleaning:
	$(foreach obj, $(shell ls $(OBJ_DIR)/ 2>/dev/null), \
		@echo Removing: $(OBJ_DIR)/$(obj) $(\n) \
		@rm $(OBJ_DIR)/$(obj) $(\n))
	$(foreach lib, $(shell ls $(LIB_DIR)/ 2>/dev/null), \
		@echo Removing: $(LIB_DIR)/$(lib) $(\n) \
		@rm $(LIB_DIR)/$(lib) $(\n))
	$(foreach test, $(shell ls $(TEST_BIN_DIR)/ 2>/dev/null), \
		@echo Removing: $(test) $(\n) \
		@rm $(TEST_BIN_DIR)/$(test) $(\n))

ifneq ("$(wildcard $(LIB_DIR)/)", "")
		@echo Removing: $(LIB_DIR)
		@rmdir $(LIB_DIR)
endif

ifneq ("$(wildcard $(OBJ_DIR))", "")
		@echo Removing: $(OBJ_DIR)
		@rm -r $(OBJ_DIR)
endif

ifneq ("$(wildcard $(TEST_BIN_DIR))", "")
		@echo Removing: $(TEST_BIN_DIR)
		@rmdir $(TEST_BIN_DIR)
endif

ifneq ("$(wildcard $(BUILD_DIR))", "")
		@echo Removing: $(BUILD_DIR)
		@rm -r $(BUILD_DIR)
endif
	@echo Cleaned:

# To run an specific test
test_%.out: $(TEST_BIN_DIR)/test_%.out
	@echo Testing:
	@echo Running: $<
	@valgrind --leak-check=full --track-origins=yes -s  --show-leak-kinds=all ./$<
	@echo Passed:

# To run all the tests
tests: $(TESTS)
	@echo Testing:
	$(foreach test, $(TESTS), \
		@echo Running: $(test) $(\n) \
		@valgrind --leak-check=full --track-origins=yes -s ./$(test) $(\n))
	@echo Passed:

# To compile the release lib
compile: F_FLAGS = -cpp -O3
compile: clean $(OBJ_DIR) $(LIB_DIR) $(TEST_BIN_DIR) $(OBJS) $(LIBS)
	@echo Creating: $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)
	@echo Build:
	$(foreach lib, $(LIBS), \
		@echo Copying: $(lib) -o $(BUILD_DIR)/$(notdir $(lib)) $(\n) \
		@cp $(lib) $(BUILD_DIR)/ $(\n))

# The module file
	$(foreach obj, $(OBJS), \
		@echo Copying: $(basename $(obj)).mod -o $(BUILD_DIR)/$(basename $(notdir $(obj))).mod $(\n) \
		@cp $(basename $(obj)).mod $(BUILD_DIR)/ $(\n))

# To install the lib
install: compile
	@echo Install:
	$(foreach lib, $(LIBS), \
		@echo Installing: $(lib) -o $(INSTALL_DIR_LIB)/$(notdir $(lib)) $(\n) \
		sudo $(INSTALL) $(lib) $(INSTALL_DIR_LIB)/ $(\n))

	$(foreach obj, $(OBJS), \
		@echo Installing: $(basename $(obj)).mod -o \
					$(INSTALL_DIR_HEADER)/$(basename $(notdir $(obj))).mod $(\n) \
		sudo $(INSTALL) $(basename $(obj)).mod $(INSTALL_DIR_HEADER)/ $(\n))

	@echo Installing: $(INCLUDE_DIR)/assertf.h -o $(INSTALL_DIR_HEADER)/assertf.h
	sudo $(INSTALL) $(INCLUDE_DIR)/assertf.h $(INSTALL_DIR_HEADER)/assertf.h
