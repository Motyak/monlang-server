
import * as monaco from "https://esm.sh/monaco-editor@0.52.2?bundle"

export const create_monlang_editor = (domElement, value = "") => {

    monaco.languages.register({id: "monlang"})

    monaco.languages.setLanguageConfiguration("monlang", {
        autoClosingPairs: [
            {open: "(", close: ")"},
            {open: "[", close: "]"},
            {open: "{", close: "}"},
            {open: '"', close: '"'},
            {open: "```", close: "```"},
        ],
        brackets: [
            ["(", ")"],
            ["[", "]"],
            ["{", "}"],
        ],
        colorizedBracketPairs: [],
        // comments: {
        //     lineComment: "--",
        // },
        folding: {
            offSide: true,
        },
        onEnterRules: [
            {
                action: {indentAction: 2},
                afterText: /```/,
                beforeText: /```/,
            },
        ],
        surroundingPairs: [
            {open: "(", close: ")"},
            {open: "[", close: "]"},
            {open: "{", close: "}"},
            {open: '"', close: '"'},
        ],
        wordPattern: /[^()[\]{}"`:.,#& \n]+/, // for word completion
    })

    monaco.languages.setMonarchTokensProvider("monlang", {
        includeLF: true, // otherwise can't use \n in regexes
        tokenizer: {
            root: [
                /* order matters here !! */
                /* 1 */
                [/^ *var( |\n)(?!([:+*%\/-]|\*\*|&&|\|\|)=)/, "keyword"],
                [/^( *)-- .*{\n/, "comment", "@trailing_block_in_comment"],
                [/^( *)-- .*```\n/, "comment", "@trailing_quotblock_in_comment"],
                [/^( *)-- .*\n/, "comment"],

                /* 2 */
                [/"/, "string", "@string"],
                [/```/, "string", "@multilineString"],

                /* 3 */
                [/[()[\]{}"`:, \n]/, "delimiter", "@delimiter"], // removed dot here
                [/\./, "delimiter"],
            ],
            string: [
                [/[^\\"]+/, "string"], // match newlines as well, to detect non-ending quotes more easily
                [/\\./, "string.escape"],
                [/"/, "string", "@pop"], // don't pop on newline, to detect non-ending quotes more easily
            ],
            multilineString: [
                [/[^\\`]+/, "string"],
                [/\\./, "string.escape"],
                [/```/, "string", "@pop"],
            ],
            delimiter: [
                [/'/, "string", "@atomQuot"],
                [/(?!')/, "delimiter", "@pop"],
            ],
            atomQuot: [
                [/[^()[\]{}"`.:, \n]+/, "string"],
                [/(?=[()[\]{}"`.:, \n])/, "string", "@popall"],
            ],
            trailing_block_in_comment: [
                /* order matters here !! */
                [/^.*{\n/, "comment", "@trailing_block_in_comment"],
                [/^ *(-- )?}.*\n/, "comment", "@pop"],
                [/^.*\n/, "comment"],
            ],
            trailing_quotblock_in_comment: [
                /* order matters here !! */
                [/^ *```.*\n/, "comment", "@pop"],
                [/^.*\n/, "comment"],
            ],
        }
    })

    // remove token coloring
    monaco.editor.defineTheme("monlang", {
        base: "vs",
        inherit: false,
        rules: [
            {
                token: "keyword",
                fontStyle: "bold",
            },
            {
                token: "string",
                fontStyle: "italic",
            },
            {
                token: "comment",
                foreground: "#7F7F7F"
            },
        ],
        colors: {},
    })

    let editor = monaco.editor.create(domElement, {
        automaticLayout: true,
        fontFamily: "Menlo, Consolas, monospace",
        fontSize: 12,
        lineHeight: 18,
        language: "monlang",
        lineNumbersMinChars: 3,
        theme: "monlang",
        occurrencesHighlight: "off",
        value: value,
        wordSeparators: "()[]{}:\"`,.#&", // for word navigation
    })

    editor.getModel().pushEOL(monaco.editor.EndOfLineSequence.LF)

    return editor
}
