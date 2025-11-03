function error_fill_plot(freqs, tmpmean, tmpsem, colorCode)
    plot(freqs,tmpmean,'LineWidth',2,Color=rgb(colorCode))
    hold on
    patch([freqs, flip(freqs)], [tmpmean-tmpsem, flip(tmpmean+tmpsem)]', rgb(colorCode), 'FaceAlpha',0.25,'EdgeColor','none')

end