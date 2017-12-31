# Check-Cast_XMR

This utility will check the hash rate of Cast_XMR and kill/restart the miner if the hash rate is below a set threshold.

This script is meant to be ran as a windows service on the computer running Cast_XMR.

This script requires that you run Cast_XMR with the -R option to enable remote access.

## Setup / How To Use

1) Copy the code or download check-cast_xmr.vbs and place this script wherever you like.

2) Edit the user variables in the script that are loacted between the comments EDIT BELOW/ABOVE HERE:<br>
  a) strCastXMR_HTTP - this is the web site for Cast_XMR stats, you probably won't need to change this<br>
  b) arrHash         - Place the hash rate thresholds for each card inside the brackets, seperated by commas<br>
  c) strCastXMR_EXE  - this is the actual file name for the miner you are running and want to kill/restart<br>
  d) strCastXMR_BAT  - this is the batch file that will start Cast_XMR<br>
  e) strDevCon_BAT   - this is the batch file that will disable/enable your VEGA cards, this is optional

3) Test the script by double-clicking.  Make sure it's completing succesffully.  A log file will be created in the same folder.

4) Create the schedule in Windows Task Scheduler.  Click "Create Task".  Match the screenshots:

-Give it a name, important to run with highest privileges if you are calling DevCon.<br>
<img src="https://i.imgur.com/0kMQugm.png">

-Click NEW to create a new trigger.<br>
<img src="https://i.imgur.com/IhpqWFy.png">

-Set the START anytime before current time.  Change the repeat minutes to whatever you feel is best.<br>
<img src="https://i.imgur.com/PL0Pw0s.png">

-Click NEW to create a new action.<br>
<img src="https://i.imgur.com/2XTdqvA.png">

-If script is in C:\Cast_XMR\check-cast_xmr.vbs, set the START IN to C:\Cast_XMR\<br>
<img src="https://i.imgur.com/j4qmPyB.png">

-Match these settings.<br>
<img src="https://i.imgur.com/FBA8yXW.png">

-Match these settings.<br>
<img src="https://i.imgur.com/nnNL6kC.png">

### Notes

If the script creates a popup message, it will disappear in five seconds, you don't have to click it.

The script will loop through all cards running in Cast_XMR, or through every hash threshold listed in arrHash, whichver is smaller.

If your setup needs more time waiting between killing the miner, edit the line WScript.Sleep 5000, which is currently 5 seconds.

If your setup needs more time waiting after diable/enable the cards, edit the line WScript.Sleep 10000, which is currently 10 seconds.

### END
