#!/bin/sh

a=""
b=""

while IFS= read -r line; do
line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//') # trim spaces
[ -z "$line" ] && continue # skip empty lines

case "$line" in
say\ \"*\")
msg=$(printf '%s\n' "$line" | sed -n 's/^say "\(.*\)"$/\1/p')
echo "$msg"
;;
if\ *\ is\ *)
a=$(printf '%s\n' "$line" | cut -d' ' -f2)
b=$(printf '%s\n' "$line" | cut -d' ' -f4)
;;
do\ *)
cmd=$(printf '%s\n' "$line" | cut -d' ' -f2)
if [ "$a" = "$b" ]; then
# If cmd matches a shell command, run it, else just echo that cmd
if command -v "$cmd" >/dev/null 2>&1; then
"$cmd"
else
echo "Unknown command: $cmd"
fi
fi
;;
exit)
exit 0
;;
*)
echo "Syntax error: $line" >&2
;;
esac
done
