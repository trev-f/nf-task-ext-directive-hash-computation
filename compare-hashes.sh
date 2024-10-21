#!/usr/bin/env bash
# taken from https://www.nextflow.io/docs/latest/cache-and-resume.html#comparing-the-hashes-of-two-runs

readonly pipeline="${1}"

nextflow -log run_1.log run "${pipeline}" -dump-hashes json
nextflow -log run_2.log run "${pipeline}" -dump-hashes json -resume

get_hashes() {
    cat $1 \
    | grep 'cache hash:' \
    | cut -d ' ' -f 10- \
    | sort \
    | awk '{ print; print ""; }'
}

get_hashes run_1.log > run_1_task_hashes.txt
get_hashes run_2.log > run_2_task_hashes.txt

diff run_1_task_hashes.txt run_2_task_hashes.txt
