--プレデター・プライム・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_MZONE,
		pre_select_mat_opponent_location=LOCATION_MZONE,
		additional_fgoalcheck=s.fgoalcheck
	})
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end

---@type FUSION_FGCHECK_FUNCTION
function s.fgoalcheck(tp,mg,tc,mg_all)
	---Must including 2 or more DARK monsters you control
	---@param c Card
	if mg_all:FilterCount(function(c) return c:IsControler(tp) and c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsOnField() end,nil)<2 then
		return false
	end
	return true
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10f3)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
