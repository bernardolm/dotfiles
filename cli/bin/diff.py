#!/usr/bin/env python

import os
import sys


os.system('meld "%s" "%s"' % (sys.argv[2], sys.argv[5]))
