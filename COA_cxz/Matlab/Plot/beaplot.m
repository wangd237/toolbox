function h = beaplot(x,y,ltype,lwidth,Plottitle,xlab,ylab,reverse,xti,fts)
%该函数用来修改plot使其更漂亮输出
%注意该函数未设计缺省
%泛化能力不强
%因此如果需要修改，请编写default语句
%防止以前的程序无法运行
set(0,'defaultfigurecolor','w')
if nargout == 0
    plot(x,y,ltype,'linewidth',lwidth);
else if nargout ==1
        h = plot(x,y,ltype,'linewidth',lwidth);
    end
end
if nargin == 10
    fontsize = fts;
else 
    fontsize =14;
end
title( Plottitle ,'fontsize',fontsize,'fontname','黑体')
set(gca,'fontname','黑体')
xlabel(xlab);
ylabel(ylab);
set(get(gca,'xlabel'),'fontsize',fontsize-2,'fontname','黑体')
set(get(gca,'ylabel'),'fontsize',fontsize-2,'fontname','黑体')
set(gca, 'fontsize',fontsize-2,'fontname','黑体')
if xti==1
    set(gca,'xtick',x)
end
if reverse
    axis ij
end
end