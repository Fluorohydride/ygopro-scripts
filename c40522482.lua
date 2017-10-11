--スカイスクレイパー・シュート
function c40522482.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c40522482.target)
	e1:SetOperation(c40522482.activate)
	c:RegisterEffect(e1)
end
function c40522482.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3008) and c:IsType(TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c40522482.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c40522482.desfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function c40522482.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40522482.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40522482.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,c40522482.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local atk=tg:GetFirst():GetAttack()
	local g=Duel.GetMatchingGroup(c40522482.desfilter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local dam=0
	if fc and c40522482.ffilter(fc) then
		dam=g:GetSum(Card.GetBaseAttack)
	else
		g,dam=g:GetMaxGroup(Card.GetBaseAttack)
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,1-tp,dam)
end
function c40522482.ffilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf6)
end
function c40522482.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c40522482.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if og:GetCount()==0 then return end
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		local dam=0
		if fc and c40522482.ffilter(fc) then
			dam=og:GetSum(Card.GetBaseAttack)
		else
			g,dam=og:GetMaxGroup(Card.GetBaseAttack)
		end
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
