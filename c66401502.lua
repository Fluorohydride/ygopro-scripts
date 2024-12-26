--VS パンテラ
---@param c Card
function c66401502.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66401502,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,66401502)
	e1:SetCondition(c66401502.spcon)
	e1:SetTarget(c66401502.sptg)
	e1:SetOperation(c66401502.spop)
	c:RegisterEffect(e1)
	--show earth for indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66401502,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,66401503)
	e2:SetCost(c66401502.indescost)
	e2:SetCondition(aux.bpcon)
	e2:SetTarget(c66401502.indestg)
	e2:SetOperation(c66401502.indesop)
	c:RegisterEffect(e2)
	--show earth and fire for destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66401502,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,66401503)
	e3:SetHintTiming(0,TIMING_EQUIP+TIMING_END_PHASE)
	e3:SetCost(c66401502.descost)
	e3:SetTarget(c66401502.destg)
	e3:SetOperation(c66401502.desop)
	c:RegisterEffect(e3)
end
function c66401502.spcfilter(c)
	return c:GetSequence()<5
end
function c66401502.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c66401502.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66401502.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetFlagEffect(tp,66401502)==0 end
	Duel.RegisterFlagEffect(tp,66401502,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c66401502.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c66401502.indescfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsPublic()
end
function c66401502.indescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66401502.indescfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c66401502.indescfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseEvent(g,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
end
function c66401502.indestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,66401502)==0 end
	Duel.RegisterFlagEffect(tp,66401502,RESET_CHAIN,0,1)
end
function c66401502.indesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	c:RegisterEffect(e1)
end
function c66401502.descfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_FIRE) and not c:IsPublic()
end
function c66401502.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c66401502.descfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_EARTH,ATTRIBUTE_FIRE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_EARTH,ATTRIBUTE_FIRE)
	Duel.ConfirmCards(1-tp,sg)
	Duel.RaiseEvent(sg,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
end
function c66401502.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetColumnGroup():Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return #g>0 and Duel.GetFlagEffect(tp,66401502)==0 end
	Duel.RegisterFlagEffect(tp,66401502,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c66401502.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local g=c:GetColumnGroup():Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.Destroy(g,REASON_EFFECT)
end
