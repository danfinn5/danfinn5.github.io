---
title: Auto-Create Common Release Versions in Jira
description: How to use Jira automation to create and assign a common release version to multiple projects. 
weight: 3
---

![Release ships header image](/images/ship/ships.png)

## Introduction
In Jira Cloud, release versions are project-specific, meaning shared versions across multiple projects are not supported. For product and engineering teams, this can be a challenge. For instance, if you need to track and manage a common release version across multiple projects, your teams are forced to manually create and manage each project's release version, which can be time-consuming and prone to errors.

By leveraging Jira’s built-in automation features, custom fields, and placeholder tickets, you can automate the process of generating release versions across multiple projects. By running on a biweekly schedule, the automation automatically sets the next release version, updates related issues, and ensures all projects are using identical versions. This ensures synchronized versioning, improves visibility, and eliminates manual effort.

### Key Benefits
- **Automation of repetitive tasks:** Ensures consistent version management with minimal manual effort.
- **Improved visibility:** Helps track tickets related to a release across multiple projects.
- **Consistency across projects:** Guarantees that all teams are using the same release versions, streamlining release visibility across the organization.

## Prerequisites
Prior to following this guide, please ensure you have:
- Jira admin or another level of permissions sufficient to create multi-project automation rules.
- A custom text field (single-line) on a placeholder issue in an anchor project:
  - **Next Release Version**
- A designated placeholder issue in the anchor project, for example **PROJA-9999**.
- A list of target project keys to keep in sync (for example: **PROJA**, **PROJB**, **PROJC**).

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
  Computes the upcoming version name, stores it on **PROJA-9999**, and creates that version in the anchor project.
- **Rule 2: Propagate & Release (All Target Projects)**  
  When **PROJA-9999** is updated, releases the previous version across all projects and creates the next version across all projects.

---

## Rule 1 — Stage Next Release (Anchor Project)

**Goal:** On a biweekly cadence, compute the *next* version string, store it on `PROJA-9999`, and ensure that version exists in the anchor project.

1. **Trigger**  
   - **Scheduled** → every 2 weeks (e.g., Wednesday 12:00 America/New_York).

2. **Condition — Even-week guard**  
   - **Advanced compare**  
     - **First value:** `{{now.weekOfYearIso}}`  
     - **Condition:** `matches`  
     - **Second value:** `/\d*[02468]$/`  *(runs only on even ISO week numbers)*

3. **Lookup issues**  
   - JQL: `key = PROJA-9999`

4. **Create variable — `next`**  
   - Value:  
     `{{now.plusWeeks(2).weekOfYearIso}}-{{now.plusWeeks(2).format("yy")}}:[{{now.plusDays(14).format("yy-MM-dd")}}]`

5. **Edit issue (PROJA-9999)**  
   - Set **Next Release Version** = `{{next}}`

6. **Create version (anchor only)**  
   - **Project:** PROJA  
   - **Version name:** `{{next}}`  
   - **Release date:** `{{now.plusDays(14).format("yyyy-MM-dd")}}`  

7. **(Optional) Edit Fix versions on PROJA-9999**  
   - **Fix versions** = `{{next}}`

---

## Rule 2 — Propagate & Release (All Target Projects)

**Goal:** When the placeholder updates, **release the previous cycle’s version** in all projects and **create the next version** in all projects—without storing a “previous” field.

1. **Trigger**  
   - **Issue updated**  
   - **Field changed:** **Next Release Version**  
   - **Condition:** Issue key = `PROJA-9999`

2. **Create variables**  
   - `next = {{issue.fields."Next Release Version"}}`  
   - `prev = {{now.minusWeeks(2).weekOfYearIso}}-{{now.minusWeeks(2).format("yy")}}:[{{now.minusDays(14).format("yy-MM-dd")}}]`  

3. **Release previous version across projects**   
   - **Release version:** Project **PROJA**, Version `{{prev}}`, Release date `{{now.format("yyyy-MM-dd")}}`  
   - **Release version:** Project **PROJB**, Version `{{prev}}`, Release date `{{now.format("yyyy-MM-dd")}}`  
   - **Release version:** Project **PROJC**, Version `{{prev}}`, Release date `{{now.format("yyyy-MM-dd")}}`  

4. **Create next version across projects**  
   - **Create version:** Project **PROJA**, Version `{{next}}`
   - **Create version:** Project **PROJB**, Version `{{next}}`  
   - **Create version:** Project **PROJC**, Version `{{next}}`
   
---

## Validation
- Each project’s **Releases** page shows:
  - `prev` as **Released** with today’s date (if present).
  - `next` as **Unreleased** with the expected future date.
- Automation **Audit log** reflects the per-project release/create actions.

## Notes
- Keep the target project list centralized in Rule 2 for easy edits.
- Timezone: set both rules to **America/New_York** to align with your cadence.