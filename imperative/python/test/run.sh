#!/bin/bash -e

TEST_PLAT=$1
export MEGENGINE_LOGGING_LEVEL="ERROR"

if [[ "$TEST_PLAT" == cpu ]]; then
    echo "test cpu after Ninja develop"
elif [[ "$TEST_PLAT" == cuda ]]; then
    echo "test cuda after Ninja develop"
elif [[ "$TEST_PLAT" == cpu_local ]]; then
    echo "test cpu after python3 -m pip install xxx"
elif [[ "$TEST_PLAT" == cuda_local ]]; then
    echo "test cuda after python3 -m pip install xxx"
else
    echo "ERR args, support list:"
    echo "$0 cpu        (test cpu after Ninja develop)"
    echo "$0 cuda       (test cuda after Ninja develop)"
    echo "$0 cpu_local  (test cpu after python3 -m pip install xxx)"
    echo "$0 cuda_local (test cuda after python3 -m pip install xxx)"
    exit 1
fi

if [[ "$TEST_PLAT" =~ "local" ]]; then
    cd $(dirname "${BASH_SOURCE[0]}")
    megengine_dir=`python3 -c 'from pathlib import Path;import megengine;print(Path(megengine.__file__).resolve().parent)'`
    test_dirs="${megengine_dir} ."

    machine=$(uname -m)
    case ${machine} in
        x86_64) echo "test on ${machine}" ;;
        aarch64) echo "test on ${machine}" ;;
        *) echo "nonsupport env!!!";exit -1 ;;
    esac

    echo "test local env at: ${test_dirs}"
    PY_IGNORE_IMPORTMISMATCH=1 python3 -m pytest --ignore=${megengine_dir}/_internal -s -v $test_dirs -m 'not isolated_distributed'
    if [[ "$TEST_PLAT" =~ "cuda" ]]; then
        echo "test GPU pytest now"
        PY_IGNORE_IMPORTMISMATCH=1 python3 -m pytest --ignore=${megengine_dir}/_internal -s -v $test_dirs -m 'isolated_distributed' --ignore=./integration/test_dtr.py
    fi
else
    cd $(dirname "${BASH_SOURCE[0]}")/..
    test_dirs="megengine test"
    echo "test develop env"
    TEST_PY_PATH="."
    PYTHONPATH=${TEST_PY_PATH} PY_IGNORE_IMPORTMISMATCH=1 python3 -m pytest -s -v $test_dirs -m 'not isolated_distributed'
    if [[ "$TEST_PLAT" =~ "cuda" ]]; then
        echo "test GPU pytest now"
        PYTHONPATH=${TEST_PY_PATH} PY_IGNORE_IMPORTMISMATCH=1 python3 -m pytest -s -v $test_dirs -m 'isolated_distributed'
    fi
fi
