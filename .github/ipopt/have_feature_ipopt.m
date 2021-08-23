function [TorF, vstr, rdate] = have_feature_ipopt()
%Based on full version from MP-Opt-Model

%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://github.com/MATPOWER/mp-opt-model for more info.

TorF = exist('ipopt', 'file') == 3;
vstr = '';
rdate = '';
if TorF
    try
        x = feval('qps_ipopt', [],[1; 1],[1 1],[2],[2],[1; 1],[1; 1],[1; 1],struct('verbose', 0));
        if ~isequal(x, [1;1])
            TorF = 0;
        end
    catch
        TorF = 0;
    end
end
