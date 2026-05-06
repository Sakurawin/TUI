# TUI Candidates Tracker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a Chinese benchmark-candidate tracker file for future TUI project evaluation.

**Architecture:** This change is documentation-only. Create one shared markdown file under `benchmarks/` with a short usage guide, status definitions, evaluation fields, and a reusable entry template.

**Tech Stack:** Markdown documentation

---

### Task 1: Add the Candidate Tracker File

**Files:**
- Create: `benchmarks/tui-candidates.md`

- [ ] **Step 1: Write the tracker header and usage notes**

Add a short Chinese introduction that explains the file is for managing non-`wego` TUI benchmark candidates.

- [ ] **Step 2: Add status definitions**

List the allowed statuses so future entries stay consistent.

- [ ] **Step 3: Add the reusable candidate template**

Write one Chinese markdown template section containing all required comparison fields.

- [ ] **Step 4: Add one starter example entry**

Include `wego` as a reference example so the intended level of detail is clear.

- [ ] **Step 5: Verify the new file exists and reads cleanly**

Run: `test -f benchmarks/tui-candidates.md`
Expected: exit code 0
