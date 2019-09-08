#!/bin/bash
#    Carpenter.AzurePipelines
#    Common YAML templates and scripts for Azure Pipelines definitions.
#
#    Copyright © 2015-2019 Nosnitor Corporation, All rights reserved.
#
#    Permission is hereby granted, free of charge, to any person obtaining a copy
#    of this software and associated documentation files (the "Software"), to deal
#    in the Software without restriction, including without limitation the rights
#    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#    copies of the Software, and to permit persons to whom the Software is
#    furnished to do so, subject to the following conditions:
#
#    The above copyright notice and this permission notice shall be included in all
#    copies or substantial portions of the Software.
#
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#    SOFTWARE.

# SPDX-License-Identifier: MIT

# get version prefix from VERSION file
if [ -z "$CARPENTER_VERSION_VERSIONFILE" ]; then
	echo "##vso[task.logissue type=warning;]Carpenter.Version.VersionFile (CARPENTER_VERSION_VERSIONFILE) variable has not been defined. Using version 0.1.0."
	echo "##vso[task.complete result=SucceededWithIssues;]Carpenter.Version.VersionFile (CARPENTER_VERSION_VERSIONFILE) variable has not been defined."
	VERSIONPREFIX=0.1.0
	VERSIONMAJOR=0
	VERSIONMINOR=1
	VERSIONPATCH=0
else
	VERSIONFILEPATH=$BUILD_SOURCESDIRECTORY/$CARPENTER_VERSION_VERSIONFILE
	if [[ -f "$VERSIONFILEPATH" ]]; then
		echo "Using VERSION file $VERSIONFILEPATH"
		VERSIONPREFIXSTRING=`cat $VERSIONFILEPATH`
		regex='^([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)$'
		if [[ $VERSIONPREFIXSTRING =~ $regex ]]; then
		VERSIONPREFIX=$VERSIONPREFIXSTRING
		VERSIONMAJOR="${BASH_REMATCH[1]}"
		VERSIONMINOR="${BASH_REMATCH[2]}"
		VERSIONPATCH="${BASH_REMATCH[3]}"
		else
		echo "##vso[task.logissue type=error;]VERSION file should contain only the Major.Minor.Patch elements of the version number (e.g. 1.2.3). Version File: $VERSIONFILEPATH"
		echo "##vso[task.complete result=Failed;]VERSION file should contain only the Major.Minor.Patch elements of the version number."
		fi
	else
		echo "##vso[task.logissue type=error;]Could not locate version file. File not found: $VERSIONFILEPATH"
		echo "##vso[task.complete result=Failed;]Could not locate version file."
	fi
fi


# determine build type

# default to CI build if not defined
if [ -z "$CARPENTER_BUILDTYPE" ]; then
	CARPENTER_BUILDTYPE=CI
fi

case "$CARPENTER_BUILDTYPE" in
	# continuous integration build
	CI)
		printf -v DATESTRING '%(%Y%m%d)T'
		VERSIONSUFFIX=CI.$DATESTRING
		;;
	*)
		echo "##vso[task.logissue type=error;]Carpenter.BuildType (CARPENTER_BUILDTYPE) contains an unknown build type. BuildType: $CARPENTER_BUILDTYPE"
		echo "##vso[task.complete result=Failed;]Carpenter.BuildType (CARPENTER_BUILDTYPE) contains an unknown build type."
		;;
esac

if [ ! -z "$VERSIONSUFFIX" ]; then
	VERSIONSUFFIXSTRING="-$VERSIONSUFFIX"
fi

VERSIONSTRING="$VERSIONMAJOR.$VERSIONMINOR.$VERSIONPATCH$VERSIONSUFFIXSTRING"

echo "##vso[task.setvariable variable=Carpenter.Version.Major;isOutput=true]$VERSIONMAJOR"
echo "##vso[task.setvariable variable=Carpenter.Version.Minor;isOutput=true]$VERSIONMINOR"
echo "##vso[task.setvariable variable=Carpenter.Version.Patch;isOutput=true]$VERSIONPATCH"
echo "##vso[task.setvariable variable=Carpenter.Version.Prefix;isOutput=true]$VERSIONPREFIX"
echo "##vso[task.setvariable variable=Carpenter.Version.Suffix;isOutput=true]$VERSIONSUFFIX"
echo "##vso[task.setvariable variable=Carpenter.Version.PackageVersion;isOutput=true]$VERSIONSTRING"
