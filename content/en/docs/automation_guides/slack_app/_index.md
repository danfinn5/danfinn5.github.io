---
title: Auto-Create Slack Channels from Jira tickets
hasMermaid: "true"
description: Integrate Jira and Slack to auto-create and populate Slack channels with data from Jira tickets. 
weight: 2
---

![Slack power plug graphic header image](/images/slack/hq720.jpg)

<!-- ## Table of Contents
1. [Example Use Case](#example-use-case)
2. [Overview](#overview)
3. [Jira Automation Rules](#jira-automation-rules)
   - [Rule 1: Slack Channel Creation](#rule-1-slack-channel-creation)
   - [Rule 2: Slack Channel Updates](#rule-2-slack-channel-updates)
   - [Rule 3: Slack Channel Archive](#rule-3-slack-channel-archive)
4. [Diagram](#diagram)
5. [Prerequisites](#prerequisites)
6. [Steps](#steps)
   - [Step 1: Create the Slack App](#step-1-create-the-slack-app)
   - [Step 2: Create Jira Automation Rules](#step-2-create-jira-automation-rules)
   - [Step 3: Customize the Rules](#step-3-customize-the-rules) -->

## Use Case
For this Jira and Slack App integration, consider a scenario in which your organization performs regular deployments of microservices, and each development team uses different Jira projects. Each deployment must have a dedicated Slack channel assocaited with it that references the deployment ticket, as well as key details of the ticket and deployment. This automation streamlines the process of creating each Slack channel, populating detals about the ticket, and even automatically updating the channel if the ticket changes.

## Prerequisites
To complete this guide, please ensure you have:
- **Jira Administrator permissions** to create automation rules.
- A **Slack account** with permissionsto create a Slack App.
- Familiarity with [Jira Automation](https://support.atlassian.com/cloud-automation/docs/jira-cloud-automation/) and basic [REST API](https://aws.amazon.com/what-is/api/) concepts.

## Overview
To implement this solution, you'll need to:
1. Create a Slack App to receive data from Jira.
2. Set up at least three Jira Automation rules:
   - Create a Slack channel when a Jira ticket is updated with specific data.
   - Update the Slack channel when details in the Jira ticket change.
   - Archive the Slack channel when the Jira ticket is marked as complete.

## Jira Automation Rules

### Rule 1: Slack Channel Creation
- **Trigger**: When a custom field in Jira is set.
- **Actions**:
  - Check if required fields (e.g., summary, priority, client) are filled.
  - If fields are incomplete, revert the trigger and notify the user.
  - Once fields are filled, send a request to the Slack API to create a new channel with details from the Jira ticket.
  - Save the Slack channel ID and timestamp back into the Jira ticket.

### Rule 2: Slack Channel Updates
- **Trigger**: When fields in the Jira ticket (e.g., summary, due date) are updated.
- **Actions**:
  - Verify if a Slack channel ID exists in the Jira ticket.
  - Send updated details to the Slack API to update the channel’s name and information.
  - Save the updated timestamp in the Jira ticket.

### Rule 3: Slack Channel Archive
- **Trigger**: When a Jira ticket status moves to "Done" or on a predefined schedule.
- **Actions**:
  - Retrieve the Slack channel ID from the Jira ticket.
  - Send a request to the Slack API to archive the channel.
  - Log the Slack response for future reference.

## Channel Creation Flow Diagram

```mermaid
flowchart TD
  Jira_Ticket_Trigger --> Check_Fields
  Check_Fields --> Send_To_Slack --> Create_Channel --> Save_Data_To_Jira
  Channel_Fields_Change --> Update_Fields --> Send_Update_To_Slack --> Update_Channel
  Jira_Ticket_Completed --> Archive_Channel --> Log_Response
```

## Steps

### Step 1: Create the Slack App
1. Go to the [Slack API](https://api.slack.com/apps) dashboard and click "Create New App."
2. Follow the instructions to create a new app and give it the necessary permissions to handle incoming requests from Jira.
3. Under the "OAuth & Permissions" section, configure the following permissions:
   - `channels:manage` - To create, update, and archive channels.
   - `chat:write` - To post messages to the channel.
   - `channels:read` - To read channel information.
4. Generate OAuth tokens that will be used in your Jira Automation rules.

### Step 2: Create Jira Automation Rules
1. In your Jira project, navigate to **Project Settings** > **Automation**.
2. Click on "Create Rule" and configure Rule 1: Slack Channel Creation:
   - Set the trigger as a field update (e.g., a custom field like "Create Slack Channel").
   - Add a condition to check if required fields (e.g., summary, priority) are filled.
   - Set up an action to send a request to the Slack API to create the channel.
   - Store the Slack channel ID and timestamp in Jira.
   
3. Create Rule 2: Slack Channel Updates:
   - Trigger the rule when certain fields (e.g., summary, priority) are updated.
   - Send an update request to the Slack API with the new information.

4. Create Rule 3: Slack Channel Archive:
   - Trigger the rule when the Jira ticket is marked as "Done" or on a scheduled basis.
   - Send a request to Slack to archive the channel.

### Step 3: Customize the Rules
1. If you have specific requirements (e.g., prevent auto-creation when cloning tickets or push updates to write-protected fields), you can add additional rules or conditions.
2. Test your automation by creating a test Jira ticket and ensuring the correct Slack channels are created, updated, and archived as expected.
