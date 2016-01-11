--フレンドリーファイヤ
function c46253216.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c46253216.condition)
	e1:SetTarget(c46253216.target)
	e1:SetOperation(c46253216.activate)
	c:RegisterEffect(e1)
end
function c46253216.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c46253216.desfilter(c,rc)
	return c~=rc and c:IsDestructable()
end
function c46253216.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=nil
	if re:GetHandler():IsRelateToEffect(re) then rc=re:GetHandler() end
	if chkc then return chkc:IsOnField() and c46253216.desfilter(chkc,rc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c46253216.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c46253216.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c46253216.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
