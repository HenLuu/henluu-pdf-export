# Focused maintenance guide

## Confirmed editing model

The finalized .19 baseline was authored by directly editing a candidate copy of `main.js`. The upstream TypeScript tree remains the unmodified reference source. The full tested bundle lives at `plugin/main.js`, and `source/patches/main.js.patch` records its exact difference from upstream’s published bundle.

For a future change, copy the candidate bundle to scratch first. Make a replacement only when the anchor appears exactly once. Keep the replacement script temporary. After editing, run `node --check` and exercise the relevant non-UI behavior. Follow the [reconstruction procedure](source/REPRODUCE.md#prepare-and-review-a-future-code-change) to review the patch, copy the approved bundle into a new release candidate, and verify its reconstruction. Use an isolated test vault for Obsidian rendering checks before replacing installed files.

## Existing detector smoke test

The pure `detectLessonGuide(rawSource, path)` helper can be exercised without starting Obsidian or producing a PDF. Useful checks are: canonical `Institution_New_Lesson_Handout.md` detects as a lesson guide; `Institution_Lesson_Handout.md` detects; a teacher classroom script remains excluded even when its heading mentions a lesson guide; and an unrelated document returns false.

## Tested baseline and changes

The packaged plugin release is `4.7.8`; its tested baseline is local revision `2026.10.25.19`. Revision .19 was originally behavior-verified on 2026-10-25; a Guide export and asset identity were checked on 2026-11-05 in Academic/A2/Paged. This package contains no PDFs. Revision .19 preserves explicit image dimensions when eligible neighboring images pair, including unequal heights, and retains their vertical layout when the pair does not fit. Earlier local behavior includes canonical Lesson Handout detection and document-specific Stage/Lesson Guide pagination alongside Teaching/Smart layout.

## Installation and licensing

The fork is desktop-only and requires a manual, reviewed update. Its equivalent preset is Academic, Custom 420 × 594 mm, Portrait, Paged, Teaching on, Smart on; the package does not apply or bundle settings. Keep the upstream GPL-3.0 `LICENSE`, author attribution, and project URL with every copy. The GitHub release asset `henluu-pdf-export-4.7.8.zip` contains only the four install assets under `henluu-pdf-export/`. Never include `data.json`, vault content, course material, private paths, or internal logs in a release package.

To migrate settings, disable the previous local installation and quit Obsidian. Copy its settings file to `henluu-pdf-export/data.json` while Obsidian is closed, then reopen and enable this plugin. There is no automatic installation or settings migration.
