--Live☆Twin リィラ・トリート
function c81078880.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81078880+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81078880.spcon)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81078880,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81078881)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c81078880.atkcon)
	e2:SetTarget(c81078880.atktg)
	e2:SetOperation(c81078880.atkop)
	c:RegisterEffect(e2)
end
function c81078880.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x152)
end
function c81078880.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c81078880.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c81078880.cfilter(c)
	local bc=c:GetBattleTarget()
	return c:IsSetCard(0x2151) or (bc and bc:IsSetCard(0x2151))
end
function c81078880.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81078880.cfilter,1,nil)
end
function c81078880.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()~=0
end
function c81078880.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c81078880.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81078880.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81078880.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c81078880.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-ev)
		tc:RegisterEffect(e1)
	end
end
