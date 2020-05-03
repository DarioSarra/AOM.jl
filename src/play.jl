using Revise
using AOM
using BrowseTables
##
res = update_results()
lw = lastweek(res)
pub = adjust_to_show(lw)
open_html_table(pub)
##
using DataFrames
filt=filter(row -> row.name != "Annanana",lw)
##
p = AOM.plot_results(filt)
savefig(p,"/Users/dariosarra/Documents/House/AOM/Stats/26-Apr-2020.png")
##
