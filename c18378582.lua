--大天使ゼラート
---@param c Card
function c18378582.initial_effect(c)
	aux.AddCodeList(c,56433456)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c18378582.spcon)
	e2:SetTarget(c18378582.sptg)
	e2:SetOperation(c18378582.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18378582,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c18378582.descost)
	e3:SetTarget(c18378582.destg)
	e3:SetOperation(c18378582.desop)
	c:RegisterEffect(e3)
end
function c18378582.rfilter(c,tp)
	return c:IsFaceup() and c:IsCode(66073051) and Duel.GetMZoneCount(tp,c)>0
end
function c18378582.spcon(e,c)
	if c==nil then return Duel.IsEnvironment(56433456) end
	return Duel.CheckReleaseGroupEx(c:GetControler(),c18378582.rfilter,1,REASON_SPSUMMON,false,nil,c:GetControler())
end
function c18378582.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c18378582.rfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c18378582.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c18378582.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c18378582.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18378582.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c18378582.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c18378582.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18378582.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsEnvironment(56433456) then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
