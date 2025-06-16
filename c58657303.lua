--墓守の霊術師
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47355498)
	--fusion summon
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		gc=s.gc
	})
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(47355498)
	    or Duel.IsExistingMatchingCard(function(c) return c:IsCode(47355498) and c:IsFaceup() end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

function s.fusfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end

function s.gc(e)
	return e:GetHandler()
end
