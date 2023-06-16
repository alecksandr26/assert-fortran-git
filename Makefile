# For debuggin
.SUFFIXES:
%:: SCCS/s.%
%:: RCS/%
%:: RCS/%,v
%:: %,v
%:: s.%

define \n


endef

PKGNAME = assert-fortran-git
F = gfortran

# Options for development
F_DEBUG_FLAGS = -cpp -ggdb -pedantic -Wall -Jobj -Iobj
F_COMPILE_FLAGS = -O2 -DNDEBUG -fno-stack-protector -z execstack -no-pie -Jobj -Iobj
F_FLAGS = $(F_DEBUG_FLAGS)

AR = ar rc

V = valgrind
V_FLAGS = --leak-check=full --track-origins=yes -s  --show-leak-kinds=all

M = makepkg
M_FLAGS = -f --config .makepkg.conf --skipinteg --noextract

# The base directories
OBJ_DIR = obj
SRC_DIR = src
TEST_DIR = test
LIB_DIR = lib
BUILD_DIR = build

# The nested directories
TEST_SRC_DIR = $(addprefix $(TEST_DIR)/, src)
TEST_BIN_DIR = $(addprefix $(TEST_DIR)/, bin)

OBJS = $(addprefix $(OBJ_DIR)/, assertf.o)
LIBS = $(addprefix $(LIB_DIR)/, libassertf.a)
TESTS = $(addprefix $(TEST_BIN_DIR)/, test_assertf.out)

.PHONY: all clean compile test pkg upload-aur
all: $(OBJS) $(LIBS) $(TESTS)

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

$(UPLOAD_DIR):
	@echo Creating: $@
	@mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90 | $(OBJ_DIR)
	@echo Compiling: $< -o $@
	@$(F) $(F_FLAGS) -c $< -o $@

$(LIB_DIR)/%.a: $(OBJS) | $(LIB_DIR)
	@echo Archiving: $^ -o $@
	@$(AR) $@ $^
	@ranlib $@

$(TEST_BIN_DIR)/test_%.out: $(TEST_SRC_DIR)/test_%.f90 $(OBJS) | $(TEST_BIN_DIR)
	@echo Compiling: $^ -o $@
	@$(F) $(F_FLAGS) $^ -o $@

# Remove all the compiled things
clean: 
ifneq ("$(wildcard $(LIB_DIR))", "")
	@echo Removing: $(LIB_DIR) $(wildcard $(LIB_DIR)/*.a)
	@rm -r $(LIB_DIR)
endif

ifneq ("$(wildcard $(OBJ_DIR))", "")
	@echo Removing: $(OBJ_DIR) $(wildcard $(OBJ_DIR)/*.o)
	@rm -r $(OBJ_DIR)
endif

ifneq ("$(wildcard $(TEST_BIN_DIR))", "")
	@echo Removing: $(TEST_BIN_DIR) $(wildcard $(TEST_BIN_DIR)/*.out)
	@rm -r $(TEST_BIN_DIR)
endif

test_%.out: $(TEST_BIN_DIR)/test_%.out
	@echo Testing: $@
	@$(V) $(V_FLAGS) ./$<

test: $(notdir $(TESTS))

# To recompile the release lib
compile: F_FLAGS = $(F_COMPILE_FLAGS)
compile: clean $(LIBS)

pkg:
	@$(M) $(M_FLAGS)

$(UPLOAD_DIR)/$(PKGNAME): $(UPLOAD_DIR)
	@cd $< && git clone $(GCU)

upload-aur: $(UPLOAD_DIR)/$(PKGNAME)
	@cp PKGBUILD $</
	@cd $</ && $(M) --printsrcinfo > .SRCINFO
	@cd $</ && git add PKGBUILD .SRCINFO
	@echo -n "Commit-msg: "
	@read commitmsg
	@cd $</ && git commit -m commitmsg
	@cd $</ && git push
