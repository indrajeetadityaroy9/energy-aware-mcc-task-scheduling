CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -Wpedantic -Wshadow -O2 -MMD -MP
TARGET := mcc_scheduler
SOURCES := mcc.cpp
OBJECTS := $(SOURCES:.cpp=.o)
DEPS := $(OBJECTS:.o=.d)

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(OBJECTS) -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(OBJECTS) $(DEPS) $(TARGET)

-include $(DEPS)
