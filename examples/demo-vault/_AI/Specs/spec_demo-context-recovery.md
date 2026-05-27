# Feature Spec — Demo Context Recovery

Date: 2026-05-27
Status: draft

## Context

The demo vault has memory, hot context, command prompts, and a session note.

## Problem

New users need to see that Claude can recover context in a new session.

## Goal

Show a short flow where Claude loads memory and summarizes active context after `/brain`.

## Non-goals

- Full RAG implementation
- Automatic modification of human notes

## Proposed approach

Use `Memory/MEMORY.md` as the durable index and `Memory/hot.md` as short-lived context.

## Validation plan

- Start a new Claude Code session.
- Run `/brain`.
- Confirm the response mentions active focus, recent decisions, blocker, and next actions.
