#!/bin/bash
set -e
tmp=${TMPDIR:-/tmp/}
check_assignment () {
    intest="$1"
    inexample="${intest%/*}/example.erl"
    testfn=${intest##*/}
    assignment=${testfn%_test.erl}
    workdir=$(mktemp -d "${tmp}${assignment}.XXXXXXXXXX")
    modname=$(awk '/^-module/ { sub(/.*\(\s*/, ""); sub(/\s*\).*$/, ""); print }' "${inexample}")
    cp "${inexample}" "${workdir}/${modname}.erl"
    cp "${intest}" "${workdir}/${testfn}"
    (
        cd "${workdir}"
        erl -make && erl -noshell -eval \
            "init:stop(case ${assignment}_test:test() of ok -> 0; _ -> 1 end)."
    )
    status=$?
    rm -rf "${workdir}"
    return $status
}
failures=()
for fn in assignments/erlang/*/*_test.erl; do
    (check_assignment "${fn}")
    if [ $? -ne 0 ]; then
        echo "check failed"
        testfn=${fn##*/}
        assignment=${testfn%_test.erl}
        failures=(${failures[@]} "${testfn%_test.erl}")
    fi
done
if [ "${#failures[*]}" -eq "0" ]; then
    echo "SUCCESS!"
else
    output=$(printf ", %s" "${failures[@]}")
    echo "FAILURES: ${output:2}"
    exit 1
fi
