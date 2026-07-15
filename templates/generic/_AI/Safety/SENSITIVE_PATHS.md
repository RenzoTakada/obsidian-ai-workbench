# Sensitive Paths — Do Not Access Without Explicit Authorization

~/.ssh/     ~/.gnupg/    ~/.aws/      ~/.config/
~/.kube/    ~/.docker/   ~/.npmrc     ~/.netrc
**/.env     **/.env.*    **/secrets.* **/credentials.*
~/Downloads/ ~/Desktop/  ~/Library/   /etc/  /private/
.git/       ~/.gitconfig

Also: any directory outside the vault, corporate projects, client repos.

If sensitive data is found in memory:
1. Do not copy, display, or transmit it
2. Notify the user immediately
3. Propose removal in Outputs/ — wait for confirmation
