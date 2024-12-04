--天雷震龍－サンダー・ドラゴン
function c5206415.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c5206415.spcon)
	e1:SetTarget(c5206415.sptg)
	e1:SetOperation(c5206415.spop)
	c:RegisterEffect(e1)
	--effect target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5206415,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c5206415.etcon)
	e2:SetCost(c5206415.etcost)
	e2:SetTarget(c5206415.ettg)
	e2:SetOperation(c5206415.etop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5206415,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c5206415.tgcon)
	e3:SetTarget(c5206415.tgtg)
	e3:SetOperation(c5206415.tgop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(5206415,ACTIVITY_CHAIN,c5206415.chainfilter)
end
function c5206415.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_THUNDER) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c5206415.spfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsLevelBelow(8) and c:IsRace(RACE_THUNDER)
		and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c5206415.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetCustomActivityCount(5206415,tp,ACTIVITY_CHAIN)~=0
		or Duel.GetCustomActivityCount(5206415,1-tp,ACTIVITY_CHAIN)~=0)
		and Duel.IsExistingMatchingCard(c5206415.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,tp)
end
function c5206415.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c5206415.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c5206415.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
end
function c5206415.etcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c5206415.fselect(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_THUNDER)
end
function c5206415.etcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c5206415.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c5206415.fselect,false,2,2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c5206415.etfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_THUNDER)
end
function c5206415.ettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c5206415.etfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5206415.etfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c5206415.etfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c5206415.etop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetValue(c5206415.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
end
function c5206415.tgoval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
function c5206415.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c5206415.tgfilter(c)
	return c:IsSetCard(0x11c) and c:IsAbleToGrave()
end
function c5206415.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5206415.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c5206415.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c5206415.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
