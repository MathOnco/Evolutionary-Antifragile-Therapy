%% add significance lines to violin plot

function [] = addSignificance(vals, RANGE)
    diffs=[];is=[];js=[];
    for i = 1:1:size(vals,2)
        for j = i:1:size(vals,2)
            diffs=[diffs,abs(i-j)];
            is=[is;i];
            js=[js;j];
        end
    end

    [~,index]=sort(diffs,'descend');

    is=is(index);
    js=js(index);

    b=2;
    for k = 1:1:length(is)
        i=is(k);
        j=js(k);

        if (i ~= j)
            [h,p] = ttest(vals(:,i),vals(:,j));
            d=b*abs(RANGE(2)-RANGE(1))/(2*(size(vals,2)^2));
            dT=(b-0.3)*abs(RANGE(2)-RANGE(1))/(2*(size(vals,2)^2));
            if (h==1) % statistically different
                
                plot([i,j],[max(RANGE)-d,max(RANGE)-d],'-k','LineWidth',2); hold on;
                %plot([i,j],[max(RANGE)-d,max(RANGE)-d],'-k','LineWidth',2); hold on;


                

                if (p < 0.05) && (p >= 0.01)
                    text((j-i)/2+i,max(RANGE)-dT,'*','FontSize',20,'FontWeight','bold');
                else
                    text((j-i)/2+i,max(RANGE)-dT,'**','FontSize',20,'FontWeight','bold');
                end
            else
                plot([i,j],[max(RANGE)-d,max(RANGE)-d],':k','LineWidth',1.5); hold on;
                text((j-i)/2+i,max(RANGE)-dT,'NS','FontSize',6,'FontWeight','bold');
                
            end
            b=b+1;
        end
        k=k+1;
    end
end