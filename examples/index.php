<ul>
<?php
    $files = array_diff(scandir("."), array(".", "..", "index.php"));
    foreach ($files as $file) {
        $file_basename = basename($file);
        $src = urlencode(file_get_contents($file));
        $url = "/?srcname={$file_basename}&src={$src}";
        echo "    <li><a href=\"{$url}\">{$file_basename}</a></li>\n";
    }
?>
</ul>

<link rel="icon" href="../favicon.png">
