#!/usr/bin/env python

import sys
import os

os.system('meld "%s" "%s"' % (sys.argv[2], sys.argv[5]))
