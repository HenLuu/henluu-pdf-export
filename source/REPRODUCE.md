# Reproduce the tested bundle

## Pinned upstream

`UPSTREAM_SOURCE.md` locks the source to ShrekBytes Advanced PDF Export tag `4.7.7`, commit `3faf4baf56c7ba582290469cc475a385b6bc2ec9`. The clean `upstream/` archive includes the TypeScript source, package lockfile and `esbuild.config.mjs`. Upstream’s build entry point is `src/main.ts`; `npm run build` runs TypeScript checking and creates the production `main.js` bundle.

The final tested revision was made by directly editing a candidate copy of the generated `main.js`. The full tested bundle is `../plugin/main.js`. The exact changes relative to the pinned upstream bundle are in `patches/main.js.patch`. `patches/manifest.json.patch` changes the plugin identity and description and adds the tested local revision. `styles.css` is unchanged.

## Deterministic package reconstruction

From a clean copy of the candidate, run `source/rebuild.sh source/upstream <empty-output-directory>`. The script checks the locked source record and the SHA-256 of upstream `main.js`, `styles.css`, `manifest.json`, and `LICENSE`; it then copies the upstream bundle assets, applies both patches, and verifies all four output hashes. It requires no `.git` metadata, network access, npm install, vault, settings, or course files. Compare the output files with `plugin/` before using the candidate.

This procedure reconstructs the tested release assets from the upstream published bundle plus the exact local bundle patch. It is not a byte-identical rebuild of the upstream bundle from TypeScript. For review packaging, the four files are placed under `jiawei-pdf-export/` in the single `jiawei-pdf-export-4.7.7.zip` asset.

## Prepare and review a future code change

1. Copy `plugin/main.js` to an isolated scratch directory; never edit the candidate or installed copy in place.
2. Use a one-off exact-match replacement against the scratch file. Require the old anchor to occur exactly once; abort on zero or multiple matches. Save the edited scratch bundle.
3. Run `node --check <scratch-main.js>` and a focused behavior check for the changed non-UI helper or setting. The detector smoke test in this task used a temporary comment edit at the `detectLessonGuide` anchor, then exercised the existing helper without starting Obsidian or producing a PDF.
4. Create a fresh release candidate from the current repository. In that copy, regenerate the bundle patch with stable labels using `diff -u -L a/main.js source/upstream/main.js -L b/main.js <scratch-main.js> > source/patches/main.js.patch`. For this command, exit status 1 indicates differences and a status above 1 indicates an error. Regenerate the manifest patch only if that file intentionally changes.
5. Review the full diff. Once approved, copy the edited scratch file into the new candidate's `plugin/main.js` and place any approved manifest change in `plugin/manifest.json`. Update the matching output hashes in `source/rebuild.sh` from those files. Keep the upstream input hashes and provenance fixed unless the upstream tag and commit are deliberately upgraded.
6. Run `source/rebuild.sh source/upstream <empty-output-directory>` in the new candidate. Use `cmp` to compare each rebuilt asset with its counterpart under `plugin/`. Run the relevant rendering and runtime checks in an isolated test vault before updating an installation or uploading the package.

The patch is the source-level change record for this direct-bundle fork. A future maintainer may port the behavior into upstream TypeScript, but must regenerate and review the resulting bundle rather than assume that such a port is byte-identical.
