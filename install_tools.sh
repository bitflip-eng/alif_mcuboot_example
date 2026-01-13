#!/bin/bash
TOOLDIR=${1:-../tools}
mkdir -p $TOOLDIR
TOOLDIR=$(readlink -f $TOOLDIR)

# optional oath token 
# if specified, oath is used to download, otherwise ssh
OAUTH_TOKEN=${2}

# helper to clone a repo...
download_repo() {
	local project=$1; shift
	local localpath=$1; shift
	if [ -z "$OAUTH_TOKEN" ]; then 
		remote=ssh://git@gitlab.com
	else
		remote=https://oauth2:${OAUTH_TOKEN}@gitlab.com
	fi
	url=$remote/$project

	if [ ! -d $localpath ] ; then
		echo "Downloading $url -> $localpath"
		git clone $url $localpath
	else
		echo "checking out pre-downloaded repo $localpath"
		if pushd $localpath; then
			git pull 
			popd
		fi
	fi
}


gitlab_root=bitflip-main/bi

case $(uname -s) in
    Darwin*)
	    HOST=darwin
        TOOLCHAIN_HOST=darwin-arm64;;
	Linux*)
	    HOST=linux
        TOOLCHAIN_HOST=x86_64;;
        *)
                echo "Only linux platforms are supported"
                exit -1
esac


echo "Installing compilers"

# add all new toolchains to this array using this format
TOOLCHAINS=(
"arm-gnu-toolchain-13.3.rel1-${TOOLCHAIN_HOST}-arm-none-eabi"
"gcc-arm-none-eabi-10-2020-q4-major-x86_64"
)

# newer compilers are named differently
for TOOLCHAIN in "${TOOLCHAINS[@]}"
do
    download_repo ${gitlab_root}/tools/toolchains/${HOST}/${TOOLCHAIN}  ${TOOLDIR}/${TOOLCHAIN}
done

