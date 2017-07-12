--不知火流 輪廻の陣
function c78765160.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c78765160.target)
	c:RegisterEffect(e1)
	--change code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(40005099)
	c:RegisterEffect(e2)
	--no damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78765160,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c78765160.damcost)
	e3:SetTarget(c78765160.damtg)
	e3:SetOperation(c78765160.damop)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78765160,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c78765160.tdtg)
	e4:SetOperation(c78765160.tdop)
	c:RegisterEffect(e4)
end
function c78765160.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c78765160.tdtg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return true end
	local b1=c78765160.damcost(e,tp,eg,ep,ev,re,r,rp,0)
		and c78765160.damtg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c78765160.tdtg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(78765160,0),aux.Stringid(78765160,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(78765160,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(78765160,1))+1
		end
		if op==0 then
			c78765160.damcost(e,tp,eg,ep,ev,re,r,rp,1)
			c78765160.damtg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetCategory(0)
			e:SetProperty(0)
			e:SetOperation(c78765160.damop)
		else
			c78765160.tdtg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e:SetOperation(c78765160.tdop)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c78765160.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function c78765160.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78765160.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c78765160.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c78765160.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(78765160)==0 end
	e:GetHandler():RegisterFlagEffect(78765160,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c78765160.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c78765160.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsDefenseBelow(0) and c:IsAbleToDeck()
end
function c78765160.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c78765160.tdfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(78765160)==0
		and Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c78765160.tdfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c78765160.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	e:GetHandler():RegisterFlagEffect(78765160,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c78765160.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not e:GetHandler():IsRelateToEffect(e) or not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==2 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
