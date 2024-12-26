--サンダー・ディスチャージ
local s,id,o=GetID()
---@param c Card
function c27623932.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,27623932+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c27623932.condition)
	e1:SetTarget(c27623932.target)
	e1:SetOperation(c27623932.operation)
	c:RegisterEffect(e1)
end
function c27623932.cfilter(c)
	return c:IsCode(3285552) and c:IsFaceup()
end
function c27623932.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27623932.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c27623932.tgfilter(c,tp)
	return c:IsFaceup() and c:GetEquipCount()>0 and c:GetEquipGroup():IsExists(c27623932.cfilter2,1,nil)
		and Duel.IsExistingMatchingCard(c27623932.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c27623932.cfilter2(c)
	return c:IsFaceup() and aux.IsCodeListed(c,3285552)
end
function c27623932.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c27623932.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c27623932.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27623932.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c27623932.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local dg=Duel.GetMatchingGroup(c27623932.desfilter,tp,0,LOCATION_MZONE,nil,g:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c27623932.CanEquipFilter(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c)
end
function c27623932.eqfilter(c,tp)
	return aux.IsCodeListed(c,3285552) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c27623932.CanEquipFilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c27623932.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local dg=Duel.GetMatchingGroup(c27623932.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		if Duel.Destroy(dg,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local eqg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp)
			local eqc=eqg:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local mg=Duel.SelectMatchingCard(tp,s.CanEquipFilter,tp,LOCATION_MZONE,0,1,1,nil,eqc)
			Duel.Equip(tp,eqc,mg:GetFirst())
		end
	end
end
