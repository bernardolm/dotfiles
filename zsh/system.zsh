function hibernate_now() {
	# echo code > /sys/power/pm_test
	# echo devices > /sys/power/pm_test
	# echo freezer > /sys/power/pm_test
	# echo platform > /sys/power/pm_test
	# echo processors > /sys/power/pm_test
	echo none > /sys/power/pm_test

	# echo reboot > /sys/power/disk
	# echo shutdown > /sys/power/disk
	# echo test_resume > /sys/power/disk
	echo platform > /sys/power/disk

	echo disk > /sys/power/state
}