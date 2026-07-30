--三幻魔の天壊
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,33017964)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_CHAIN_END)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.thfilter(c)
	return c:IsCode(33017964) and c:IsAbleToHand()
end
function s.costfilter1(c)
	return c:IsSetCard(0x1144) and c:IsLevel(10) and not c:IsPublic()
end
function s.costfilter2(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1144) and c:IsType(TYPE_TRAP) and c:IsAbleToDeckAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local ch=Duel.GetCurrentChain()
	local og=Group.CreateGroup()
	local tsp=-1
	local tse=nil
	if e:GetHandler():IsStatus(STATUS_CHAINING) then ch=ch-1 end
	if ch>1 then
		tsp,tse=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
		og:AddCard(tse:GetHandler())
		if tsp==1-tp and Duel.IsChainDisablable(ev) then
			local te,p=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			b1=(te and te:GetHandler():IsSetCard(0x1144) and te:IsActiveType(TYPE_MONSTER) and p==tp)
		end
	end
	local b2=Duel.IsExistingMatchingCard(s.costfilter1,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.costfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2},
		{b3,aux.Stringid(id,3),3})
	e:SetLabel(op,1)
	if op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.costfilter1,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.costfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	local b1=false
	local ch=Duel.GetCurrentChain()
	local og=Group.CreateGroup()
	local tsp=-1
	local tse=nil
	if e:GetHandler():IsStatus(STATUS_CHAINING) then ch=ch-1 end
	if ch>1 then
		tsp,tse=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
		og:AddCard(tse:GetHandler())
		if tsp==1-tp and Duel.IsChainDisablable(ev) then
			local te,p=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			b1=(te and te:GetHandler():IsSetCard(0x1144) and te:IsActiveType(TYPE_MONSTER) and p==tp)
		end
	end
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or ((b2 or b3) and not e:IsCostChecked()) or e:IsCostChecked() end
	local op,el=e:GetLabel()
	if el==0 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2},
			{b3,aux.Stringid(id,3),3})
	end
	e:SetLabel(op,0)
	if op==1 then
		e:SetCategory(CATEGORY_DISABLE)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,og,1,0,0)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES_SELF)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_HANDES_SELF,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==3 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local ch=Duel.GetCurrentChain()
		Duel.NegateEffect(ch-1)
	elseif e:GetLabel()==2 then
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	elseif e:GetLabel()==3 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToChain() and tc:IsOnField() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
