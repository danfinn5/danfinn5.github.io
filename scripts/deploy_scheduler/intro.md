## Automated Scheduled Maintenance windows for Atlassian Statuspage

This automation runs at configurable intervals (e.g., every even week on Wednesday) and generates timezone-aware Scheduled Maintenance events based on a table of values stored in a .CSV file such as name, week (odd/even), time window, day of week, timezone, and Statuspage component and sub-component IDs. 

When the automation runs it uses the data in the .CSV file to determine the upcoming schedule of deployments for specific Components and Sub-Components. It then creates a branch writes those to a file called window_times.json with the necessary data to create Scheduled Maintenance in Statuspage and creates a Pull Request. Once the data in window_times.json is reviewed and merged, a github workflow kicks off that authenticates and sends the data to Statuspage using the Statuspage API. As each of these Scheduled Maintenance events are created, users who are subscribed to receive emails for each Statuspage Component and Sub-Component are automatically notified of the planned maintenance window. 

From there, Statuspage automatically sends the remaining chain of notifications as the dates and times for each Scheduled Maintenance events arrive.

**Note**: Statuspage uses UTC exclusively, so this automation converts the calculated local time into UTC prior to sending data to Statuspage.  

## Other features

The github workflow that uses this also automatically uses github actions to automatically retrieve the issue number of Jira tickets used to track this work and incorporates it into the Pull Request name (for CI purposes), and it can also send slack messages to update your team on the status of the automation.

### How to Review and Merge the Scheduled Maintenance JSON
The automation will run at configred intervals such as even Wednesdays at Noon (12:00PM) EST, which kicks off [statuspage_maint.yml](https://github.com/takeoff-com/release-notes/blob/master/.github/workflows/statuspage_maint.yml). This workflow runs a series of scripts and generates a Pull Request titled `maintenance events MAINT_WINDOWS_RT[ww-yy]` is generated which contains an updated `Window_Times.json` file containing the json payload. 

Once that PR gets generated, you need to: 
1. Open `Window_Times.json` in Edit mode.
2. For each client, review their scheduled maintenance event for the upcoming RT against the event in the [MFC Change Calendar](https://calendar.google.com/calendar/u/0?cid=dGFrZW9mZi5jb21fcmViNGRldnJhamg4dHU1bmRhaHJwa3BkazRAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ). Making sure `scheduled_for` and `scheduled_until` **date** and **time** match what is in the calendar.
- If the client's deploy window has been cancelled due to codefreeze, or punted from the RT, etc, delete the entire `incident` object for that client.
- When checking the `scheduled_for` and `scheduled_until` data, the easiest way to do this is to convert from your local time as listed in Google Calendar to UTC with [worldtimebuddy.com](worldtimebuddy.com). For example if your local time zone on Google Calendar is US Eastern, use worldtimebuddy.com to convert that to UTC, then check that against the `scheduled_for` and `scheduled_until` date and time. 

1. If everything looks good, merge the PR. This triggers the creation of all Statuspage Scheduled Maintenance windows and you will start to see notificaions go out in [#statuspage-maintenance-events](https://takeofftech.slack.com/archives/C03RBAGFSBF). Double check the [Send Statuspage Maintenance Windows](https://github.com/takeoff-com/release-notes/actions/workflows/send_statuspage_maint.yml) workflow to make sure it completed successfully (e.g., if you had a typo in your json data, it will create some Scheduled Maintenance windows, but not all).
2. Once that workflow is complete, a new PR titled Maintenance file FILE_MAINT_WINDOWS_RT[ww-yy] will be generated (e.g., [Maintenance file FILE_MAINT_WINDOWS_RT48-23](https://github.com/takeoff-com/release-notes/pull/609). That PR must also be merged in order to allow [closeMaintenanceWindw.sh in the Release Train Management repo](https://github.com/takeoff-com/release-train-management/blob/master/scripts/closeMaintenanceWindow.sh) to automatically mark the Scheduled Maintenance as Complete for each client once the RT deployment to Prod is done. 

