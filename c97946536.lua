--ゼクトライク－紅黄
---@param c Card
function c97946536.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97946536,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,97946536+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c97946536.cost)
	e1:SetTarget(c97946536.optg)
	e1:SetOperation(c97946536.opop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(97946536,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetTarget(c97946536.eqtg)
	e2:SetOperation(c97946536.eqop)
	c:RegisterEffect(e2)
end
function c97946536.tgcostfilter(c)
	return c:IsSetCard(0x56) and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c97946536.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97946536.tgcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c97946536.tgcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c97946536.opfilter(c,e,tp,spchk,eqchk)
	return c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER)
		and (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or eqchk and c:CheckUniqueOnField(tp) and not c:IsForbidden())
end
function c97946536.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x56)
end
function c97946536.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local eqchk=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c97946536.cfilter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(c97946536.opfilter,tp,LOCATION_DECK,0,1,nil,e,tp,spchk,eqchk)
	end
end
function c97946536.opop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local eqchk=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c97946536.cfilter,tp,LOCATION_MZONE,0,1,nil)
	local g=Duel.SelectMatchingCard(tp,c97946536.opfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,spchk,eqchk)
	local tc=g:GetFirst()
	if tc then
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and spchk
			and (not eqchk or Duel.SelectOption(tp,1152,aux.Stringid(97946536,2))==0) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=Duel.SelectMatchingCard(tp,c97946536.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			local sc=sg:GetFirst()
			if sc then
				if not Duel.Equip(tp,tc,sc) then return end
				--equip limit
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetLabelObject(sc)
				e1:SetValue(c97946536.eqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c97946536.eqfilter(c,tp)
	return c:IsSetCard(0x56) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c97946536.tgfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c97946536.tgfilter(c,eqc)
	return c:IsFaceup() and c:IsSetCard(0x56) and eqc:CheckEquipTarget(c)
end
function c97946536.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c97946536.eqfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c97946536.eqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c97946536.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if ec then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc=Duel.SelectMatchingCard(tp,c97946536.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,ec):GetFirst()
			Duel.Equip(tp,ec,tc)
		end
	end
end
function c97946536.eqlimit(e,c)
	return c==e:GetLabelObject()
end
