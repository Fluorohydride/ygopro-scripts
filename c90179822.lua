--喜劇のデスピアン
---@param c Card
function c90179822.initial_effect(c)
	--disable effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90179822,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,90179822)
	e1:SetCondition(c90179822.discon)
	e1:SetCost(c90179822.discost)
	e1:SetTarget(c90179822.distg)
	e1:SetOperation(c90179822.disop)
	c:RegisterEffect(e1)
	--special summon itself
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90179822,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,90179822)
	e2:SetCost(c90179822.spcost)
	e2:SetTarget(c90179822.sptg)
	e2:SetOperation(c90179822.spop)
	c:RegisterEffect(e2)
end
function c90179822.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x164) and c:IsControler(tp) and c:IsOnField()
end
function c90179822.discon(e,tp,eg,ep,ev,re,r,rp)
	if not (rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c90179822.cfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c90179822.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c90179822.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c90179822.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c90179822.rfilter(c,tp)
	return c:IsType(TYPE_FUSION) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c)>0
end
function c90179822.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c90179822.rfilter,1,nil,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c90179822.rfilter,1,1,nil,tp)
	Duel.Release(rg,REASON_COST)
end
function c90179822.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c90179822.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
