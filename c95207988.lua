--地縛共振
function c95207988.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95207988,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,95207988)
	e2:SetCondition(c95207988.damcon)
	e2:SetTarget(c95207988.damtg)
	e2:SetOperation(c95207988.damop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95207988,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,95207988+1)
	e3:SetCondition(c95207988.descon)
	e3:SetTarget(c95207988.destg)
	e3:SetOperation(c95207988.desop)
	c:RegisterEffect(e3)
end
function c95207988.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonLocation(LOCATION_EXTRA)
		and not c:IsType(TYPE_TOKEN)
		and c:IsReason(REASON_EFFECT)
end
function c95207988.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95207988.cfilter,1,nil,tp)
end
function c95207988.tgfilter(c,e)
	return c:IsCanBeEffectTarget(e) and not c:IsAttack(0)
end
function c95207988.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=eg:Filter(c95207988.cfilter,nil,tp):Filter(c95207988.tgfilter,nil,e)
	if chkc then return mg:IsContains(chkc) end
	if chk==0 then return mg:GetCount()>0 end
	local g=mg
	if mg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=mg:Select(tp,1,1,nil)
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c95207988.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Damage(tp,tc:GetAttack()/2,REASON_EFFECT,true)
		Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
function c95207988.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_DARK)
		and tc:IsType(TYPE_SYNCHRO) and tc:IsSummonLocation(LOCATION_EXTRA)
end
function c95207988.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c95207988.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end