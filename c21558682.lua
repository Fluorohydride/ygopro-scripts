--ディフェンド・スライム
function c21558682.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21558682,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c21558682.atkcon)
	e2:SetTarget(c21558682.atktg)
	e2:SetOperation(c21558682.atkop)
	c:RegisterEffect(e2)
end
function c21558682.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetAttackTarget()~=nil
end
function c21558682.filter(c,atg)
	return c:IsFaceup() and c:IsCode(31709826) and atg:IsContains(c)
end
function c21558682.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local atg=Duel.GetAttacker():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc~=at and c21558682.filter(chkc,atg) end
	if chk==0 then return Duel.IsExistingTarget(c21558682.filter,tp,LOCATION_MZONE,0,1,at,atg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c21558682.filter,tp,LOCATION_MZONE,0,1,1,at,atg)
end
function c21558682.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and not Duel.GetAttacker():IsImmuneToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end
