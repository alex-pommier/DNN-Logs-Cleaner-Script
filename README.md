This script bulk deletes DNN log files in the directory `\Portals\_default\Logs` for all top-level website directories by specifying the Primary Directory ie: `C:\inetpub\wwwroot`
It will log files deleted into a text file & print in console. It will also show you the total file size space saved.

There is a `testMode` you can toggle on & off to simulate a run without deleting any actual files so you can confirm it will action correctly before running it.
Switch this: `$testMode = $false` to `$testMode = $true` if you'd like to run it in test mode.

Update this: `$primaryDirectory = "E:\inetpub\websites"` IE: `$primaryDirectory = "C:\mypathhere"` to specify your top-level directory.

NOTE* You will need to run this script in an administrator priviledged power shell console.
