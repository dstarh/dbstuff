-----------------
Migration Toolkit
-----------------
Migration Toolkit is a command line utility that imports data or schema object
definitions immediately, or generates scripts that can be used at a later time 
to duplicate data and database objects.

Migration Toolkit facilitates migration to an Advanced Server or PostgreSQL database 
from:

    *  Oracle
    *  MySQL
    *  Sybase
    *  SQL Server

Migration Toolkit also simplifies migration from PostgreSQL into Advanced Server, or 
from an Advanced Server database into PostgreSQL.

For detailed information about migration support offered by Migration Toolkit, please
refer to the Postgres Plus Migration Guide, available from the EnterpriseDB website at:

    www.enterprisedb.com/products-services-training/products/documentation


----------------------------------
Installing Source-Specific Drivers
----------------------------------
Before using Migration Toolkit, you must install a source-specific driver.  Source-specific 
drivers are freely available through their respective vendors; for links to the vendors, 
visit the Third Party Drivers page at the EnterpriseDB website:

    www.enterprisedb.com/downloads/third-party-jdbc-drivers 

After downloading the source-specific driver, move the driver file into the /jre/lib/ext 
directory under the Postgres home directory if you are migrating to Advanced Server.  If you 
are migrating to PostgreSQL, move the driver file into the jre/lib/ext directory under your 
JVM installation.


-----------------------------------
Editing the toolkit.properties file
-----------------------------------
Migration Toolkit reads configuration information from the toolkit.properties file 
during the migration process to identify and connect to the source and target
databases.  Before executing Migration Toolkit, modify the toolkit.properties file
(located in 'etc' sub-directory, under the Postgres Plus installation directory) with 
the editor of your choice.  Update the file to include the following information:

  * SRC_DB_URL is a JDBC URL that specifies how Migration Toolkit should connect 
       to the source database.
         
  * SRC_DB_USER specifies a user name with sufficient privileges in the source
       database.
       
  * SRC_DB_PASSWORD is the password of the source database user.
    
  * TARGET_DB_URL is the JDBC URL of the target database.
    
  * TARGET_DB_USER specifies a user name with sufficient privileges in the target
       database.
       
  * TARGET_DB_PASSWORD is the password of the target database user.
    
For example, the toolkit.properties file to migrate from an Oracle database (mgmt)
with a user (hr) and password (hr) into an Advanced Server database (edb) with a
user (enterprisedb) and password (edb) contains the entries:

    SRC_DB_URL=jdbc:oracle:thin:@//localhost:1521/mgmt
    SRC_DB_USER=hr
    SRC_DB_PASSWORD=hr

    TARGET_DB_URL=jdbc:edb://localhost:5444/edb
    TARGET_DB_USER=enterprisedb
    TARGET_DB_PASSWORD=edb

After editing the toolkit.properties file to identify the source and target
database information, use the appropriate command and options (described below)
to migrate.  

For information about migrating from a non-Oracle database, see the Postgres
Plus Migration Guide, available at:

    www.enterprisedb.com/products-services-training/products/documentation


--------------------------
Invoking Migration Toolkit
--------------------------
The Migration Toolkit executable is located in the 'bin' directory.  The
executable is named runMTK.sh on Linux/Unix systems and runMTK.bat on Windows
systems.

Migrating from an instance of Oracle
------------------------------------
Use the following commands to migrate from an Oracle database.  

  To migrate a complete schema:
      (On Linux)
      $ ./runMTK.sh schema_name
      (On Windows)
      > .\runMTK.bat schema_name

  To migrate multiple schemas, include the schema names in a comma-delimited list:
      (On Linux)
      $ ./runMTK.sh schema_1,schema_2,schema_3
      (On Windows)
      > .\runMTK.bat schema_1,schema_2,schema_3

Append the appropriate options to further control the details of the migration.  For
example, to migrate all schemas from an Oracle database:

      (On Linux)
      $ ./runMTK.sh -allSchemas
      (On Windows)
      > .\runMTK.bat -allSchemas
      
Specifying a Source Type and a Target Type
------------------------------------------

By default, Migration Toolkit expects the source database to be Oracle; if the
source database is not Oracle, you must include the -sourcedbtype option when you invoke 
Migration Toolkit.

  -sourcedbtype source_type
    source_type specifies the source database type; by default, source_type is oracle.  
    source_type may be one of the following values: oracle, mysql, sqlserver, sybase, 
    postgres, postgresql or enterprisedb.  source_type is case-insensitive.  

To migrate a complete schema from a MySQL database to an Advanced Server database:
      (On Linux)
      $ ./runMTK.sh -sourcedbtype mysql schema_name
      (On Windows)
      > .\runMTK.bat -sourcedbtype mysql schema_name

By default, Migration Toolkit expects the target database to be Advanced Server; if the
source database is not Advanced Server, you must include the -targetdbtype option when you 
invoke Migration Toolkit.

  -targetdbtype target_type    target_type specifies the server type of the target database; by default, target_type 
    is enterprisedb.  target_type may be one of the following values: enterprisedb, postgres 
    or postgresql.  target_type is case-insensitive. 

To migrate a complete schema from a MySQL database to a postgresql database:
      (On Linux)
      $ ./runMTK.sh -sourcedbtype mysql -targetdbtype postgresql schema_name
      (On Windows)
      > .\runMTK.bat -sourcedbtype mysql -targetdbtype postgresql schema_name


---------------------------------
Migration Toolkit Command Options
---------------------------------

Import Mode
-----------
By default, Migration Toolkit imports both the data and the object definition
(DDL) when migrating a schema; you can optionally choose to import either the data
or the DDL.

  -sourcedbtype source_type
    The -sourcedbtype option specifies the source database type.  source_type may be one 
    of the following values: mysql, oracle, sqlserver, sybase, enterprisedb, postgres, 
    or postgresql.  source_type is case-insensitive.  By default, source_type is oracle.

  -targetdbtype target_type
    The -targetdbtype option specifies the target database type.  target_type may be 
    one of the following values: enterprisedb, postgres, postgresql, oracle or 
    sqlserver.  target_type is case-insensitive.  By default, target_type is enterprisedb.
 
  -schemaOnly
    This option imports the schema definition and creates all selected schema
    objects in the target database. This option cannot be used in conjunction with 
    '-dataOnly' option.

  -dataOnly
    This option copies the table data only. When used with the '-tables' option,
    Migration Toolkit will only import data for the selected tables (see usage
    details below). This option cannot be used with '-schemaOnly' option.

Schema Creation
---------------
By default, Migration Toolkit imports the source schema objects and/or data into
the existing (target) schema.  If the schema does not exist, Migration Toolkit 
creates a new schema that is named after the source schema or, alternatively, 
uses the custom name specified via the '-targetSchema schema_name' option. You can
choose to drop the (target) existing schema and create a new schema using the
following option:

  -dropSchema [true|false]
    When set to true, Migration Toolkit drops the existing schema (if any) and
    creates a new schema.  By default, -dropSchema is false.

  -targetSchema schema_name
    Specify the name of the target schema in place of schema_name.  If you are 
    migrating multiple schemas, specify a name for each schema in a comma-separated
    list.  If the call to Migration Toolkit does not include the -targetSchema
    option, the name of the new schema will be the same as the name of the source
    schema.
    
    Please note that you cannot specify 'information-schema', 'dbo', 'sys' or 
    'pg_catalog' as target schema names.  These schema names are reserved for 
    meta-data storage.

Schema Object Selection
-----------------------
Use the following options to select specific schema objects to migrate:

  -allTables
    Import all tables from the source schema.

  -tables table_list
    Import the selected tables from the source schema. table_list is a 
    comma-separated list of table names (e.g. -tables emp,dept,acctg).

  -importPartitionAsTable table_list
    Include the -importPartitionAsTable parameter to import the contents of a 
    partitioned table into a single non-partitioned table.  table_list is a comma-separated 
    list of table names (e.g. -importPartitionAsTable emp,dept,acctg).

  -constraints
    Import the table constraints. This option is valid when importing an entire
    schema or when the '-allTables' or '-tables table_list' options are specified.

  -ignoreCheckConstFilter
    By default, Migration Toolkit does not implement migration of check constraints 
    and default clauses from a Sybase database.  Include the  ignoreCheckConstFilter 
    parameter when specifying the -constraints parameter to migrate constraints and 
    default clauses from a Sybase database.  

  -skipCKConst
    Omit the migration of check constraints.  This option is useful when migrating 
    check constraints that are based on built-in functions (in the source database) 
    that are not supported in the target database.  This option is valid only 
    when importing an entire schema, or when the -allTables or -tables table_list 
    option *and* the -constraints option are specified.

  -skipFKConst
    Omit the migration of foreign key constraints.  This option is valid only when
    importing an entire schema, or when the -allTables or -tables table_list option 
    *and* the -constraints option are specified.

  -skipColDefaultClause
    Omit the migration of the column DEFAULT clause.

  -indexes
    Import the table indexes. This option is valid when importing an entire
    schema or when '-allTables' or '-tables table_list' option is specified.
    
  -triggers
    Import the table triggers. This option is valid when importing an entire
    schema or when '-allTables' or '-tables table_list' option is specified.

  -allViews
    Import all views from the source schema.

  -views view_list
    Import the selected views from the source schema.  view_list is a 
    comma-separated list of view names (e.g. -views all_emp,mgmt_list,acct_list)

  -allSequences
    Import all sequences from the source schema.

  -sequences sequence_list
    Import the selected sequences from the source schema.  sequence_list is a
    comma-separated list of sequence names.

  -allProcs
    Import all stored procedures from the source schema.

  -procs procedures_list
    Import the selected stored procedures from the source schema.  procedures_list
    is a comma-separated list of procedure names.

  -allFuncs
    Import all functions from the source schema.

  -funcs function_list
    Import the selected functions from the source schema.  function_list is a
    comma-separated list of function names.

  -checkFunctionBodies [true/false]
    When false, disables validation of the function body during function creation (to 
    avoid errors if the function contains forward references).  The default value is true.

  -allPackages
    Import all packages from the source schema.

  -packages package_list
    Import the selected packages from the source schema. package_list is a 
    comma-separated list of package names.

  -allRules
    Import all rules from the source database; this option is only valid when both the 
    source and target are stored on a PostgreSQL or PPAS host. 

Miscellaneous Options
---------------------  
  -help
    Display the application command-line usage information.

  -version
    Display the Migration Toolkit version.

  -verbose [on|off]
    Display application log messages on standard output (By default, verbose is
    on).

  -logDir log_path
    Include this option to specify where the log files will be written; log_path 
    represents the directory where log files are saved.  By default, 
    on Linux, the logfiles are saved to:

      $HOME/.enterprisedb/migration-toolkit/logs

    By default, on Windows, the logfiles are saved to:

      %HOMEDRIVE%%HOMEPATH%\.enterprisedb\migration-toolkit\logs

Migration Options
-----------------
  -loaderCount [value]
    Use the -loaderCount option to specify the number of parallel threads that Migration 
    Toolkit should use when importing data.  This option is particularly useful if the 
    source database contains a large volume of data, and the target host has high-end CPU 
    and RAM resources.  While value may be any non-zero, positive number, we recommend that 
    value should not exceed the number of CPU cores; a dual core CPU should have an optimal 
    value of 2.

    Please note that specifying too large of a value could cause Migration Toolkit to 
    terminate, generating a 'Out of heap space' error.

  -truncLoad	
    Truncate tables before importing new data.  This option can only be used in
    conjunction with the -dataOnly option.

  -enableConstBeforeDataLoad
    Include the -enableConstBeforeDataLoad option if a non-partitioned source table is 
    mapped to a partitioned table. This enables all the triggers on the target table 
    (including any triggers that redirect data to individual partitions) before the data 
    migration.  -enableConstBeforeDataLoad is valid only if the -truncLoad parameter is also 
    specified. 

  -retryCount [value]
    If you are performing a multiple-schema migration, objects that fail to migrate 
    during the first migration attempt due to cross-schema dependencies may successfully 
    migrate during a subsequent migration.  Use the -retryCount option to specify the 
    number of attempts that Migration Toolkit will make to migrate an object that has 
    failed during an initial migration attempt.  Specify a value that is greater than 0; 
    the default value is 2. 

  -safeMode
    If you include the -safeMode option, Migration Toolkit commits each row as
    migrated; if the migration fails to transfer all records, rows inserted prior
    to the point of failure will remain in the target database.
    
  -fastCopy
    Including the -fastCopy option specifies that Migration Toolkit should bypass
    WAL logging to perform the COPY operation in an optimized way, default disabled.
    If you choose to use the -fastCopy option, migrated data may not be recoverable
    (in the target database) if the migration is interrupted.

  -replaceNullChar [value]
    Include the -replaceNullChar option, to instruct Migration Toolkit to replace NULL 
    characters within a column with the specified value.  By default, Migration Toolkit 
    does not replace NULL characters. 

  -analyze
    Include the -analyze option to invoke the Postgres ANALYZE operation against a target 
    database.  The optimizer consults the statistics collected by the ANALYZE operation, 
    utilizing the information to construct efficient query plans.

  -vacuumAnalyze
    Include the -vacuumAnalyze option to invoke both the VACUUM and ANALYZE operations 
    against a target database. The optimizer consults the statistics collected by the 
    ANALYZE operation, utilizing the information to construct efficient query plans.  
    The VACUUM operation reclaims any storage space occupied by dead tuples in the target 
    database.
    
  -copyDelimiter
    Specify a single character to be used as a delimiter in the copy command when
    loading table data.  The default value is '\t' (tab).

  -batchSize
    Specify the batch size of bulk inserts.  Valid values are 1-1000.  The default
    batch size is 1000; reduce the value of batchSize if Out of Memory exceptions
    occur.

  -cpBatchSize
    Specify the Batch Size in MB, to be used in the Copy command.  Any value 
    greater than 0 is valid; the default batch size is 8 MB.

  -fetchSize
    Use the -fetchSize option to specify the number of rows fetched in a result set.
    If the fetchSize is too large, you may encounter Out of Memory exceptions; use
    the -fetchSize option to limit the fetchSize when migrating large tables.  The
    default fetch size is specific to the JDBC driver implementation, and varies by 
    database. 

    MySQL users note: By default, the MySQL JDBC driver will fetch all of the rows 
    that reside in a table into the client application (Migration Toolkit) in a single 
    network round-trip.  This behavior can easily exceed available memory for large 
    tables.  If you encounter an 'out of heap space' error, specify -fetchSize 1 as a 
    command line argument to force Migration Toolkit to load the table data one row at 
    a time.  

  -filterProp file_name
    file_name specifies the name of a file that contains constraints in key=value
    pairs.  Each record read from the database is evaluated against the
    constraints; those that satisfy the constraints are migrated.  The left side
    of the pair specifies a table name; please note that the table name should not 
    be schema-qualified.  The right side specifies a condition that must be true for 
    each row migrated.  For example including the following constraints in the property 
    file:
         
      countries=country_id<>'AR'
    
    Migrates only those countries with a country_id value that is not equal
    to 'AR'; this constraint applies to the countries table.

  -customColTypeMapping list
    Use custom type mapping to change the data type of migrated columns.  The left
    side of each pair specifies the columns with a regular expression; the right
    side of each pair names the data type that column should assume.  You can
    include multiple pairs in a semi-colon separated column_list.  For example, to
    map any column whose name ends in 'ID' to type INTEGER, use the following custom
    mapping entry:
    
      .*ID=INTEGER
    
    Custom mapping is applied to all table columns that match the criteria unless
    the column is table-qualified. 
    
    The '\\' characters act as an escape string; since "." is a reserved character
    in regular expressions, use "\\." to represent the '.' character. For example,
    to select rows from the "EMP_ID" column in the "EMP" table, specify the
    following custom mapping entry:
    
      EMP\\.EMP_ID=INTEGER

  -customColTypeMappingFile property_file
    You can include multiple custom type mappings in a property_file; specify each
    entry on a separate line, in a COL_NAME_REG_EXPR=TYPE pair. 
   
    -offlineMigration [directoryName]
    The -offlineMigration option generates a set of SQL scripts that will recreate
    the data and/or schema objects in the target database.  The SQL command that creates 
    each object or data item is saved in a separate file whose name is derived from the 
    schema name and object type (e.g. mtk_hr_table_ddl.sql).  
    
    In addition to creating individual SQL files, Migration Toolkit creates a master
    file that contains the DDL scripts for all of the migrated objects.  The name of
    the master file is based on the schema name (e.g. mtk_hr_ddl.sql).  If you are
    migrating multiple schemas, a separate master file is created for each schema.  
        
    To specify a file destination, include a directory name after the 
    '-offlineMigration' option: 
    
      $ ./runMTK -offlineMigration /opt/mtk

    If you do not specify a directory, the scripts are created in your home directory.

    For more information about performing an offline migration, please see Section 7.1 of 
    the Postgres Plus Migration Guide, available from EnterpriseDB at:

     www.enterprisedb.com/products-services-training/products/documentation


Oracle Specific Options
-----------------------
The following options apply only when the source database is Oracle.

  -objecttypes schema_name
    Import all object types from the source schema.  schema_name is the name of the
    source schema.  

  -allUsers
    Import all users and roles from the source database.  
        
  -users user_list
    Import the selected users or roles from the source Oracle database. user_list
    is a comma-separated list of user/role names (e.g. -users MTK,SAMPLE,acctg)

  -copyViaDBLinkOra
    The dblink_ora module provides EnterpriseDB to Oracle connectivity at the SQL
    level.  dblink_ora is bundled and installed as part of the EnterpriseDB
    database installation.  dblink_ora utilizes the COPY API method to transfer
    data from an Oracle database to EnterpriseDB database and is considerably
    faster than the JDBC COPY method.  
    
    The following example uses the dblink_ora COPY API to migrate all tables from
    the HR schema:

      $ ./runMTK -copyViaDBLinkOra -allTables HR 

    The target EnterpriseDB database must have dblink_ora installed and
    configured.  For installation details, refer to the dblink_ora setup guide
    'README-dblink_ora_setup.txt', in the /doc subfolder under the Postgres Plus 
    Advanced Server installation home directory. 

  -allDBLinks [link_Name_1=password_1,link_Name_2=password_2,...]
    Choose this option to migrate Oracle database links. The password information
    for each link connection in the source database is encrypted, so unless
    specified, a default password (edb) is substituted.  
    
    To migrate all database links (using "edb" as the default password) for the 
    connected user:
    
      $ ./runMTK -allDBLinks HR
    
    You can alternatively specify the password for each of the database links
    through a comma-separated list of name=value pairs.  Specify the link name on
    the left side of the pair and the password on the right side.
    
    To migrate all database links with the passwords specified on the
    command-line:
     
      $ ./runMTK -allDBLinks LINK_NAME1=abc,LINK_NAME2=xyz HR

    Migration Toolkit migrates only the database link types that are currently
    supported by EnterpriseDB; this includes "Fixed User Links" of Public and
    Private type.  

  -allSynonyms
    Include the -allSynonyms option to migrate all public and private synonyms from 
    an Oracle database to an Advanced Server database.  If a synonym with the same name 
    already exists in the target database, the existing synonym will be replaced with 
    the migrated version.

  -allPublicSynonyms
    Include the -allPublicSynonyms option to migrate all public synonyms from an Oracle 
    database to an Advanced Server database.  If a synonym with the same name already 
    exists in the target database, the existing synonym will be replaced with the 
    migrated version.
  -allPrivateSynonyms
    Include the -allPrivate Synonyms option to migrate all private synonyms from an Oracle 
    database to an Advanced Server database.  If a synonym with the same name already 
    exists in the target database, the existing synonym will be replaced with the 
    migrated version.
    

For more information about using Migration Toolkit, see the Postgres Plus Migration 
Guide, available from:

      www.enterprisedb.com/products-services-training/products/documentation


*******************************************************************************
  Copyright (c) 2012 - EnterpriseDB Corporation.  All Rights Reserved.
*******************************************************************************
