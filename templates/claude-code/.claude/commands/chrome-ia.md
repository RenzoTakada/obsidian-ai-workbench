# /chrome-ia

Start Google Chrome with remote debugging enabled on port 9222, using a dedicated persistent profile (`~/.chrome-debug-profile`) that preserves sessions between uses.

Important: Chrome 148+ blocks debugging when `--user-data-dir` points to the default profile. Use `~/.chrome-debug-profile` instead: a separate but persistent profile. The user logs in once and sessions remain available for future sessions.

Use this to open Chrome before an investigation session. After the user logs in once, Claude can connect through `/chrome-dev-browser`.

---

## Steps

1. Check whether Chrome is already running with debug on port 9222:

   ```bash
   curl -s http://127.0.0.1:9222/json/version
   ```

   - If it responds, report that Chrome is already active with debug. Do not restart it.
   - If it does not respond, continue to step 2.

2. Check whether Chrome is running without debug:

   ```bash
   pgrep -f "Google Chrome" | head -1
   ```

   - If a process exists, close it with `pkill -f "Google Chrome" 2>/dev/null; sleep 1`, then continue.
   - If no process exists, continue to step 3.

3. Create the debug profile directory if needed and open Chrome:

   ```bash
   mkdir -p "$HOME/.chrome-debug-profile"
   nohup "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
     --remote-debugging-port=9222 \
     --remote-allow-origins="*" \
     --no-first-run \
     --no-default-browser-check \
     --user-data-dir="$HOME/.chrome-debug-profile" \
     > /tmp/chrome-debug.log 2>&1 &
   ```

4. Wait 6 seconds and confirm that the port responds:

   ```bash
   sleep 6 && curl -s http://127.0.0.1:9222/json/version
   ```

   - If it fails, show the log with `cat /tmp/chrome-debug.log | head -20`.

5. Connect and list open tabs:

   ```js
   dev-browser --connect http://127.0.0.1:9222 <<'EOF'
   const tabs = await browser.listPages();
   console.log(JSON.stringify(tabs, null, 2));
   EOF
   ```

6. Return confirmation with:

   - Number of open tabs.
   - If this is the first time: "New debug profile. Log in to the sites you need. Sessions will be saved in `~/.chrome-debug-profile` for future use."
   - If sessions already exist: "Chrome is ready with saved sessions. Use `/chrome-dev-browser [instruction]` when you want me to access something."

---

Do not close Chrome when finished. It should remain open for use with `/chrome-dev-browser`.

Never run `pkill` after Chrome is already running with debug enabled. Only close Chrome when needed before reopening it with debug.
