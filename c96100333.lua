--古代遺跡の目覚め
function c96100333.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c96100333.target1)
	e1:SetOperation(c96100333.operation)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96100333,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c96100333.cost)
	e2:SetTarget(c96100333.target2)
	e2:SetOperation(c96100333.operation)
	c:RegisterEffect(e2)
end
function c96100333.cfilter(c)
	return (c:IsRace(RACE_ROCK) or c:IsType(TYPE_FIELD)) and c:IsAbleToRemoveAsCost()
end
function c96100333.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c96100333.spfilter(c,e,tp)
	return c:IsRace(RACE_ROCK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c96100333.tdfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToDeck()
end
function c96100333.tspfilter(c,e,tp)
	return c:IsRace(RACE_ROCK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c96100333.cfilter,tp,LOCATION_GRAVE,0,2,c)
end
function c96100333.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then return chkc:IsOnField() and c96100333.desfilter(chkc) and chkc~=e:GetHandler()
		elseif e:GetLabel()==2 then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c96100333.spfilter(chkc,e,tp)
		else return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c96100333.tdfilter(chkc) end
	end
	if chk==0 then return true end
	local b1=Duel.IsExistingTarget(c96100333.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local b2=Duel.IsExistingTarget(c96100333.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=Duel.IsExistingTarget(c96100333.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1)
	if b2 and not (b1 and b3) then
		b2=Duel.IsExistingTarget(c96100333.tspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	if Duel.IsExistingMatchingCard(c96100333.cfilter,tp,LOCATION_GRAVE,0,2,nil)
		and (b1 or b2 or b3) and Duel.SelectYesNo(tp,94) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c96100333.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		b2=Duel.IsExistingTarget(c96100333.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local ops={}
		local opval={}
		local off=1
		if b1 then
			ops[off]=aux.Stringid(96100333,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(96100333,2)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(96100333,3)
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		e:SetLabel(sel)
		if sel==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectTarget(tp,c96100333.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
			e:SetCategory(CATEGORY_DESTROY)
		elseif sel==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectTarget(tp,c96100333.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectTarget(tp,c96100333.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
			e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		end
		e:GetHandler():RegisterFlagEffect(96100333,RESET_PHASE+PHASE_END,0,1)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function c96100333.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(96100333)==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local sel=e:GetLabel()
	if sel==1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif sel==2 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		end
	else
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c96100333.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96100333.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c96100333.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c96100333.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then return chkc:IsOnField() and c96100333.desfilter(chkc) and chkc~=e:GetHandler()
		elseif e:GetLabel()==2 then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c96100333.spfilter(chkc,e,tp)
		else return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c96100333.tdfilter(chkc) end
	end
	local b1=Duel.IsExistingTarget(c96100333.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local b2=Duel.IsExistingTarget(c96100333.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=Duel.IsExistingTarget(c96100333.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1)
	if b2 and not (b1 and b3) then
		b2=Duel.IsExistingTarget(c96100333.tspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	if chk==0 then return e:GetHandler():GetFlagEffect(96100333)==0
		and (b1 or b2 or b3) end
	b2=Duel.IsExistingTarget(c96100333.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(96100333,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(96100333,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(96100333,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c96100333.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c96100333.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c96100333.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	e:GetHandler():RegisterFlagEffect(96100333,RESET_PHASE+PHASE_END,0,1)
end
