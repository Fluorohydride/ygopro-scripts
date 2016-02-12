--鬼くじ
function c73820802.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE,0)
	e1:SetTarget(c73820802.target1)
	e1:SetOperation(c73820802.operation)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73820802,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetLabel(1)
	e2:SetCondition(c73820802.condition)
	e2:SetTarget(c73820802.target2)
	e2:SetOperation(c73820802.operation)
	c:RegisterEffect(e2)
end
function c73820802.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		e:SetLabel(1)
		e:GetHandler():RegisterFlagEffect(73820802,RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	else
		e:SetCategory(0)
		e:SetLabel(0)
	end
end
function c73820802.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(1-tp,70,71,72)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if (op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP)) then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	else
		local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if hg:GetCount()>0 then
			local sg=hg:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		end
	end
	Duel.MoveSequence(tc,1)
end
function c73820802.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c73820802.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(73820802)==0 end
	e:GetHandler():RegisterFlagEffect(73820802,RESET_PHASE+PHASE_END,0,1)
end
