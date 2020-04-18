using Revise
using AOM
using BrowseTables


full = append_stats()

sort!(full,(:date,:name))
df = by(full,:name) do dd
    days = union(full.date)
    for d in days
        if !in(d,dd.date)
            println(dd.name[1])
            push!(full,[d,dd.name[1],dd.role[end], missings(9)...])
            # , missing, 
            # missing,missing,missing,
            # missing,missing,missing])
        end
    end
end
sort!(full,(:date,:name))
full

open_html_table(full)
