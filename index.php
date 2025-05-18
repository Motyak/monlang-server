
<?php
    $srcpath = $_POST["srcpath"] ?? $_FILES["src"]["full_path"];
    $tmppath = $_FILES["src"]["tmp_name"];
    `/bin/bash eval.sh '{$tmppath}' '{$srcpath}'`;

    echo json_encode(array(
        "out" => array(
            "LV1.ast.txt" => file_get_contents("out/LV1.ast.txt"),
            "LV2.ast.txt" => file_get_contents("out/LV2.ast.txt"),
            "traceback.txt" => file_get_contents("out/traceback.txt"),
            "console.txt" => file_get_contents("out/console.txt"),
        )
    ));
    echo "\n";
?>
