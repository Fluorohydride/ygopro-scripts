--古代遺跡の目覚め
function c96100333.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96100333,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c96100333.target)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96100333,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c96100333.cost)
	e2:SetTarget(c96100333.destg)
	e2:SetOperation(c96100333.desop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(96100333,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,0x1e0)
	e3:SetTarget(c96100333.sptg)
	e3:SetOperation(c96100333.spop)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(96100333,3))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,0x1e0)
	e4:SetTarget(c96100333.tdtg)
	e4:SetOperation(c96100333.tdop)
	c:RegisterEffect(e4)
end
function c96100333.cfilter(c)
	return (c:IsRace(RACE_ROCK) or c:IsType(TYPE_FIELD)) and c:IsAbleToRemoveAsCost()
end
function c96100333.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(96100333)==0
		and Duel.IsExistingMatchingCard(c96100333.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c96100333.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(96100333,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c96100333.desfilter(c)
	return c:IsFaceup()
end
function c96100333.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c96100333.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c96100333.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c96100333.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c96100333.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c96100333.spcfilter1(c,cg,sg)
	local g=sg:Clone()
	g:RemoveCard(c)
	return cg:IsExists(c96100333.spcfilter2,1,c,g)
end
function c96100333.spcfilter2(c,sg)
	return sg:IsExists(aux.TRUE,1,c)
end
function c96100333.spfilter(c,e,tp)
	return c:IsRace(RACE_ROCK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c96100333.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c96100333.spfilter(chkc,e,tp) end
	local cg=Duel.GetMatchingGroup(c96100333.cfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Duel.GetMatchingGroup(c96100333.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return e:GetHandler():GetFlagEffect(96100333)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and cg:IsExists(c96100333.spcfilter1,1,nil,cg,sg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=cg:FilterSelect(tp,c96100333.spcfilter1,1,1,nil,cg,sg)
	sg:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=cg:FilterSelect(tp,c96100333.spcfilter2,1,1,g1:GetFirst(),sg)
	sg:RemoveCard(g2:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=sg:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(96100333,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c96100333.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c96100333.tdcfilter1(c,cg,sg)
	local g=sg:Clone()
	g:RemoveCard(c)
	return cg:IsExists(c96100333.spcfilter2,1,c,g)
end
function c96100333.tdcfilter2(c,sg)
	return sg:IsExists(aux.TRUE,1,c)
end
function c96100333.tdfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToDeck()
end
function c96100333.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c96100333.tdfilter(chkc) end
	local cg=Duel.GetMatchingGroup(c96100333.cfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Duel.GetMatchingGroup(c96100333.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return e:GetHandler():GetFlagEffect(96100333)==0
		and Duel.IsPlayerCanDraw(tp,1)
		and cg:IsExists(c96100333.tdcfilter1,1,nil,cg,sg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=cg:FilterSelect(tp,c96100333.tdcfilter1,1,1,nil,cg,sg)
	sg:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=cg:FilterSelect(tp,c96100333.tdcfilter2,1,1,g1:GetFirst(),sg)
	sg:RemoveCard(g2:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=sg:Select(tp,1,3,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	e:GetHandler():RegisterFlagEffect(96100333,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c96100333.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c96100333.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then return c96100333.destg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
		elseif e:GetLabel()==2 then return c96100333.sptg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
		else return c96100333.tdtg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	end
	if chk==0 then return true end
	local b1=c96100333.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and c96100333.destg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c96100333.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	local b3=c96100333.tdtg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2 or b3) and Duel.SelectYesNo(tp,94) then
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
			c96100333.cost(e,tp,eg,ep,ev,re,r,rp,1)
			c96100333.destg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetCategory(CATEGORY_DESTROY)
			e:SetOperation(c96100333.desop)
		elseif sel==2 then
			c96100333.sptg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetOperation(c96100333.spop)
		else
			c96100333.tdtg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
			e:SetOperation(c96100333.tdop)
		end
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
