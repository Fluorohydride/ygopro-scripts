--トイ・パレード
function c92607427.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92607427,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,92607427)
	e1:SetTarget(c92607427.target)
	e1:SetOperation(c92607427.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92607427,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,92607427)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c92607427.thcon)
	e2:SetTarget(c92607427.thtg)
	e2:SetOperation(c92607427.thop)
	c:RegisterEffect(e2)
end
function c92607427.filter(c)
	return c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c92607427.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c92607427.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c92607427.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c92607427.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c92607427.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c92607427.ftarget)
		e1:SetLabel(tc:GetFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetCondition(c92607427.atkcon)
		e2:SetOperation(c92607427.atkop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c92607427.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c92607427.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.bdgcon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsChainAttackable(0)
end
function c92607427.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c92607427.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c92607427.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c92607427.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c92607427.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c92607427.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92607427.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c92607427.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c92607427.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
