# The System — Three Flows

A second brain with AI is not a setup. It is a system with three distinct flows.

Without all three flows working together, you end up with organized folders that nobody reads.

---

## Flow 1 — Your Second Brain (where you think)

This is your space. The human's space.

Here you read, process, reflect, and write with your own words. The AI does not author anything here. It can suggest, search, and surface — but the permanent notes are written by you.

**What lives here:**
- Permanent notes (Zettelkasten-style, in your own words)
- Literature notes (your annotations on what you studied)
- Daily notes and fleeting thoughts
- Projects and areas (PARA or your own structure)

**The AI's role in this flow:**
- Search notes you forgot you had
- Suggest missing links between ideas
- Compare new material with what you already know
- Avoid duplicate study by surfacing existing knowledge

**What the AI must never do here:**
- Write your permanent notes for you
- Edit the content of authorial notes
- Replace your thinking process
- Decide the angle or thesis of what you are learning

> "The AI is the librarian. Never the author."

---

## Flow 2 — The AI Workbench (where the AI works)

This is Claude Code's space. A dedicated folder inside your vault.

Here the AI has full autonomy to create, edit, organize, and delete. No permission needed.

Outside this folder, the AI must ask first.

**What lives here:**
- Outputs and deliverables
- Session logs
- AI memory (durable context between sessions)
- Skills and reusable commands
- Specs and project plans
- Decisions and history
- Templates and references
- Briefings and databases

**Folder structure:**

```
_AI/
  Memory/         ← durable context across sessions
  Sessions/       ← what happened in each session
  Outputs/        ← deliverables for human review
  Logs/           ← what the AI did
  Specs/          ← plans and implementation docs
  Decisions/      ← decisions with rationale
  Skills/         ← reusable commands
  Templates/      ← reference templates
  Maintenance/    ← cleanup and review work
  Briefings/      ← context documents for the AI
  Projects/       ← project-level files
  Inbox/          ← unprocessed input
```

**Claude's rule here:**
Full autonomy inside this folder. Ask first for everything outside.

---

## Flow 3 — The Integration (where multiplication happens)

This is where your second brain and the AI workbench connect.

The AI reads your notes to give you better context and output.
You read the AI's outputs to generate new thoughts and decisions.

But the boundary between the two spaces must remain clear.

**How integration works:**
1. You give the AI access to specific notes or areas (explicitly, not permanently)
2. The AI produces output in its workbench
3. You review the output
4. You decide what, if anything, becomes part of your permanent knowledge
5. Your new knowledge feeds back into the next AI session

**What the AI can do with your notes:**
- Read and analyze (with your permission)
- Summarize and extract patterns
- Find connections and gaps
- Suggest what to study next

**What the AI cannot do:**
- Write directly into your permanent notes
- Decide what becomes part of your knowledge
- Replace the process of you actually thinking about the material

---

## The Feedback Loop

```
INPUT
  ↓
Your Second Brain (you think, you write)
  ↓
Integration Layer (AI reads your notes, produces output)
  ↓
AI Workbench (AI works, stores results)
  ↓
OUTPUT (you review, you decide)
  ↓
FEEDBACK → back to Your Second Brain
```

If any part of this loop is broken, you do not have a system. You have a folder.

---

## The Maintenance Problem

Every system needs maintenance.

The AI workbench will accumulate outputs, logs, and memory over time. More files does not mean more intelligence. Unmaintained files become noise that degrades output quality.

See `docs/maintenance.md` for the maintenance workflow.

---

## Common Mistakes

**Mistake 1: Giving the AI full vault access**
Result: too much context, worse outputs, broken boundaries.

**Mistake 2: Keeping a separate vault for the AI**
Result: the AI loses connection to your real knowledge; "schizophrenic" behavior between two vaults.

**Mistake 3: Letting the AI write your permanent notes**
Result: a second brain that is not yours. Notes you do not understand or trust.

**Mistake 4: Treating setup as the system**
Result: beautiful folder structure that generates no value.

**The right approach:**
One vault. One dedicated AI folder inside it. Clear boundary. You think in your space. The AI works in its space. They connect with explicit permission and clear handoffs.
