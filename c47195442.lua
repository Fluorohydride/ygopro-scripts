--四獣層ウォンキー
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	c:EnableReviveLimit()
	--immume
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--attach_PHASE_STANDBY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atcon1)
	e2:SetTarget(s.attg)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
	--attach_xyzSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atcon2)
	e3:SetTarget(s.attg)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.atcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.atcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ld=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_DECK,0,nil)
	if ld<1 then return end
	local g=Duel.GetDecktopGroup(tp,math.min(ld,3))
	if c:IsRelateToEffect(e) then
		Duel.DisableShuffleCheck()
		Duel.Overlay(c,g)
	end
	Duel.BreakEffect()
	if c:GetOverlayGroup():FilterCount(Card.IsType,nil,TYPE_MONSTER)<5 then
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		Duel.GetControl(c,1-tp)
	else
		Duel.Damage(tp,c:GetOverlayCount()*400,REASON_EFFECT)
		local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
		Duel.Destroy(mg,REASON_EFFECT)
	end
end
