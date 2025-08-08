// C Language Tokenizer JavaScript Implementation

// Token types
const TokenType = {
    KEYWORD: 'KEYWORD',
    IDENTIFIER: 'IDENTIFIER',
    LITERAL: 'LITERAL',
    OPERATOR: 'OPERATOR',
    PUNCTUATION: 'PUNCTUATION',
    COMMENT: 'COMMENT',
    PREPROCESSOR: 'PREPROCESSOR',
    STRING: 'STRING'
};

// C keywords
const C_KEYWORDS = [
    'auto', 'break', 'case', 'char', 'const', 'continue', 'default', 'do',
    'double', 'else', 'enum', 'extern', 'float', 'for', 'goto', 'if',
    'int', 'long', 'register', 'return', 'short', 'signed', 'sizeof', 'static',
    'struct', 'switch', 'typedef', 'union', 'unsigned', 'void', 'volatile', 'while'
];

// C operators
const C_OPERATORS = [
    '+', '-', '*', '/', '%', '++', '--', '==', '!=', '<', '>', '<=', '>=',
    '&&', '||', '!', '&', '|', '^', '~', '<<', '>>', '=', '+=', '-=', '*=',
    '/=', '%=', '<<=', '>>=', '&=', '|=', '^=', '->', '.', '?', ':'
];

// C punctuation
const C_PUNCTUATION = [
    '(', ')', '[', ']', '{', '}', ';', ',', '#'
];

// Symbol table to store identifiers
let symbolTable = [];
let comments = [];

function tokenizeCode() {
    const code = document.getElementById('cCodeInput').value;
    if (!code.trim()) {
        alert('Please enter some C code to tokenize.');
        return;
    }

    // Reset tables
    symbolTable = [];
    comments = [];
    
    const tokens = [];
    const lines = code.split('\n');
    
    for (let lineNum = 0; lineNum < lines.length; lineNum++) {
        const line = lines[lineNum];
        const lineTokens = tokenizeLine(line, lineNum + 1);
        tokens.push(...lineTokens);
    }
    
    displayTokens(tokens);
    displaySymbolTable();
    displayComments();
}

function tokenizeLine(line, lineNumber) {
    const tokens = [];
    let current = '';
    let i = 0;
    
    while (i < line.length) {
        const char = line[i];
        
        // Skip whitespace
        if (/\s/.test(char)) {
            i++;
            continue;
        }
        
        // Handle comments
        if (char === '/' && i + 1 < line.length) {
            if (line[i + 1] === '/') {
                // Single line comment
                const comment = line.substring(i);
                tokens.push({
                    token: comment,
                    type: TokenType.COMMENT,
                    line: lineNumber
                });
                comments.push({
                    text: comment,
                    line: lineNumber,
                    type: 'single-line'
                });
                break;
            } else if (line[i + 1] === '*') {
                // Multi-line comment start
                let comment = '/*';
                i += 2;
                while (i < line.length && !(line[i] === '*' && i + 1 < line.length && line[i + 1] === '/')) {
                    comment += line[i];
                    i++;
                }
                if (i < line.length) {
                    comment += '*/';
                    i += 2;
                }
                tokens.push({
                    token: comment,
                    type: TokenType.COMMENT,
                    line: lineNumber
                });
                comments.push({
                    text: comment,
                    line: lineNumber,
                    type: 'multi-line'
                });
                continue;
            }
        }
        
        // Handle strings
        if (char === '"') {
            let string = '"';
            i++;
            while (i < line.length && line[i] !== '"') {
                if (line[i] === '\\' && i + 1 < line.length) {
                    string += line[i] + line[i + 1];
                    i += 2;
                } else {
                    string += line[i];
                    i++;
                }
            }
            if (i < line.length) {
                string += '"';
                i++;
            }
            tokens.push({
                token: string,
                type: TokenType.STRING,
                line: lineNumber
            });
            continue;
        }
        
        // Handle character literals
        if (char === "'") {
            let charLiteral = "'";
            i++;
            while (i < line.length && line[i] !== "'") {
                if (line[i] === '\\' && i + 1 < line.length) {
                    charLiteral += line[i] + line[i + 1];
                    i += 2;
                } else {
                    charLiteral += line[i];
                    i++;
                }
            }
            if (i < line.length) {
                charLiteral += "'";
                i++;
            }
            tokens.push({
                token: charLiteral,
                type: TokenType.LITERAL,
                line: lineNumber
            });
            continue;
        }
        
        // Handle numbers
        if (/\d/.test(char)) {
            let number = '';
            while (i < line.length && (/\d/.test(line[i]) || line[i] === '.' || line[i] === 'e' || line[i] === 'E' || line[i] === '+' || line[i] === '-')) {
                number += line[i];
                i++;
            }
            tokens.push({
                token: number,
                type: TokenType.LITERAL,
                line: lineNumber
            });
            continue;
        }
        
        // Handle identifiers and keywords
        if (/[a-zA-Z_]/.test(char)) {
            let identifier = '';
            while (i < line.length && /[a-zA-Z0-9_]/.test(line[i])) {
                identifier += line[i];
                i++;
            }
            
            if (C_KEYWORDS.includes(identifier)) {
                tokens.push({
                    token: identifier,
                    type: TokenType.KEYWORD,
                    line: lineNumber
                });
            } else {
                tokens.push({
                    token: identifier,
                    type: TokenType.IDENTIFIER,
                    line: lineNumber
                });
                
                // Add to symbol table if not already present
                if (!symbolTable.find(s => s.symbol === identifier)) {
                    symbolTable.push({
                        symbol: identifier,
                        type: 'variable',
                        scope: 'global',
                        line: lineNumber
                    });
                }
            }
            continue;
        }
        
        // Handle operators and punctuation
        let found = false;
        for (const op of C_OPERATORS) {
            if (line.substring(i, i + op.length) === op) {
                tokens.push({
                    token: op,
                    type: TokenType.OPERATOR,
                    line: lineNumber
                });
                i += op.length;
                found = true;
                break;
            }
        }
        
        if (!found) {
            for (const punct of C_PUNCTUATION) {
                if (line.substring(i, i + punct.length) === punct) {
                    tokens.push({
                        token: punct,
                        type: TokenType.PUNCTUATION,
                        line: lineNumber
                    });
                    i += punct.length;
                    found = true;
                    break;
                }
            }
        }
        
        if (!found) {
            // Unknown character
            tokens.push({
                token: char,
                type: 'UNKNOWN',
                line: lineNumber
            });
            i++;
        }
    }
    
    return tokens;
}

function displayTokens(tokens) {
    const tbody = document.getElementById('tokenTableBody');
    tbody.innerHTML = '';
    
    tokens.forEach(token => {
        const row = document.createElement('tr');
        const tokenCell = document.createElement('td');
        const typeCell = document.createElement('td');
        const lineCell = document.createElement('td');
        
        tokenCell.textContent = token.token;
        tokenCell.className = `token-${token.type.toLowerCase()}`;
        
        typeCell.textContent = token.type;
        lineCell.textContent = token.line;
        
        row.appendChild(tokenCell);
        row.appendChild(typeCell);
        row.appendChild(lineCell);
        tbody.appendChild(row);
    });
}

function displaySymbolTable() {
    const tbody = document.getElementById('symbolTableBody');
    tbody.innerHTML = '';
    
    symbolTable.forEach(symbol => {
        const row = document.createElement('tr');
        const symbolCell = document.createElement('td');
        const typeCell = document.createElement('td');
        const scopeCell = document.createElement('td');
        const lineCell = document.createElement('td');
        
        symbolCell.textContent = symbol.symbol;
        typeCell.textContent = symbol.type;
        scopeCell.textContent = symbol.scope;
        lineCell.textContent = symbol.line;
        
        row.appendChild(symbolCell);
        row.appendChild(typeCell);
        row.appendChild(scopeCell);
        row.appendChild(lineCell);
        tbody.appendChild(row);
    });
}

function displayComments() {
    const commentsList = document.getElementById('commentsList');
    commentsList.innerHTML = '';
    
    if (comments.length === 0) {
        commentsList.innerHTML = '<p style="color: #6c757d; text-align: center; padding: 20px;">No comments found in the code.</p>';
        return;
    }
    
    comments.forEach(comment => {
        const commentDiv = document.createElement('div');
        commentDiv.className = 'comment-item';
        
        const commentText = document.createElement('div');
        commentText.className = 'comment-text';
        commentText.textContent = comment.text;
        
        const commentLine = document.createElement('div');
        commentLine.className = 'comment-line';
        commentLine.textContent = `Line ${comment.line} - ${comment.type}`;
        
        commentDiv.appendChild(commentText);
        commentDiv.appendChild(commentLine);
        commentsList.appendChild(commentDiv);
    });
}

function showTab(tabName) {
    // Hide all tab contents
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(content => {
        content.classList.remove('active');
    });
    
    // Remove active class from all tab buttons
    const tabButtons = document.querySelectorAll('.tab-btn');
    tabButtons.forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Show selected tab content
    document.getElementById(tabName).classList.add('active');
    
    // Add active class to clicked button
    event.target.classList.add('active');
}

// Add keyboard shortcut for tokenization
document.addEventListener('keydown', function(event) {
    if (event.ctrlKey && event.key === 'Enter') {
        tokenizeCode();
    }
});

// Initialize the page
document.addEventListener('DOMContentLoaded', function() {
    // Set focus to the input textarea
    document.getElementById('cCodeInput').focus();
});
