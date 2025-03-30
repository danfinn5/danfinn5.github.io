# Automated Release Notes

This repo is used to automatically generate release notes from Jira and publish them to Zendesk using GitHub Actions workflows.

## Overview

This automation supports a centralized, single-page, date-driven changelog — modeled after release documentation from cloud-native SaaS providers (e.g., [Google Cloud Release Notes](https://cloud.google.com/release-notes)). It replaces manual or client-specific documentation with a more scalable approach, leveraging CI/CD practices.

Publishing is handled via GitHub Actions, with scheduled jobs, Slack notifications, and structured review steps to ensure consistent, timely release communications.

There is a one-business-day SLA for review and publishing.

## Automation Workflow

The automation is orchestrated using **GitHub Actions**. The core workflow, [`ZD_html_to_dict.yml`](https://github.com/takeoff-com/release-notes/blob/master/.github/workflows/ZD_html_to_dict.yml), runs on a **cron schedule**:

```yaml
on:
  schedule:
    - cron: '0 6,12,18 * * *'  # Runs at 6 AM, 12 PM, and 6 PM UTC daily
```
### Workflow Steps

1. **Zendesk Sync**  
   The script fetches the current release notes from Zendesk and saves them to `data/zendesk_data.html`. This snapshot is used to compare existing notes against new updates.

2. **Jira Query**  
   The automation queries Jira for issues where the `Release Notes Required` field is set to `Yes - Ready to Publish`, and extracts:
   - `Release Notes Description`
   - `Fix Versions`
   - `Product Area`

3. **Data Processing**  
   A set of Python scripts handle parsing, merging, formatting, and generating the final release notes HTML:

   - `jira_issue.py`  
     Converts raw Jira JSON into structured objects. Each Jira issue becomes a reusable Python class instance. It also:
     - Sorts entries by earliest Fix Version.
     - Filters out unwanted versions.
     - Groups issues by product area and normalizes field values.

   - `union_data.py`  
     Merges and reconciles data from both Jira and the current Zendesk snapshot:
     - Deduplicates entries.
     - Maintains historical ordering and groupings.
     - Sorts by date and issue type to build a unified changelog dataset.

   - `html_to_dict.py`  
     Parses the raw HTML content from Zendesk (`zendesk_data.html`) into a structured Python dictionary:
     - Uses BeautifulSoup to preserve nested elements.
     - Captures sections, tags, and release dates for comparison.
     - Enables accurate diffing and minimal-overwrite updates.

   - `release_notes_builder.py`  
     Assembles the final HTML release notes using data from `union_data.py` and `html_to_dict.py`:
     - Injects new Jira issues into the correct location in the document.
     - Applies formatting from `template.html` using Jinja2.
     - Outputs a single, complete `release_notes_zendesk.html` file.

4. **Pull Request Generation**  
   If updates are found, a GitHub Actions workflow automatically creates a pull request with the new release notes.

5. **Slack Notification**  
   A Slack message is sent to the **Technical Documentation Team** channel using a Slack app webhook to notify the team that a PR is ready for review.

6. **Publishing to Zendesk**  
   When the pull request is approved and merged to `master`, a second GitHub Actions workflow (`send_to_zd.yml`) is triggered. This job:
   - Converts the updated HTML to JSON via `html_to_json.py`.
   - Sends the content to Zendesk via API, overwriting the previous article content.

## Manual Workflow Options

### Run the Automation Manually

You can trigger the full workflow manually using **Workflow Dispatch**:

1. In GitHub Actions, open the [`ZD_html_to_dict.yml`](https://github.com/takeoff-com/release-notes/blob/master/.github/workflows/ZD_html_to_dict.yml) workflow.
2. Select "Run workflow" and provide any optional inputs.
3. After the PR is merged, publishing will proceed automatically via `send_to_zd.yml`.

### Modify a Previously Published Issue

You can update the description, change the date, or reorder previously published entries.

**To update the description, fix version, or product area:**

1. Open the Jira issue and update the `Release Notes Description` field.
2. The update will be picked up during the next scheduled run.
3. The entry will remain in the same location and date group.

**To manually change the date or location:**

1. Create a branch and update the `release_notes_zendesk.html` file in the `data/` directory.
2. Edit the Zendesk article manually via the HTML view to match the change.
3. Merge the branch into `master`; the changes will be preserved on the next automation run.

### Delete a Previously Published Issue

1. Create a branch and remove the entry (and date heading, if it was the only entry) from `release_notes_zendesk.html`.
2. Update the Zendesk article accordingly via the HTML editor.
3. Merge to `master` to trigger the publishing workflow.
