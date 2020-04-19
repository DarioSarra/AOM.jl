function plot_results(lw)
    lw[!,:color] .= RGB(61/255,164/255,77/255)
    for r in eachrow(lw)
        if r.rank_zscore_total > 24
            r.color = RGB(172/255,141/255,24/255)
        elseif r.rank_zscore_total < 6
            r.color = RGB(0/255,153/255,249/255)
        end
    end
    lw[!,:xname] = ["# $(r.rank_zscore_total) $(r.name)" for r in eachrow(lw)]
    lw[!,:notey] = [(r.zscore_total >= 0.0 ? r.zscore_total + 0.5 : r.zscore_total - 0.5) for r in eachrow(lw)]
    lw[!,:note] =[(r.rank_zscore_total, r.notey, Plots.text("$(round(r.zscore_total,digits=1))",:center,12)) for r in eachrow(lw)]
    sort!(lw,:rank_zscore_total)
    fig = plot(ylabel = "Zscore",
        xlabel = "Ranking",
        guidefontsize=18,
        bottom_margin = 100px,
        left_margin = 40px,
        size=(1000,1000))
    bar!(fig,lw.rank_zscore_total,lw.zscore_total,
        xticks = (1:nrow(lw),lw.xname),
        xrotation=45,
        ylims = (minimum(lw.zscore_total)-1.2,maximum(lw.zscore_total)+1.2),
        fillcolor = lw.color,tickfontsize = 13,
        legend = false)
    annotate!(lw.note)
end
