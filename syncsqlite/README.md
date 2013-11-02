== SYNCSQLITE

USAGE
 synsqlite.sh SOURCEDB DESTHOST [DESTDIR]

This script takes a source database, creates a diff of it from the last time it was run, and copies it to the destination host via UUCP.

USAGE
 applysqlite.sh SOURCEDB DESTDB PATCH

This script takes a source database and creates a new database after applying a patch. The script will succeed regardless of if the patch has been applied or not.
