#!/bin/sh
#
# Startup script for the Keepalived daemon
#
# processname: keepalived
# pidfile: /var/run/keepalived.pid
# config: /etc/keepalived/keepalived.conf
# chkconfig: - 21 79
# description: Start and stop Keepalived

# Source function library
if [ -f /etc/rc.d/init.d/functions ];then
	. /etc/rc.d/init.d/functions
fi

SYS_KP_FILE={$SERVER_PATH}/keepalived/etc/sysconfig/keepalived
# Source configuration file (we set KEEPALIVED_OPTIONS there)
if [ -f $SYS_KP_FILE ];then
	. $SYS_KP_FILE
fi

RETVAL=0
prog="keepalived"

start() {
    echo -n $"Starting $prog: "
    {$SERVER_PATH}/keepalived/sbin/keepalived ${KEEPALIVED_OPTIONS}
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch /var/lock/subsys/$prog
}

stop() {
    echo -n $"Stopping $prog: "
    pkill keepalived
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/$prog
}

reload() {
    echo -n $"Reloading $prog: "
    pkill keepalived -1
    RETVAL=$?
    echo
}

# See how we were called.
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    reload)
        reload
        ;;
    restart)
        stop
        start
        ;;
    condrestart)
        if [ -f /var/lock/subsys/$prog ]; then
            stop
            start
        fi
        ;;
    status)
        status keepalived
        RETVAL=$?
        ;;
    *)
        echo "Usage: $0 {start|stop|reload|restart|condrestart|status}"
        RETVAL=1
esac

exit $RETVAL
