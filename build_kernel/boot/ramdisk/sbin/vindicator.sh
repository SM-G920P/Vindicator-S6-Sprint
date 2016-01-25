#!/system/bin/sh

# VARS

BB=/system/xbin/busybox
PROP=/system/kernel.prop
SYSTEMPROP=/system/build.prop

mount -o remount,rw /system
mount -o remount,rw /data

sync

/system/xbin/daemonsu --auto-daemon &

# Make internal storage directory.
busybox mount -t rootfs -o remount,rw rootfs
if [ ! -d /data/.vindicator ]; then
	mkdir /data/.vindicator
	$BB chmod -R 0777 /.vindicator/
fi
busybox mount -t rootfs -o remount,ro rootfs

# Synapse
busybox mount -t rootfs -o remount,rw rootfs
busybox chmod -R 755 /res/synapse
busybox ln -fs /res/synapse/uci /sbin/uci
/sbin/uci
busybox mount -t rootfs -o remount,ro rootfs

# Dumping
busybox mount -t rootfs -o remount,rw rootfs
busybox chmod -R 755 /res/dumping
busybox mount -t rootfs -o remount,ro rootfs

# Setup for Cron Task
# Copy Cron files
$BB cp -a /res/crontab/ /data/
if [ ! -e /data/crontab/custom_jobs ]; then
	$BB touch /data/crontab/custom_jobs;
	$BB chmod 777 /data/crontab/custom_jobs;
fi

# kernel custom test

if [ -e /data/vindicatortest.log ]; then
rm /data/vindicatortest.log
fi

#Set default values on boot
if [ "`grep "ro.build.version.release=5.1.1" $SYSTEMPROP`" != "" ]; then
	mkdir /system/su.d
	chmod 0700 /system/su.d
	echo "#!/tmp-mksh/tmp-mksh" > /system/su.d/000000deepsleep
	echo "echo "temporary none" > /sys/class/scsi_disk/0:0:0:1/cache_type" >>  /system/su.d/000000deepsleep
	echo "echo "temporary none" > /sys/class/scsi_disk/0:0:0:2/cache_type" >> /system/su.d/000000deepsleep
	chmod 0700 /system/su.d/000000deepsleep
	echo "Set deepsleep values on boot successful." >> /data/vindicatortest.log
fi

#Synapse profile
if [ ! -f /data/.vindicator/bck_prof ]; then
	cp -f /res/synapse/files/bck_prof /data/.vindicator/bck_prof
fi

chmod 777 /data/.vindicator/bck_prof

sleep 20;
if [ -d "/sys/class/misc/arizona_control" ]; then
	echo "0x0FF3 0x041E 0x0034 0x1FC8 0xF035 0x040D 0x00D2 0x1F6B 0xF084 0x0409 0x020B 0x1EB8 0xF104 0x0409 0x0406 0x0E08 0x0782 0x2ED8" > /sys/class/misc/arizona_control/eq_A_freqs
	echo "0x0C47 0x03F5 0x0EE4 0x1D04 0xF1F7 0x040B 0x07C8 0x187D 0xF3B9 0x040A 0x0EBE 0x0C9E 0xF6C3 0x040A 0x1AC7 0xFBB6 0x0400 0x2ED8" > /sys/class/misc/arizona_control/eq_B_freqs
	echo "1" >/sys/class/misc/arizona_control/switch_eq_hp
	echo "Set default sound values on boot successful." >> /data/vindicatortest.log
fi

# interactive governor
chown -R system:system /sys/devices/system/cpu/cpu0/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu0/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu0/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu1/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu1/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu1/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu2/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu2/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu2/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu3/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu3/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu3/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu4/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu4/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu4/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu5/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu5/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu5/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu6/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu6/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu6/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu7/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu7/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu7/cpufreq/interactive

#Setup Mhz Min/Max Cluster 0
echo 400000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
echo 1500000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
echo 400000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
echo 1500000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
echo 400000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
echo 1500000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
echo 400000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
echo 1500000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;

#Setup Mhz Min/Max Cluster 1
echo 800000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq;
echo 2100000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq;
echo 800000 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq;
echo 2100000 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq;
echo 800000 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq;
echo 2100000 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq;
echo 800000 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq;
echo 2100000 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq;

#e/frandom permissions
chmod 444 /dev/erandom
chmod 444 /dev/frandom

#Make sure perms are correct
chmod 755 /sys/kernel/hmp/power_migration

#Fix GPS Wake Issues. From LSpeed Mod 
mount -o remount,rw /
mount -o remount,rw rootfs
mount -o remount,rw /system
busybox mount -o remount,rw /
busybox mount -o remount,rw rootfs
busybox mount -o remount,rw /system

busybox sleep 40
su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$Receiver"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver"

#Setup vindicator file location if it doesn't exist already
[ ! -d "/data/data/vindicator" ] && mkdir /data/data/vindicator
chmod 755 /data/data/vindicator

# init.d support
/system/xbin/busybox run-parts /system/etc/init.d

# Apollo Minfreq
CFILE="/data/data/vindicator/APminfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
fi

# Apollo Maxfreq
CFILE="/data/data/vindicator/APmaxfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
fi	
# Atlas Minfreq
CFILE="/data/data/vindicator/ATminfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
fi

# Atlas Maxfreq
CFILE="/data/data/vindicator/ATmaxfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
fi
	
#PEWQ's
CFILE="/data/data/vindicator/PEWQ"
SFILE="/sys/module/workqueue/parameters/power_efficient"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

#FSync
CFILE="/data/data/vindicator/SHWL"
SFILE="/sys/module/wakeup/parameters/enable_sensorhub_wl"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

#Task Packing
CFILE="/data/data/vindicator/packing"
SFILE="/sys/kernel/hmp/packing_enable"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

#Power Aware Scheduling
CFILE="/data/data/vindicator/PAS"
SFILE="/sys/kernel/hmp/power_migration"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

#DT2W
CFILE="/data/data/vindicator/DT2W"
SFILE="/sys/android_touch/doubletap2wake"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

sleep 1;
