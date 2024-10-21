---
title: Auto-Create Common Release Versions in Jira
description: How to use Jira Automation to create and assign a common release version to multiple projects. 
weight: 3
---

![Alt text](/images/ship/ships.png)

## Introduction

In Jira Cloud, release versions are project-specific, meaning shared versions across multiple projects aren't supported by default. However, by leveraging Jira’s built-in automation features and custom fields, you can create a solution that automatically generates and assigns synchronized release versions across several projects. This guide outlines how to set up such automation to manage release versions (e.g., Release Train versions) on a biweekly schedule, keeping multiple Jira projects in sync.

## Use Case Example

Imagine a scenario where your company conducts regular deployments for a suite of software services. The development teams responsible for these services each use a different Jira project. By automating the creation of common release versions, you gain visibility into which tickets across various projects are associated with a particular deployment. This automation ensures consistent versioning across projects and streamlines release management.

## Solution Overview

To achieve this, we will create a Jira automation rule that runs on a biweekly schedule and uses custom fields to create and manage the next release version (RT version) across multiple projects.

### Components of the Automation Rule

1. **Trigger:**
   - The rule runs on a biweekly schedule every Wednesday at noon (12:00 PM) Eastern Time.
   - It checks for issues updated within a specified timeframe, ensuring it processes only relevant tickets.

2. **Conditions and Actions:**
   - **Initial Check:** The rule uses a regular expression to check if the current week is an even-numbered week.
   - **Issue Selection:** It identifies a specific issue (e.g., `DF-12345`) and retrieves the current release version from its `fixVersions` field.
   - **Set Variable:** The current release version is stored in a variable called `lastRelVersion`, which is then logged for tracking purposes.

3. **Release and Version Management:**
   - **Release Across Projects:** The `lastRelVersion` is released across multiple projects by their project IDs, ensuring synchronization.
   - **Next Release Version:** The rule automatically creates the next release version using a specific naming format. Here's how it works:

### Smart Values in Next Release Version Naming Format

The next release version is generated with a consistent, predictable format using Jira's **smart values**, which allow for dynamic date and time calculations. The format is as follows:

```
{{now.plusWeeks(2).weekOfYearIso}}-{{now.plusWeeks(2).format('yy')}}:[{{now.plusDays(14).format('yy-MM-dd')}}]
```

- **now.plusWeeks(2)**: This adds two weeks to the current date, ensuring the next release aligns with a biweekly cadence.
- **weekOfYearIso**: This smart value returns the week number according to the ISO calendar. For example, if today is in week 41 of the year, `weekOfYearIso` returns `43`, giving the week of the next release.
- **format('yy')**: This formats the year as a two-digit value (e.g., `24` for the year 2024). 
- **now.plusDays(14)**: This adds 14 days (two weeks) to the current date and formats it as `yy-MM-dd`, giving the exact release date.

For example, if today is October 11, 2024 (week 41), the rule generates a version name like:

```
43-24:[24-10-25]
```

This indicates the release occurs in the 43rd week of 2024, and the release date is October 25, 2024.

4. **Updating Issues:**
   - **Set Fix Versions:** The new release version is applied to the `fixVersions` field of the targeted issue (`DF-12345`), preparing it for the next release.
   - **Create Variable for New Version:** The new release version is stored in a variable (`nextversion`) and logged for reference.

5. **Version Synchronization Across Projects:**
   - **Log and Apply Version:** The new release version is created across all relevant projects using their project IDs, ensuring consistent versioning.

## Summary

This Jira automation rule simplifies the process of managing release versions across multiple projects. By running on a biweekly schedule, it automatically sets the next release version, updates related issues, and ensures all projects are using the correct version numbers. This ensures synchronized versioning, improves visibility, and eliminates manual effort.

## Key Benefits
- **Automation of repetitive tasks:** Ensures consistent version management with minimal manual effort.
- **Improved visibility:** Helps track tickets related to a release across multiple projects.
- **Consistency across projects:** Guarantees that all teams are using the same release versions, streamlining deployments across the organization.
