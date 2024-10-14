--サイコウィールダー
---@param c Card
function c3233859.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,3233859+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c3233859.sprcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3233859,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,3233860)
	e2:SetCondition(c3233859.descon)
	e2:SetTarget(c3233859.destg)
	e2:SetOperation(c3233859.desop)
	c:RegisterEffect(e2)
end
function c3233859.sprfilter(c)
	return c:IsFaceup() and c:IsLevel(3) and not c:IsCode(3233859)
end
function c3233859.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3233859.sprfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c3233859.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c3233859.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk-1)
end
function c3233859.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local atk=e:GetHandler():GetReasonCard():GetAttack()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c3233859.desfilter(chkc,atk) end
	if chk==0 then return Duel.IsExistingTarget(c3233859.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,atk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c3233859.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c3233859.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
