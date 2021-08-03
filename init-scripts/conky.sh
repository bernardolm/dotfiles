[ $(ps auxwf | grep -v grep | grep conky | wc -l | bc) -gt 1 ] && echo "several conkys was started, killing them" && kill-conky && sleep 1
[ $(ps auxwf | grep -v grep | grep conky | wc -l | bc) -eq 0 ] && echo "starting conky" && conky -q
