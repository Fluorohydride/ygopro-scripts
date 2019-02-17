--運命のドロー
function c856784.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,856784+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c856784.condition)
	e1:SetTarget(c856784.target)
	e1:SetOperation(c856784.activate)
	c:RegisterEffect(e1)
end
function c856784.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c856784.check(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function c856784.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanDraw(tp,1) then return false end
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
		return g:CheckSubGroup(c856784.check,3,3)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c856784.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:SelectSubGroup(tp,c856784.check,false,3,3)
		Duel.ConfirmCards(1-tp,sg)
		if Duel.ShuffleDeck(tp)~=0 then
			for i=1,3 do
				local tc
				if i<3 then
					tc=sg:RandomSelect(tp,1):GetFirst()
				else
					tc=sg:GetFirst()
				end
				Duel.MoveSequence(tc,0)
				sg:RemoveCard(tc)
			end
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c856784.regcon)
	e2:SetOperation(c856784.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c856784.actcon)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c856784.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c856784.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,856784,RESET_PHASE+PHASE_END,0,1)
end
function c856784.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,856784)>0
end
