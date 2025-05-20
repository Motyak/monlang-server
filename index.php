
<?php
    /* handles POST */
    if (isset($_FILES["src"])) {
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

        exit(0);
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
        <div id="consolepanel" class="flex-none w-full h-1/3 border border-dashed border-red-500">console</div>
    </div>
</div>

<style>
    .CodeMirror {
        width: 100%;
        height: 100%;
    }
</style>

<script>
    const get_src = () => {
        return "<file content>"
    }

    const set_src = (src) => {
        console.log(src)
    }

    const get_res = () => {
        
    }

    const set_res = res => {
        console.log(JSON.parse(res))
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

    let editor = CodeMirror($("#editorpanel").get(0), {
        lineNumbers: true,
        indentUnit: 4,
    })
    

    $(document).keydown(event => {
        if (event.ctrlKey && event.key === "s") {
            event.preventDefault()
            // alert("saving...")
            alert(test("saving...."))
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
