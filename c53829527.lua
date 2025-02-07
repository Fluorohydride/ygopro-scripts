--クリストロン・クラスター
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Cannot Banish
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.rmlimit)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.rmlimit(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0xea) and c:IsFaceup()
		and r&REASON_EFFECT~=0 and re:GetOwnerPlayer()~=tp
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xea) and c:IsType(TYPE_SYNCHRO)
end
function s.tdfilter(c)
	return not c:IsCode(id) and c:IsFaceupEx() and c:IsSetCard(0xea) and c:IsAbleToDeck()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	local xg=nil
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then xg=e:GetHandler() end
	local ct=1
	if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then ct=2 end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,xg)
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,xg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if dg:GetCount()>0 then
		Duel.HintSelection(dg)
		if Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
			and dg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)>0
			and tg:GetCount()>0 then
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end
