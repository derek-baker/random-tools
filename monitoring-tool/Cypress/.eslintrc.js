// DOCS: https://javascriptplayground.com/typescript-eslint/
// DOCS: https://github.com/typescript-eslint/typescript-eslint/tree/master/packages/eslint-plugin/docs/rules

module.exports = {
    parser: '@typescript-eslint/parser',
    plugins: ['@typescript-eslint', 'cypress'],
    env: {
        'browser': true,
        'commonjs': true,
        'es6': true,
        'node': true,
        'cypress/globals': true
    },
    extends: [
        'eslint:recommended',
        'plugin:@typescript-eslint/recommended'
    ],
    globals: {
        'Atomics': 'readonly',
        'SharedArrayBuffer': 'readonly',
    },
    parserOptions: {
        'ecmaVersion': 2018,
        "sourceType": "module",
    },
    rules: {
        'no-trailing-spaces': ['off', { 'ignoreComments': true }],
        'indent': ['off', 'tab'],
        'brace-style': ['error', 'stroustrup', { 'allowSingleLine': true }],
        'linebreak-style': ['off', 'windows'],
        'brace-style': ['error', 'stroustrup'],
        'block-spacing': ['error', 'always'],
        'comma-dangle': ['error', 'never'],
        'semi': ['error', 'always'],
        'quotes': ['error', 'single'],
        'max-len': ['error', { 'code': 130 }],
        'no-var': 'error',
        'eqeqeq': ["error", "always"],
        '@typescript-eslint/no-inferrable-types': 0,
        '@typescript-eslint/no-explicit-any': 0,
        '@typescript-eslint/explicit-function-return-type': 2,
        '@typescript-eslint/interface-name-prefix': 0
    }
};