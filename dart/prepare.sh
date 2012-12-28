#!/bin/bash
if [ ! -d "dart-sdk" ]; then
	if [ `uname -m` == 'x86_64' ]; then
		MACHINE_TYPE='64'
	else
		MACHINE_TYPE='32'
	fi
	wget "https://storage.googleapis.com/dart-editor-archive-integration/latest/dartsdk-linux-$MACHINE_TYPE.tar.gz"
	tar -zxf "dartsdk-linux-$MACHINE_TYPE.tar.gz"
fi

export PATH=$PATH:"dart-sdk/bin"
pub install
