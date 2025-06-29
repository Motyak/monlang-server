# start the server
php -S 127.0.0.1:55555
# the following config bypass file size limitation (otherwise 2M)
php -S 127.0.0.1:55555 -c <(echo -e "upload_max_filesize=-1\npost_max_size=-1")
# server is now available under http://127.0.0.1:55555 ..
# ..you can also start from http://127.0.0.1:55555/examples

# in order to support n concurrent connections (default is 1)
PHP_CLI_SERVER_WORKERS=2 php -S 127.0.0.1:55555

---

# POST file
curl -sS http://127.0.0.1:55555 -F 'src=@factorial.ml'

# if the src file happens to be in a dir, then you must pass the options below instead
# (otherwise, curl won't send a path for "security reasons"..
# ..so our server will receive as full path "factorial.ml" instead of "examples/factorial.ml")
curl -sS http://127.0.0.1:55555 -F 'src=@examples/factorial.ml' -F 'srcpath=examples/factorial.ml'

# POST stdin (have to specify a srcpath here)
curl -sS http://127.0.0.1:55555 -F 'src=@-' -F 'srcpath=\<stdin\>'

---

# GET ERR files
curl -sS http://127.0.0.1:55555/LV1.ERR.txt
curl -sS http://127.0.0.1:55555/LV2.ERR.txt

# GET out/ files (without re-executing)
curl -sS http://127.0.0.1:55555/out/console.txt
curl -sS http://127.0.0.1:55555/out/LV1.ast.txt
curl -sS http://127.0.0.1:55555/out/LV2.ast.txt
curl -sS http://127.0.0.1:55555/out/traceback.txt

---

# you can bookmark programs (ctrl+D outside of the editor focus),
# a query parameter is automatically updated as the editor content changes.
# e.g.: http://127.0.0.1:55555/?src=print%28%2522Hello%2C%2520World%21%2522%29%250A

---

# conveniencies :

./open_monlang.sh somefile.txt
# this will run the php server in a dedicated tmux session, if not already created,..
# ..and open the file as a new tab in your preferred browser
# (modifications will not propagate to the original file)
#   -> file argument is optional,
#      you can also specify a filename even if the file doesn't exist

./monlang_server.sh
# this attaches the terminal to existing or freshly-created..
# ..tmux session dedicated for running monlang PHP server
# (ctrl+b d to detach session again)
#
# you can also pass as argument the number of server workers
# (for handling concurrent connections), default is 1

# to run the scripts from anywhere, install them :
ln -s "$(realpath open_monlang.sh)" ~/.local/bin/open_monlang
ln -s "$(realpath monlang_server.sh)" ~/.local/bin/monlang_server
