#!/bin/bash

# Based on https://github.com/Naheel-Azawy/cp-p
# which is based on https://github.com/ericpaulbishop/cp_p
# and https://unix.stackexchange.com/questions/44040/a-standard-tool-to-convert-a-byte-count-into-human-kib-mib-etc-like-du-ls1

# set some shell options
set -o errexit
set -o nounset
set -o noglob
set -o pipefail

# check if output is a tty
if [ -t 1 ]; then
    R=''
    B='\033[0E\033[K'
    W=$(tput cols)
else
    R='\n'
    B=''
    W=99999999
fi

help_opt=0
end_of_opts=0
cmd="cp"
opts=""
srcs=()
dest=""

print_help()
{
    cat >&2 << EOF
Usage: $cmd-p [OPTION]... SOURCE DEST
Like $cmd but with progress information.

Check '$cmd --help' for the options.
EOF
    exit 1
}

parse_command_line()
{
    last=""
    while [ $# -gt 0 ]; do
        arg="$1"
        shift
        if [ $end_of_opts -eq 0 ]; then
            case "$arg" in
                -t | --target-directory)
                    if [ $# -gt 0 ]; then
                        dest=$1
                        shift
                        continue
                    else
                        echo "$cmd: option requires an argument -- '$arg'" >&2
                        echo "Try '$cmd --help' for more information." >&2
                        exit 1
                    fi
                    ;;
                --target-directory=*)
                    dest="${arg#*=}"
                    if [[ "$dest" = "" ]]; then
                        echo "$cmd: option requires an argument -- '--target-directory'" >&2
                        echo "Try '$cmd --help' for more information." >&2
                        exit 1
                    fi
                    continue
                    ;;
                --mv) cmd="mv"; continue ;;
                --help) help_opt=1; continue ;;
                --) end_of_opts=1; continue ;;
                -*) opts="$opts $arg"; continue ;;
            esac
        fi
        if [[ -n "$last" ]]; then
            srcs+=("$last")
        fi
        last="$arg"
    done

    if [ -z "$dest" ]; then
        dest="$last"
    else
        srcs+=("$last")
    fi

    if [[ "$help_opt" = 1 ]] || [[ "${srcs[@]}" = "" ]] || [[ "$dest" = "" ]]; then
        print_help
    fi
}

H_FUN='
function human(x) {
    if (x < 0) {
       return "..."
    }
    s=" B   KiB MiB GiB TiB EiB PiB YiB ZiB"
    while (x >= 1024 && length(s) > 1) {
        x /= 1024
        s = substr(s, 5)
    }
    s = substr(s, 1, 4)
    xf = (s == " B  ") ? "%d" : "%.2f"
    return sprintf(xf"%s", x, s)
}
function human_time(t) {
    if (t < 0) {
       return "..."
    }
    h = int(t / 3600)
    m = int(t / 60) % 60
    s = t % 60
    if (h == 0) {h = ""} else {h = sprintf("%dh ", h)}
    if (m == 0) {m = ""} else {m = sprintf("%dm ", m)}
    return sprintf("%s%s%.1fs", h, m, s)
}'

main()
{
    printf "${B}Calculating size...${R}"

    # total size of all sources
    total_size=0

    # associative array to keep the size of each source separately
    declare -A src_sizes

    for src in "${srcs[@]}"; do
        if [ ! -e "$src" ]; then
            echo "$cmd: cannot stat '$src': No such file or directory" >&2
            exit 1
        fi
        src_sizes["$src"]=$(du -sb -- "$src" | awk '{print $1}')
        if [ -n "${src_sizes["$src"]}" ]; then
            total_size=$((total_size + ${src_sizes["$src"]}))
        fi
    done

    # human-readable total size
    total_size_h=$(echo $total_size | awk "$H_FUN"'{print human($1)}')


    if [ "$cmd" = mv ]; then
        printf "${B}Moving...${R}"
    else
        printf "${B}Copying...${R}"
        # set default options
        opts="--archive --reflink=auto $opts"
    fi

    # incremental size of the sources that have been copied/moved
    incremental_size=0

    for src in "${srcs[@]}"; do
        fname=$(basename -- "$src")
        finaldest=$(realpath -- "$dest")

        # check existing file
        if [ -e "$dest/$fname" ]; then
            copy_n=0
            finaldest="$dest/$fname"
            # keep looping till a new name is found
            while [ -w "$finaldest" ]; do
                copy_n=$((copy_n+1))
                finaldest="$dest/$fname.~$copy_n~"
            done
        fi

        strace -q -e write,copy_file_range -o >(
            awk "$H_FUN"'
            BEGIN { time_start = systime() }
            {
                time_elapsed = systime() - time_start
                incremental_size += $NF
                if (time_elapsed == 0 || incremental_size == 0) {
                    bytes_per_sec = -1
                    eta = -1
                } else {
                    bytes_per_sec = incremental_size / time_elapsed
                    eta = (total_size - incremental_size) / bytes_per_sec
                }
                if (total_size > 0 && incremental_size % 10 == 0) {
                    percent = (incremental_size / total_size) * 100
                    printf "'$B'"substr(sprintf("%3d%% (%s/%s, %s/s, ETA: %s) %s to %s'$R'", percent, human(incremental_size), total_size_h, human(bytes_per_sec), human_time(eta), src, finaldest), 0, '$W')
                }
            }
            END { print "'$B'Took " human_time(systime() - time_start) }' \
                total_size=$total_size \
                total_size_h="$total_size_h" \
                incremental_size=$incremental_size \
                src="$src" finaldest="$finaldest"
            ) $cmd $opts -- "$src" "$finaldest"

        incremental_size=$((incremental_size + ${src_sizes["$src"]}))
    done
}

parse_command_line "$@"
main
