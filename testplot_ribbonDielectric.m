for i=1:length(swerveFilePaths)
    f1 = figure(1);
    [total728] = ribbonDielectric(swerveFilePaths(i),1,[]); hold on
    
    plot728 = total728(:,2:end);
    plot728(1,:) = plot728(1,:) - plot728(1,1)/2;
    
    f2 = figure(2);
    plot(plot728(1,:), plot728(2,:),'o'); hold on
    ylim([4.5 5]);
    xlim([0 15]);
    title("Mean v. Distance from centerline");
    xlabel("Ribbon boundary from centerline [ft]");
    ylabel("Sample Mean of < Ribbon boundary");

    
    f3 = figure(3);
    plot(plot728(1,:), plot728(3,:), 'o'); hold on
    ylim([0 .06]);
    xlim([0 15]);
    title("Variance v. Distance from centerline");
    xlabel("Ribbon boundary from centerline [ft]");
    ylabel("Sample Variance of < Ribbon boundary");

    
    f4 = figure(4);
    plot(plot728(1,:), plot728(4,:),'o'); hold on
    ylim([0 1500]);
    xlim([0 15]);
    title("N v. Distance from centerline");
    xlabel("Ribbon boundary from centerline [ft]");
    ylabel("N of < Ribbon boundary");

end

xline(total728(1,1)); xline(total728(1,2)); xline(total728(1,3)); xline(total728(1,4)); xline(total728(1,5)); xline(total728(1,6)); xline(total728(1,7)); xline(total728(1,8)); xline(total728(1,9)); xline(total728(1,10));
