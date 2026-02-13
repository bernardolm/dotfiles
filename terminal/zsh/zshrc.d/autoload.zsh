# Use default modern completion system, needs to be in top
if command -v compinit >/dev/null ; then
	autoload -Uz +X compinit
	functions[compinit]=$'print -u2 \'compinit being called at \'${funcfiletrace[1]}'${functions[compinit]}
fi

# autoload -Uz promptinit && promptinit && prompt adam2 # Set up the prompt
autoload -Uz bashcompinit && bashcompinit # load some old bash completions
