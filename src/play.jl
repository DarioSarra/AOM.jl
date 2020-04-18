using Revise
using AOM
using BrowseTables

full = get_stats()
open_html_table(full)
elab = elaborate(full)
open_html_table(elab)
