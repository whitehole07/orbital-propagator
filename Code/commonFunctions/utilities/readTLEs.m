function y = TLE2Oe(TLE)
%READ_TLOES Reads NORAD-style satellite orbit prediction data files
%   READ_TLOES(FNAME) parses a standard NORAD "two-line orbital
%   element set" (TLOES) data set in file FNAME.  Returns an array
%   of structures, one structure per satellite description contained
%   in the file.
%
%   Each structure contains the following fields:
%    .name            Satellite name
%    .satnum          Satellite number in NORAD SatCat
%    .classification  U (unclassified) or C (classified)
%    .designator      A structure describing International data:
%                         .year, .launch, .piece
%    .epoch           A structure describing the measurement epoch:
%                         .year, .day (including fractional part)
%    .motion          A structure describing change in mean motion:
%                         .dt1 (1st deriv), .dt2 (2nd deriv)
%    .drag            Ballistic coefficient of drag
%    .ephemeris       Ephemeris model, general set to 0
%    .element         Element number
%    .inclination     Inclination, degrees
%    .RAAN            Right ascension of ascending node, degrees
%    .eccentricity    Eccentricity
%    .argp            Argument of perigee
%    .mean_anomaly    In degrees
%    .mean_motion     Revolutions per day
%    .revnum          Satellite revolution number at epoch
%
% For reference, see:
%   http://www.amsat.org
%   http://www.celestrak.com
%

