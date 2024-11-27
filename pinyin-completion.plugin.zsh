# shellcheck disable=all
# https://github.com/zdharma-continuum/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

local -A _punctuation_map=(
	[～]=~
	[！]=!
	[＠]=@
	[＃]='#'
	[＄]=$
	[％]=%
	[＆]='&'
	[＊]=*
	[（]='('
	[）]=')'
	[＿]=_
	[－]=-
	[＋]=+
	[［]='['
	[］]=']'
	[「]='['
	[」]=']'
	[【]='['
	[】]=']'
	[〔]='['
	[〕]=']'
	[＜]='<'
	[＞]='>'
	[《]='<'
	[》]='>'
	[«]='<'
	[»]='>'
	[‹]='<'
	[›]='>'
	[？]=?
	[，]=,
	[。]=.
	[／]=/
	[＼]=\\
	[、]=\\
	[…]=...
)

_pinyin_comp()
{
  # [:ascii:] need
  setopt rematchpcre

  # unix file names can contain '\n', so use '\0' to separate them
  local IFS=$'\0' suffix='' file result k v
  local -a files
  if [ "$words[1]" = cd ] ; then
    suffix=/
  fi
  # print -N use '\0' to separate outputs
  for file in $(print -nN ${1:h}/*"$suffix"); do
    file="${file#./}"
    result="$file"
    if [[ $result =~ [^[:ascii:]] ]]; then
      for k v in ${(kv)FUZZY} ${(kv)_punctuation_map}; do
        result="${result//$k/$v}"
      done
      result="$(pypinyin -fslug -sz -p= "$result")"
    fi
    if [[ $result == $1* ]]; then
      reply+=(${(q)file})
    fi
  done
}

# pinyin-comp is performed as one part of user-expand
zstyle ':completion:*' user-expand _pinyin_comp

# omit original and all expansions when showing the result of user-expand
zstyle ':completion:*:user-expand:*' tag-order expansions

# make use-expand perform as last, when needed
zstyle ':completion:*' completer _oldlist _expand _complete _match _user_expand
