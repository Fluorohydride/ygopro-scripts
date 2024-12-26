--黄金の征服王
---@param c Card
function c92379223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,92379223+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c92379223.condition)
	e1:SetTarget(c92379223.target)
	e1:SetOperation(c92379223.activate)
	c:RegisterEffect(e1)
end
function c92379223.filter(c)
	return c:IsSetCard(0x1142) and c:IsFaceup()
end
function c92379223.tdfilter1(c)
	return c:IsSetCard(0x2142) and c:IsFaceup()
end
function c92379223.tdfilter2(c)
	return c:IsSetCard(0x143) and c:IsFaceup()
end
function c92379223.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c92379223.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c92379223.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c92379223.tdfilter1,tp,LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(c92379223.tdfilter2,tp,LOCATION_REMOVED,0,nil)
	local b1=g1:GetClassCount(Card.GetCode)>2 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local b2=g2:GetClassCount(Card.GetCode)>2
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(92379223,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(92379223,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c92379223.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local g=Duel.GetMatchingGroup(c92379223.tdfilter1,tp,LOCATION_REMOVED,0,nil)
		if g:GetClassCount(Card.GetCode)>=3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
			if #tg>0 then
				Duel.HintSelection(tg)
			end
			Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
			local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			if ct==3 then
				Duel.BreakEffect()
				local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
				if #g>0 then
					Duel.Destroy(g,REASON_EFFECT)
				end
			end
		end
	else
		local g=Duel.GetMatchingGroup(c92379223.tdfilter2,tp,LOCATION_REMOVED,0,nil)
		if g:GetClassCount(Card.GetCode)>=3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
			if #tg>0 then
				Duel.HintSelection(tg)
			end
			Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
			local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			if ct==3 then
				Duel.BreakEffect()
				Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
				Duel.Recover(tp,Duel.GetLP(1-tp),REASON_EFFECT)
			end
		end
	end
end
