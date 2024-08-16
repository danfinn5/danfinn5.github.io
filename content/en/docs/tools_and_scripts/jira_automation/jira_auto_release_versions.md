---
title: Common Release Versions
description: Jira does not support cross-project release versions. This set of automation rules can be used to effectively create versions, identifiy tickets in a release, and apply the appropriate version as soon as code as merged to a given set of repositories.
weight: 1
---

This section describes a series of Jira Automation Rules that can be used to set common release versions across multiple Jira Projects.

### Problem Statement: 
In Jira Cloud, each project has unique **Release** versions. There is no concept of a "shared" version across multiple projects. 

However, you can use Jira's Automation features along with some custom fields and a designated ticket to automatically create and assign common releases across multiple projects. 

### Example
You might need this if your company performs regular deployments of a group of software services, and the development teams that support those services each use different Jira projects. This provides you with visibility into which tickets across multiple Jira projects are associated with a given deployment.

### Overview

Implementing this solution involves several rules and custom fields. 

This Jira automation rule is designed to automatically manage and set the next RT (Release Train) version for multiple projects on a biweekly schedule. Here's a breakdown of its main components and actions:

**Trigger**: The rule is scheduled to run biweekly every Wednesday at noon (12:00 PM) Eastern Time. It checks for issues updated within the specified timeframe.

#### Conditions and Actions:

**Initial Check**: It first checks if the current week of the year is an even week using a regular expression condition.

**Issue Selection**: It specifically targets the issue with a specific issue key (e.g., DF-12345).

**Set Variable**: It creates a variable LastRTVersion with the value of the fixVersions field from the targeted issue.
Log and Release: It logs the LastRTVersion value and releases it across multiple projects (by project ID).

#### Subsequent Actions:

**Next Release Version**: The rule creates a new version for the next release version in a specific format: 'release version {{now.plusWeeks(2).weekOfYearIso.format}}-{{now.plusWeeks(2).format("yy")}}:[{{now.plusDays(14).format("yy-MM-dd")}}]'.

**Update Release Version**: this sets the fix versions field in Jira of the issue DF-12345 to this newly created version.

**Create Variable**: A new variable `nextversion` is created with the new fixVersions value.

**Log and Create Versions**: It logs `nextversion` and creates this version across the same set of projects mentioned earlier.
Projects: The rule applies to multiple projects identified by their Project ID Numbers.

In summary, this rule automates the process of setting and releasing new RT versions every two weeks, ensuring that the versioning across different projects is synchronized and up-to-date.