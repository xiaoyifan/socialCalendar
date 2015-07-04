# To use Peter Gabriel script, you need to install it with this command line :
# sudo npm install -g peter-gabriel

# Variables to configure for your project
PROJ_FOLDER=./
SCRIPT_PATH=./Scripts
CODE_FOLDER_NAME=socialCalendar/
DEVELOP_BRANCH=develop
STAGING_BRANCH=staging
MASTER_BRANCH=master
NOTIFY=--notify
PROJECT_NAME="socialCalendar"
PROJECT_COMPANY="socialCalendar"
WORKSPACE_NAME=socialCalendar

# MASTER
SCHEME_NAME_MASTER=socialCalendar
CONFIG_NAME_MASTER=Release
HOCKEY_TOKEN_MASTER=
plist_master=./socialCalendar/Supporting\ Files/socialCalendar-Info.plist

# STAGING
SCHEME_NAME_STAGING=CookieVan
CONFIG_NAME_STAGING=Release
HOCKEY_TOKEN_STAGING=7bf94ae90c7146d6aefce9b7e5ef76d9
plist_staging=./LillyPulitzer/Supporting\ Files/CookieVan-Info.plist

# UI TESTING
SCHEME_NAME_UI_TESTING=CookieVan-calabash
TESTMUNK_APP_NAME=Lilly-Pulitzer
TESTMUNK_EMAIL=joe@prolificinteractive.com
TESTMUNK_TOKEN=XzqksJw28aInSVdIgcsp5ucVbSlSVZd0
UI_TESTS_FOLDER_NAME=testcases_lilly_pulitzer
UI_TEST_REPO=git@github.com:testmunk/testcases_lilly_pulitzer.git
ARCHIVE_PATH_TESTING=CookieVan-calabash.xcarchive
IPA_PATH_TESTING=CookieVan-calabash.ipa

define update-staging
	git checkout ${STAGING_BRANCH}
	git pull origin ${STAGING_BRANCH}
	git merge origin/${MASTER_BRANCH}
	git push origin ${STAGING_BRANCH}
endef

define update-develop
	git checkout ${DEVELOP_BRANCH}
	git pull origin ${DEVELOP_BRANCH}
	git merge origin/${STAGING_BRANCH}
	git push origin ${DEVELOP_BRANCH}
endef

define pull-latest-ui-tests
	# only clone if the directory doesn't exist yet
	if [ ! -d "${UI_TESTS_FOLDER_NAME}" ]; then git clone ${UI_TEST_REPO}; fi
	cd ${UI_TESTS_FOLDER_NAME}; git pull
endef

build: build-master

build-master:
	cd ${PROJ_FOLDER}; pod install && pod update;
	cd ${PROJ_FOLDER}; ${SCRIPT_PATH}/create_build.sh ${SCHEME_NAME_MASTER} ${CONFIG_NAME_MASTER}

build-staging:
	cd ${PROJ_FOLDER}; pod install && pod update;
	cd ${PROJ_FOLDER}; ${SCRIPT_PATH}/create_build.sh ${SCHEME_NAME_STAGING} ${CONFIG_NAME_STAGING}

build-calabash:
	cd ${PROJ_FOLDER}; pod update;
	cd ${PROJ_FOLDER}; calabash-ios sim reset; xcodebuild -sdk iphonesimulator -workspace "${WORKSPACE_NAME}.xcworkspace" -scheme ${SCHEME_NAME_UI_TESTING} ONLY_ACTIVE_ARCH=NO clean build | xcpretty -c && exit ${PIPESTATUS[0]}

archive-calabash:
	cd ${PROJ_FOLDER}; pod update;
	cd ${PROJ_FOLDER}; xcodebuild archive -workspace "${WORKSPACE_NAME}.xcworkspace" -scheme ${SCHEME_NAME_UI_TESTING} -archivePath ${ARCHIVE_PATH_TESTING} | xcpretty -c && exit ${PIPESTATUS[0]}

export-archive:
	cd ${PROJ_FOLDER}; rm -f ${IPA_PATH_TESTING}
	cd ${PROJ_FOLDER}; xcodebuild -exportArchive -exportFormat ipa -archivePath ${ARCHIVE_PATH_TESTING} -exportPath ${IPA_PATH_TESTING} | xcpretty -c && exit ${PIPESTATUS[0]}

distribute-calabash:
	# assumes `archive-calabash` and export-archive` have been run and the ipa file exists at ${PROJ_FOLDER}/${IPA_PATH_TESTING}
	# 'devices' defaults to those chosen in the web GUI, 
	# otherwise: 
	#			-F 'devices=iphone-6-plus-A' \
	$(pull-latest-ui-tests)
	cd ${UI_TESTS_FOLDER_NAME}; zip -r ../features.zip features/
	cd ${PROJ_FOLDER}; curl \
		-H 'Accept: application/vnd.testmunk.v1+json' \
		-F "file=@${IPA_PATH_TESTING}" \
		-F 'testcases=@features.zip' \
		-F "email=${TESTMUNK_EMAIL}" \
		-F 'autoStart=true' \
		-F 'public=false' \
		"https://${TESTMUNK_TOKEN}@api.testmunk.com/apps/${TESTMUNK_APP_NAME}/testruns"

distribute-master: build-master
	cd ${PROJ_FOLDER}
	${SCRIPT_PATH}/distribute_build_hockey.sh ${HOCKEY_TOKEN_MASTER} ${NOTIFY}
	#If build suceeded tag the tree
	git tag `pgab bump -l ${plist_master}`-${SCHEME_NAME_MASTER}
	git push origin `pgab bump -l ${plist_master}`-${SCHEME_NAME_MASTER}
	#Then bump version number
	pgab bump -br ${plist_master}
	git commit -am "Bumped build version (${SCHEME_NAME_MASTER})"
	git push origin HEAD:${MASTER_BRANCH}
	#Finally bring staging and develop up to speed
	$(update-staging)
	$(update-develop)

distribute-staging: build-staging
	cd ${PROJ_FOLDER}
	${SCRIPT_PATH}/distribute_build_hockey.sh ${HOCKEY_TOKEN_STAGING} ${NOTIFY}
	#If build suceeded tag the tree
	git tag `pgab bump -l ${plist_staging}`-${SCHEME_NAME_STAGING}
	#Then bump version number
	pgab bump -br ${plist_staging}
	git commit -am "Bumped build version (${SCHEME_NAME_STAGING})"
	git push origin HEAD:${STAGING_BRANCH}
	#Finally bring develop up to speed
	$(update-develop)

documentation:
	appledoc --project-name ${PROJECT_NAME} --project-company ${PROJECT_COMPANY} -h --ignore Pods --ignore Crashlytics.framework --search-undocumented-doc ./

clean-code:
	cd ${PROJ_FOLDER}
	${SCRIPT_PATH}/clean_code.sh ${CODE_FOLDER_NAME}
