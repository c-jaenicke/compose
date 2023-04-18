#!/usr/bin/env bash
# dump and restore PostgreSQL database from and to docker container

helpString="Usage: -o dump|restore -u username -p password -d databaseName -c containerName [-f fileName] [-h]
\tDump or restore a postgresql database from a container. Dumping a database creates a dump-CURRENT-DATE-TIME.sql file. Restoring a database takes a file as input.
\t-o\tChoose the operation to perform, either dump or restore.
\t-u\tGive the username of the user that will be used. Ensure this user has the needed permissions.
\t-p\tPassword of that user.
\t-d\tDatabase name to import to, ensure this database exists!
\t-c\tName of the postgres container.
\t-f\tSpecify the dump file to restore from. Only needed when restoring!
\t-f\tPrint this message.\n"

while getopts 'o:u:p:d:c:f:h' OPTION; do
    case "$OPTION" in
        # operation
        o)
            if [ $OPTARG != "dump"  ] && [ $OPTARG != "restore" ]
            then
                printf "Not a valid operation! Use 'dump' or 'restore'\n"
            else
                operation="$OPTARG"
            fi
        ;;
        
        # username
        u)
            username="$OPTARG"
        ;;
        
        # password
        p)
            password="$OPTARG"
        ;;
        
        # database name
        d)
            databaseName="$OPTARG"
        ;;
        
        # container name
        c)
            containerName="$OPTARG"
        ;;
        
        # file
        f)
            fileName="$OPTARG"
        ;;
        
        # help
        ?|*|h)
            printf "$helpString"
            exit 1
        ;;
    esac
done

# check if all mandatory arguments are set
if [ ! "$operation" ] ||
[ ! "$username" ] ||
[ ! "$password" ] ||
[ ! "$databaseName" ] ||
[ ! "$containerName" ] ;
then
    printf "Error: Missing a manadory argument (-o, -u, -p, -d, -c)! Did you provide all of them? Use -h for help.\n"
    exit 1
fi

# execute operation calling docker
case $operation in
    dump)
        docker exec -i $containerName /bin/bash -c "PGPASSWORD=$password pg_dump --username $username $databaseName " > ./dump-$(date +%Y_%m_%d-%H-%M).sql
    ;;
    restore)
        # check if trying to restore without specifying file
        if [ ! "$fileName" ]
        then
            printf "Error: Missing file to restore database from! Use -f do specify the file! Use -h for help.\n"
        else
            docker exec -i $containerName /bin/bash -c "PGPASSWORD=$password psql --username $username $databaseName" < $fileName
        fi
    ;;
esac

# BACKUP OLD CODE FOR REFERENCE
#case $1 in
#    dump)
#        docker exec -i container /bin/bash -c "PGPASSWORD=$2 pg_dump --username $3 $4" > ./dump-$(date +%Y_%m_%d-%H-%M).sql
#    ;;
#
#    restore)
#        docker exec -i container /bin/bash -c "PGPASSWORD=$2 psql --username $3 $4" < $5
#    ;;
#
#    *)
#        printf "bash dump-sql.sh dump|restore username password database_name"
#    ;;
#esac
