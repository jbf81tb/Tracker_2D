z_dist = 500*0.7;
temp = sum(masks,3);

%close all
imagesc((0:max(temp(:))*z_dist)')
colormap(flipud(gray))
set(gca,'XTick',[], 'YTick', [], 'Units','pixels','Position',[33 10 63 124*8+15]);
set(gcf,'units','pixels','Position',[1 1 124+4 124*8+32]);
%%
close all
imagesc((0:max(goodspots{3})*z_dist)')
colormap(jet)
set(gca,'XTick',[],'Units','pixels','Position',[60 0 64 800]);
ylabel('Z pos (nm)');
set(gcf,'units','pixels','Position',[0 0 100 800]);
%%
close all
imagesc((0:100*max(dens))')
colormap(hot)
set(gca,'XTick',[],'Units','pixels','Position',[60 0 64 800]);
ylabel('Density*100 (#/um^2)');
set(gcf,'units','pixels','Position',[0 0 100 800]);
%%
imagesc((1:64)')
colormap(flipud(gray))
set(gca,'XTick',[], 'YTick', [8 16 24 32 40 48 56], 'Units','pixels','Position',[33 3 63 1023]);
set(gcf,'units','pixels','Position',[1 1 128 1024+5]);
%%
imagesc((1:64)')
colormap(flipud(jet))
set(gca,'XTick',[], 'YTick', [8 16 24 32 40 48 56], 'Units','pixels','Position',[33 3 63 1023]);
set(gcf,'units','pixels','Position',[1 1 128 1024+5]);
%%
imagesc((1:64)')
colormap(flipud(hot))
set(gca,'XTick',[], 'YTick', [8 16 24 32 40 48 56], 'Units','pixels','Position',[33 3 63 1023]);
set(gcf,'units','pixels','Position',[1 1 128 1024+5]);