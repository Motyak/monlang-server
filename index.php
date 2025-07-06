<?php
    $DEBUG = false;
    $DEBUG = true; //toggle
    $request_id = $DEBUG? 0 : rand(1000, 9999);

    /* handles POST */
    if ($_SERVER["REQUEST_METHOD"] === "POST") {
        if (!isset($_FILES["src"])) exit;
        $srcpath = $_POST["srcpath"] ?? $_FILES["src"]["full_path"];
        $tmppath = $_FILES["src"]["tmp_name"];
        $DEBUG || register_shutdown_function(fn() => `rm -rf home/{$request_id}`);
        $scriptout = `/bin/bash eval.sh '{$tmppath}' '{$srcpath}' {$request_id}`;

        echo json_encode(array(
            "prog" => explode(",", $scriptout)[0],
            "prog_exitcode" => (int)explode(",", $scriptout)[1],
            "out" => array(
                "LV1.ast.txt" => file_get_contents("home/{$request_id}/out/LV1.ast.txt"),
                "LV2.ast.txt" => file_get_contents("home/{$request_id}/out/LV2.ast.txt"),
                "traceback.txt" => file_get_contents("home/{$request_id}/out/traceback.txt"),
                "console.txt" => file_get_contents("home/{$request_id}/out/console.txt"),
                "LV1.tokens.json" => json_decode(file_get_contents("home/{$request_id}/out/LV1.tokens.json")),
                "LV2.tokens.json" => json_decode(file_get_contents("home/{$request_id}/out/LV2.tokens.json")),
            )
        ), JSON_INVALID_UTF8_IGNORE), "\n";

        exit;
    }

    include("./index.html");
?>
