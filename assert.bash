# Recommended: set -eo pipefail

assert()
{
  if [ -z "$1" ]; then
    local -r caller="$(caller 0)"
    echo "Line ${caller}: The \"assert\" command being checked is empty, skipped" >&2
    return
  fi

  # shellcheck disable=SC2086 # intentionally allowing splitting
  if [ ! $1 ]; then
    local -r caller="$(caller 0)"
    local -r line="$(echo "${caller}" | cut -f1 -d ' ')"

    local -r str_length="$(echo "${1}" | awk '{ print length }')"
    local error_pointer=""
    for _ in $(seq 1 ${str_length}); do
      error_pointer="${error_pointer}^"
    done

    echo "Assertion failed: ${2}"
    echo "--> $(readlink -m "$0"):${line}"
    echo -e "\t|"
    if [ -z "${2}" ]; then
      echo -e "${line}\t| assert \"${1}\""
    else
      echo -e "${line}\t| assert \"${1}\" \"${2}\""
    fi
    echo -e "\t|         ${error_pointer}"
    kill -ABRT $$
  fi
}
