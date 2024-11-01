--夢見るネムレリア
---@param c Card
function c70155677.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(70155677)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c70155677.sprcon)
	c:RegisterEffect(e1)
	--deck move
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c70155677.mvcost)
	e2:SetTarget(c70155677.mvtg)
	e2:SetOperation(c70155677.mvop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(70155677,ACTIVITY_SPSUMMON,c70155677.counterfilter)
	--fadown remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c70155677.drmtg)
	e3:SetOperation(c70155677.drmop)
	c:RegisterEffect(e3)
end
function c70155677.sprcon(e,c)
	if c==nil then return true end
	if c:IsFacedown() then return false end
	local tp=c:GetControler()
	local exg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	local ct=exg:FilterCount(aux.AND(Card.IsFaceup,Card.IsCode),nil,70155677)
	return #exg>0 and #exg==ct and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c70155677.counterfilter(c)
	return not c:IsCode(70155677)
end
function c70155677.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(70155677,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c70155677.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c70155677.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(70155677)
end
function c70155677.mvfilter(c,tp)
	return not c:IsForbidden() and c:IsSetCard(0x191) and c:GetType()==TYPE_CONTINUOUS+TYPE_SPELL and c:CheckUniqueOnField(tp)
end
function c70155677.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c70155677.mvfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c70155677.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c70155677.mvfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	if #g==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) and c:IsRelateToEffect(e) then
		Duel.SendtoExtraP(c,nil,REASON_EFFECT)
	end
end
function c70155677.drmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	local tg=g:Filter(Card.IsAbleToDeck,nil)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
	local ct=math.floor(#g/3)
	if chk==0 then return ct>0 and #tg>0 and #rg>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
end
function c70155677.rmdfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function c70155677.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c70155677.drmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	local tg=g:Filter(Card.IsAbleToDeck,nil)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
	local ct=math.floor(#g/3)
	if ct==0 or #tg==0 or #rg==0 then return end
	if ct>#tg then ct=#tg end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=rg:Select(tp,1,ct,nil)
	Duel.HintSelection(mg)
	Duel.Remove(mg,POS_FACEDOWN,REASON_EFFECT)
	local og=Duel.GetOperatedGroup():Filter(c70155677.rmdfilter,nil)
	if #og==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg1=Duel.SelectMatchingCard(tp,c70155677.tdfilter,tp,LOCATION_REMOVED,0,#og,#og,nil)
	Duel.BreakEffect()
	Duel.HintSelection(tg1)
	Duel.SendtoDeck(tg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
