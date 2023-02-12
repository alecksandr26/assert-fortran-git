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
OBJS = $(addprefix $(OBJ_DIR)/, assertf.o)

# The libraries
LIBS = $(addprefix $(LIB_DIR)/, libassertf.a)

# The tests
TESTS = $(addprefix $(TEST_BIN_DIR)/, test_assertf.out)

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

$(BUILD_DIR):
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
$(TEST_BIN_DIR)/test_%.out: $(TEST_SRC_DIR)/test_%.f90 $(LIB_DIR)/lib%.a $(INCLUDE_DIR)/%.h
	@echo Compiling: $< $(word 2, $^) -o $@
	@$(F) $(F_FLAGS) -I$(OBJ_DIR)/ $< $(word 2, $^) -o $@

# To clean any compiled test
.PHONY: clean_$(TEST_BIN_DIR)/%.out
clean_$(TEST_BIN_DIR)/%.out: 
	@echo Removing: $(TEST_BIN_DIR)/$(notdir $@)
	@rm $(TEST_BIN_DIR)/$(notdir $@)

# To clean any compiled object
.PHONY: clean_$(OBJ_DIR)/%.o
clean_$(OBJ_DIR)/%.o: $(OBJ_DIR)/%.o
	@echo Removing: $(OBJ_DIR)/$(notdir $@)
	@rm $(OBJ_DIR)/$(notdir $@)

# To clean any module objec
.PHONY: clean_$(OBJ_DIR)/%.mod
clean_$(OBJ_DIR)/%.mod: $(OBJ_DIR)/%.mod
	@echo Removing: $(OBJ_DIR)/$(notdir $@)
	@rm $(OBJ_DIR)/$(notdir $@)

# To clean any compiled library
.PHONY: clean_$(LIB_DIR)/lib%.a
clean_$(LIB_DIR)/lib%.a: $(LIB_DIR)/lib%.a
	@echo Removing: $(LIB_DIR)/$(notdir $@)
	@rm $(LIB_DIR)/$(notdir $@)

# Remove all the compiled things
.PHONY: clean
clean: $(addprefix clean_, $(wildcard $(LIB_DIR)/*.a)) \
       $(addprefix clean_, $(wildcard $(OBJ_DIR)/*.o)) \
       $(addprefix clean_, $(wildcard $(OBJ_DIR)/*.mod)) \
	   $(addprefix clean_, $(wildcard $(TEST_BIN_DIR)/*.out))
ifneq ("$(wildcard $(LIB_DIR))", "")
		@echo Removing: $(LIB_DIR)
		@rmdir $(LIB_DIR)
endif

ifneq ("$(wildcard $(OBJ_DIR))", "")
		@echo Removing: $(OBJ_DIR)
		@rmdir $(OBJ_DIR)
endif

ifneq ("$(wildcard $(TEST_BIN_DIR))", "")
		@echo Removing: $(TEST_BIN_DIR)
		@rmdir $(TEST_BIN_DIR)
endif

ifneq ("$(wildcard $(BUILD_DIR))", "")
		@echo Removing: $(BUILD_DIR)
		@rm -r $(BUILD_DIR)
endif

# To run an specific test
.PHONY: test_%.out
test_%.out: $(TEST_BIN_DIR)/test_%.out
	@echo Testing:
	@echo Running: $<
	@valgrind --leak-check=full --track-origins=yes -s  --show-leak-kinds=all ./$<
	@echo Passed:

# To run all the tests
.PHONY: tests
tests: $(TESTS)
	@echo Testing:
	$(foreach test, $(TESTS), \
		@echo Running: $(test) $(\n) \
		@valgrind --leak-check=full --track-origins=yes -s ./$(test) $(\n))
	@echo Passed:

# Recompile everything again with a different flags
$(BUILD_DIR)/lib%.a:
	@$(MAKE) -B F_FLAGS="-cpp -O3" $(LIB_DIR)/$(notdir $@)
	@echo Copying: $(LIB_DIR)/$(notdir $@) -o $@
	@cp $(LIB_DIR)/$(notdir $@) $@

# To Copy the mod file
$(BUILD_DIR)/%.mod:
	@echo Copying: $(OBJ_DIR)/$(notdir $@) -o $@
	@cp $(OBJ_DIR)/$(notdir $@) $@

# To copy the header file to the build directory
$(BUILD_DIR)/%.h: $(INCLUDE_DIR)/%.h
	@echo Copying: $< -o $@
	@cp $< $@

# To recompile the release lib
.PHONY: compile
compile: $(OBJ_DIR) $(LIB_DIR) $(BUILD_DIR) \
		 $(addprefix $(BUILD_DIR)/, $(notdir $(LIBS))) \
	     $(addprefix $(BUILD_DIR)/, $(notdir $(wildcard $(INCLUDE_DIR)/*.h))) \
         $(addprefix $(BUILD_DIR)/, $(addsuffix .mod, $(notdir $(basename $(OBJS)))))

# To install the lib
.PHONY: install
install: compile
	@echo Installing: $(BUILD_DIR)/libassertf.a -o $(INSTALL_DIR_LIB)/assertf.a
	$(INSTALL) $(BUILD_DIR)/libassertf.a -t $(INSTALL_DIR_LIB)
	@echo Installing: $(BUILD_DIR)/assertf.h -o $(INSTALL_DIR_HEADER)/assertf.h
	$(INSTALL) $(BUILD_DIR)/assertf.h -t $(INSTALL_DIR_HEADER)/assertf.h
	@echo Installing: $(BUILD_DIR)/assertf.mod -o $(INSTALL_DIR_HEADER)/assertf.mod
	$(INSTALL) $(BUILD_DIR)/assertf.mod -t $(INSTALL_DIR_HEADER)/assertf.mod
