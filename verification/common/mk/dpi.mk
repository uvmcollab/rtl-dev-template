##==============================================================================
## [Filename]       dpi.mk
## [Project]        -
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       GNU Makefile
## [Created]        -
## [Modified]       -
## [Description]    Makefile to manage DPI
## [Notes]          
##                  g++ -fPIC -c $(DPI_FILE) -I ${VCS_HOME}/include -o $(DPI_DIR)/dpi.o
##                  -fPIC Flag to generate position-independent code (shared library)
##                  If you want to compile dpi repeatedly and include the .o to simv
##                  but it's better to compile from vcs command
## [Status]         stable
## [Revisions]      -
##==============================================================================

# ================================ DIRECTORIES =================================

SRC_DIR := $(DPI_DIR)/src
OBJ_DIR := $(DPI_DIR)/obj
BIN_DIR := $(DPI_DIR)/bin
INC_DIR := $(DPI_DIR)/include
LIB_DIR := $(DPI_DIR)/lib

DPI_DIR_VARS := SRC_DIR OBJ_DIR BIN_DIR INC_DIR LIB_DIR

# Compiler and flags
CXX      := g++
CXXFLAGS := -Wall -Wextra -std=c++17 -I ./$(INC_DIR)
LDFLAGS  :=

DPI_LIB_NAME = libdpi.so

# Output executable
TARGET := $(BIN_DIR)/app

# Files
SRCS := $(shell find $(SRC_DIR) \( -name "*.cpp" -o -name "*.cc" \) ! -name "hack_dpi.cpp")
OBJS := $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRCS))
OBJS := $(patsubst $(SRC_DIR)/%.cc, $(OBJ_DIR)/%.o, $(OBJS))

# ================================  TARGETS  ==================================

# Rule to compile source files to object files cpp
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	@printf "$(C_CYN)%s$(C_RST)\n" "Compiled: $< -> $@"
	$(CXX) $(CXXFLAGS) -c $< -o $@
#______________________________________________________________________________
	
# Rule to compile source files to object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cc
	@mkdir -p $(dir $@)
	@printf "$(C_CYN)%s$(C_RST)\n" "Compiled: $< -> $@"
	$(CXX) $(CXXFLAGS) -c $< -o $@
#______________________________________________________________________________

# Rule to create the executable
$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	@printf "$(C_CYN)%s$(C_RST)\n" "Linked: $@"
	$(CXX) $(CXXFLAGS) $(OBJS) -o $@ $(LDFLAGS)
#______________________________________________________________________________

.PHONY: build
build: $(TARGET) ## DPI: Build standalone DPI application
#______________________________________________________________________________

.PHONY: run
run: ## DPI: Run standalone DPI application
	@printf "$(C_CYN)%s$(C_RST)\n" "Running $(TARGET)"
	./$(TARGET)
#______________________________________________________________________________

.PHONY: build-dpi
build-dpi: ## DPI: Build DPI shared library for VCS
	@printf "$(C_CYN)%s$(C_RST)\n" "Compiling DPI shared library"
	@mkdir -p $(LIB_DIR)
	$(CXX) -fPIC -shared -std=c++17 -o $(LIB_DIR)/$(DPI_LIB_NAME) \
	-I ${VCS_HOME}/include -I $(INC_DIR) \
	$(SRC_DIR)/dpi.cpp
#______________________________________________________________________________

.PHONY: clean-dpi
clean-dpi: ## DPI: Remove DPI files
	@printf "$(C_CYN)%s$(C_RST)\n" "Removing compilation files"
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(LIB_DIR)
#______________________________________________________________________________

help-dpi: ## DPI: Displays help message
	@printf "%s\n" "================================================================================"
	@printf "%s\n" "                                       DPI.MK                                   "
	@printf "%s\n" "================================================================================"
	@printf "%s\n" "Usage: make <target> [variables]"
	@printf "%s\n" "------------------------------------ TARGETS -----------------------------------"
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(COMMON_MK_DIR)/dpi.mk | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "- make $(C_CYN)%-15s$(C_RST) %s\n", $$1, $$2}'
	@printf "%s\n" "================================================================================"
#_______________________________________________________________________________