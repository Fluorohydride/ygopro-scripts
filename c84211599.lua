--金満で謙虚な壺
function c84211599.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,84211599+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c84211599.cost)
	e1:SetTarget(c84211599.target)
	e1:SetOperation(c84211599.activate)
	c:RegisterEffect(e1)
	if not c84211599.gf then
		c84211599.gf=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(c84211599.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c84211599.regop(e,tp,eg,ep,ev,re,r,rp)
	if r==REASON_EFFECT then
		Duel.RegisterFlagEffect(ep,84211599,RESET_PHASE+PHASE_END,0,1)
	end
end
function c84211599.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c84211599.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,nil,POS_FACEDOWN)
	local count=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local b1=#g>=3 and count>=3 and Duel.GetDecktopGroup(tp,3):IsExists(Card.IsAbleToHand,1,nil)
	local b2=#g>=6 and count>=6 and Duel.GetDecktopGroup(tp,6):IsExists(Card.IsAbleToHand,1,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetFlagEffect(tp,84211599)==0 and (b1 or b2)
	end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(84211599,0),aux.Stringid(84211599,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(84211599,0))
	end
	local ct= op==0 and 3 or 6
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,ct,ct,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c84211599.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.ConfirmDecktop(p,d)
	local g=Duel.GetDecktopGroup(p,d)
	if #g>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sc=g:Select(p,1,1,nil):GetFirst()
		if sc:IsAbleToHand() then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sc)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sc,REASON_RULE)
		end
	end
	if #g>1 then
		Duel.SortDecktop(tp,tp,#g-1)
		for i=1,#g-1 do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c84211599.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c84211599.damval(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
