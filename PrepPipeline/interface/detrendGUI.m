function [paramsOut] = detrendGUI(hObject, callbackdata, inputData)%#ok<INUSL>
    theTitle = 'Detrend parameters';
    defaultStruct = inputData.userData.detrend;

    while(true)
        mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
        userdata = get(mainFigure, 'UserData');
        if isempty(userdata) || ~isfield(userdata, 'detrend')
            paramsOut = struct();
        else
            paramsOut = userdata.detrend;
        end
        [defaultStruct, errors] = checkStructureDefaults(paramsOut, defaultStruct);

        if ~isempty(errors)
            warning('detrendGUI:bad parameters', getMessageString(errors)); %#ok<CTPCT>
        end

        % Creates structure for error text
        fNamesDefault = fieldnames(defaultStruct);
        for k = 1:length(fNamesDefault)
            textColorStruct.(fNamesDefault{k}) = 'k';
        end

        typeValue = typeMenuPosition(defaultStruct.detrendType.value);

        %% starts the while loop, sets up the uilist and creates the GUI
        closeOpenWindows(theTitle);
        geometry = {[1,4.5],1,[3,1,3,1],[3,1,4]};
        geomvert = [];
        uilist={{'style', 'text', 'string', 'Detrend channels', ...
            'TooltipString', defaultStruct.detrendChannels.description}...
            {'style', 'edit', 'string', num2str(defaultStruct.detrendChannels.value), ...
            'tag', 'detrendChannels', 'ForegroundColor', ...
            textColorStruct.detrendChannels}...
            {'style', 'text', 'string', ''}...
            {'style', 'text', 'string', 'Detrend type', ...
            'TooltipString', sprintf('One of {''high pass'', ''linear'', ''none''} \n indicating detrending type.')}...
            {'style', 'popupmenu', 'string', 'High Pass|Linear|None', ...
            'value', typeValue, ...
            'tag', 'detrendType', 'ForegroundColor', textColorStruct.detrendType}...
            {'style', 'text', 'string', 'Detrend cutoff', ...
            'TooltipString', defaultStruct.detrendCutoff.description}...
            {'style', 'edit', 'string', num2str(defaultStruct.detrendCutoff.value), ...
            'tag', 'detrendCutoff', 'ForegroundColor', textColorStruct.detrendCutoff}...
            {'style', 'text', 'string', 'Detrend step size', ...
            'TooltipString', defaultStruct.detrendStepSize.description}...
            {'style', 'edit', 'string', num2str(defaultStruct.detrendStepSize.value), ...
            'tag', 'detrendStepSize', 'ForegroundColor', textColorStruct.detrendStepSize}...
            {'style', 'text', 'string', ''}};
        [~, ~, ~, paramsOut] = inputgui('geometry', geometry, ...
            'geomvert', geomvert, 'uilist', uilist, 'title', theTitle, ...
            'helpcom', 'pophelp(''pop_prepPipeline'')');
        if isempty(paramsOut)
            break;
        end
        [paramsOut, typeErrors, fNamesErrors] = ...
            changeType(paramsOut, defaultStruct);
        paramsOut.detrendType = typeMenuString(paramsOut.detrendType);
        mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
        userdata = get(mainFigure, 'UserData');
        userdata.detrend = paramsOut;
        set(mainFigure, 'UserData', userdata);
        if isempty(typeErrors)
            break;
        end
        textColorStruct = highlightErrors(fNamesErrors, ...
            fNamesDefault, textColorStruct);

        displayErrors(typeErrors); % Displays the errors and restarts GUI
    end
    
    function position = typeMenuPosition(theString)
        menuString = {'High Pass'; 'Linear'; 'None'};
        menuIndex = 1:length(menuString);
        position = strcmpi(theString, {'High Pass'; 'Linear'; 'None'});
        position = menuIndex(position);
    end

    function theString = typeMenuString(position)
        menuString = {'High Pass'; 'Linear'; 'None'};
        theString = menuString{position};
    end
end