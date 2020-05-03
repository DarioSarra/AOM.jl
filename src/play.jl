using Revise
using AOM
using BrowseTables
##
RequiemFusion
res = update_results(RequiemFusion)
lw = lastweek(res)
pub = adjust_to_show(lw)
open_html_table(pub)
##
using DataFrames
filt=filter(row -> row.name != "Mazsola",lw)
##
p = AOM.plot_results(filt)
savefig(p,"/Users/dariosarra/Documents/House/AOM/Stats/03-May-2020.png")
##
