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

F_FLAGS_DEBUG = -cpp -ggdb -pedantic -Wall
F_FLAGS_BUILD = -cpp -O3

# The base directories
OBJ_DIR = obj
SRC_DIR = src
TEST_DIR = test
LIB_DIR = lib
BUILD_DIR = build

# The nested directories
TEST_SRC_DIR = $(addprefix $(TEST_DIR)/, src)

TEST_BIN_DIR = $(addprefix $(TEST_DIR)/, bin)

BUILD_LIB_DIR = $(addprefix $(BUILD_DIR)/, lib)

# The dependencies 
OBJS = $(addprefix $(OBJ_DIR)/, assert.o)

# The libraries
LIBS = $(addprefix $(LIB_DIR)/, assert.a)

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
	@$(F) $(F_FLAGS_DEBUG) -c $< -o $@

# To Build the lib
$(LIB_DIR)/%.a: $(OBJ_DIR)/%.o
	@echo Archiving: $^ -o $@
	@$(AR) $@ $^
	@ranlib $@

# To Build the objects in the bebug mode
$(TEST_BIN_DIR)/test_%.out: $(TEST_SRC_DIR)/test_%.f90 $(LIB_DIR)/%.a
	@echo Compiling: $^ -o $@
	@$(F) $(F_FLAGS_DEBUG) $^ -o $@

# Remove all the compiled things
clean:
	@echo Cleaning:
	$(foreach obj, $(OBJS), \
		@echo Removing: $(obj) $(\n) \
		@rm $(obj) $(\n))
	$(foreach lib, $(LIBS), \
		@echo Removing: $(lib) $(\n) \
		@rm $(lib) $(\n))
	$(foreach test, $(TESTS), \
		@echo Removing: $(test) $(\n) \
		@rm $(test) $(\n))
	@echo Removing: $(LIB_DIR)
	@rmdir $(LIB_DIR)
	@echo Removing: $(OBJ_DIR)
	@rmdir $(OBJ_DIR)
	@echo Removing: $(TEST_BIN_DIR)
	@rmdir $(TEST_BIN_DIR)
	@echo Cleaned:

# To run an specific test
test_%.out: $(TEST_BIN_DIR)/test_%.out
	@echo Testing:
	@echo Running: $<
	@valgrind --leak-check=full --track-origins=yes -s  --show-leak-kinds=all ./$<
	@echo Passed:

# Run the tests
tests: $(TESTS)
	@echo Testing:
	$(foreach test, $(TESTS), \
		@echo Running: $(test) $(\n) \
		@valgrind --leak-check=full --track-origins=yes -s ./$(test) $(\n))
	@echo Passed:
