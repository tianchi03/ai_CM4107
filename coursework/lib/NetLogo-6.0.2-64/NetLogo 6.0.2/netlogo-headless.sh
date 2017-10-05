#!/bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ ${JAVA_HOME+1} ]]; then
  JAVA="${JAVA_HOME}/bin/java"
else
  echo "JAVA_HOME undefined, using java from path. For control over exact java version, set JAVA_HOME"
  JAVA="java"
fi;

# -Xmx1024m             use up to 1GB RAM (edit to increase)
# -Dfile.encoding=UTF-8 ensure Unicode characters in model files are compatible cross-platform
JVM_OPTS=(-Xmx1024m -Dfile.encoding=UTF-8)
OPTS_INDEX=2

ARGS=()
INDEX=0

for arg in "$@"; do
  if [[ "$arg" == "--3D" ]]; then
    JVM_OPTS[OPTS_INDEX++]="-Dorg.nlogo.is3d=true"
  elif [[ "$arg" == -D* ]]; then
    JVM_OPTS[OPTS_INDEX++]="$arg"
  else
    ARGS[INDEX++]="$arg"
  fi
done

RAW_CLASSPATH="app/args4j-2.0.12.jar:app/asm-all-5.0.4.jar:app/asm-all-5.0.4.jar:app/autolink-0.6.0.jar:app/behaviorsearch.jar:app/commons-codec-1.10.jar:app/commons-logging-1.1.1.jar:app/config-1.3.1.jar:app/flexmark-0.20.0.jar:app/flexmark-ext-autolink-0.20.0.jar:app/flexmark-ext-escaped-character-0.20.0.jar:app/flexmark-ext-typographic-0.20.0.jar:app/flexmark-formatter-0.20.0.jar:app/flexmark-util-0.20.0.jar:app/gluegen-rt-2.3.2.jar:app/httpclient-4.2.jar:app/httpcore-4.2.jar:app/httpmime-4.2.jar:app/jcommon-1.0.16.jar:app/jfreechart-1.0.13.jar:app/jhotdraw-6.0b1.jar:app/jmf-2.1.1e.jar:app/jogl-all-2.3.2.jar:app/json-simple-1.1.1.jar:app/log4j-1.2.16.jar:app/macro-compat_2.12-1.1.1.jar:app/macro-compat_2.12-1.1.1.jar:app/netlogo-6.0.2.jar:app/parboiled_2.12-2.1.3.jar:app/parboiled_2.12-2.1.3.jar:app/picocontainer-2.13.6.jar:app/picocontainer-2.13.6.jar:app/rsyntaxtextarea-2.6.0.jar:app/scala-library-2.12.2.jar:app/scala-parser-combinators_2.12-1.0.5.jar:app/shapeless_2.12-2.3.2.jar:app/shapeless_2.12-2.3.2.jar"
CLASSPATH=''

for jar in `echo $RAW_CLASSPATH | sed 's/:/ /g'`; do
  CLASSPATH="$CLASSPATH:$BASE_DIR/$jar"
done

CLASSPATH=`echo $CLASSPATH | sed 's/://'`

# -classpath ....         specify jars
# org.nlogo.headless.Main specify we want headless, not GUI
# "${ARGS[0]}"            pass along any additional arguments
java "${JVM_OPTS[@]}" -Dnetlogo.extensions.dir="${BASE_DIR}/app/extensions" -classpath "$CLASSPATH" org.nlogo.headless.Main "${ARGS[@]}"