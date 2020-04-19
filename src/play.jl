using Revise
using AOM
using BrowseTables

Zdf, Rdf = update_results()
last_Z = last_week(Zdf)
Last_R = last_week(Rdf)
open_html_table(elab)

using Plots
elab.total

y = 30 .- elab.total
x = elab.name
bar(x,y,xrotation=45)

bar(y, xticks = (1:nrow(elab),
    elab[:name]),xrotation=45)
