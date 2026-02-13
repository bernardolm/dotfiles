#!/usr/bin/env python

import re
import subprocess

# from pprint import pprint
from slugify import slugify


def run(command):
	return subprocess.run(command, text=True, shell=True, capture_output=True, check=True)


def current_keys_list():
	return run("sudo apt-key list").stdout


def get_collection(keys_list, rgex):
	# print('rgex=%s' % rgex)
	pattern = re.compile(rgex)
	list = pattern.findall(keys_list)
	# pprint(list)
	# print(len(list))
	return list


def get_keys(key_list):
	regex = r"""
	(
		[A-F0-9]{4}\s{1}
		[A-F0-9]{4}\s{1}
		[A-F0-9]{4}\s{1}
		[A-F0-9]{4}\s{1}

		[A-F0-9]{4}\s{2}

		[A-F0-9]{4}\s{1}
		[A-F0-9]{4}\s{1}
		[A-F0-9]{4}\s{1}

		(
			[A-F0-9]{4}\s{1}
			[A-F0-9]{4}
		)
	)
	""".replace('\n', '').replace(' ', '')
	return get_collection(key_list, regex)


def get_uids(key_list):
	regex = r"""
		uid\s+\[\s
		unknown
		\]\s
		(.*)
	""".replace('\n', '').replace(' ', '')
	return get_collection(key_list, regex)


output = current_keys_list()
keys_list = get_keys(output)
uids_list = get_uids(output)

for line in range(len(keys_list)):
	key = keys_list[line][1].replace(' ', '')
	uid = uids_list[line]
	slug = slugify(uid)

	command = f'sudo apt-key export {key} | ' \
   f'sudo gpg --dearmour --yes --output /etc/apt/trusted.gpg.d/{slug}.gpg'

	print(f'{line}\n{key}\n{uid}\n{slug}\n{command}')

	try:
		result = run(command)
		print(f'✅ {uid}\n')
	except subprocess.CalledProcessError as e:
		print(f'💢 {uid} fails\nerror: {e}\n')
