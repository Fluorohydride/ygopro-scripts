--ゼクトライク－紅黄
function c97946536.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,97946536+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c97946536.cost)
	e1:SetTarget(c97946536.target)
	e1:SetOperation(c97946536.activate)
	c:RegisterEffect(e1)
end
function c97946536.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	return true
end
function c97946536.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x56)
end
function c97946536.tgcostfilter2(c,tp)
	return c:IsSetCard(0x56) and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
		and Duel.GetMZoneCount(tp,c)>0
end
function c97946536.tgcostfilter3(c,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 and (not c:IsLocation(LOCATION_SZONE) or c:GetSequence()>4) then return false end 
	return c:IsSetCard(0x56) and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
		and Duel.IsExistingMatchingCard(c97946536.cfilter,tp,LOCATION_MZONE,0,1,c)
end
function c97946536.tgcostfilter4(c,tp)
	return c97946536.tgcostfilter2(c,tp) or c97946536.tgcostfilter3(c,tp)
end
function c97946536.opfilter(c,e,tp,spchk,eqchk)
	return c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER)
		and (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or eqchk and c:CheckUniqueOnField(tp) and not c:IsForbidden())
end
function c97946536.eqfilter(c,tp)
	return c:IsSetCard(0x56) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c97946536.tgfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c97946536.tgfilter(c,eqc)
	return c:IsFaceup() and c:IsSetCard(0x56) and eqc:CheckEquipTarget(c)
end
function c97946536.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	local iscost=sel==100
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local eqchk=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c97946536.cfilter,tp,LOCATION_MZONE,0,1,nil)
	if iscost then
		spchk=Duel.IsExistingMatchingCard(c97946536.tgcostfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp)
		eqchk=Duel.IsExistingMatchingCard(c97946536.tgcostfilter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp)
	end
	local b1=Duel.IsExistingMatchingCard(c97946536.opfilter,tp,LOCATION_DECK,0,1,nil,e,tp,spchk,eqchk)
	local b2=eqchk and Duel.IsExistingMatchingCard(c97946536.eqfilter,tp,LOCATION_DECK,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(97946536,0),aux.Stringid(97946536,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(97946536,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(97946536,1))+1
	end
	e:SetLabel(0,op)
	if iscost then
		local g
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			if Duel.IsExistingMatchingCard(c97946536.opfilter,tp,LOCATION_DECK,0,1,nil,e,tp,true,true) then
				g=Duel.SelectMatchingCard(tp,c97946536.tgcostfilter4,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp)
			elseif Duel.IsExistingMatchingCard(c97946536.opfilter,tp,LOCATION_DECK,0,1,nil,e,tp,true,false) then
				g=Duel.SelectMatchingCard(tp,c97946536.tgcostfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp)
			else
				g=Duel.SelectMatchingCard(tp,c97946536.tgcostfilter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp)
			end
		else
			g=Duel.SelectMatchingCard(tp,c97946536.tgcostfilter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp)
		end
		Duel.SendtoGrave(g,REASON_COST)
	end
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function c97946536.activate(e,tp,eg,ep,ev,re,r,rp)
	local _,op=e:GetLabel()
	if op==0 then
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
	else
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
end
function c97946536.eqlimit(e,c)
	return c==e:GetLabelObject()
end
