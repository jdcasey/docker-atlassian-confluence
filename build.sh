#!/bin/bash

./download.py || exit $?

docker build --tag=docker.io/buildchimp/confluence $@ .

