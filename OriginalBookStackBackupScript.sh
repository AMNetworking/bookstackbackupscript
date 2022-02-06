# set current date
BKDATE=$(date "+%F-%H-%M-%S")

# set name of backup file
BFNAME=bookstack-total-backup-"$BKDATE"

echo "creating backup directory '/var/www/bookstack/bookstack-total-backup'--------------------------------------------"
mkdir /var/www/bookstack/bookstack-total-backup

echo "moving into bokstack's directory '/var/www/bookstack/'--------------------------------------------"
cd /var/www/bookstack/

echo "compressing files listed below--------------------------------------------"
tar -czvf bookstack-files-backup.tar.gz .env public/uploads storage/uploads

echo "moving compressed files to '/var/www/bookstack/bookstack-total-backup/'--------------------------------------------"
mv /var/www/bookstack/bookstack-files-backup.tar.gz /var/www/bookstack/bookstack-total-backup/

echo "performing SQL dump into '/var/www/bookstack/bookstack-total-backup/'--------------------------------------------"
mysqldump -u root bookstack > /var/www/bookstack/bookstack-total-backup/bookstack.backup.sql

echo "compressing entire backup folder '/bookstack-total-backup'--------------------------------------------"
tar -czvf "$BFNAME".tar.gz bookstack-total-backup

echo "removing backup folder '/var/www/bookstack/bookstack-total-backup/'--------------------------------------------"
rm -r /var/www/bookstack/bookstack-total-backup

echo "moving into root directory ~ --------------------------------------------"
cd ~

# check if there was a previous compressed backup file on home dir
CHKPB=$(find . -name "*bookstack-total-backup*")

# condition for check previous backup
if [ -f ~/"$CHKPB" ]
then
echo "deleting previous backup $CHKPB --------------------------------------------"
    find . -name "*bookstack-total-backup*" -delete
echo "moving new backup named $BFNAME into root directory ~ --------------------------------------------"
    mv /var/www/bookstack/"$BFNAME".tar.gz ~
else
    echo "no previous backup present--------------------------------------------"
    echo "moving new backup named $BFNAME into root directory ~ --------------------------------------------"
    mv /var/www/bookstack/"$BFNAME".tar.gz ~
fi
