--ヴァリュアブル・フォーム
function c64038662.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--equip or spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(64038662,0))
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c64038662.eftg)
	e2:SetOperation(c64038662.efop)
	c:RegisterEffect(e2)
end
function c64038662.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x56)
end
function c64038662.filter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x56) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c64038662.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then return false
		else return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c64038662.filter2(chkc,e,tp) end
	end
	local b1=Duel.IsExistingTarget(c64038662.filter1,tp,LOCATION_MZONE,0,2,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.IsExistingTarget(c64038662.filter2,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(64038662,2),1},
		{b2,aux.Stringid(64038662,3),2})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c64038662.filter1,tp,LOCATION_MZONE,0,2,2,nil)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c64038662.filter2,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c64038662.efop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local g=Duel.GetTargetsRelateToChain()
		if g:FilterCount(Card.IsFaceup,nil)<2 then return end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(64038662,4))
		local tc1=g:Select(tp,1,1,nil):GetFirst()
		local tc2=(g-tc1):GetFirst()
		if Duel.Equip(tp,tc1,tc2,false) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c64038662.eqlimit)
			e1:SetLabelObject(tc2)
			tc1:RegisterEffect(e1)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c64038662.eqlimit(e,c)
	return c==e:GetLabelObject()
end
