# pfsense_zfs_check
Health check script for pfSense on ZFS.

This job will check all ZFS pools to confirm health state of them, trigger a scrub of the pool, and check if usage of the pool has not reached configurable value (default 50%)

# Config file 
By default the script will produce a warning when drive space is at 50% or greater.  If you want to change this modify the following line

max_capacity=50

# Usage
Setup a cron job under pfSense GUI: Services -> Cron -> Settings

Here is an example for a weekly job run

0 	0 	* 	* 	* 	root 	/root/pfsense_zfs_check.sh

# Requirements
* pfSense
* Notifications setup under: System -> Advanced -> Notifications

# Donation
If you find this useful and you would like to support please the use option below.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=jason%2ep%2eclara%40gmail%2ecom&lc=CA&item_name=Jason%20Clara&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)

