function i = lifetime_picker( traces_file, cellnum, varargin )


load(traces_file);
k = 0;
if nargin == 2
    i = 0;
elseif nargin == 4
    i = varargin{1};
    load(varargin{2});
else
    error('Need file to get old data from');
end

num_traces = 0;
for j = 1:size(x,2)
    if ~isempty(x{cellnum,j})
        num_traces = num_traces + 1;
    end
end

while (k~=4 && i < num_traces)
    i = i+1;
    figure('units','normalized','outerposition',[0 0 1 1]);
    axh = axes('units', 'normalized', 'Position', [.1 .1 .8 .8]);
    plot(x{cellnum,i},y{cellnum,i});
    title('Click and drag from point to point to select a peak. Or click to skip.');

    pause(.2); %this performs magic. accept it without question.
    rect = getrect(axh);
    pause(.2); %this performs magic. accept it without question.
    if rect(3)<1
        k = 3;
    else
        f = figure('units','normalized','outerposition',[0 0 1 1],...
            'WindowKeyPressFcn',@wkpcb);
        directions = sprintf('D or %s: Accepts input and goes to next \n\n A or %s: Rejects input to try again \n\n S or %s: Rejects input and goes to next \n\n W or %s: Exits the program, returning index of last viewed','\rightarrow','\leftarrow','\downarrow','\uparrow');
        text(0.5,0.5,directions,...
            'VerticalAlignment','Middle',...
            'HorizontalAlignment','Center',...
            'Units','normalized',...
            'FontSize',18);
        waitfor(f);
        if (k == 1)
            [~,first] = min(abs(x{cellnum, i} - round(rect(1))));
            if first < 1, first = 1; end
            [~,last] = min(abs(x{cellnum, i} - round(rect(1)+rect(3))));
            if last > length(x{cellnum, i}), last = length(x{cellnum, i}); end
            new_x{i} = x{cellnum,i}(first:last);
            
            clear new_data;
        elseif (k == 2 || k == 4)
            i = i - 1;
        end
    end
    close all;
end

    function wkpcb(~, evt)
        c_num = double(evt.Character);
        switch(c_num)
            case {29,100} % right arrow or 'd'
                k = 1; % Accepts input and goes to next
            case {28,97} % left arrow or 'a'
                k = 2; % Rejects input to try again
            case {31,115} % down arrow or 's'
                k = 3; % Rejects input and goes to next
            case {30,119} % up arrow or 'w'
                k = 4; % Exits the program, returning index of last viewed
        end
        close(f);
    end
save(sprintf('traces%i.mat',cellnum), 'new_x');
end