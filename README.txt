# start the server
php -S 127.0.0.1:55555
# the following config bypass file size limitation (otherwise 2M)
php -S 127.0.0.1:55555 -c <(echo -e "upload_max_filesize=-1\npost_max_size=-1")
# server is now available under http://127.0.0.1:55555

---

# POST file
curl -sS http://127.0.0.1:55555 -F 'src=@factorial.ml'

# if the src file happens to be in a dir, then you must pass the options below instead
# (otherwise, curl won't send a path for "security reasons"..
# ..so our server will receive as full path "factorial.ml" instead of "examples/factorial.ml")
curl -sS http://127.0.0.1:55555 -F 'src=@examples/factorial.ml' -F 'srcpath=examples/factorial.ml'
