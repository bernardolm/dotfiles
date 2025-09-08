export color_black ; color_black='\e[0;30m'
export color_blue ; color_blue='\e[0;34m'
export color_brown ; color_brown='\e[0;33m'
export color_cyan ; color_cyan='\e[0;36m'
export color_gray ; color_gray='\e[1;30m'
export color_green ; color_green='\e[0;32m'
export color_light_blue ; color_light_blue='\e[1;34m'
export color_light_cyan ; color_light_cyan='\e[1;36m'
export color_light_gray ; color_light_gray='\e[0;37m'
export color_light_green ; color_light_green='\e[1;32m'
export color_light_purple ; color_light_purple='\e[1;35m'
export color_light_red ; color_light_red='\e[1;31m'
export color_nc ; color_nc='\e[0m' # no color
export color_purple ; color_purple='\e[0;35m'
export color_red ; color_red='\e[0;31m'
export color_white ; color_white='\e[1;37m'
export color_yellow ; color_yellow='\e[1;33m'

function colors1() {
  echo -e "\n\033[4;31mLight Colors\033[0m  \t\t\033[1;4;31mDark Colors\033[0m"

  echo -e "\e[0;30;47m Black    \e[0m 0;30m \t\e[1;30;40m Dark Gray  \e[0m 1;30m"
  echo -e "\e[0;31;47m Red      \e[0m 0;31m \t\e[1;31;40m Dark Red   \e[0m 1;31m"
  echo -e "\e[0;32;47m Green    \e[0m 0;32m \t\e[1;32;40m Dark Green \e[0m 1;32m"
  echo -e "\e[0;33;47m Brown    \e[0m 0;33m \t\e[1;33;40m Yellow     \e[0m 1;33m"
  echo -e "\e[0;34;47m Blue     \e[0m 0;34m \t\e[1;34;40m Dark Blue  \e[0m 1;34m"
  echo -e "\e[0;35;47m Magenta  \e[0m 0;35m \t\e[1;35;40m DarkMagenta\e[0m 1;35m"
  echo -e "\e[0;36;47m Cyan     \e[0m 0;36m \t\e[1;36;40m Dark Cyan  \e[0m 1;36m"
  echo -e "\e[0;37;47m LightGray\e[0m 0;37m \t\e[1;37;40m White      \e[0m 1;37m"
}

function colors2() {
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}

function colors3() {
  for i in {0..255} ; do
		a=$(($i%6))
    if [ $a -eq 0 ]; then
      printf "\x1b[38;5;${i}mcolour${i}\n";
    else
      printf "\x1b[38;5;${i}mcolour${i}  ";
    fi
  done
}
