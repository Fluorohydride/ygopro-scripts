--リブロマンサー・オリジン
function c84121302.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,84121302+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c84121302.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c84121302.atktg)
	e2:SetValue(c84121302.atkval)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84121302,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,84121303)
	e3:SetCondition(c84121302.descon)
	e3:SetTarget(c84121302.destg)
	e3:SetOperation(c84121302.desop)
	c:RegisterEffect(e3)
end
function c84121302.setfilter(c)
	return not c:IsCode(84121302) and c:IsSetCard(0x17c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c84121302.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c84121302.setfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(84121302,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,sc)
	end
end
function c84121302.atktg(e,c)
	return c:IsSetCard(0x17c) and c:IsType(TYPE_RITUAL)
end
function c84121302.atkval(e,c)
	return c:GetLevel()*100
end
function c84121302.spfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsControler(tp)
end
function c84121302.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c84121302.spfilter,1,nil,tp)
end
function c84121302.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c84121302.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
