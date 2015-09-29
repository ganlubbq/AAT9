
function stereo_test_vas(inputarg)



    % Parts:
    %
    % 1 - Present the test procedure to the user (brief instructions)
    % 2 - Familiarization ("this is inside", "this is outside")
    % 3 - Randomize the order or presentation
    % 4 - Retrieve data and save it a text file








%     [position, slider] = showLocalizationPlot();
%     disp(sprintf('Position: %.2f, %.2f. Slider: %.2f', position(1), position(2), slider));

    inputAudio = audioread('audio_signals/test_recording.wav');

    frontAudio = convolveSound(inputAudio, 0);

    disp('>> Generating all necessary audios ...\n\n');

    % Left side audios
    side_30_Audio = convolveSound(inputAudio, 30);
    side_45_Audio = convolveSound(inputAudio, 45);
    side_72_Audio = convolveSound(inputAudio, 72);
    side_110_Audio = convolveSound(inputAudio, 110);
    side_144_Audio = convolveSound(inputAudio, 144);
    side_170_Audio = convolveSound(inputAudio, 170);

    % Right side audios
    side__30_Audio = convolveSound(inputAudio, -30);
    side__45_Audio = convolveSound(inputAudio, -45);
    side__72_Audio = convolveSound(inputAudio, -72);
    side__110_Audio = convolveSound(inputAudio, -110);
    side__144_Audio = convolveSound(inputAudio, -144);
    side__170_Audio = convolveSound(inputAudio, -170);

    disp('Playing 0 degrees');
    playAudio(frontAudio);
    disp('Playing 30 degrees');
    playAudio(side_30_Audio);
    disp('Playing 45 degrees');
    playAudio(side_45_Audio);
    disp('Playing 72 degrees');
    playAudio(side_72_Audio);
    disp('Playing 110 degrees');
    playAudio(side_110_Audio);
    disp('Playing 144 degrees');
    playAudio(side_144_Audio);
    disp('Playing 170 degrees');
    playAudio(side_170_Audio);

    disp('Playing -170 degrees');
    playAudio(side__170_Audio);
    disp('Playing -144 degrees');
    playAudio(side__144_Audio);
    disp('Playing -110 degrees');
    playAudio(side__110_Audio);
    disp('Playing -72 degrees');
    playAudio(side__72_Audio);
    disp('Playing -45 degrees');
    playAudio(side__45_Audio);    
    disp('Playing -30 degrees');
    playAudio(side__30_Audio);

    return
    
    disp('Playing 30 degrees');
    playAudio(side_30_Audio);
    disp('Playing 45 degrees');
    playAudio(side_45_Audio);
    disp('Playing 72 degrees');
    playAudio(side_72_Audio);
    disp('Playing 110 degrees');
    playAudio(side_110_Audio);
    disp('Playing 144 degrees');
    playAudio(side_144_Audio);
    disp('Playing 170 degrees');
    playAudio(side_170_Audio);

end

function playAudio(inputAudio)

    playerHandler = audioplayer(inputAudio, 44100);
    playblocking(playerHandler);

end

function outputSound = convolveSound(inputAudio, degree)

% This table contains the measured differences of level received on the
% dummy head. The impulse responses were normalized to make an optimum use
% of the dynamic range of the wav file (16 bits). Therefore, they have to
% be scaled afterwards to include the attenuation effect between ears.
% 
%                         close         far       difference
% side (30 degrees):   -15.90 dBV    -25.37 dBV     9.47 dB
% side (45 degrees):   -15.35 dBV    -27.83 dBV    12.48 dB
% side (72 degrees):   -15.46 dBV    -29.24 dBV    13.78 dB
% side (110 degrees):  -16.90 dBV    -29.84 dBV    12.94 dB
% side (144 degrees):  -20.93 dBV    -27.98 dBV     7.05 dB
% side (170 degrees):  -22.57 dBV    -24.99 dBV     2.42 dB

    switch abs(degree)
        case {0}
            % Load IRs front
            left_IR = audioread('surround_ir/front_left_1s_01.wav');
            right_IR = audioread('surround_ir/front_right_1s_01.wav');
            attenuation_db = 0;

        case {30}
            % Load IRs 30 degrees
            left_IR = audioread('surround_ir/side_30_close_2s_01.wav');
            right_IR = audioread('surround_ir/side_30_far_2s_01.wav');
            attenuation_db = 9.47;

        case {45}
            % Load IRs 45 degrees
            left_IR = audioread('surround_ir/side_45_close_2s_01.wav');
            right_IR = audioread('surround_ir/side_45_far_2s_01.wav');
            attenuation_db = 12.48;

        case {72}
            % Load IRs 72 degrees
            left_IR = audioread('surround_ir/side_72_close_2s_01.wav');
            right_IR = audioread('surround_ir/side_72_far_2s_01.wav');
            attenuation_db = 13.78;

        case {110}
            % Load IRs 110 degrees
            left_IR = audioread('surround_ir/side_110_close_2s_01.wav');
            right_IR = audioread('surround_ir/side_110_far_2s_01.wav');
            attenuation_db = 12.94;

        case {144}
            % Load IRs 144 degrees
            left_IR = audioread('surround_ir/side_144_close_2s_01.wav');
            right_IR = audioread('surround_ir/side_144_far_2s_01.wav');
            attenuation_db = 7.05;

        case {170}
            % Load IRs 170 degrees
            left_IR = audioread('surround_ir/side_170_close_2s_01.wav');
            right_IR = audioread('surround_ir/side_170_far_2s_01.wav');
            attenuation_db = 2.42;

        otherwise
        disp('ERROR: invalid angle!');
        return
    end

    % Obtains the output data from the convolution with the IRs
    leftChannel = conv(left_IR, inputAudio);
    rightChannel = conv(right_IR, inputAudio) * 10^(-attenuation_db/20);

    % Normalizes the output audio to -1 dBFS
    normalizationValue = max(max(leftChannel), max(rightChannel));
    leftChannel = leftChannel / normalizationValue * 10^(-1/20);
    rightChannel = rightChannel / normalizationValue * 10^(-1/20);

    % Invert the output channels if the angle is negative
    if degree > 0
        outputSound = [leftChannel, rightChannel];
    else
        outputSound = [rightChannel, leftChannel];
    end
end

function [position, slider] = showLocalizationPlot()

    %windowTitle = 'My title';
    %plotTitle = 'Plot title';
    backColor = [.82 .81 .8];
    windowTitle = 'Stereo perception test - AAT9 2015.';
    position = [-1, -1];
    slider = 50;
    positionAlreadySelected = false;

    % Loads the background image from file
    img = imread('plot_background.png');

    % Creates the figure with the desired size, centered on screen
    hFig = figure('Color', backColor);
    set(hFig,'Name', windowTitle, 'NumberTitle','off')
    hold on;
    set(hFig, 'Position', [0 0 520 650])
    movegui(hFig, 'north')

    % Callback for the click
    set(hFig,'windowbuttondownfcn',@fhbdfcn)

    % Removes the toolbar and the menu bar
    set(hFig, 'MenuBar', 'none');
    set(hFig, 'ToolBar', 'none');
    set(gca,'xtick',[],'ytick',[])

    % Sets the canvas position
    set(gca,'Position',[0.05 0.2 0.9 0.7])

    % Displays the background image
    image([-300 300], [300 -300], img);
    axis([-300 300 -300 300])

    % Sets the title to the plot
    title('Click where the source was perceived', ...
          'FontSize', 16, 'FontWeight', 'normal');

    % -- Internal callbacks --

    function [] = fhbdfcn(h, ~)

        % Gets the position coordinates
        positionCoordinates = get(gca, 'currentpoint');
        positionCoordinates = [positionCoordinates(1, 1) 
                               positionCoordinates(1, 2)];

        if ~positionAlreadySelected

            % Checks that the click is within the boundaries
            if positionCoordinates(1) > 300 || positionCoordinates(1) < -300
                return
            end
            if positionCoordinates(2) > 300 || positionCoordinates(2) < -300
                return
            end

            % Displays a mark on the selected point
            plot([positionCoordinates(1)], [positionCoordinates(2)], ...
                 'x', 'MarkerSize', 30, 'LineWidth', 3);

            % Saves the selected position
            position = positionCoordinates;

            % Adds slider for the perceived realism
%             m = ones(100,1)*(1:100);
            hsl = uicontrol('Style','slider','Min',1,'Max', 100,...
                            'SliderStep',[1 1]./100,'Value', 52,...
                            'Position',[130 50 250 20]);

            % Wires callback for the slider
            set(hsl, 'Callback', @callbackSlider)

            % Adds boton to continue
            uicontrol('Style', 'pushbutton', 'String', 'Continue',...
                'Position', [220 10 70 30],...
                'Callback', 'close');

            % Adds label for 'Perceived realism'
            uicontrol('Style','text',...
                'Position',[160 80 200 20],...
                'BackgroundColor', backColor, ...
                'FontSize', 14, ...
                'String','Perceived realism valoration:');

            % Adds label for 'very fake'
            uicontrol('Style','text',...
                'Position',[80 30 40 50],...
                'BackgroundColor', backColor, ...
                'FontSize', 14, ...
                'String', sprintf('Very\nfake'));

            % Adds label for 'very realistic'
            uicontrol('Style','text',...
                'Position',[390 30 70 50],...
                'BackgroundColor', backColor, ...
                'FontSize', 14, ...
                'String', sprintf('Very\nrealistic'));

            % Removes the title
            title('');

            % Flag of 'position already selected'
            positionAlreadySelected = true;
        end
    end
    
    function callbackSlider(hObject, evt)
        slider = get(hObject, 'Value');
    end

    % Waits until the window is closed
    waitfor(hFig);

end
