log warn "running in DEBUG mode"

log debug "testing emoji char: \xee\x82\xa0 \xf0\x9f\x90\x8d \ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699 (9)"

python_symbols_test=$(python3 -c 'print (u"\u22c5 \u22c5\u22c5 \u201d \u2019 \u266f \u2622 \u260d \u2318 \u2730 \u28ff \u26a1 \u262f \u2691 \u21ba \u2934 \u2935 \u2206 \u231a \u2240\u2207 \u2707 \u26a0\xa0\u25d4 \u26a1\xa0\u21af \xbf \u2a02 \u2716 \u21e3 \u21e1 \u2801 \u2809 \u280b \u281b \u281f \u283f \u287f \u28ff \u2639 \u2780 \u2781 \u2782 \u2783 \u2784 \u2785 \u2786 \u2787 \u2788 \u2789 \u25b9\xa0\u254d \u25aa \u26af \u2692 \u25cc \u21c5 \u21a1 \u219f \u229b \u267a".encode("utf8"))')

log debug "testing python symbols: ${python_symbols_test}"
