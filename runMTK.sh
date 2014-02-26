# ----------------------------------------------------------------------------
# --
# -- Copyright (c) 2004-2012 - EnterpriseDB Corporation.  All Rights Reserved.
# --
# ----------------------------------------------------------------------------

java -Dprop=toolkit.properties -jar lib/edb-migrationtoolkit.jar -targetdbtype postgres "$@"
