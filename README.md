# C Language Tokenizer Web Application

A modern web application that tokenizes C language code and displays token tables, symbol tables, and comments. Built with HTML, CSS, JavaScript, and separate Flex/Bison files for lexical analysis and parsing.

## Features

- **Token Table**: Displays all tokens with their type and line number
- **Symbol Table**: Shows identifiers, functions, and variables with scope information
- **Comments Display**: Extracts and displays both single-line and multi-line comments
- **Modern UI**: Beautiful, responsive design with flexbox layout
- **Real-time Processing**: Instant tokenization without page reload
- **Syntax Highlighting**: Color-coded tokens for better readability

## File Structure

```
├── index.html          # Main HTML file with modern UI
├── styles.css          # CSS styles with flexbox layout
├── script.js           # JavaScript tokenizer implementation
├── lexer.l             # Flex file for lexical analysis
├── parser.y            # Bison file for parsing and symbol table
├── Makefile            # Build configuration for Flex/Bison
└── README.md           # This file
```

## Web Application Usage

1. **Open the Web App**: Open `index.html` in your web browser
2. **Input C Code**: Paste or type C code in the textarea
3. **Tokenize**: Click the "Tokenize Code" button or press `Ctrl+Enter`
4. **View Results**: Switch between tabs to see:
   - **Token Table**: All tokens with type and line number
   - **Symbol Table**: Variables, functions, and their scope
   - **Comments**: Extracted comments with line numbers

## Example C Code

```c
#include <stdio.h>

int main() {
    int x = 10; // This is a comment
    float y = 20.5;
    char c = 'A';
    
    /* Multi-line comment
       explaining the code */
    
    printf("Hello World\n");
    return 0;
}
```

## Flex/Bison Implementation

### Compiling the Flex/Bison Files

1. **Install Dependencies**:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install flex bison build-essential
   
   # macOS
   brew install flex bison
   ```

2. **Compile**:
   ```bash
   make all
   ```

3. **Test**:
   ```bash
   make test
   ```

### Using the Command Line Tools

1. **C Tokenizer (Flex only)**:
   ```bash
   ./c_tokenizer input.c
   ```

2. **C Parser (Flex + Bison)**:
   ```bash
   ./c_parser input.c
   ```

## Token Types

The application recognizes the following token types:

- **KEYWORD**: C language keywords (int, if, while, etc.)
- **IDENTIFIER**: Variable names, function names
- **LITERAL**: Numbers, character literals
- **OPERATOR**: Arithmetic, logical, bitwise operators
- **PUNCTUATION**: Parentheses, brackets, semicolons
- **COMMENT**: Single-line (//) and multi-line (/* */) comments
- **STRING**: String literals
- **PREPROCESSOR**: #include, #define directives

## Symbol Table Features

The symbol table tracks:
- **Symbol Name**: Variable or function name
- **Type**: variable, function, parameter
- **Scope**: global, local, function
- **Line Number**: Where the symbol is first declared

## Technical Details

### JavaScript Implementation
- Pure JavaScript tokenizer (no external dependencies)
- Handles C language syntax patterns
- Real-time processing with immediate feedback
- Color-coded token display

### Flex Implementation (lexer.l)
- Defines lexical patterns for C language
- Handles comments, strings, numbers, identifiers
- Generates token stream with line numbers
- Supports all C operators and punctuation

### Bison Implementation (parser.y)
- Implements C language grammar
- Builds symbol table during parsing
- Handles function definitions and variable declarations
- Tracks scope and type information

## Browser Compatibility

- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+

## Keyboard Shortcuts

- `Ctrl+Enter`: Tokenize the current code
- `Tab`: Navigate between input and output sections

## Customization

### Adding New Token Types
1. Add the token type to `TokenType` enum in `script.js`
2. Add corresponding CSS class in `styles.css`
3. Update the tokenization logic in `script.js`

### Modifying the Grammar
1. Edit `parser.y` to add new grammar rules
2. Update `lexer.l` to recognize new lexical patterns
3. Recompile with `make clean && make all`

## Troubleshooting

### Web Application Issues
- Ensure JavaScript is enabled in your browser
- Check browser console for any error messages
- Verify that all files are in the same directory

### Flex/Bison Compilation Issues
- Install required dependencies: `make install-deps`
- Check that flex and bison are properly installed
- Ensure you have a C compiler (gcc) installed

### Token Recognition Issues
- The JavaScript implementation may not handle all edge cases
- For complete C language support, use the Flex/Bison implementation
- Check the token table for unrecognized tokens

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Flex and Bison for lexical analysis and parsing
- Modern CSS flexbox for responsive layout
- JavaScript for client-side tokenization
