#!/bin/fish

function trollname
    argparse h/help "n/number=!_validate_int --min 0" f/firstmatch= l/lastmatch= r/restrict= s/stdin -- $argv
    or return

    if set -q _flag_help
        echo "Usage: trollname [-h|--help] [-n|--number] [-f|--firstmatch] [-l|--lastmatch] [-s|--stdin] SOURCES..."
        echo "  -h, --help        prints this help information"
        echo "  -n, --number      number of full names to generate (default: 1)"
        echo "  -f, --firstmatch  regex to match for first names, grep basic, case insensitive"
        echo "  -l, --lastmatch   regex to match for last names, grep basic, case insensitive"
        echo "  -r, --restrict    regex to match for all names, grep basic, case insensitive"
        echo "  -s, --stdin       if set will read from stdin"
        echo
        echo "Potential names will be taken from SOURCES, if provided, otherwise from the TROLLNAMES_PATH environment variable (and otherwise a stupid specific path that only works on my machine)."
        echo ""
        return 0
    end

    if not set -q _flag_number
        set -f _flag_number 1
    end

    if not set -q _flag_firstmatch
        set -f _flag_firstmatch ".*"
    end

    if not set -q _flag_lastmatch
        set -f _flag_lastmatch ".*"
    end

    if not set -q _flag_restrict
        set -f _flag_restrict ".*"
    end

    if not set -q argv[1]
        if set -q $TROLLNAMES_PATH
            set -f source_path $TROLLNAMES_PATH
        else
            set -f source_path "/home/mbk/hs/content/mine/trollname/6-letter-english-words.txt"
        end
    end

    for i in (seq 1 $_flag_number)
        if set -q source_path
            if set -q _flag_stdin
                set -f first_name (cat - $source_path | grep -Gi $_flag_firstmatch | grep -Gi $_flag_restrict | shuf -n 1)
                set -f last_name (cat - $source_path | grep -Gi $_flag_lastmatch | grep -Gi $_flag_restrict | shuf -n 1)
            else
                # Note the lack of a - after cat
                set -f first_name (cat $source_path | grep -Gi $_flag_firstmatch | grep -Gi $_flag_restrict | shuf -n 1)
                set -f last_name (cat $source_path | grep -Gi $_flag_lastmatch | grep -Gi $_flag_restrict | shuf -n 1)
            end
        else
            set -f first_name (cat $argv | grep -Gi $_flag_firstmatch | shuf -n 1)
            set -f last_name (cat $argv | grep -Gi $_flag_lastmatch | shuf -n 1)
        end

        echo "$first_name $last_name"
    end
end

trollname $argv
