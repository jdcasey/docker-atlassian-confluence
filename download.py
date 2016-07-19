#!/usr/bin/env python

import os
import sys
import urllib2
import glob

CHUNK = 16 * 1024

JDK_URL="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"
DL_DIR='downloads'

DUMB_INIT_VERSION="1.1.1_amd64"
CONFLUENCE_VERSION="5.10.0"
POSTGRESQL_VERSION="9.4-1202.jdbc41"

DOWNLOADS = {
	"dumb-init": "https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_%s" % DUMB_INIT_VERSION,
	"confluence.tar.gz": "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-%s.tar.gz" % CONFLUENCE_VERSION,
	"postgresql.jar": "https://jdbc.postgresql.org/download/postgresql-%s.jar" % POSTGRESQL_VERSION
}

if not os.path.isdir(DL_DIR):
	os.makedirs(DL_DIR)

for filename,url in DOWNLOADS.items():
	# Download the file from `url` and save it locally under `file_name`:
	f = os.path.join(DL_DIR, filename)
	if not os.path.exists(f):
		print "Downloading: %s" % url
		response = urllib2.urlopen(url)
		with open(f, 'wb') as outfile:
			while True:
				chunk = response.read(CHUNK)
				print '.',
				if not chunk: break
				outfile.write(chunk)
		response.close()
		print ""
	else:
		print "NOT downloading: %s. It already exists." % f

if len(glob.glob(os.path.join(DL_DIR, 'jdk*.tar.gz'))) < 1:
	print """Cannot find Oracle JDK in %s. 

Please download the tar.gz version of the JavaSE 1.8 SDK manually from:

%s

""" % (DL_DIR, JDK_URL)
	exit(1)

#ADD jdk*.tar.gz /opt/jdk

