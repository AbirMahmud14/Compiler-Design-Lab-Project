CC = gcc
CFLAGS = -Wall -Wextra -std=c99
FLEX = flex
BISON = bison

# Targets
all: c_tokenizer c_parser

# C Tokenizer (Flex only)
c_tokenizer: lex.yy.c
	$(CC) $(CFLAGS) -o c_tokenizer lex.yy.c -lfl

lex.yy.c: lexer.l
	$(FLEX) lexer.l

# C Parser (Flex + Bison)
c_parser: parser.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o c_parser parser.tab.c -lfl -ly

parser.tab.c: parser.y
	$(BISON) -d parser.y

# Clean up
clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h c_tokenizer c_parser *.o

# Test with sample C code
test: c_tokenizer
	@echo "Testing with sample C code..."
	@echo "#include <stdio.h>" > test.c
	@echo "" >> test.c
	@echo "int main() {" >> test.c
	@echo "    int x = 10; // This is a comment" >> test.c
	@echo "    printf(\"Hello World\");" >> test.c
	@echo "    return 0;" >> test.c
	@echo "}" >> test.c
	./c_tokenizer test.c
	@rm -f test.c

# Install dependencies (for Ubuntu/Debian)
install-deps:
	sudo apt-get update
	sudo apt-get install -y flex bison build-essential

# Install dependencies (for macOS)
install-deps-mac:
	brew install flex bison

.PHONY: all clean test install-deps install-deps-mac
