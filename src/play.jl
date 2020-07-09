using Revise
using AOM
using BrowseTables
##
plot_results(RequiemFusion;remove = ["Black Dahlia", "uncleb"])
##
res = update_results(RequiemFusion)
lw = lastweek(res)
open_html_table(lw)
pub = adjust_to_show(lw)
open_html_table(pub)
##
using DataFrames
filt=filter(row -> row.name != "Mazsola",lw)
##
range(colorant"red", stop=colorant"green", length=15)
p = AOM.plot_results(filt)
savefig(p,"/Users/dariosarra/Documents/House/AOM/Stats/03-May-2020.png")
##
plot_results(BoethiasChampions)
res = update_results(BoethiasChampions)
lw = lastweek(res)
pub = adjust_to_show(lw)
open_html_table(pub)
p = AOM.plot_results(lw)
##
using Plots
pow = dropmissing(res)
gd = groupby(pow,:date)
p = combine(gd,:total_power=>sum=>:clan_power)
scatter(p[:,:date],p[:,:clan_power])
