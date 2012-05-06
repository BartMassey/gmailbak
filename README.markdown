# Gmailbak - Back up your Gmail to your UNIX/Linux box

Copyright &copy; 2012 Bart Massey  
This work is distributed under the MIT license: see
the file COPYING in this distribution for license details.

These scripts, in conjunction with getmail4, will back up
your Gmail account regularly via cron.

&hellip;or something. This is a **very fragile** and
**poorly tested** setup, and Gmail may actually **publish
your Gmail password and then remove all your email, all your
email backups and itself.** You have been warned.

That said, I have been using Gmailbak for about a year, and
it seems to work reliably for me.

## Installation

1.  Make a directory for your backup. It should be somewhere
    with sufficient storage for all your future email.

2.  Create a user gmailbak with your backup directory as its
    home directory.

3.  Make sure your backup directory is mode 700. Make a Make
    a subdirectory named your Gmail username. Make
    subdirectories of the username directory named "new",
    "cur" and "tmp".  When you are done your setup should
    look like

        /storage/dir/username/new
        /storage/dir/username/cur
        /storage/dir/username/tmp

    Make sure all directories are owned by gmailbak. Do not
    make anything readable by anyone you don't want to be able
    to see your email.
  
4.  Make sure you have a copy of getmail4 installed. Your
    distro should have it, but if not you can get a copy
    from
    [http://pyropus.ca/software/getmail](http://pyropus.ca/software/getmail).

5.  Set your Gmail account up for backup.

    By default, Gmailbak uses POP3 SSL, so make sure that is
    turned on in your Gmail settings. **Make sure that the
    POP setting to "keep Gmail's copy in the Inbox' is
    turned on in the Gmail settings.** Otherwise, your email
    will be deleted from Gmail as it is "backed up", which
    is probably not what you had in mind.

    If you have Google Accounts set up to do two-factor
    authentication, note that you will have to **create an
    application-specific password** to use POP3 SSL. This
    would be a good idea in any case: unfortunately you have
    to store your password in clear, and you don't want your
    general Google account to be compromised by a security
    problem.

    If you want to use IMAP instead of POP3 or to turn off
    SSL, it should be straightforward to hack up Gmailbak to
    do this, but I haven't tried it.

6.  Copy getmail-example.conf to ~gmailbak/username.conf
    where "username" is your Gmail username. Edit
    username.conf appropriately for your connection. Again,
    note that this file will contain your **cleartext
    password**, so make sure it is protected appropriately:
    owned by gmailbak, with perms 0600.

7.  Copy gmailbak.sh to ~gmailbak. Make it owned by gmailbak,
    with perms 0700.

8.  If you want more users, you should just be able to stick
    more username.conf files in the gmailbak directory and
    add the corresponding subdirectories to your storage
    directory (repeating steps 3 and 6). Note that this has
    not been tested, however.

9.  Get things started with "su - gmailbak; sh -x gmailbak.sh".
    You should see getmail run for a long time, then sleep for
    60 seconds, then run for a long time again, until it has
    downloaded all the email. You can look at the log files in
    the gmailbak home directory or the emails themselves to verify
    that everything is copacetic. Note that this could literally
    take days.

10. Once the initial backup is done, use "crontab -e -u
    gmailbak" as root (or gmailbak) to insert an entry for
    cron to run gmailbak.sh to make your backups
    regularly. I use this entry to run morning and evening.

          7 5,23 *   *   *    sh $HOME/gmailbak.sh

## TODO

* Add scripts or something to simplify the complex
  installation.

* Because of the one-file-per-email storage format, your
  backup directory may become difficult to work with due to
  the number of directory entries. Figure out a good plan
  for this.
