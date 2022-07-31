--幽麗なる幻滝
function c23068051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c23068051.cost)
	e1:SetTarget(c23068051.target)
	e1:SetOperation(c23068051.activate)
	c:RegisterEffect(e1)
end
function c23068051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	return true
end
function c23068051.filter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function c23068051.filter2(c)
	return c:IsFaceupEx() and c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function c23068051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sel=e:GetLabel()
	local b1=Duel.IsExistingMatchingCard(c23068051.filter,tp,LOCATION_DECK,0,1,nil)
	local b2=sel==100
		and Duel.IsExistingMatchingCard(c23068051.filter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(23068051,0),aux.Stringid(23068051,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(23068051,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(23068051,1))+1
	end
	e:SetLabel(0,op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		local ft=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local g=Duel.GetMatchingGroup(c23068051.filter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		local ct=math.min(ft-1,g:GetCount()+1)
		local sg=g:Select(tp,1,ct,nil)
		Duel.SendtoGrave(sg,REASON_COST)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(sg:GetCount()+1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,sg:GetCount()+1)
	end
end
function c23068051.activate(e,tp,eg,ep,ev,re,r,rp)
	local _,op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c23068051.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
