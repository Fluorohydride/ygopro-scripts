--ラーバモス
---@param c Card
function c87756343.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c87756343.spcon)
	e2:SetTarget(c87756343.sptg)
	e2:SetOperation(c87756343.spop)
	c:RegisterEffect(e2)
end
function c87756343.eqfilter(c)
	return c:IsCode(40240595) and c:GetTurnCounter()>=2
end
function c87756343.rfilter(c,tp)
	return c:IsCode(58192742) and c:GetEquipGroup():FilterCount(c87756343.eqfilter,nil)>0
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c87756343.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c87756343.rfilter,1,REASON_SPSUMMON,false,nil,tp)
end
function c87756343.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c87756343.rfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c87756343.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
