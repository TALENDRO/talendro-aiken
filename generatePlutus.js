const fs = require('fs');
const path = require('path');

// Path to the JSON file
const jsonPath = path.join(__dirname, 'plutus.json');

// Load the JSON content
const jsonContent = require(jsonPath);

// Prepare an array to hold export statements
const validatorexports = [];

jsonContent.validators.forEach((validator) => {
    const title = validator.title.replace(/\./g, "_"); // Replace dots with underscores
    const compiledCode = validator.compiledCode;
    if (compiledCode) {
        validatorexports.push(`export const ${title} = ${JSON.stringify(compiledCode)};`);
    }
});

// Write the JS file
const outputPath = path.join(__dirname, './client/config/scripts/plutus.ts');
fs.writeFileSync(outputPath, validatorexports.join('\n'), 'utf8');
console.log('plutus.js generated successfully!');
