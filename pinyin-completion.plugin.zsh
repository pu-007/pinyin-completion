# shellcheck disable=all
# https://github.com/zdharma-continuum/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

PINYIN_REPO_DIR="${0:h}"
if (( fpath[(I)$PINYIN_REPO_DIR] == 0 )); then
  fpath+=($PINYIN_REPO_DIR)
fi

autoload -Uz _pinyin_comp

# pinyin-comp is performed as one part of user-expand
zstyle ':completion:*' user-expand _pinyin_comp

# omit original and all expansions when showing the result of user-expand
zstyle ':completion:*:user-expand:*' tag-order expansions

# make use-expand perform as last, when needed
zstyle ':completion:*' completer _oldlist _expand _complete _match _user_expand

unset PINYIN_REPO_DIR
