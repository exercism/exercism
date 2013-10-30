#!/bin/bash
set -e
tmp=${TMPDIR:-/tmp/}
check_assignment () {
  testfile="$1"
  testfilename=${testfile##*/}
  assignmentdir=${testfile%/src/test/scala*}
  workdir=$(mktemp -d "${tmp}${testfilename}.XXXXXXXXXX")
  mkdir -p "${workdir}/src/main/scala"
  mkdir -p "${workdir}/src/test/scala"
  cp "${assignmentdir}/build.sbt" "${workdir}/build.sbt"
  cp "${assignmentdir}/example.scala" "${workdir}/src/main/scala/"
  grep -v '^\s\+pending' "${testfile}" > "${workdir}/src/test/scala/${testfilename}"
  (
    cd "${workdir}"
    sbt test
  )
  status=$?
  rm -rf "${workdir}"
  return $status
}

failures=()
for assignment in assignments/scala/*/src/test/scala/*.scala; do
  (check_assignment "${assignment}")
  if [ $? -ne 0 ]; then
    echo "check failed"
    failures=(${failures[@]} $assignment)
  fi
done
if [ "${#failures[*]}" -eq "0" ]; then
  echo "SUCCESS!"
else
  output=$(printf ", %s" "${failures[@]}")
  echo "FAILURES: ${output:2}"
  exit 1
fi
