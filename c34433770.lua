--閃刀亜式－レムニスゲート
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	-- Special Summon
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_SPSUMMON_SUCCESS)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.sfilter(c,e)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x115) and (not e or c:IsCanBeEffectTarget(e))
end
function s.mfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1115) and (not e or c:IsCanBeEffectTarget(e))
end
function s.fselect(g)
	return g:FilterCount(s.sfilter,nil)==g:FilterCount(s.mfilter,nil)
end
function s.SelectSub(g1,g2,tp)
	local max=math.min(#g1,#g2)
	local sg1=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	local sg=sg1+sg2
	local fg=g1+g2
	local finish=false
	while true do
		finish=#sg1==#sg2 and #sg>0
		local sc=fg:SelectUnselect(sg,tp,finish,finish,2,max*2)
		if not sc then break end
		if sg:IsContains(sc) then
			if g1:IsContains(sc) then
				sg1:RemoveCard(sc)
			else
				sg2:RemoveCard(sc)
			end
		else
			if g1:IsContains(sc) then
				sg1:AddCard(sc)
			else
				sg2:AddCard(sc)
			end
		end
		sg=sg1+sg2
		fg=g1+g2-sg
		if #sg1>=max then
			fg=fg-g1
		end
		if #sg2>=max then
			fg=fg-g2
		end
	end
	return sg
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_GRAVE,0,nil,e)
	local g2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chkc then return false end
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
	local tg=s.SelectSub(g1,g2,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetsRelateToChain()
	if #sg==0 then return end
	if sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local g=Duel.GetOperatedGroup()
		local ct=math.floor(g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)/3)
		local dg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if ct>0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local dc=dg:Select(tp,1,ct,nil)
			if dc and dc:GetCount()>0 then
				Duel.BreakEffect()
				Duel.HintSelection(dc)
				Duel.SendtoHand(dc,nil,REASON_EFFECT)
			end
		end
	end
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x115) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1115) and c:IsType(TYPE_LINK) and c:IsLinkSummonable(nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.LinkSummon(tp,g:GetFirst(),nil)
	end
end
