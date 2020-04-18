using Revise
using AOM
using BrowseTables

elab = last_week_results()
open_html_table(elab)

full = get_stats()
open_html_table(full)
elab = elaborate(full)
elab.total = elab.arena_place + elab.arena_victories + elab.arena_defences +
    elab.maxed_heroes + elab.clan_tokens + elab.raid_points + elab.portal_stones
open_html_table(elab)

last_week = union(elab.date)[end]
last_df = filter(row -> row[:date] == last_week, elab)

using StatsBase: tiedrank

for c in names(last_df)
    if !in(c,[:name,:date])
        last_df[!,c] = tiedrank(last_df[!,c],rev = true)
    end
end

open_html_table(last_df)
