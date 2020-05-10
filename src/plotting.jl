function plot_results(lw::AbstractDataFrame)
    lw[!,:xname] = ["# $(Int64(round(r.rank_zscore_total))) $(r.name)" for r in eachrow(lw)]
    lw[!,:notey] = [(r.zscore_total >= 0.0 ? r.zscore_total + 0.5 : r.zscore_total - 0.5) for r in eachrow(lw)]
    lw[!,:note] =[(r.rank_zscore_total, r.notey, Plots.text("$(round(r.zscore_total,digits=1))",:center,12)) for r in eachrow(lw)]
    sort!(lw,:rank_zscore_total)
    add_colors!(lw)
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
        #fillcolor = lw.color,
        fillcolor = lw.heat,
        tickfontsize = 13,
        legend = false)
    annotate!(lw.note)
end

function plot_results(clan::AbstractDict; remove = ["player_names"])
    res = update_results(clan)
    lw = lastweek(res)
    filt = filter(row -> !in(row.name,remove),lw)
    p = AOM.plot_results(filt)
    filename = clan[:name]*"_"*string(today())*".png"
    dir = "/Users/dariosarra/Documents/House/AOM/Stats/"
    savefig(p,joinpath(dir,filename))
    return p
end

function add_colors!(lw::AbstractDataFrame)
    lw[!,:color] .= RGB(61/255,164/255,77/255)
    for r in eachrow(lw)
        if r.rank_zscore_total > 24
            r.color = RGB(172/255,141/255,24/255)
        elseif r.rank_zscore_total < 6
            r.color = RGB(0/255,153/255,249/255)
        end
    end
    pal = range(HSL(colorant"green"), stop=HSL(colorant"red"), length=nrow(lw))
    lw[!,:heat] = collect(pal)
end
