#!/usr/bin/env bash
JVM_MAX_HEAP_SIZE=${JVM_MAX_HEAP_SIZE:-1024M}

JVM_EXTRA_OPTS=""

if [ ! -z "${JVM_MAX_HEAP_SIZE}" ]; then
  JVM_EXTRA_OPTS="${JVM_EXTRA_OPTS} -Xmx${JVM_MAX_HEAP_SIZE}"
fi

if [ ! -z "${JVM_INIT_HEAP_SIZE}" ]; then
  JVM_EXTRA_OPTS="${JVM_EXTRA_OPTS} -Xms${JVM_INIT_HEAP_SIZE}"
fi

if [ ! -z "${JVM_MAX_THREAD_STACK_SIZE}" ]; then
  JVM_EXTRA_OPTS="${JVM_EXTRA_OPTS} -Xss${JVM_MAX_THREAD_STACK_SIZE}"
fi

JVM_OPTS="${JVM_EXTRA_OPTS}
  -Djava.awt.headless=true
  -Dfile.encoding=UTF-8"

UNIFI_CMD="java ${JVM_OPTS} -jar lib/ace.jar start"

${UNIFI_CMD} &

sleep 5 && tail -n 100 -f logs/server.log
