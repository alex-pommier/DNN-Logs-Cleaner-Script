This script bulk deletes DNN log files in the directory `\Portals\_default\Logs` for all top-level website directories by specifying the Primary Directory ie: `C:\inetpub\wwwroot`
It will log files deleted into a text file & print in console. It will also show you the total file size space saved.

There is a `testMode` you can toggle on & off to simulate a run without deleting any actual files so you can confirm it will action correctly before running it.
Switch this: `$testMode = $false` to `$testMode = $true` if you'd like to run it in test mode.

Update this: `$primaryDirectory = "E:\inetpub\websites"` IE: `$primaryDirectory = "MyPathHere"` to specify your top-level directory.

NOTE* You will need to run this script in an administrator priviledged power shell console.
```
EXAMPLE:
C:/inetpub/wwwroot/
├── mywebsite1/
│   └── Portals/
│       └── _default/
│           └── Logs/
│               ├── 2024.05.23.log.resources
│               ├── 2024.05.24.log.resources
│               └── 2024.05.25.log.resources
├── mywebsite2/
│   └── Portals/
│       └── _default/
│           └── Logs/
│               ├── 2024.05.21.log.resources
│               └── 2024.05.22.log.resources
├── mywebsite3/
│   └── Portals/
│       └── _default/
│           └── Logs/
│               └── 2024.05.20.log.resources
└── mywebsite4/
    └── Portals/
        └── _default/
            └── Logs/
                ├── 2024.05.15.log.resources
                ├── 2024.05.16.log.resources
                └── 2024.05.17.log.resources

The script will process all top-level folders (e.g., `mywebsite1`, `mywebsite2`, etc.) under the `C:/inetpub/wwwroot/` directory.
It will:
1. Navigate to the `Portals/_default/Logs/` folder inside each website folder.
2. Identify and delete files matching the pattern `*.log.resources`.
3. Log the following details:
   - Number of files deleted per folder.
   - Total size of files deleted globally and per folder.
   - Errors encountered during processing.

Example Output:
- Processing directory: mywebsite1. Files to delete: 3
- Processing directory: mywebsite2. Files to delete: 2
- Processing directory: mywebsite3. Files to delete: 1
- Processing directory: mywebsite4. Files to delete: 3

Total files deleted: 9
Total size deleted: 45.67 MB
```
