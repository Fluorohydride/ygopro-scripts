--輝石融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	FusionSpell.RegisterSummonEffect(c,{
		fusfilter=s.fusfilter,
	})
end

function s.fusfilter(c)
	return c:IsSetCard(0x1047)
end
