#!/bin/sh

# $1: hockey API token, to be create from hockey in API section (don't use app ID)
# $2: Option to notify users or not

ipa distribute:hockeyapp \
	--token $1\
	--mandatory \
	--notes "$(git log --no-merges --pretty="%s" --since="`/usr/local/opt/coreutils/bin/gdate  -r ./../lastSuccessful/build.xml "+%F %T"`")" \
	$2
