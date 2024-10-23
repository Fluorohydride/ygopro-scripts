--セリオンズ・クロス
function c43270827.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43270827,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,43270827+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c43270827.condition)
	e1:SetTarget(c43270827.target)
	e1:SetOperation(c43270827.activate)
	c:RegisterEffect(e1)
end
function c43270827.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x179)
end
function c43270827.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c43270827.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c43270827.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local b1=Duel.IsChainDisablable(ev)
	local b2=rc:IsRelateToEffect(re) and rc:IsAbleToRemove() and not rc:IsLocation(LOCATION_REMOVED)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,21887075) then
			op=Duel.SelectOption(tp,aux.Stringid(43270827,1),aux.Stringid(43270827,2),aux.Stringid(43270827,3))
		else
			op=Duel.SelectOption(tp,aux.Stringid(43270827,1),aux.Stringid(43270827,2))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(43270827,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(43270827,2))+1
	end
	e:SetLabel(op)
	if op~=0 then
		if op==1 then
			e:SetCategory(CATEGORY_REMOVE)
		else
			e:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
		end
		if rc:IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		end
	else
		e:SetCategory(CATEGORY_DISABLE)
	end
end
function c43270827.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local res=0
	if op~=1 then
		Duel.NegateEffect(ev)
	end
	if op~=0 then
		local rc=re:GetHandler()
		if rc:IsRelateToEffect(re) then
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
