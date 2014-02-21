#!/bin/bash

LAUNCH_DIR=$PWD

APPLEDOC_EXE=$(which appledoc)
if [ -z "$APPLEDOC_EXE" ]; then
	APPLEDOC_EXE=/usr/local/bin/appledoc
fi



PROJECT_ROOT=$PWD

DEPLOYMENT_DIR=${PROJECT_ROOT}/deployment
SDK_LIBRARIES_ROOT=${PROJECT_ROOT}/SCItemsBrowser


if [ -d "$DEPLOYMENT_DIR" ]; then
	rm -rf "$DEPLOYMENT_DIR" 
fi
mkdir -p "$DEPLOYMENT_DIR" 


cd "$DEPLOYMENT_DIR"
	which appledoc

	${APPLEDOC_EXE}                                    \
	 	--project-name "Sitecore Items Browser"    \
		--project-company "Sitecore"               \
		--company-id net.sitecore                  \
                --no-repeat-first-par                      \
 		--output .                                 \
	        --ignore "$SDK_LIBRARIES_ROOT/FileManager" \
	        --ignore "$SDK_LIBRARIES_ROOT/Grid"        \
		"$SDK_LIBRARIES_ROOT"                      


	DOCUMENTATION_PATH=$( cat docset-installed.txt | grep Path: | awk 'BEGIN { FS = " " } ; { print $2 }' )
	echo DOCUMENTATION_PATH - $DOCUMENTATION_PATH
	
	cp -R "${DOCUMENTATION_PATH}" .
	find . -name "*.docset" -exec zip -r Sitecore-Mobile-SDK-doc.zip {} \;  -print 
cd "$LAUNCH_DIR"
