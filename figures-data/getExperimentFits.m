%% get the alpha values, as well as the best fit alpha used for SIMULATIONS only (not for plotting)

function [alpha,alpha_hill_fit_parameters] = getExperimentFits(BD)

    %% load alpha:
    load(strcat('save/alpha_BD',num2str(BD),'.mat'));
    %% load alpha_hill_fit_parameters
    load(strcat('save/alpha_fit_BD',num2str(BD),'.mat'));

    if (BD == 33)
        % add back in the 12.5 dose
        alpha = [alpha(:,1),alpha(:,1)*NaN,alpha(:,2:end)];
    end

    % this always needs to be reversed, for fitting
    alpha(:,1)=-alpha(:,1);


end