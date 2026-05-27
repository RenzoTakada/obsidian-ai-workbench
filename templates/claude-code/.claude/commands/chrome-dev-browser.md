# /chrome-dev-browser

Connect to the Chrome instance opened by `/chrome-ia` and run an investigation or task through DOM/HTML without relying on screenshots.

Use this to read private pages, extract merge request diffs, search table data, navigate authenticated flows, and investigate internal environments.

Prerequisite: Chrome was started with `/chrome-ia` and the user is already logged in where needed.

---

## Steps

1. Check whether Chrome is accessible:

   ```bash
   curl -s http://127.0.0.1:9222/json/version
   ```

   - If it does not respond, tell the user to run `/chrome-ia` first.

2. List open tabs to understand the current context:

   ```js
   dev-browser --connect http://127.0.0.1:9222 <<'EOF'
   const tabs = await browser.listPages();
   console.log(JSON.stringify(tabs, null, 2));
   EOF
   ```

3. Execute the task passed as the argument. Use this strategy by task type:

   **Page reading / data extraction:**

   - Use `page.snapshotForAI()` to get the complete structure as text, including accessibility and content.
   - It returns `{ full, incremental? }`; read `result.full` to map elements and content.
   - Prefer snapshot over screenshot for any text or data task.

   **Navigation:**

   - Use `await page.goto(url, { waitUntil: "domcontentloaded" })` for normal pages.
   - Use `waitUntil: "load"` only when external resources must finish loading.

   **Interaction:**

   - After snapshot, use `page.getByRole()` to interact with elements by semantic role.
   - Example: `await page.getByRole("button", { name: "Approve" }).click()`.

   **Merge request diff extraction:**

   - Navigate to the MR Changes tab.
   - Extract text with `page.innerHTML(".diff-content")` or a snapshot of the diff area.
   - Save to a temp file only when needed.

   **Screenshot:**

   - Use screenshots only when visual layout matters.
   - Example:

     ```js
     const buf = await page.screenshot();
     const path = await saveScreenshot(buf, "name.png");
     ```

4. Process extracted data directly in the response when possible.

5. Report the result to the user and wait for the next instruction. Keep the connection open and do not close named pages.

---

## Notes

- Named pages (`browser.getPage("name")`) persist between executions while the daemon is running. Use descriptive names such as `"gitlab"`, `"dynatrace"`, or `"backoffice"`.
- Inside `page.evaluate()`, use plain JavaScript only.
- If a script fails, reconnect to the same named page and take a screenshot for diagnosis.
- Do not close Chrome, do not stop the daemon, and do not take destructive actions without confirmation.
