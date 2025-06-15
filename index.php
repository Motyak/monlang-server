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
                "LV1.tokens.json" => json_decode(file_get_contents("out/LV1.tokens.json")),
                "LV2.tokens.json" => json_decode(file_get_contents("out/LV2.tokens.json")),
            )
        )), "\n";

        exit;
    }

    include("./index.html");
?>
