% Skip sync tests for now (sync tests cause issues on Mac OS)
Screen('Preference', 'SkipSyncTests', 1);         

% Choosing the display with the highest display number is
% a best guess about where you want the stimulus displayed.
screens=Screen('Screens');
screenNumber=max(screens);

% Open window with default settings:
screenColor = [128,128,128];
screenSize = [400,400];
screenUpperLeft = [200,200];
screenRect = [screenUpperLeft, screenUpperLeft + screenSize];
w=Screen('OpenWindow', screenNumber, screenColor, screenRect);

%% Block 1 (Translating Dots) with 2s Motion and 0.5s Frozen Dots
totalTime = 20;  % Total block time in seconds
motionDuration = 2;  % 2 seconds per motion stimulus
gapDuration = 0.5;  % 0.5-second gap (frozen dots)
cycleTime = motionDuration + gapDuration;  % Time for one cycle

% Calculate number of full motion + gap cycles within the block
numCycles = floor(totalTime / cycleTime);

for repeat = 1:2  % Repeat twice with different speeds
    if repeat == 2
        dotSpeed = 4;  % Faster speed for the second repeat
    else
        dotSpeed = 2;  % Original speed for the first repeat
    end
    
    % Initialize dot positions for the block
    dotPositions = [rand(1, numDots) * screenSize(1); rand(1, numDots) * screenSize(2)];
    
    % Run the cycles
    for cycle = 1:numCycles
        % 2 seconds of motion
        cycleFrames = round(motionDuration / ifi);
        for frame = 1:cycleFrames
            % Update dot positions and wrap them as before
            dotPositions(1, :) = dotPositions(1, :) + dotSpeed;
            offScreenDots = dotPositions(1, :) > screenSize(1);
            dotPositions(1, offScreenDots) = 0;

            % Draw the dots
            Screen('DrawDots', w, dotPositions, dotSize, [255 255 255], [], 2);
            vbl = Screen('Flip', w, vbl + (0.5 * ifi));
        end
        
        % 0.5 seconds of frozen dots (no movement, just redraw the dots)
        cycleFrames = round(gapDuration / ifi);  % Number of frames for the frozen period
        for frame = 1:cycleFrames
            % Draw the dots in their current (frozen) positions
            Screen('DrawDots', w, dotPositions, dotSize, [255 255 255], [], 2);
            vbl = Screen('Flip', w, vbl + (0.5 * ifi));
        end
    end

    % 3-second gap between repeats
    WaitSecs(3);
end

%% Block 2 (Spiral Dots) with 2s Motion and 0.5s Frozen Dots
totalTime = 20;  % Total block time in seconds
motionDuration = 2;  % 2 seconds per motion stimulus
gapDuration = 0.5;  % 0.5-second gap (frozen dots)
cycleTime = motionDuration + gapDuration;  % Time for one cycle

% Calculate number of full motion + gap cycles within the block
numCycles = floor(totalTime / cycleTime);

for repeat = 1:2  % Repeat twice with different speeds
    if repeat == 2
        rotationSpeed = 4;  % Faster speed for the second repeat
        expansionSpeed = 4;
    else
        rotationSpeed = 2;  % Original speed for the first repeat
        expansionSpeed = 2;
    end
    
    % Initialize dot positions and polar coordinates for spiral movement
    dotPositions = [rand(1, numDots) * screenSize(1); rand(1, numDots) * screenSize(2)];
    angles = rand(1, numDots) * 2 * pi;
    radii = rand(1, numDots) * (min(screenSize) / 2);
    
    % Run the cycles
    for cycle = 1:numCycles
        % 2 seconds of spiral motion
        cycleFrames = round(motionDuration / ifi);
        for frame = 1:cycleFrames
            % Update angle (for rotation) and radius (for spiral effect)
            angles = angles + rotationSpeed;
            radii = radii + expansionSpeed;

            % Convert polar coordinates (radii, angles) to Cartesian (x, y)
            dotPositions(1, :) = screenSize(1) / 2 + radii .* cos(angles);  % x-coordinates
            dotPositions(2, :) = screenSize(2) / 2 + radii .* sin(angles);  % y-coordinates

            % Handle off-screen dots and reset
            offScreenDots = (dotPositions(1, :) < 0 | dotPositions(1, :) > screenSize(1)) | ...
                            (dotPositions(2, :) < 0 | dotPositions(2, :) > screenSize(2));
            radii(offScreenDots) = rand(1, sum(offScreenDots)) * (min(screenSize) / 2);  % Reset radius
            angles(offScreenDots) = rand(1, sum(offScreenDots)) * 2 * pi;  % Reset angle

            % Draw the dots
            Screen('DrawDots', w, dotPositions, dotSize, [255 255 255], [], 2);
            vbl = Screen('Flip', w, vbl + (0.5 * ifi));
        end
        
        % 0.5 seconds of frozen dots (no movement, just redraw the dots)
        cycleFrames = round(gapDuration / ifi);  % Number of frames for the frozen period
        for frame = 1:cycleFrames
            % Draw the dots in their current (frozen) positions
            Screen('DrawDots', w, dotPositions, dotSize, [255 255 255], [], 2);
            vbl = Screen('Flip', w, vbl + (0.5 * ifi));
        end
    end

    % 3-second gap between repeats
    WaitSecs(3);
end

%% Block 3 (Expanding Dots/Stars) with 2s Motion and 0.5s Frozen Dots
totalTime = 20;  % Total block time in seconds
motionDuration = 2;  % 2 seconds per motion stimulus
gapDuration = 0.5;  % 0.5-second gap (frozen dots)
cycleTime = motionDuration + gapDuration;  % Time for one cycle

% Calculate number of full motion + gap cycles within the block
numCycles = floor(totalTime / cycleTime);

for repeat = 1:2  % Repeat twice with different speeds
    if repeat == 2
        speedFactor = 4;  % Faster stars in the second run
    else
        speedFactor = 2;  % Original star speed
    end
    
    % Initialize star positions and speeds
    starPositions = [rand(1, numStars) * screenSize(1); rand(1, numStars) * screenSize(2)];
    starSpeeds = rand(1, numStars) * 5 + speedFactor;
    dotSizes = ones(1, numStars) * initialDotSize;
    
    % Run the cycles
    for cycle = 1:numCycles
        % 2 seconds of expanding stars motion
        cycleFrames = round(motionDuration / ifi);
        for frame = 1:cycleFrames
            % Update star positions and sizes
            deltaX = (starPositions(1, :) - screenSize(1)/2) .* starSpeeds * ifi;
            deltaY = (starPositions(2, :) - screenSize(2)/2) .* starSpeeds * ifi;
            starPositions(1, :) = starPositions(1, :) + deltaX;
            starPositions(2, :) = starPositions(2, :) + deltaY;
            dotSizes = dotSizes + 0.1 * starSpeeds;

            % Handle off-screen or too-large stars and reset
            offScreenStars = (starPositions(1, :) < 0 | starPositions(1, :) > screenSize(1)) | ...
                             (starPositions(2, :) < 0 | starPositions(2, :) > screenSize(2)) | ...
                             (dotSizes > maxDotSize);
            starPositions(:, offScreenStars) = [rand(1, sum(offScreenStars)) * screenSize(1); ...
                                                rand(1, sum(offScreenStars)) * screenSize(2)];
            dotSizes(offScreenStars) = initialDotSize;  % Reset size
            starSpeeds(offScreenStars) = rand(1, sum(offScreenStars)) * 5 + speedFactor;  % New random speed

            % Draw the stars
            Screen('DrawDots', w, starPositions, dotSizes, [255 255 255], [], 2);
            vbl = Screen('Flip', w, vbl + (0.5 * ifi));
        end
        
        % 0.5 seconds of frozen dots (no movement, just redraw the dots)
        cycleFrames = round(gapDuration / ifi);  % Number of frames for the frozen period
        for frame = 1:cycleFrames
            % Draw the stars in their current (frozen) positions
            Screen('DrawDots', w, starPositions, dotSizes, [255 255 255], [], 2);
            vbl = Screen('Flip', w, vbl + (0.5 * ifi));
        end
    end

    % 3-second gap between repeats
    WaitSecs(3);
end
%%
% close window:
sca;