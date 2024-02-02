--ペンデュラム・エボリューション
function c55795155.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55795155,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,55795155)
	e2:SetTarget(c55795155.thtg)
	e2:SetOperation(c55795155.thop)
	c:RegisterEffect(e2)
	--pendulum summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55795155,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,55795156)
	e3:SetCondition(c55795155.pcon)
	e3:SetTarget(c55795155.ptg)
	e3:SetOperation(c55795155.pop)
	c:RegisterEffect(e3)
	--multi attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55795155,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,55795157)
	e4:SetCondition(c55795155.atkcon)
	e4:SetTarget(c55795155.atktg)
	e4:SetOperation(c55795155.atkop)
	c:RegisterEffect(e4)
	if not c55795155.global_check then
		c55795155.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c55795155.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c55795155.checkfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsPreviousPosition(POS_FACEDOWN) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c55795155.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c55795155.checkfilter,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),55795155,RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end
function c55795155.cfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c55795155.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c55795155.thfilter(c,code)
	return c:IsType(TYPE_PENDULUM) and c:IsAttack(2500) and not c:IsCode(code) and c:IsAbleToHand()
end
function c55795155.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.IsExistingMatchingCard(c55795155.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c55795155.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55795155.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55795155.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c55795155.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,55795155)>0
end
function c55795155.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanPendulumSummon(tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c55795155.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PendulumSummon(tp,nil)
end
function c55795155.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c55795155.atkfilter(c)
	return c:IsCode(13331639) and c:IsFaceup()
end
function c55795155.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsCode(13331639) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c55795155.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c55795155.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c55795155.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
