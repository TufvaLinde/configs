# Neovim cheat sheet

Open this anywhere with **`Space ?`**. Close it with `Space q`.
Forgot a shortcut? Press **`Space`** and wait: a menu shows everything. **`Space fk`** searches all keymaps.

---

## 0. The one idea that makes Vim click

Commands are **sentences**: `[count] verb  target`

| Verbs | | Targets (motions) | | Targets (text objects) | |
|---|---|---|---|---|---|
| `d` | delete (= cut) | `w` / `b` | next / previous word | `iw` / `aw` | inside / around word |
| `c` | change (delete + insert) | `e` | end of word | `i"` `i'` `` i` `` | inside quotes |
| `y` | yank (= copy) | `$` / `0` / `^` | end / start / first char of line | `i(` `i[` `i{` | inside brackets |
| `>` `<` | indent / dedent | `j` / `k` | line down / up | `ip` | inside paragraph |
| `gU` `gu` | UPPER / lower case | `f{char}` / `t{char}` | to / till next char on the line | `it` | inside HTML tag |
| `=` | auto-indent | `G` / `gg` | end / start of file | `i$` (LaTeX) `ie` | inside math / environment |

So: `dw` delete word, `ciw` change this word, `ci"` change text in quotes, `yip` copy paragraph, `d3j` delete this + 3 lines down, `ct,` change up to the comma, `>ip` indent paragraph.
**Double the verb = whole line:** `dd` `cc` `yy` `>>`.
**`.` repeats the last change.** Change one word with `ciw`, then move and press `.` to do it again.

---

## 1. Modes

| Key | Goes to |
|---|---|
| `i` / `a` | insert before / after the cursor |
| `I` / `A` | insert at start / end of line |
| `o` / `O` | new line below / above and insert |
| `v` / `V` / `Ctrl-v` | select characters / lines / a block (column) |
| `Esc` | back to normal mode (always safe to press) |
| `:` | command line (`:w` save, `:q` quit, `:wq`, `:q!` quit without saving) |

---

## 2. Moving around (normal mode)

| Keys | Moves |
|---|---|
| `h j k l` | left down up right |
| `j` / `k` on a wrapped line | move one *screen* row (with a count like `5j` they jump real lines) |
| `:set nowrap` / `:set wrap` | turn line wrapping off / on for this window |
| `w` `b` `e` | word forward / back / to end (`W B E` = ignore punctuation) |
| `0` `^` `$` | line start / first character / end |
| `f x` / `F x` | jump to next / previous `x` on this line; `;` repeat, `,` reverse |
| `gg` / `G` / `42G` | top / bottom / line 42 |
| `Ctrl-d` / `Ctrl-u` | half a page down / up |
| `{` / `}` | previous / next empty line (paragraph) |
| `%` | jump to the matching bracket |
| `*` / `#` | search the word under the cursor forward / back |
| `/text` `?text` | search forward / back; `n` next, `N` previous; `Esc` clears highlight |
| `Ctrl-o` / `Ctrl-i` | jump back / forward (after any big jump: search, `gd`, `G`...) |
| `5j` / `3k` | 5 down / 3 up (use the relative numbers in the margin!) |
| `zz` | centre the screen on the cursor |

---

## 3. Copy, cut, paste, undo

The clipboard is shared with macOS: whatever you `y`/`d` you can `Cmd-V` elsewhere, and `Cmd-C` from elsewhere you can `p` here.

| Keys | Does |
|---|---|
| `yy` / `yiw` / `y$` | copy line / word / to end of line |
| `v` …move… `y` | select, then copy |
| `dd` / `x` | cut line / cut one character |
| `p` / `P` | paste after / before the cursor (lines: below / above) |
| `"0p` | paste what you last **copied** (even if you deleted something since) |
| `"_d` | delete **without** overwriting the clipboard |
| `u` / `Ctrl-r` | undo / redo |
| `ddp` / `ddkP` | move line down / up |
| `yyp` | duplicate line |
| `J` | join the line below onto this one |

---

## 4. Editing faster

| Keys | Does |
|---|---|
| `ciw` `ci(` `ci"` | replace a word / bracket content / string |
| `cc` / `C` / `D` | replace whole line / to end / delete to end |
| `r x` | replace one character with `x` |
| `~` | toggle case |
| `gcc` / `gc` + motion | comment / uncomment line(s) (`gcip` = paragraph) |
| `Ctrl-v` → `jjj` → `I` → type → `Esc` | type on many lines at once |
| `:%s/old/new/g` | replace everywhere in file (add `c` to confirm each: `/gc`) |
| `qa` … `q` then `@a` | record a macro into `a`, then replay it (`10@a` = 10 times) |

---

## 5. Files, windows, buffers

| Keys | Does |
|---|---|
| `Space Space` / `Space ff` | find file by name |
| `Space fg` | find text in the whole project |
| `Space fr` | recent files |
| `Space fb` | switch between open files |
| `Space /` | search in this file |
| `-` | file explorer (Oil): Enter opens, `-` goes up, edit lines + `:w` to rename/delete/create |
| `Space w` / `Space q` | save / close window |
| `:vsplit` / `:split` | split side by side / top-bottom |
| `Ctrl-h j k l` | move between splits |
| `Ctrl-t` | toggle a terminal at the bottom (`Esc` to scroll it, `i` to type) |

---

## 6. Coding (Python and any language with a server)

| Keys | Does |
|---|---|
| `K` | docs for the thing under the cursor |
| `gd` | go to definition (`Ctrl-o` to come back) |
| `grr` | find all references |
| `Space cr` | rename everywhere |
| `Space ca` | quick fix / code action |
| `Space cd` | show the full error under the cursor |
| `]d` / `[d` | next / previous error |
| `Space fd` | list all errors |
| `Space cf` | format (also happens on every save) |
| `Space cs` | list functions/classes in the file |
| **Completion popup** | `Ctrl-n` / `Ctrl-p` move, **`Ctrl-y` accept**, `Ctrl-e` close, `Ctrl-Space` open |
| `]h` / `[h` | next / previous git change; `Space gp` preview it, `Space gb` blame |

More languages: `:Mason` lists servers. Add the name to `ensure_installed` in `lua/plugins/lsp.lua`.

---

## 7. Jupyter

Open any `.ipynb` (it shows up as Python with `# %%` cell markers) or a `.py` file with `# %%` cells.

| Keys | Does |
|---|---|
| `Space ji` | start a kernel (pick `scratch` or your project's) |
| `Space jr` | run the cell the cursor is in (in visual mode: run the selection) |
| `Space jn` | run cell and jump to the next one |
| `Space jl` | run the current line |
| `]j` / `[j` | next / previous cell |
| `Space jc` | new cell below |
| `Space jo` | enter the output window (scroll / copy it; `q` to leave) |
| `Space jh` / `Space jd` | hide / delete output |
| `Space jx` / `Space jR` | interrupt / restart kernel |

**Use a project's own packages:** in the project folder, `uv venv && uv pip install pandas ...`, then in Neovim `:JupyterRegisterVenv`, then `Space ji` and pick the kernel named after the folder.

`:w` saves the code back into the `.ipynb`. Outputs shown by Molten are not written into the file.

---

## 8. Rich (pretty terminal output in Python)

In a project: `uv add rich`. (`scratch` already has it.) Snippets, type then `Tab`:

| Snippet | Gives you |
|---|---|
| `rprint` | `from rich import print` (colourful print for dicts, lists, `[bold red]markup[/]`) |
| `rtrace` | readable tracebacks that show variable values |
| `rtable` | a table |
| `rtrack` | a progress bar around a loop |
| `rinspect` | look inside any object: its methods, attributes and docs |
| `cell` | a new `# %%` Jupyter cell |

Colours show when you run a script in a terminal (`Ctrl-t`, then `uv run script.py`). In notebooks (Molten) you get Rich's layout, but **no colours**: Molten strips them.

In the shell: `rich file.md` / `file.csv` / `file.json` / `file.py` prints it nicely; add `--pager` to scroll.

---

## 9. LaTeX (`\` = local leader)

| Keys | Does |
|---|---|
| `\ll` | compile on every save (toggle) |
| `\lv` | show PDF in a split |
| `\c` | save + compile once |
| `\le` / `\lk` / `\lc` | errors / stop / clean |
| `cse` `dse` / `ci$` `dsm` | change/delete environment / change in math, delete math |
| `Tab` / `Shift-Tab` | expand snippet, jump fields |

---

## Practice plan

- **Week 1:** `:Tutor` (built-in, ~30 min). Then only `hjkl w b e 0 $ gg G Ctrl-d Ctrl-u`, no arrow keys.
- **Week 2:** the grammar in §0. Every time you'd select with the mouse, say the sentence instead (`ci"`, `dap`, `yi(`).
- **Week 3:** `f`/`t` + `;`, `*`, `.` repeat, `Ctrl-o`. Find files only with `Space ff`/`Space fg`.
- **Week 4:** macros (`qa`…`q`, `@a`), `:%s`, block insert with `Ctrl-v`.
- **Always:** if something feels slow, there is a faster way. Ask, or `Space fh` to search help.
