---
name: pr-check
description: Run full lint and test suite across all sub-projects and report failures
---

# PR Check

Run full lint and test suite across all sub-projects. Report failures clearly.

Run the following commands sequentially from the repo root:

```bash
echo "=== Backend lint ===" && cd backend && make lint
echo "=== Backend tests ===" && make test
echo "=== UI lint ===" && cd ../ui && npm run lint:all
echo "=== UI tests ===" && npm run test:unit
echo "=== Care-UI lint ===" && cd ../care-ui && npm run lint:all
echo "=== Care-UI tests ===" && npm run test:unit
```

If a step fails, report the failure and continue with remaining steps. Summarize results at the end: which passed ✅ and which failed ❌.
