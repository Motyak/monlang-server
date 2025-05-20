<?php
    /* handles POST */
    if ($_SERVER["REQUEST_METHOD"] === "POST") {
        if (!isset($_FILES["src"])) exit;
        $srcpath = $_POST["srcpath"] ?? $_FILES["src"]["full_path"];
        $tmppath = $_FILES["src"]["tmp_name"];
        $scriptout = `/bin/bash eval.sh '{$tmppath}' '{$srcpath}'`;

        echo json_encode(array(
            "prog" => explode(",", $scriptout)[0],
            "prog_exit_code" => (int)explode(",", $scriptout)[1],
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
    const editor = CodeMirror($("#editorpanel").get(0), editor_conf)
    const get_src = () => editor.getValue()
    const set_src = src => editor.setValue(src)

    const console_conf = {
        readOnly: true,
        lineWrapping: true,
    }
    const console_ = CodeMirror($("#consolepanel").get(0), console_conf)
    const get_res = () => console_.getValue()
    const set_res = res => {
        const res_obj = JSON.parse(res)
        console.log(res_obj)
        if (res_obj["prog"] === "interpreter") {
            console_.setValue(res_obj["out"]["console.txt"])
            console_.scrollTo(null, console_.getScrollInfo().height)
        }
        else if (res_obj["prog"] === "parser") {
            console_.setValue(res_obj["out"]["traceback.txt"])
            console_.scrollTo(null, 0)
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
