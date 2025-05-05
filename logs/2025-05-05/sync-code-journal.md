# Sync Code-Journal Logs Workflow

This GitHub Actions workflow automatically syncs the contents of the `.code-journal/logs/` directory from any repository into a central `code-journal` repository on each push.

## 1. Create a Personal Access Token

1. In GitHub, go to **Settings → Developer settings → Personal access tokens**.  
2. Generate a token with the **repo** scope.  
3. In each project repository, add a secret named `CODE_JOURNAL_PAT` under **Settings → Secrets → Actions**, with the token value.

> Tip: If using an organization, store the token once as an organization secret.

## 2. Add the Workflow

Create `.github/workflows/sync-code-journal.yml` with:

```yaml
name: 📓 Sync Code-Journal Logs

on:
  push:
    paths:
      - '.code-journal/**'

jobs:
  sync-logs:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout this repo
        uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Checkout code-journal repo
        uses: actions/checkout@v3
        with:
          repository: ${{ github.repository_owner }}/code-journal
          path: code-journal
          token: ${{ secrets.CODE_JOURNAL_PAT }}
          ref: main

      - name: Sync logs
        run: |
          rsync -av --update .code-journal/logs/ code-journal/logs/

      - name: Commit & push changes
        run: |
          cd code-journal
          git config user.name  "${{ github.actor }}"
          git config user.email "${{ github.actor }}@users.noreply.github.com"
          git add logs
          if [ -n "$(git status --porcelain)" ]; then
            git commit -m "Sync from ${{ github.repository }} @ ${{ github.sha }}"
            git push origin main
          else
            echo "✅ No new journal entries to sync."
          fi
```

### Notes

- `rsync --update` ensures only newer files overwrite.  
- Adjust `ref: main` & branch if needed.  
- Narrow `paths:` under `on.push` to optimize runs.

## 3. Verify

1. Commit a new file under `.code-journal/logs/YYYY-MM-DD/`.  
2. Observe the Actions run in your repo.  
3. Confirm the new log appears in the central `code-journal` repo.

---

Now, every push with journal updates will sync automatically!
