---
title: Auto-Create Common Release Versions in Jira
description: How to use Jira Automation to create and assign a common release version to multiple projects. 
weight: 3
---

![Release ships header image](/images/ship/ships.png)

## Introduction
In Jira Cloud, release versions are project-specific, meaning shared versions across multiple projects are not supported. For product and engineering teams, this can be a challenge. For instance, if you need to track and manage a common release version across multiple projects, your teams are forced to manually create and manage each project's release version, which can be time-consuming and prone to errors.

By leveraging Jira’s built-in automation features, custom fields, and placeholder tickets, you can automate the process of generating release versions across multiple projects. By running on a biweekly schedule, it automatically sets the next release version, updates related issues, and ensures all projects are using identical versions. This ensures synchronized versioning, improves visibility, and eliminates manual effort.

### Key Benefits
- **Automation of repetitive tasks:** Ensures consistent version management with minimal manual effort.
- **Improved visibility:** Helps track tickets related to a release across multiple projects.
- **Consistency across projects:** Guarantees that all teams are using the same release versions, streamlining release visibility across the organization.

## Prerequisites
- Jira Admin or project permissions sufficient to run multi-project Automation and manage Versions.
- Two custom text fields (single-line) on a placeholder issue in the anchor project:
  - **Next Release Version**
  - **Previous Release Version**
- A designated placeholder issue in the anchor project, for example **TEAM-9999**.
- A list of target projects to keep in sync (for example: **PROJA**, **PROJB**, **PROJC**).

## Use Case Example
Imagine a scenario where your company conducts regular deployments for a suite of software services. The development teams responsible for these services each use a different Jira project. By automating the creation of common release versions, you gain visibility into all tickets across each project that are associated with a particular deployment. This automation ensures consistent versioning and streamlines release management.

## Version Naming Format (Smart Values)
Use a biweekly cadence and compute the next version string:

```
{{now.plusWeeks(2).weekOfYearIso}}-{{now.plusWeeks(2).format("yy")}}:[{{now.plusDays(14).format("yy-MM-dd")}}]
```

Example: `43-24:[24-10-25]`

## Two-Rule Design
- **Rule 1: Stage Next Release (Anchor Project)**  
  Computes the upcoming version name, stores it on **TEAM-9999**, and creates that version in the anchor project.
- **Rule 2: Propagate & Release (All Target Projects)**  
  When **TEAM-9999** is updated, releases the previous version across all projects and creates the next version across all projects.

---

## Rule 1 — Stage Next Release (Anchor Project)

**Goal:** After the current release version is created, set the next release version string on the placeholder issue and ensure that version exists in the anchor project.

1. **Trigger**  
   - **Scheduled** → every 2 weeks (e.g., Wednesday 12:00 America/New_York).

2. **Condition — Even-week guard (keep this)**  
   - **Advanced compare**  
     - **First value:** `{{now.weekOfYearIso}}`  
     - **Condition:** `matches`  
     - **Second value:** `/\d*[02468]$/`  
   - This allows the rule to proceed only on even ISO week numbers.

3. **Lookup Issue**  
   - JQL: `key = TEAM-9999`

4. **Create Variable — `previous`**  
   - Value: `{{issue.fields."Next Release Version"}}`

5. **Create Variable — `next`**  
   - Value:  
     `{{now.plusWeeks(2).weekOfYearIso}}-{{now.plusWeeks(2).format("yy")}}:[{{now.plusDays(14).format("yy-MM-dd")}}]`

6. **Edit Issue (TEAM-9999)**  
   - Set **Previous Release Version** = `{{previous}}`  
   - Set **Next Release Version** = `{{next}}`

7. **Create Version (Anchor Project only)**  
   - **Project:** TEAM  
   - **Version name:** `{{next}}`  
   - **Release date:** `{{now.plusDays(14).format("yyyy-MM-dd")}}`  
   - Allow duplicates to be ignored (Automation will no-op if it already exists).

8. **(Optional) Edit Issue Fix Versions (TEAM-9999)**  
   - Set **Fix versions** = `{{next}}` (helps searching and auditing).

---

## Rule 2 — Propagate & Release (All Target Projects)

**Goal:** When the placeholder is updated, release the previous version everywhere and create the next version everywhere.

1. **Trigger**  
   - **Issue Updated**  
   - **Field changed:** **Next Release Version**  
   - **Condition:** Issue key equals **TEAM-9999**

2. **Create Variables**  
   - `prev = {{issue.fields."Previous Release Version"}}`  
   - `next = {{issue.fields."Next Release Version"}}`

3. **Guard — Only release if `prev` present**  
   - **Condition (Advanced compare):** `{{prev}}` **does not equal** _empty_  
   - If empty (first run), skip the release steps.

4. **Release Previous Version across all projects**  
   - **Action:** Release version → **Project:** TEAM → **Version:** `{{prev}}` → **Release date:** `{{now.format("yyyy-MM-dd")}}`  
   - Repeat the **Release version** action for each target project (e.g., PROJA, PROJB, PROJC) by changing only the **Project**.

5. **Create Next Version across all projects**  
   - **Action:** Create version → **Project:** TEAM → **Version name:** `{{next}}` → **Release date:** `{{now.plusDays(14).format("yyyy-MM-dd")}}`  
   - Repeat the **Create version** action for each target project (e.g., PROJA, PROJB, PROJC) by changing only the **Project**.  
   - These actions are idempotent if you allow duplicates to be ignored.

6. **(Optional) Set Fix Versions on per-project wrapper issues**  
   - If you maintain one “release wrapper” issue per project, add an **Edit issue** action per project to set **Fix versions** = `{{next}}` using a simple JQL (e.g., `project = PROJA AND "Release Wrapper" = true ORDER BY updated DESC` and limit to the first result).

---

## Validation
- In each project’s **Releases** page:
  - `prev` appears as **Released** with the correct date.
  - `next` appears as **Unreleased** with the expected date.
- The audit log for Rule 1 shows the staged values; Rule 2 shows the per-project release/create actions.

## Notes
- Keep the list of target projects in one place (Rule 2) so updates are simple.
- Ensure the rule actor has permission to **Manage Versions** in all target projects.
- Set each rule’s timezone to **America/New_York** if your cadence depends on local time.