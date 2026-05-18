--黄金郷の七摩天
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=FusionSpell.CreateSummonEffect(c,{
		matfilter=s.matfilter,
		extra_target=s.extra_target
	})
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.alcon)
	e2:SetTarget(s.altg)
	e2:SetOperation(s.alop)
	c:RegisterEffect(e2)
end

function s.matfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end

function s.alfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsFaceup() and c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
end

function s.alcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.alfilter,1,nil)
end

function s.cfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end

function s.altg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
end
function s.alop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFacedown() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
