# Code-Journal Sync Workflow Recap

## Directory Structure
- **Individual Repositories**
  - `.code-journal/`
    - `logs/`
      - `YYYY-MM-DD/`
        - `*.md` (daily notes)
- **Central `code-journal` Repository**
  - `logs/`
    - `YYYY-MM-DD/`
      - `*.md` (merged notes from all projects)

## Trigger
- **Event**: `push` to any individual repo
- **Path Filter**: `.code-journal/**`

## Workflow Steps
1. **Checkout Current Repo**
   - Use `actions/checkout@v3` to fetch the full history of the repo containing the new logs.
2. **Checkout Central Repo**
   - Use `actions/checkout@v3` with `repository: ${{ github.repository_owner }}/code-journal` and `token: ${{ secrets.CODE_JOURNAL_PAT }}`.
3. **Sync Files**
   - Run:
     ```bash
     rsync -av --update .code-journal/logs/ code-journal/logs/
     ```
   - Copies only newer or new files from the individual repo to the central repo.
4. **Commit & Push**
   - In `code-journal` directory:
     ```bash
     git config user.name  "${{ github.actor }}"
     git config user.email "${{ github.actor }}@users.noreply.github.com"
     git add logs
     if [ -n "$(git status --porcelain)" ]; then
       git commit -m "Sync from ${{ github.repository }} @ ${{ github.sha }}"
       git push origin main
     fi
     ```
   - Only pushes if there are changes.

## Data Flow
```
Individual Repo A (.code-journal/logs/)  ──┐
                                         ├─► rsync ──► Central repo logs/
Individual Repo B (.code-journal/logs/)  ──┘
```

## One-Way Sync
- Changes flow **from** each individual repo **into** the central repo.
- Central repo edits **do not** propagate back to individual repos.

## Notes
- **rsync `--update`**: prevents older files from overwriting newer ones.
- Adjust branch names (`main` vs `master`) as needed.
- Ensure `CODE_JOURNAL_PAT` secret is set in each individual repo.

