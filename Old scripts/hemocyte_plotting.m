for i = 1:20
    subplot(4,5,i)
    plot(traces(i).Frame,traces(i).Intensity);
    title(strcat(traces(i).MovieName, ' - ', num2str(traces(i).TraceNumber)),'Interpreter','none');
    xlabel(strcat('X = ',num2str(round(mean(traces(i).X)))));
    ylabel(strcat('Y = ',num2str(round(mean(traces(i).Y)))));
end