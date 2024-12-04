--召喚制限－猛突するモンスター
function c30834988.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30834988,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c30834988.target)
	e2:SetOperation(c30834988.operation)
	c:RegisterEffect(e2)
end
function c30834988.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function c30834988.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local ct,last_turn,last_lp_0,last_lp_1,last_deck_0,last_deck_1=e:GetLabel()
	local turn=Duel.GetTurnCount()
	local lp_0=Duel.GetLP(0)
	local lp_1=Duel.GetLP(1)
	local deck_0=Duel.GetFieldGroupCount(0,LOCATION_DECK,0)
	local deck_1=Duel.GetFieldGroupCount(1,LOCATION_DECK,0)
	if ct==nil
		or last_turn~=turn or last_lp_0~=lp_0 or last_lp_1~=lp_1 or last_deck_0-deck_0>5 or last_deck_1-deck_1>5 then
		e:SetLabel(0,turn,lp_0,lp_1,deck_0,deck_1)
	else
		ct=ct+1
		if ct>10 then
			Duel.SendtoGrave(c,REASON_RULE)
			return
		end
		e:SetLabel(ct,turn,lp_0,lp_1,last_deck_0,last_deck_1)
	end
end
