# Henluu PDF Export

面向教学讲义的 Obsidian 桌面端 PDF 导出插件，支持自定义排版、智能分页和长题图。基于 ShrekBytes 的 Advanced PDF Export 4.7.7，沿用 GPL-3.0 许可。插件 ID 为 `henluu-pdf-export`。

## Tested baseline

The full tested installed bundle is in `plugin/`. Its manifest records local revision `2026.10.25.19`. Revision .19 was originally behavior-verified on 2026-10-25. A Guide export and installed asset identity were checked on 2026-11-05 in Academic/A2/Paged. Release 4.7.8 retains that tested layout behavior. This package contains no PDFs, and no new export was run during this packaging task.

The final .19 baseline was made by directly editing a candidate copy of `main.js`. The checked-in `plugin/main.js` is the complete tested bundle, and `source/patches/main.js.patch` records its exact delta from the pinned upstream published bundle.

The .19 change preserves author-specified dimensions on eligible adjacent image pairs, including unequal heights; it pairs only when both measured widths plus the 18 px gap fit the available content width, otherwise it keeps the original vertical layout. The current baseline also includes Teaching/Smart paged layout behavior, stage and lesson-guide pagination, and canonical Institution Lesson Handout detection.

## Equivalent preset to inspect

To match the tested local setup, manually check **Academic**, **Custom 420 × 594 mm**, **Portrait**, **Paged**, **Teaching on**, and **Smart on**. These values are not applied by this package.

## Source and exact reconstruction

- `source/upstream/` contains the complete upstream source archive for tag 4.7.7, including the TypeScript source and esbuild config. Upstream builds `main.js` from `src/main.ts`.
- `source/patches/main.js.patch` is the exact bundle-first change; the tested `plugin/main.js` is the full editable output. The manifest patch preserves the distinct local plugin identity.
- `source/rebuild.sh` reconstructs the installable assets from the pinned upstream bundle and checked-in patches, then checks their SHA-256 values. See `source/REPRODUCE.md` and `MAINTENANCE.md` for future edits.

The GitHub release asset is `henluu-pdf-export-4.7.8.zip`. It contains `henluu-pdf-export/` with exactly four files: `main.js`, `styles.css`, `manifest.json`, and `LICENSE`. The public documentation and source kit stay outside that ZIP.

The installable asset set contains no `data.json`, user settings, vault content, course materials, private paths, or internal logs.

## Manual installation

1. Download `henluu-pdf-export-4.7.8.zip` from GitHub Releases and extract it.
2. Copy the contained `henluu-pdf-export/` folder into the target vault’s `.obsidian/plugins/` directory.
3. Reload Obsidian and enable **Henluu PDF Export** in Community plugins.

Do not replace the vault’s existing settings. The distinct plugin ID is intentional; review each update manually.

### Manual settings migration

When moving from a previously installed local build, disable that plugin in Obsidian and close Obsidian completely. To retain its settings, copy its existing `data.json` to `henluu-pdf-export/data.json` while Obsidian is closed. Reopen Obsidian and enable Henluu PDF Export. Installation and settings migration are manual; the package performs neither automatically.

## License and attribution

The full upstream GPL-3.0 license is included as `plugin/LICENSE` and in the ZIP. Upstream project: [ShrekBytes/advanced-pdf-export](https://github.com/ShrekBytes/advanced-pdf-export), tag `4.7.7`. This fork is not an upstream release or endorsement.
