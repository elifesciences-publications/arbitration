function [pvec, pstruct] = softmax_social_bias_1stlevelprecision_reward_social_transp(r, ptrans)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)     = exp(ptrans(1));       % ze1
pstruct.ze = pvec(1);
pvec(2)     = exp(ptrans(2));       % beta
pstruct.be_ch = pvec(2);
pvec(3)     = exp(ptrans(3));       % ze3
pstruct.be_wager = pvec(3);
return;