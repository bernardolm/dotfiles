function hibernate_now() {
	# # echo code | sudo tee /sys/power/pm_test
	# # echo devices | sudo tee /sys/power/pm_test
	# # echo freezer | sudo tee /sys/power/pm_test
	# # echo platform | sudo tee /sys/power/pm_test
	# # echo processors | sudo tee /sys/power/pm_test
	# # echo none | sudo tee /sys/power/pm_test

	# # echo reboot | sudo tee /sys/power/disk
	# # echo shutdown | sudo tee /sys/power/disk
	# # echo test_resume | sudo tee /sys/power/disk

	echo platform | sudo tee /sys/power/disk
	echo disk | sudo tee /sys/power/state

	gnome-screensaver-command -l
}
