#!/bin/bash 

home=~/.switchGPU
bin="$home/bin"
tmp="$home/tmp"
logs="$home/logs"
logfile="$logs/logs.txt"

url_gfx="https://github.com/qnxor/macoh/raw/master/gfxCardStatus.tgz"

mkdir -p "$logs" "$tmp" "$bin"

function get_gfx () {
	set -e
	rm -f $bin/done-gfx
	echo "Fetching gfxCardStatus into $bin ..." >> $logfile
	/usr/local/bin/wget -q "$url_gfx" -P $tmp
	[[ -d $bin/gfxCardStatus.app ]] && rm -rf $bin/gfxCardStatus.app
	tar -C $bin -zxf $tmp/gfxCardStatus.tgz
	rm -f $tmp/gfxCardStatus.tgz
	touch $bin/done-gfx
}

function check_gfx () {
	[[ -r $bin/done-gfx && -d $bin/gfxCardStatus.app ]] || get_gfx force
}

function gpudetect () {
	local i log pid
	$bin/gfxCardStatus.app/Contents/MacOS/gfxCardStatus &> $logs/gfx.txt &
	pid=$!
	echo "Detecting GPUs ..." >> $logfile
	for ((i=0;i<10;i++)); do
		sleep 1
		log=$(<$logs/gfx.txt)
		if [[ "$log" =~ GPUs\ present:\ \([^\)]+$'\n'\) ]]; then
			log=${log/*GPUs present: (/}
			log=${log/)*/}
			log="${log//[\",]/}"
			local IFS=$'\n'
			log=($log)
			local IFS=$'\n\t '
			if [[ ${#log[*]} -lt 2 ]]; then
				silentkill $pid
				echo "Only one GPU detected. Nothing to switch. Exiting ..." 2>> $logfile
				return 15
			else
				silentkill $pid
				return 0
			fi
		fi
	done
	silentkill $pid
	echo "Timeout waiting for gfxCardStatus." 2>> $logfile
	return 16
}

function silentkill () {
	# Die with dignity. Kill if stubborn.
	# Add brackets ( ) around bg processes so we suppress "stopped" messsages
	( { sleep 0.25; kill -TERM $* &>/dev/null; } & )
	( { sleep 5; kill -KILL $* &>/dev/null; } & )
	# The 'wait' trick only works for subprocess of the current shell, should be fine
	# It suppresses the "terminated" background messages.
	# "wait" returns 127 if process not found (thanks!). We return 0 always.
	wait $* &>/dev/null || return 0
}

function gpuswitch () {
	check_gfx
	gpudetect || return $?
	local i j pid n=3 size gfxlog=$logs/gfx.txt
	echo "Switching GPU to Integrated ..." >> $logfile
	# Need to attempt 2-3 times due to a bug
	# https://github.com/codykrieger/gfxCardStatus/issues/103
	for ((i=1;i<=n;i++)); do
		echo "Switching attempt $i/$n ..." >> $logfile
		# It also doesn't exit, so we need to background it, monitor its log file, then kill it ... 
		touch $gfxlog
		$bin/gfxCardStatus.app/Contents/MacOS/gfxCardStatus --integrated &> $gfxlog &
		pid=$!
		# stop when file size stops increasing
		for ((j=0;j<10;j++)); do
			[[ $j = 0 ]] && sleep 1 || sleep 1
			size[1]=`wc -c $gfxlog`
			[[ ${size[0]} = ${size[1]} ]] && break
			size[0]=${size[1]}
		done
		[[ $j = 10 ]] && Timeout waiting for gfxCardStatus. GPU possibly not switched. >&2
		[ $i != $n ] && silentkill $pid
	done
	rm -f $gfxlog
	printf "Done. GPU should now be switched to Integrated.\n------------------------\n" >> $logfile
}

echo "$(date)" >> $logfile
killall gfxCardStatus 2>&1
gpuswitch

