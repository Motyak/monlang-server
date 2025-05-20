<?php
    /* handles POST */
    if ($_SERVER["REQUEST_METHOD"] === "POST") {
        if (!isset($_FILES["src"])) exit;
        $srcpath = $_POST["srcpath"] ?? $_FILES["src"]["full_path"];
        $tmppath = $_FILES["src"]["tmp_name"];
        $scriptout = `/bin/bash eval.sh '{$tmppath}' '{$srcpath}'`;

        echo json_encode(array(
            "prog" => explode(",", $scriptout)[0],
            "prog_exitcode" => (int)explode(",", $scriptout)[1],
            "out" => array(
                "LV1.ast.txt" => file_get_contents("out/LV1.ast.txt"),
                "LV2.ast.txt" => file_get_contents("out/LV2.ast.txt"),
                "traceback.txt" => file_get_contents("out/traceback.txt"),
                "console.txt" => file_get_contents("out/console.txt"),
            )
        )), "\n";

        exit;
    }
?>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>

<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

<script src="https://cdn.jsdelivr.net/npm/codemirror@5.65.19/lib/codemirror.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/codemirror@5.65.19/lib/codemirror.min.css" rel="stylesheet">

<!--
min-w-0 => to prevent flex-1 w-full from expanding beyond its parent (viewport)
min-h-0 => to prevent flex-1 h-full from expanding beyond its parent (viewport)
-->

<div id="globalpanel" class="flex flew-row w-screen h-screen">
    <div id="sidepanel" class="flex-none w-1/5 h-full border border-dashed border-red-500">sidepanel</div>
    <div id="mainpanel" class="flex flex-col flex-1 w-full h-full min-w-0">
        <div id="editorpanel" class="flex-1 w-full h-full min-h-0"></div>
        <div id="consolepanel" class="flex-none w-full h-1/3 border border-dashed border-red-500"></div>
        <p id="prog_exitcode" class="truncate"></p>
    </div>
</div>

<style>
    .CodeMirror {
        width: 100%;
        height: 100%;
    }
</style>

<script>
    const editor_conf = {
        autofocus: true,
        indentUnit: 4,
        lineNumbers: true,
    }
    const editor = CodeMirror($("#editorpanel")[0], editor_conf)
    const get_src = () => editor.getValue()
    const set_src = src => editor.setValue(src)

    const console_conf = {
        readOnly: true,
        lineWrapping: true,
    }
    const console_ = CodeMirror($("#consolepanel")[0], console_conf)
    const get_res = () => console_.getValue()
    const set_res = res => {
        const res_obj = JSON.parse(res)
        console.log(res_obj)
        if (res_obj["prog"] === "interpreter") {
            console_.setValue(res_obj["out"]["console.txt"])
            console_.scrollTo(null, console_.getScrollInfo().height)
            $("#prog_exitcode").text(`Program terminated with exit code ${res_obj["prog_exitcode"]}`)
        }
        else if (res_obj["prog"] === "parser") {
            console_.setValue(res_obj["out"]["traceback.txt"])
            console_.scrollTo(null, 0)
            $("#prog_exitcode").text("")
        }
    }

    const execute_src = (src = get_src(), onSuccess = set_res) => {
        const formData = new FormData()
        formData.append("src", new Blob([src]), "src.ml")
        $.post({
            data: formData,
            contentType: false,
            processData: false,
            success: res => onSuccess(res),
            error: (xhr, status, error) => console.error(xhr, status, error)
        })
    }

    // line and col starts at 1
    const jump_to = (line, col) => {
        editor.setCursor({line: line-1, ch: col-1})

        // middle of the view, relative to top of the view
        const relativeMidY = Math.round(editor.getScrollInfo().clientHeight/2)
        // cursor position, relative to top of the view
        // this will only be a positive value, between 0 and .clientHeight, if cursor is visible
        const relativeCursorY = editor.cursorCoords().top
        // top of the view, relative to the beginning of the document
        const absoluteTopY = editor.getScrollInfo().top

        const newAbsoluteTopY = absoluteTopY + relativeCursorY - relativeMidY
        editor.scrollTo(null, newAbsoluteTopY)
    }

    const addLinksToConsole = () => {
        const fileLocationPattern = /src\.ml:([1-9][0-9]*):([1-9][0-9]*)/

        console_.eachLine(linehandle => {
            const match = linehandle.text.match(fileLocationPattern)
            if (match) {
                const line = match[1]
                const col = match[2]

                const $link = $('<a href="#" class="link"></a>').text(match[0]);
                $link.on("click", () => jump_to(line, col));

                console_.addLineWidget(linehandle, $link[0], {
                    coverGutter: false,
                    noHScroll: true,
                    above: true,
                })
            }
        })
    }

    let saved_y = null
    $(document).keydown(event => {
        if (event.ctrlKey && event.key === "s") {
            event.preventDefault()
            execute_src()
        }
        if (event.ctrlKey && event.key === "j") {
            event.preventDefault()
            if ($("#consolepanel").is(":hidden")) {
                $("#consolepanel").show()
            }
            else {
                $("#consolepanel").hide()
            }
        }
    })
</script>
