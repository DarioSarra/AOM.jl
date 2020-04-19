using Revise
using AOM
using BrowseTables

##
res = update_results()
lw = lastweek(res)
open_html_table(lw)
##
p = AOM.plot_results(lw)
savefig(p,"/Users/dariosarra/Documents/House/AOM/Stats/19-Apr-2020.png")
##
