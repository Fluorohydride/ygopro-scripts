--ラーバモス
function c87756343.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c87756343.spcon)
	e2:SetOperation(c87756343.spop)
	c:RegisterEffect(e2)
end
function c87756343.eqfilter(c)
	return c:IsCode(40240595) and c:GetTurnCounter()>=2
end
function c87756343.rfilter(c,ft,tp)
	return c:IsCode(58192742) and c:GetEquipGroup():FilterCount(c87756343.eqfilter,nil)>0
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c87756343.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c87756343.rfilter,1,nil,ft,tp)
end
function c87756343.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c87756343.rfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
