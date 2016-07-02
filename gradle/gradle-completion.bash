# Taken from https://raw.githubusercontent.com/calid/dotfiles/master/completion.d/gradle

_gradle()
{
  local cur_cmd
  local cur_arg
  local commands
  local cache_dir
  local checksum

  cur_cmd=${COMP_WORDS[0]}
  cur_arg=${COMP_WORDS[COMP_CWORD]}

  if [[ ! -x $cur_cmd && ! $(which $cur_cmd 2>/dev/null) ]]; then
      return 1
  fi

  cache_dir="$HOME/.gradle/completion_files"
  mkdir -p $cache_dir

  if [[ -f build.gradle ]]; then # top-level gradle file
    checksum=$(\
        find . -name build.gradle 2> /dev/null \
             | sort -u \
             | xargs cat \
             | git hash-object --stdin \
        )
  else # no top-level gradle file
    checksum='no_gradle_files'
  fi

  if [[ -f $cache_dir/$checksum ]]; then # cached! yay!
    commands=$(cat $cache_dir/$checksum)
  else # not cached! boo-urns!
    commands=$(\
      $cur_cmd tasks --all \
        | sed -e 0,/Build/d -e '/Rules/,$d' \
        | awk 'BEGIN {p=0} /^-+/ {p=1} /^$/ {p=0} /^[^-]/ {if (p) print $1}'
    )
  fi

  if [[ ! -z $commands ]]; then
      echo $commands > $cache_dir/$checksum
  fi

  COMPREPLY=( $(compgen -W "$commands" -- $cur_arg) )
  return 0
}

complete -o default -F _gradle gradle
complete -o default -F _gradle gradlew
complete -o default -F _gradle ./gradlew

# vim:ft=bash.sh:
