--罪宝合戦
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function s.desfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x19e)
end
function s.desfilter2(c,e,tp,gc1,gc2)
	return c:IsCanBeEffectTarget(e) and ((c:IsControler(tp) and gc1>0) or (c:IsControler(1-tp) and gc2>0))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local gc1=Duel.GetMatchingGroupCount(s.desfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local gc2=Duel.GetMatchingGroupCount(s.desfilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if chkc then return chkc:IsOnField() and chkc:IsCanBeEffectTarget(e) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),e,tp,gc1,gc2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Group.CreateGroup()
	while true do
		local g=Duel.GetMatchingGroup(s.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,sg,e,tp,gc1,gc2)
		if g:IsContains(e:GetHandler()) then
			g:RemoveCard(e:GetHandler())
		end
		if #g==0 then
			break
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sc=g:SelectUnselect(sg,tp,#sg>0,#sg>0,1,99)
		if not sc then
			break
		elseif g:IsContains(sc) then
			g:RemoveCard(sc)
			sg:AddCard(sc)
			if sc:IsControler(tp) then
				gc1=gc1-1
			else
				gc2=gc2-1
			end
		else
			sg:RemoveCard(sc)
			g:AddCard(sc)
			if sc:IsControler(tp) then
				gc1=gc1+1
			else
				gc2=gc2+1
			end
		end
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and re:IsActivated()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
